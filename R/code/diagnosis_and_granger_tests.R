##########################model 1##############################################

#BG individual autocorrelation tests
bg_index_model_1 <- lmtest::bgtest(model_var_1$varresult$sentiment_index)
bg_selic_model_1 <- lmtest::bgtest(model_var_1$varresult$selic_real_12m_diff)
bg_ibcbr_model_1 <- lmtest::bgtest(model_var_1$varresult$ibc_br)
bg_pimpf_model_1 <- lmtest::bgtest(model_var_1$varresult$pim_pf)

#joint autocorrelation test
vars::serial.test(model_var_1, lags.pt = 10, type = "BG")$serial

#ARCH-LM heteroskedasticity test
vars::arch.test(model_var_1, lags.multi = 15)$arch.mul #p-valor = 0.1 > 0.05 -> sem heterocedasticidade nas variancias dos residuos

#testing for structural breaks in the residuals
plot(vars::stability(model_var_1, type = "OLS-CUSUM"))

################################################################################

#Engle-Granger individual tests: variables - index
granger_selic_index_model_1 <- lmtest::grangertest(all_data_diff[, 2],
                                                   all_data_diff[, 1],
                                                   order = 1)

granger_ibcbr_index_model_1 <- lmtest::grangertest(all_data_diff[, 3],
                                                   all_data_diff[, 1],
                                                   order = 1)

granger_pimpf_index_model_1 <- lmtest::grangertest(all_data_diff[, 4],
                                                   all_data_diff[, 1],
                                                   order = 1)

#Engle-Granger individual tests: index - variables
granger_index_selic_model_1 <- lmtest::grangertest(all_data_diff[, 1],
                                                   all_data_diff[, 2],
                                                   order = 1)

granger_index_ibcbr_model_1 <- lmtest::grangertest(all_data_diff[, 1],
                                                   all_data_diff[, 3],
                                                   order = 1)

granger_index_pimpf_model_1 <- lmtest::grangertest(all_data_diff[, 1],
                                                   all_data_diff[, 4],
                                                   order = 1)

#joint granger causality test
granger_selic_model_1 <- vars::causality(model_var_1, cause = "selic_real_12m_diff")
granger_selic_model_1

granger_ibcbr_model_1 <- vars::causality(model_var_1, cause = "ibc_br")
granger_ibcbr_model_1

granger_pimpf_model_1 <- vars::causality(model_var_1, cause = "pim_pf")
granger_pimpf_model_1

##########################model 2##############################################

#BG individual autocorrelation tests
bg_index_model_2 <- bgtest(model_var_2$varresult$sentiment_index)
bg_selic_model_2 <- bgtest(model_var_2$varresult$selic_real_12m_diff)
bg_ibcbr_model_2 <- bgtest(model_var_2$varresult$ibc_br)
bg_pimpf_model_2 <- bgtest(model_var_2$varresult$pim_pf)

#joint autocorrelation test
vars::serial.test(model_var_2, lags.pt = 10, type = "BG")$serial

#ARCH-LM heteroskedasticity test
vars::arch.test(model_var_2, lags.multi = 15)$arch.mul

#testing for structural breaks in the residuals
plot(vars::stability(model_var_2, type = "OLS-CUSUM"))

################################################################################

#Engle-Granger individual tests: variables - index
granger_selic_index_model_2 <- lmtest::grangertest(all_data_diff[, 2],
                                                   all_data_diff[, 1],
                                                   order = 2)

granger_ibcbr_index_model_2 <- lmtest::grangertest(all_data_diff[, 3],
                                                   all_data_diff[, 1],
                                                   order = 2)

granger_pimpf_index_model_2 <- lmtest::grangertest(all_data_diff[, 4],
                                                   all_data_diff[, 1],
                                                   order = 2)

#Engle-Granger individual tests: index - variables
granger_index_selic_model_2 <- lmtest::grangertest(all_data_diff[, 1],
                                                   all_data_diff[, 2],
                                                   order = 2)

granger_index_ibcbr_model_2 <- lmtest::grangertest(all_data_diff[, 1],
                                                   all_data_diff[, 3],
                                                   order = 2)

granger_index_pimpf_model_2 <- lmtest::grangertest(all_data_diff[, 1],
                                                   all_data_diff[, 4],
                                                   order = 2)

#joint granger causality test
granger_selic_model_2 <- vars::causality(model_var_2, cause = "selic_real_12m_diff")
granger_selic_model_2

granger_ibcbr_model_2 <- vars::causality(model_var_2, cause = "ibc_br")
granger_ibcbr_model_2

granger_pimpf_model_2 <- vars::causality(model_var_2, cause = "pim_pf")
granger_pimpf_model_2