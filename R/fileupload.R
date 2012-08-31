FileUploadOperation <- setRefClass(
  'FileUploadOperation',
  fields = list(
    .parent = 'ANY',
    .id = 'character',
    .dir = 'character',
    .currentFileInfo = 'list',
    .currentFilePath = 'character',
    .currentFileData = 'ANY'
  ),
  methods = list(
    initialize = function(parent, id, dir) {
      .parent <<- parent
      .id <<- id
      .dir <<- dir
    },
    fileBegin = function(file) {
      .currentFileInfo <<- file
      # TODO: Make sure the filename is safe
      .currentFilePath <<- file.path(.dir, file$name)
      .currentFileData <<- file(.currentFilePath, open='wb')
    },
    fileChunk = function(rawdata) {
      writeBin(rawdata, .currentFileData)
    },
    fileEnd = function() {
      close(.currentFileData)
    },
    finish = function() {
      .parent$onJobFinished(.id)
      return(.dir)
    }
  )
)

FileUploadContext <- setRefClass(
  'FileUploadContext',
  fields = list(
    .basedir = 'character',
    .operations = 'Map'
  ),
  methods = list(
    initialize = function(dir=tempdir()) {
      .basedir <<- dir
    },
    createUploadOperation = function() {
      while (T) {
        id <- paste(as.raw(runif(12, min=0, max=0xFF)), collapse='')
        dir <- file.path(.basedir, id)
        if (!dir.create(dir))
          next
        
        op <- FileUploadOperation$new(.self, id, dir)
        .operations$set(id, op)
        return(id)
      }
    },
    getUploadOperation = function(jobId) {
      .operations$get(jobId)
    },
    onJobFinished = function(jobId) {
      .operations$remove(jobId)
    }
  )
)
