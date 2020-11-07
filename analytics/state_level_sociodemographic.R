library(data.table)
library(readxl)

mydir = "~/Documents/C/Research/data/social-demographic"
myfiles = list.files(path=mydir, pattern="*.xlsx", full.names=TRUE)
myfiles

length(state.name)

state_names = c(state.name, 'District of Columbia')
state_names = sort(state_names)


### age sex distribution 
agesex_files <- myfiles[grepl('social-demographic/sc-est2019-agesex', myfiles)]
agesex_files <- sort(agesex_files)

states_info_pool <- list()

for(i in 1:length(agesex_files)){
  f = agesex_files[i]
  s = state_names[i]
  dt <- read_excel(f, sheet = 1)
  dt <- dt[c(5, 25, 30:33), c(1, (ncol(dt)-1):ncol(dt))]
  #dt <- data.table(dt)
  names(dt) <- c('ages_group', 'male', 'female')
  total = as.integer(dt[1,2]) + as.integer(dt[1,3])
  segs = c(as.integer(dt[2:6,2][[1]]), as.integer(dt[2:6,3][[1]]) )
  segs = segs/total
  segs = c(s, segs)
  states_info_pool[[s]] = segs
}

states_info_pool[[1]]


df_sex = do.call(rbind.data.frame, states_info_pool)
names(df_sex) <- c('state'
              , 'm_le18', 'm_18_24', 'm_25_44', 'm_45_64', 'm_ge_65'
              , 'f_le18', 'f_18_24', 'f_25_44', 'f_45_64', 'f_ge_65')



### race distribution 
racefiles <- myfiles[grepl('social-demographic/sc-est2019-sr11h', myfiles)]
racefiles <- sort(racefiles)

states_info_pool <- list()

for(i in 1:length(racefiles)){
  f = racefiles[i]
  s = state_names[i]
  dt <- read_excel(f, sheet = 1)
  dt <- dt[c(4,6:10), c(1,13)]
  #dt <- data.table(dt)
  names(dt) <- c('race_group', 'cnt')
  total = as.integer(dt[1,2])
  segs = as.integer(dt[2:6,2][[1]])
  segs = segs/total
  segs = c(s, total, segs)
  states_info_pool[[s]] = segs
}

df_race = do.call(rbind.data.frame, states_info_pool)
names(df_race) <- c('state'
                   , 'total_population', 'white', 'black_or_african_american', 'american_indian_and_alaska_native', 'asian'
                   , 'native_hawaiian_and_other_pacific_islander')



### education
edu_file <- data.table(read.csv('~/Documents/C/Research/data/social-demographic/education_data_state_level.csv'))

intersect(df_race$state, edu_file$State)
colnames(edu_file)[1] <- 'state'

df_edu <- rbind(edu_file
                , data.table(state = 'District of Columbia'
                             , PercentHighSchoolOrHigher = 90.6
                             , PercentBachelorsOrHigher = 57.5
                             )
                )




## AGG

df_state_demographic = base::merge(df_sex, df_race, by = 'state', all.x = T)
df_state_demographic = base::merge(df_state_demographic, df_edu, by = 'state', all.x = T)


write.csv(df_state_demographic, file = '~/Documents/C/Research/data/state_socio_demographic_sex_pop_edu_race.csv')
