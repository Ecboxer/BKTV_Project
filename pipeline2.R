library(tidyverse)
library(lubridate)
library(magrittr)
library(chron)

df_oct <- read_csv('oct2017.csv')
df_nov <- read_csv('nov2017.csv')
df_dec <- read_csv('dec2017.csv')

df <- rbind(df_oct, df_nov)
df <- rbind(df, df_dec)

df$CARRIER_DELAY <- NULL
df$WEATHER_DELAY <- NULL
df$NAS_DELAY <- NULL
df$SECURITY_DELAY <- NULL
df$LATE_AIRCRAFT_DELAY <- NULL
df$X19 <- NULL
colnames(df) <- c('date', 'carrier', 'flight_num', 'origin', 'dest', 'dest_state', 'sched_dep', 'dep', 'sched_arr', 'arr', 'cancelled', 'canc_code', 'distance')

df$weekday <- df$date %>% weekdays()
df$dep <- format(strptime(df$dep, format='%H%M'), format = '%H:%M')
df$sched_dep <- format(strptime(df$sched_dep, format='%H%M'), format='%H:%M')
df$dep <- paste(df$dep, '00', sep=':')
df$dep <- paste(df$date, df$dep, sep=' ')
df$sched_dep <- paste(df$sched_dep, '00', sep=':')
df$sched_dep <- paste(df$date, df$sched_dep, sep=' ')
df$dep <- df$dep %>% strptime('%Y-%m-%d %H:%M:%OS')
df$sched_dep <- df$sched_dep %>% strptime('%Y-%m-%d %H:%M:%OS')
df$dep_delay <- difftime(df$dep, df$sched_dep, units=c('mins')) #Delay in mins st >0 => delay ^ <0 => early

df$arr <- format(strptime(df$arr, format='%H%M'), format = '%H:%M')
df$sched_arr <- format(strptime(df$sched_arr, format='%H%M'), format='%H:%M')
df$arr <- paste(df$arr, '00', sep=':')
df$arr <- paste(df$date, df$arr, sep=' ')
df$sched_arr <- paste(df$sched_arr, '00', sep=':')
df$sched_arr <- paste(df$date, df$sched_arr, sep=' ')
df$arr <- df$arr %>% strptime('%Y-%m-%d %H:%M:%OS')
df$sched_arr <- df$sched_arr %>% strptime('%Y-%m-%d %H:%M:%OS')
df$arr_delay <- difftime(df$arr, df$sched_arr, units=c('mins'))

write.csv(df, 'clean.csv')

set.seed(42)
df_sample <- df[sample(nrow(df), 1000), ]

write.csv(df_sample, 'clean_sample.csv')