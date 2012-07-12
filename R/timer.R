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
      
    }
  )
)

timerCallbacks <- TimerCallbacks$new()
