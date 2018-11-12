df <- read_csv('sep2017.csv')
df$CARRIER_DELAY <- NULL
df$WEATHER_DELAY <- NULL
df$NAS_DELAY <- NULL
df$SECURITY_DELAY <- NULL
df$LATE_AIRCRAFT_DELAY <- NULL
df$X19 <- NULL
colnames(df) <- c('date', 'carrier', 'flight_num', 'origin', 'dest', 'dest_state', 'sched_dep', 'dep', 'sched_arr', 'arr', 'cancelled', 'canc_code', 'distance')
library(lubridate)
library(magrittr)
library(chron)
df$weekday <- df$date %>% weekdays()
df$dep <- format(strptime(df$dep, format='%H%M'), format = '%H:%M')
df$sched_dep <- format(strptime(df$sched_dep, format='%H%M'), format='%H:%M')
df$dep <- paste(df$dep, '00', sep=':')
df$sched_dep <- paste(df$sched_dep, '00', sep=':')
temp <- df %>% select( dep) %>% filter(!is.na(df$dep))
x <- chron(times=temp$dep)
df %>% difftime(dep, sched_dep)
