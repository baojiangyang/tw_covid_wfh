library(stringr)
visualize_dgm  = function(data = df_wfh
                                 , state = 'California'
                                 , model
                                 , emotion = 'anger'
                                 , scale_y = 100
                                 , plot_with_true_values = F
                                 , with_interactions = F
                                 , excl_var = c()){
  tmp_state = state
  dt = data[state==tmp_state]
  fixed = model$coefficients$fixed
  random = model$coefficients$random$state
  state_random = random[rownames(random)==tmp_state,1]
  
  fixed_intercept = fixed['(Intercept)']
  interactions = names(fixed)[grepl(':',names(fixed) )]
  
  if(!with_interactions){
    fixed = fixed[!names(fixed) %in% interactions]
  }
  
  # exclude variables
  evs = c()
  if(length(excl_var)>0){
    for(v in excl_var){
      vs = names(fixed)[grepl(v, names(fixed))]
      evs = c(evs, vs)
    }
  }
  fixed = fixed[!names(fixed) %in% evs]
  
  # create interaction terms
  if(length(interactions)>0 & with_interactions){
    for(i in 1:length(interactions)){
      origin_term = interactions[i]
      sep_term = str_split(origin_term, ":")[[1]]
      left = dt[, sep_term[1], with = F]
      right = dt[, sep_term[2], with = F]
      dt[, origin_term] =  left*right
    }
  }
  
  sum = rep(0, nrow(dt))
  for(i in 1:length(fixed)){
    if(names(fixed)[i]=='(Intercept)'){
      sum = sum + rep(1, nrow(dt))*fixed['(Intercept)']
    }else{
      sum = sum + dt[, names(fixed)[i], with = F] * fixed[i]
    }
  }
  
  dt$pred_y = (sum + state_random)/scale_y
  
  
  emotion_col = paste('pred_', emotion, sep = '')
  stopifnot(emotion_col %in% names(dt))
  
  dt$true_y = dt[, emotion_col, with = F][[1]] * 100
  dt$pred_y = dt$pred_y * 100
  
  
  lim_pred_lower = min(dt$pred_y) - 0.4*(max(dt$pred_y) - min(dt$pred_y))
  lim_pred_upper = max(dt$pred_y) + 0.4*(max(dt$pred_y) - min(dt$pred_y))
  lim_lower = min(c(lim_pred_lower, dt$true_y)) - 0.1*(max(c(lim_pred_upper, dt$true_y)) - min(c(lim_pred_lower, dt$true_y)))
  lim_upper = max(c(lim_pred_upper, dt$true_y)) + 0.1*(max(c(lim_pred_upper, dt$true_y)) - min(c(lim_pred_lower, dt$true_y)))
  
  order_start_date = dt[, unique(start_date)]
  order_end_date = dt[, unique(end_date)]
  dt[, date := as.Date(date)]
  
  emotion = str_to_title(emotion)
  if(!plot_with_true_values){
    p <- ggplot(dt) +
      geom_line(aes(x = date, y = pred_y), size = 1.5, color = "darkblue") + ylab('Predicted Y') + 
      geom_vline(xintercept=order_start_date, colour="grey", linetype = 'dotdash') +
      geom_vline(xintercept=order_end_date, colour="grey", linetype = 'dotdash') +
      geom_text(aes(x=order_start_date, label="\norder start date", y= mean(c(lim_pred_lower, lim_pred_upper))), colour="grey", angle=90) +
      geom_text(aes(x=order_end_date, label="order end date\n", y= mean(c(lim_pred_lower, lim_pred_upper))), colour="grey", angle=90) + 
      scale_y_continuous(limits=c(max(0,lim_pred_lower), lim_pred_upper), name = emotion)+ 
      theme_bw() + xlab('Date') + theme(axis.title=element_text(size=14))
      #scale_x_discrete(breaks =c('2020-03-01', '2020-04-01','2020-05-01', '2020-06-01','2020-07-01'))
  
  }else{
    p <- ggplot(dt) +
      geom_point(aes(x = date, y = true_y), size = 1.8, color = "lightblue", shape = 17) +
      geom_line(aes(x = date, y = pred_y), size = 1.2, color="darkblue", group = 1)+
      geom_vline(xintercept=order_start_date, colour="grey", linetype = 'dotdash') +
      geom_vline(xintercept=order_end_date, colour="grey", linetype = 'dotdash') +
      geom_text(aes(x=order_start_date, label="\norder start date", y= mean(c(lim_lower, lim_upper))), colour="grey", angle=90) +
      geom_text(aes(x=order_end_date, label="order end date\n", y= mean(c(lim_lower, lim_upper))), colour="grey", angle=90) + 
      scale_y_continuous(limits=c(max(0,lim_lower), lim_upper), name = emotion) +
      theme_bw() + xlab('Date') + theme(axis.title=element_text(size=14))
      #scale_x_discrete(breaks =c('2020-03-01', '2020-04-01','2020-05-01', '2020-06-01','2020-07-01'))
  }

  p
}

# 
# #visualize_dgm(data = df_wfh, state = 'California', model = angerstage4a, excl_var = c('new_cases'))
# visualize_dgm(data = df_wfh, state = 'California', model = AngerS2Relative, with_interactions = F)
# 
# 
# p = visualize_dgm(data = df_wfh, state = 'California'
#               , model = AngerS2Relative, emotion = 'anger'
#               , with_interactions = F
#               , plot_with_true_values = T)
# 


setwd('~/Documents/C/Research/tw_covid_remote/tw_covid_wfh/reports/')
emotions = c('anger','joy','sadness','surprise','disgust','fear')
models = list(AngerS2Relative,JoyS2Relative,SadS2Relative,SurpriseS2Relative,DisgustS2Relative,FearS2Relative)
states = c('California', 'New York', 'Texas', 'Florida', 'Alabama', 'Illinois', 'Nevada')

for(s in states){
  for(i in 1:6){
    emo = emotions[i]
    emo_model = models[[i]]
    print(paste(s, emo, sep = ':'))
    
    p = visualize_dgm(data = df_wfh, state = s
                      , model = emo_model, emotion = emo
                      , with_interactions = F
                      , plot_with_true_values = T)
    ggsave(paste(s, emo, 'model_with_dots_small.jpeg', sep='_'), p, width = 10, height = 8, dpi = 200)
  }
}










