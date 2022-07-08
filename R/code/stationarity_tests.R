#ADF and KPSS tests of level variables

##none
adf_none_test_results <- 
  lapply(all_data,
         function(x){summary(urca::ur.df(x, type = "none", lags = 1)
         )
         }
  )

##drift
adf_drift_test_results <- 
  lapply(all_data,
         function(x){summary(urca::ur.df(x, type = "drift", lags = 1)
         )
         }
  )


##trend
adf_trend_test_results <- 
  lapply(all_data,
         function(x){summary(urca::ur.df(x, type = "trend", lags = 1)
         )
         }
  )

#kpss test results
kpss_test_results <- 
  lapply(all_data,
         function(x){summary(urca::ur.kpss(x, type = "tau")
         )
         }
  )

#ADF and KPSS tests of level variables with 1st differenced selic

##none
adf_diff_none_test_results <- 
  lapply(all_data_diff,
         function(x){summary(urca::ur.df(x, type = "none", lags = 1)
         )
         }
  )

##drift
adf_diff_drift_test_results <- 
  lapply(all_data_diff,
         function(x){summary(urca::ur.df(x, type = "drift", lags = 1)
         )
         }
  )

##trend
adf_drift_trend_test_results <- 
  lapply(all_data_diff,
         function(x){summary(urca::ur.df(x, type = "trend", lags = 1)
         )
         }
  )

#kpss test results
kpss_diff_test_results <- 
  lapply(all_data_diff,
         function(x){summary(urca::ur.kpss(x, type = "tau")
         )
         }
  )