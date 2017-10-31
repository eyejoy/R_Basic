# LA 범죄 데이터

# 데이터셋은 2010년 이후 LA의 사건 사고를 나타낸다.
# 이 데이터는 종이로 기록된 사건 일지를 바꾼 것이라서 일부 오류가 있을 수 있다.
# 위치값이 없는 지역은 (0°, 0°)으로 표시되어있다.
# 주소는 프라이버스 유지를 위해 근처 100블록을 제공 된다.

# column 정의: https://data.lacity.org/A-Safe-City/Crime-Data-from-2010-to-Present/y8tr-7khq

# DR Number: 파일 번호(Division of Records Number: Official file number made up of a 2 digit year, area ID, and 5 digits)
# Date Reported: 기록일 (MM/DD/YYYY)
# Date Occurred: 사건발생일 (MM/DD/YYYY)
# Time Occurred: 사건발생시간 (In 24 hour military time.)
# Area ID: 지역ID
# Area Name: 지역명
# Reporting District: 서브 지역을 나타내는 4자리 코드
# Crime Code; 범죄코드
# Crime Code Description: 범죄코드 설명
# MO Codes: 범죄 방식
# Victim Age: 피의자 나이 (Two character numeric)
# Victim Sex: 피의자 성별 (F - Female M - Male X - Unknown)
# Victim Descent: 피의자 인종 (Descent Code: A - Other Asian B - Black C - Chinese D - Cambodian F - Filipino G - Guamanian H - Hispanic/Latin/Mexican I - American Indian/Alaskan Native J - Japanese K - Korean L - Laotian O - Other P - Pacific Islander S - Samoan U - Hawaiian V - Vietnamese W - White X - Unknown Z - Asian Indian)
# Premise Code: 범죄 장소 코드
# Premise Description: 범죄 장소 설명
# Weapon Used Code: 무기 사용 코드
# Weapon Description: 무기 사용 설명
# Status Code: 상태 코드 (Status of the case. (IC is the default))
# Status Description: 상태 설명 (체포 등등)
# Crime Code 1: 제일 주요한 범죄 코드
# Crime Code 2: 2번째 주요한 범죄 코드
# Crime Code 3: 3번째 주요한 범죄 코드
# Crime Code 4: 4번째 주요한 범죄 코드
# Address: 주소(범죄 현장 근처 100블록)
# Cross Street: 주소 주변 교차로 이름
# Location: 위치 (100블록 근처 위치, (0°, 0°)으로 표시)


# --------------------------------------------------------------- #
options("scipen" = 100)

## load data
library(tidyverse)
column_name = c("dr_num", "report_dt", "occured_dt", "occured_tm", "area_id", 
                "area_nm", "report_distict", "crime_cd", "crime_cd_desc", "mo_cd",
                "victim_age", "victim_sex", "victim_descent", "premise_cd", "premise_desc",
                "weapon_used_cd", "weapon_desc", "status_cd", "status_desc",
                "crime_cd_1", "crime_cd_2", "crime_cd_3", "crime_cd_4", 
                "address", "cross_st", "loc") 

# column type: c = character, i = integer, n = number, d = double, l =logical, D = date, T = date time, t = time, ? = guess, or _/- to skip the column.
crime_la_raw <- read_csv("data/Crime_Data_2010_2017.csv", col_names = column_name, skip = 1,
                         col_types = cols(.default = "c",
                                          report_dt = col_date("%m/%d/%Y"), occured_dt = col_date("%m/%d/%Y"), victim_age = "d"))

str(crime_la)


# 데이터 전처리 (포멧 맞추기)
library(stringr)
crime_la <- crime_la_raw %>% 
   mutate(occured_tm = parse_time(paste0(strrep("0", 4-nchar(occured_tm)), occured_tm), "%H%M"),
          latitude = matrix(as.numeric(unlist(str_extract_all(ifelse(is.na(loc), "(0, 0)", loc), "([-]?[0-9]{1,}[.]?[0-9]{0,})"))), ncol=2, byrow=T)[, 1],
          longitude = matrix(as.numeric(unlist(str_extract_all(ifelse(is.na(loc), "(0, 0)", loc), "([-]?[0-9]{1,}[.]?[0-9]{0,})"))), ncol=2, byrow=T)[, 2],
          occured_yy = strftime(occured_dt, "%Y"),
          occured_mm = strftime(occured_dt, "%Y-%m"))


# mo_cd 처리 (http://garrettgman.github.io/tidying/)
max_len_mo_cd <- max(sapply(str_split(crime_la$mo_cd, " "), length))
mo_cd_name <- str_c("mo_cd_", 1:max_len_mo_cd)
test_dt %>% 
   select(dr_num, mo_cd)

test_dt %>% 
   select(dr_num, mo_cd) %>% 
   separate(mo_cd, mo_cd_name, " ", remove=T) %>% 
   gather(key, mo_cd, -dr_num) %>% 
   filter(!is.na(mo_cd)) %>% 
   arrange(dr_num)


##



#### EDA ####
# reference: http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/
library(ggplot2)
library(scales)
library(lubridate)

### 년도별 사건 발생 현황

# 년도별 사건 발생 빈도
crime_la %>%
   group_by(occured_yy) %>% 
   summarise(occured_cnt = n()) %>% 
   ggplot(aes(x = occured_yy, y=occured_cnt)) +
   geom_bar(stat = "identity", fill = "skyblue", colour="black") +
   scale_y_continuous(labels = comma, limits = c(0, 300000))


# 년도별 * 범죄 코드
crime_la %>%
   group_by(occured_yy, crime_cd) %>% 
   summarise(occured_cnt = n()) %>% 
   filter(occured_cnt >= 5000) %>% 
   ggplot(aes(x = occured_yy, y = occured_cnt)) +
   geom_bar(stat = "identity", colour = "black", aes(fill = crime_cd)) +
   scale_y_continuous(labels = comma, limits = c(0, 300000))


# 년도별 * 범죄 방식 -> 범죄 방식 정리 필요..
crime_la %>%
   group_by(occured_yy, mo_cd) %>% 
   summarise(occured_cnt = n()) %>% 
   filter(occured_cnt >= 5000) %>% 
   ggplot(aes(x = occured_yy, y = occured_cnt)) +
   geom_bar(stat = "identity", colour = "black", aes(fill = mo_cd)) +
   scale_y_continuous(labels = comma, limits = c(0, 300000))


# 년도별 * 연령대별
crime_la %>%
   group_by(occured_yy, age_band = factor(as.integer(victim_age/10))) %>% 
   summarise(occured_cnt = n()) %>% 
   ggplot(aes(x = occured_yy, y=occured_cnt)) +
   geom_bar(stat = "identity", colour="black", aes(fill = age_band)) +
   scale_y_continuous(labels = comma, limits = c(0, 300000))


# 년도별 * 성별
crime_la %>%
   group_by(occured_yy, victim_sex) %>% 
   summarise(occured_cnt = n()) %>% 
   ggplot(aes(x = occured_yy, y = occured_cnt)) +
   geom_bar(stat = "identity", colour = "black", aes(fill = victim_sex)) +
   scale_y_continuous(labels = comma, limits = c(0, 300000))

# 년도별 * 무기 사용 정보
crime_la %>%
   group_by(occured_yy, weapon_desc) %>% 
   summarise(occured_cnt = n()) %>% 
   filter(occured_cnt >= 1000) %>% 
   ggplot(aes(x = occured_yy, y=occured_cnt)) +
   geom_bar(stat = "identity", colour="black", aes(fill = weapon_desc)) +
   scale_y_continuous(labels = comma, limits = c(0, 300000))


# 년도별 * 상태 정보
crime_la %>%
   group_by(occured_yy, status_desc) %>% 
   summarise(occured_cnt = n()) %>% 
   filter(occured_cnt >= 100) %>% 
   ggplot(aes(x = occured_yy, y=occured_cnt)) +
   geom_bar(stat = "identity", colour="black", aes(fill = status_desc)) +
   scale_y_continuous(labels = comma, limits = c(0, 300000))


# 년도별 * 주요 범죄 코드
crime_la %>%
   group_by(occured_yy, crime_cd_1) %>% 
   summarise(occured_cnt = n()) %>% 
   filter(occured_cnt >= 1000) %>% 
   ggplot(aes(x = occured_yy, y=occured_cnt)) +
   geom_bar(stat = "identity", colour="black", aes(fill = crime_cd_1)) +
   scale_y_continuous(labels = comma, limits = c(0, 300000))


# 년도별 * 위치(주변 교차로)
crime_la %>%
   group_by(occured_yy, cross_st) %>% 
   summarise(occured_cnt = n()) %>% 
   filter(occured_cnt >= 500) %>% 
   ggplot(aes(x = occured_yy, y=occured_cnt)) +
   geom_bar(stat = "identity", colour="black", aes(fill = cross_st)) +
   scale_y_continuous(labels = comma, limits = c(0, 300000))



# 년도별 * 위치(주변 교차로)
crime_la %>%
   filter(loc == "(0, 0)") %>% 
   group_by(occured_yy) %>% 
   summarise(occured_cnt = n())

## 지도 그리기
# https://lovetoken.github.io/r/data_visualization/2016/10/18/ggmap.html
# http://trucvietle.me/r/tutorial/2017/01/18/spatial-heat-map-plotting-using-r.html
# http://www.exegetic.biz/blog/2013/12/contour-and-density-layers-with-ggmap/
# http://stat405.had.co.nz/ggmap.pdf

# 네모네모 density: http://flovv.github.io/Gas_price-Mapping/
library(ggmap)
library(RColorBrewer)

# 도화지 선택
get_googlemap("LA", zoom = 10, maptype = "satellite") %>% ggmap(extent = "device")
get_googlemap("LA", zoom = 10, maptype = "hybrid") %>% ggmap(extent = "device")
get_googlemap("LA", zoom = 10, maptype = "terrain") %>% ggmap(extent = "device")
get_googlemap("LA", zoom = 10, maptype = "roadmap") %>% ggmap(extent = "device")


get_googlemap("LA", zoom = 10, maptype = "satellite") %>% ggmap(extent = "device") +
   geom_point(data = crime_la, aes(x = longitude, y = latitude), color="red", alpha=0.1)

# 년도별 시각화
map_la <- get_googlemap("LA", zoom = 11, maptype = "satellite") %>% ggmap(extent = "device")
map_la +
   stat_density2d(data = crime_la, aes(x=longitude, y=latitude, fill=..level.., alpha=..level..), geom="polygon") +
   scale_fill_gradient(low = "yellow", high = "red") +
   guides(size = F, alpha = F) +
   facet_wrap(~occured_yy)


####

## boxplot: http://sape.inf.usi.ch/quick-reference/ggplot2/facet

### 월별 사건 발생 현황

# 월별 사건 발생 빈도 (2010년 ~ 2011년)
crime_la %>%
   filter(occured_yy >= 2010 & occured_yy <= 2011) %>% 
   group_by(occured_mm) %>% 
   summarise(occured_cnt = n()) %>% 
   ggplot(aes(x = occured_mm, y=occured_cnt)) +
   geom_bar(stat = "identity", fill = "skyblue", colour="black") + 
   scale_y_continuous(labels = comma, limits = c(0, 20000))

# 월별 사건 발생 빈도 (2012년 ~ 2013년)
crime_la %>%
   filter(occured_yy >= 2012 & occured_yy <= 2013) %>% 
   group_by(occured_mm) %>% 
   summarise(occured_cnt = n()) %>% 
   ggplot(aes(x = occured_mm, y=occured_cnt)) +
   geom_bar(stat = "identity", fill = "skyblue", colour="black") +
   scale_y_continuous(labels = comma, limits = c(0, 20000))

# 월별 사건 발생 빈도 (2014년 ~ 2015년)
crime_la %>%
   filter(occured_yy >= 2014 & occured_yy <= 2015) %>% 
   group_by(occured_mm) %>% 
   summarise(occured_cnt = n()) %>% 
   ggplot(aes(x = occured_mm, y=occured_cnt)) +
   geom_bar(stat = "identity", fill = "skyblue", colour="black") +
   scale_y_continuous(labels = comma, limits = c(0, 20000))

# 월별 사건 발생 빈도 (2016년 ~ 2017년)
crime_la %>%
   filter(occured_yy >= 2016 & occured_yy <= 2017) %>% 
   group_by(occured_mm) %>% 
   summarise(occured_cnt = n()) %>% 
   ggplot(aes(x = occured_mm, y=occured_cnt)) +
   geom_bar(stat = "identity", fill = "skyblue", colour="black") +
   scale_y_continuous(labels = comma, limits = c(0, 20000))


# 년도별 * 지역
crime_la %>%
   group_by(occured_yy, area_nm) %>% 
   summarise(occured_cnt = n()) %>% 
   ggplot(aes(x = occured_yy, y=occured_cnt)) +
   geom_bar(stat = "identity", colour="black", aes(fill = area_nm)) +
   scale_y_continuous(labels = comma, limits = c(0, 300000))