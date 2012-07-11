#ifndef _shiny_RCPP_TIME_H
#define _shiny_RCPP_TIME_H

#include <Rcpp.h>

#include <sys/time.h>

using namespace Rcpp;

/*
 * note : RcppExport is an alias to `extern "C"` defined by Rcpp.
 *
 * It gives C calling convention to the rcpp_hello_world function so that 
 * it can be called from .Call in R. Otherwise, the C++ compiler mangles the 
 * name of the function and .Call can't find it.
 *
 * It is only useful to use RcppExport when the function is intended to be called
 * by .Call. See the thread http://thread.gmane.org/gmane.comp.lang.r.rcpp/649/focus=672
 * on Rcpp-devel for a misuse of RcppExport
 */

long long now() {
  timeval tim;
  gettimeofday(&tim, NULL);
  return (tim.tv_sec * 1000000) + tim.tv_usec;
}

RCPP_MODULE(time) {
  function("now", &now);
}

#endif
