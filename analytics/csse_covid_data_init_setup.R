library(data.table)
library(ggplot2)
library(stringr)

setwd('~/Documents/C/Research/data/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/')


### for loop approach

dates <- seq(as.Date("2020-02-01"), by = "day", length.out = 159)
dates <- as.character(dates)

list_of_files = list()
for(d in dates){
  month_num = substr(as.character(d), start = 6, stop = 7)
  day_num = substr(as.character(d), start = 9, stop = 10)
  file = paste(as.character(month_num)
               , '-'
               , as.character(day_num)
               , '-2020.csv'
               , sep = '')
  df = read.csv(file)
  df$date = d
  names(df)[grepl('state', tolower(names(df)))] = 'state'
  #names(df)[grepl('admin2', tolower(names(df)))] = 'county'
  names(df)[grepl('country', tolower(names(df)))] = 'country'
  names(df)[grepl('confirmed', tolower(names(df)))] = 'confirmed'
  names(df)[grepl('death', tolower(names(df)))] = 'deaths'
  df = df[, c('date', 'state','country', 'confirmed', 'deaths')]
  list_of_files[[d]] = df
}

dt= data.table(rbindlist(list_of_files, fill = TRUE))

## Keep only US data

dt[, .N, by = country][order(-N)][1:10]
dt = dt[country == 'US']

## keep only dates of interests
dt[, date := as.Date(date)]
dt = dt[date >= '2020-02-01' & date <= '2020-07-08']


## Extract State from data before 

dt[, .N, by = state][order(-N)][1:10]
dt[grepl(',', state), state_abb := str_sub(state, -2)]
dt[grepl(',', state), state := state.name[match(state_abb,state.abb)]]
#dt[state == 'District of Columbia', state := 'DC']
dt$state_abb = NULL


# Aggregation 

dt_agg = dt[, list(total_confirmed = sum(confirmed)
                   , total_deaths = sum(deaths))
            , by = list(state, date)][order(state,date)]

intersect(dt_agg[, unique(state)], state.name)
dt_agg = dt_agg[(state %in% state.name) | (state == 'District of Columbia')]


all_states = as.character(dt_agg[order(state), unique(state)])
all_dates = as.Date(dt_agg[order(date), unique(date)])


dt_out = data.table(date = rep(all_dates, length(all_states))
                    , state = rep(all_states, each = length(all_dates))
                    )
dt_out = base::merge(dt_out, dt_agg, by = c('state', 'date'), all.x = T)
dt_out[date == '2020-02-01' & is.na(total_confirmed),  total_confirmed:= 0]
dt_out[date == '2020-02-01' & is.na(total_deaths),  total_deaths:= 0]

# fill missing dates 
i = 1
while(nrow(dt_out[is.na(total_confirmed)])){
  print(i)
  print(nrow(dt_out[is.na(total_confirmed)]))
  dt_out[order(state, date), tmp_lagged_confirmed := shift(total_confirmed, i), by = list(state)]
  dt_out[order(state, date), tmp_lagged_death := shift(total_deaths, i), by = list(state)]
  dt_out[is.na(total_confirmed), total_confirmed:= tmp_lagged_confirmed]
  dt_out[is.na(total_deaths), total_deaths:= tmp_lagged_death]
  i = i+1
}

dt_out = dt_out[,list(state,date,total_confirmed, total_deaths)]
write.csv(dt_out, file = '~/Documents/C/Research/data/covid_state_by_date.csv')

