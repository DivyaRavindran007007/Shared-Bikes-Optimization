mean_midnight = read.csv("~/mean_bikes_at_midnight.csv",sep="/")
colnames(mean_midnight) = c("X","station_id","bikes_after_optm")
mean_midnight["start_hour"] = as.factor("0")
mean_midnight[1] = NULL
mean_midnight["bikes_after_optm"] = lapply(mean_midnight["bikes_after_optm"], round)

prev_rslt = readRDS("~/result.rds",sep="/")

shp = prev_rslt$station_hourly_preds

levels(shp$start_hour) = list("0" = c("0","1","2","3","4","5","6","7","8","9"),
                              "10" = c("10","11","12","13","14","15","16"), "17" = c("17","18"),
                              "19" = c("19","20","21","22","23"))
shp[3:6] = NULL

library(data.table)
shp = data.table(shp)
shp_grouped = shp[, lapply(.SD, sum, na.rm=TRUE), by=list(station_id,start_hour) ]
shp_grouped[,ideal_inv:=(predicted_leav_upper-predicted_arr)]

head(shp_grouped)
mm_dt = data.table(mean_midnight)

shp_mrg = mm_dt[shp_grouped, on = c("station_id","start_hour")]
shp_mrg$bikes_after_optm <- ifelse(is.na(shp_mrg$bikes_after_optm), shp_mrg$predicted_leav_upper - shp_mrg$predicted_arr, shp_mrg$bikes_after_optm)

shp_order = shp_mrg[order(station_id,start_hour)]

shp_full = shp_order[, bikes_before_optm := shift(bikes_after_optm) - shift(predicted_leav) + shift(predicted_arr), by = list(station_id)]

library(tidyverse)
shp_full = shp_full %>%
  group_by(station_id) %>%
  mutate(bikes_before_optm=ifelse(is.na(bikes_before_optm),
                                  sum(bikes_after_optm[start_hour == "19"],
                                      -predicted_leav[start_hour == "19"],
                                      predicted_arr[start_hour == "19"]),
                                  bikes_before_optm))

write.csv(shp_full, "~/station_hourly_supply_demand_200_station.csv",sep="/")

dat <- expand.grid(unique(train_leav$station_id), 
                   seq(1:24) - 1, 
                   seq(1:12), 
                   25,
                   10,
                   c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

colnames(dat) <- c("station_id","end_hour","end_month","tempC","visibility","day_of_week")

dat[, 2] <- as.factor(dat[, 2])
dat[, 3] <- as.factor(dat[, 3])

arrPred = predict(arr_pred, newdata = dat, type = "response")

colnames(dat) <- c("station_id","start_hour","start_month","tempC","visibility","day_of_week")

leavPred = predict(leav_pred, newdata = dat, type = "response")

dat <- cbind(dat, arrPred, leavPred)
write.csv(dat, "~/divvy.csv",sep="/")