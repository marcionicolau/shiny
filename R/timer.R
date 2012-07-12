# Return the current time, in milliseconds from epoch, with
# unspecified time zone.
now <- function() {
  .Call('getTimeInMillis')
}

TimerCallbacks <- setRefClass(
  'TimerCallbacks',
  fields = list(
    .funcs = 'Map',
    .times = 'data.frame'
  ),
  methods = list(
    schedule = function(millis, func) {
      # TODO: Make a unique ID
      id <- 'a0'
      t <- now()
      
      # TODO: Horribly inefficient, use a heap instead
      .times <<- rbind(.times, data.frame(time=t+millis,
                                          scheduled=t,
                                          id=id))
      .times <<- .times[order(.times$time),]
      
      .funcs$set(id, func)
      
      return(id)
    },
    timeToNextEvent = function() {
      if (length(.times) == 0)
        return(Inf)
      return(.times[1, 'time'] - now())
    },
    takeElapsed = function() {
      t <- now()
      elapsed <- .times$time < now()
      result <- .times[elapsed,]
      .times <<- .times[!elapsed,]
      
      # TODO: Examine scheduled column to check if any funny business
      #       has occurred with the system clock (e.g. if scheduled
      #       is later than now())
      
      return(result)
    },
    executeElapsed = function() {
      elapsed <- takeElapsed()
      for (id in elapsed$id) {
        thisFunc <- .funcs$remove(id)
        # TODO: Catch exception, and...?
        # TODO: Detect NULL, and...?
        thisFunc()
      }
    }
  )
)

timerCallbacks <- TimerCallbacks$new()

timerCallbacks$schedule(1000, function() {print('a')})
timerCallbacks$schedule(2000, function() {print('b')})
timerCallbacks$schedule(3000, function() {print('c')})
timerCallbacks$schedule(3000, function() {print('d')})
timerCallbacks$schedule(4000, function() {print('e')})
timerCallbacks$schedule(6000, function() {print('f')})
timerCallbacks$schedule(1000, function() {print('g')})
timerCallbacks$schedule(10000, function() {print('h')})
while (T) {
  Sys.sleep(max(0, timerCallbacks$timeToNextEvent()))
  timerCallbacks$executeElapsed()
}