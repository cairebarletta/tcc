##########################model 1##############################################

#VAR model specification
model_var_selection <- vars::VARselect(all_data_diff,
                                       type = "none",
                                       lag.max = 10)[["selection"]]

#VAR model estimation -> p = 1
model_var_1 <- vars::VAR(all_data_diff,
                         type = "none",
                         p = 1)

model_summary_1 <- model_var_1 %>% urca::summary()
model_summary_1[["roots"]]
model_summary_1


#index - index
irf_index <- vars::irf(model_var_1,
                       impulse = "sentiment_index",
                       response = "sentiment_index",
                       n.ahead = 30,
                       boot = T)

plot(irf_index,
     main = "Choque do Índice de Sentimentos", 
     ylab = "Índice de Sentimentos",
     xlab = "")

#index - selic
irf_selic <- vars::irf(model_var_1,
                      impulse = "sentiment_index",
                      response = "selic_real_12m_diff",
                      n.ahead = 30,
                      boot = T)

plot(irf_selic, main = "Choque do Índice de Sentimentos", 
     ylab = "D(Juros Real)")

#index - ibc_br
irf_ibcbr <- vars::irf(model_var_1,
                       impulse = "sentiment_index",
                       response = "ibc_br",
                       n.ahead = 30,
                       boot = T)

plot(irf_ibcbr, main = "Choque do Índice de Sentimentos", 
     ylab = "Atividade Econômica")

#index - pim_pf
irf_pimpf <- vars::irf(model_var_1,
                       impulse = "sentiment_index",
                       response = "pim_pf",
                       n.ahead = 30,
                       boot = T)

plot(irf_pimpf, main = "Choque do Índice de Sentimentos", 
     ylab = "Produção Industrial")

##########################model 2##############################################

#VAR model estimation -> p = 2
model_var_2 <- vars::VAR(all_data_diff,
                         type = "none",
                         p = 2)

model_summary_2 <- model_var_2 %>% urca::summary()
model_summary_2[["roots"]]
model_summary_2

#index - index
irf_index <- vars::irf(model_var_2,
                       impulse = "sentiment_index",
                       response = "sentiment_index",
                       n.ahead = 30,
                       boot = T)

plot(irf_index,
     main = "Choque do Índice de Sentimentos", 
     ylab = "Índice de Sentimentos",
     xlab = "")

#index - selic
irf_selic <- vars::irf(model_var_2,
                       impulse = "sentiment_index",
                       response = "selic_real_12m_diff",
                       n.ahead = 30,
                       boot = T)

plot(irf_selic, main = "Choque do Índice de Sentimentos", 
     ylab = "D(Juros Real)")

#index - ibc_br
irf_ibcbr <- vars::irf(model_var_2,
                       impulse = "sentiment_index",
                       response = "ibc_br",
                       n.ahead = 30,
                       boot = T)

plot(irf_ibcbr, main = "Choque do Índice de Sentimentos", 
     ylab = "Atividade Econômica")

#index - pim_pf
irf_pimpf <- vars::irf(model_var_2,
                       impulse = "sentiment_index",
                       response = "pim_pf",
                       n.ahead = 30,
                       boot = T)

plot(irf_pimpf, main = "Choque do Índice de Sentimentos", 
     ylab = "Produção Industrial")