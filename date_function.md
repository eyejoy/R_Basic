R에서 날짜 타입 다루기
================

------------------------------------------------------------------------

날짜-시간 클래스
----------------

`POSIX` 날짜/시간 클래스는 운영계의 인터페이스를 표현

-   `POSIX`클래스는 두 종류(`POSIXct`와 `POSIXlt`)가 있고 이들의 차이는 저장 방식

    | 클래스    | 설명                                     |
    |-----------|------------------------------------------|
    | `Date`    | 일반적인 날짜 클래스 (yyyy-mm-dd 형태)   |
    | `POSIXct` | 1970년 1월 1일 기점으로 시간을 초로 저장 |
    | `POSIXlt` | 연, 월, 시, 분, 초를 각각 저장           |

    -   참고: <http://blog.naver.com/dfdf4912/220623488198>

------------------------------------------------------------------------

날짜 포멧
---------

아래와 같은 다양한 포멧이 존재

-   시간대 정보는 `OlsonNames()`로 확인 가능 (참고: <https://en.wikipedia.org/wiki/Time_zone>)

    | 포멧       | 정의                                         | 예제               |
    |------------|----------------------------------------------|--------------------|
    | `%a`       | 요일 약어                                    | Sun, Thu           |
    | `%A`       | 요일 이름                                    | Sunday, Thusday    |
    | `%b or %h` | 월 약어                                      | May, Jul           |
    | `%B`       | 월 이름                                      | May, Jul           |
    | `%d`       | 일자(01~31)                                  | 27, 01             |
    | `%j`       | 1년 중 일자(001~366)                         | 148, 188           |
    | `%m`       | 월(01~12)                                    | 05, 07             |
    | `%U`       | 주(01~53, 주 시작일은 일요일)                | 22, 27             |
    | `%w`       | 요일(0~6, 0은 일요일)                        | 0, 4               |
    | `%W`       | 주(00~53, 주 시작일은 월요일)                | 21, 27             |
    | `%y`       | 두자리 년도                                  | 84, 05             |
    | `%Y`       | 네자리 년도(00~68: 20xx, 69~90: 19xx)        | 1984, 2005         |
    | `%C`       | 세기                                         | 19, 20             |
    | `%D`       | %m/%d/%y 형                                  | 05/27/84, 07/07/05 |
    | `%u`       | 요일(1~7, 1은 월요일)                        | 7, 4               |
    | `%Z`       | 시간대(KST: 한국, GMT: 영국, UTC: 세계 표준) | KST, UTC           |

    -   참고: <https://www.r-bloggers.com/date-formats-in-r/>

------------------------------------------------------------------------

R Code: 날짜 읽기
-----------------

**날짜 데이터 &gt;&gt; `POSIX` 클래스로 변환**

-   `strptime`: 포멧에 맞는 날짜 데이터를 입력

-   `ISOdate`: 날짜 데이터의 "년, 월, 일, 시, 분, 초"를 입력

    ``` r
    strptime('16/Oct/2005:07:51:00',format='%d/%b/%Y:%H:%M:%S')
    #> [1] NA
    ISOdate(2005,10,21,18,47,22)
    #> [1] "2005-10-21 18:47:22 GMT"
    ```

**날짜 데이터 &gt;&gt; "년, 월, 일, 시, 분, 초"로 변환**

-   각각 value가 존재(년: year, 월: mon, 일: mday, 시: hour, 분: hour, 초: sec, 요일: wday, 1년 중 일수: yday, 시간대: zone)

-   `format` 함수도 사용 가능

    ``` r
    # 년, 월, 일, 시, 분, 초 출력
    test_date = as.POSIXlt("2017-09-06 07:01:00")
    test_date$year
    #> [1] 117

    # format 함수 사용
    format(test_date, "%Y")
    #> [1] "2017"
    strftime(test_date, "%Y")
    #> [1] "2017"
    ```

**문자열 &gt;&gt; 날짜 데이터로 변환**

-   함수: `format`, `as.Date`, `strptime`, `as.POSIXlt`

    ``` r
    # format function
    format(Sys.time(), "%a, %A, %b, %B, %d, %D, %X, %Y , %Z")
    #> [1] "화, 화요일, 9, 9월, 12, 09/12/17, 오후 11:29:26, 2017 , KST"
    format("170906", format="%y%m%d")
    #> [1] "170906"

    # as.Date function
    as.Date('2017-09-06')
    #> [1] "2017-09-06"
    as.Date('2017/09/06')
    #> [1] "2017-09-06"
    as.Date('06/09/2017', format='%m/%d/%Y')
    #> [1] "2017-06-09"
    as.Date('April 09, 2017',format='%B %d, %Y')
    #> [1] NA
    as.Date('06JUN17',format='%d%b%y')
    #> [1] NA
    as.Date('170906',format='%y%m%d')
    #> [1] "2017-09-06"

    # weekdays function
    bdays <- c(tukey=as.Date('1915-06-16'), fisher=as.Date('1890-02-17'),
               cramer=as.Date('1893-09-25'), kendall=as.Date('1907-09-06'))
    weekdays(bdays)
    #>    tukey   fisher   cramer  kendall 
    #> "수요일" "월요일" "월요일" "금요일"

    # strptime function
    strptime('170906',format='%y%m%d', tz="Asia/Seoul")
    #> [1] "2017-09-06 KST"

    # as.POSIXlt function
    dts <- c("2005-10-21 18:47:22", "2005-12-24 16:39:58", "2005-10-28 07:30:05 PDT")
    as.POSIXlt(dts)
    #> [1] "2005-10-21 18:47:22 KST" "2005-12-24 16:39:58 KST"
    #> [3] "2005-10-28 07:30:05 KST"

    mydates <- c(1127056501, 1104295502, 1129233601, 1113547501, 
                 1119826801, 1132519502, 1125298801, 1113289201)
    class(mydates) <- c('POSIXt','POSIXct')
    mydates
    #> [1] "2005-09-19 00:15:01 KST" "2004-12-29 13:45:02 KST"
    #> [3] "2005-10-14 05:00:01 KST" "2005-04-15 15:45:01 KST"
    #> [5] "2005-06-27 08:00:01 KST" "2005-11-21 05:45:02 KST"
    #> [7] "2005-08-29 16:00:01 KST" "2005-04-12 16:00:01 KST"
    ```

-   클래스 확인

    ``` r
    class(format("170906", format="%y%m%d"))
    #> [1] "character"
    class(as.Date("170906", format="%y%m%d"))
    #> [1] "Date"
    class(strptime("170906", format="%y%m%d", tz="Asia/Seoul"))
    #> [1] "POSIXlt" "POSIXt"
    ```

------------------------------------------------------------------------

R Code: 날짜/시간 차이
----------------------

-   날짜/시간 차이 계산하는 함수: `difftime()`

    -   차이 값의 형태를 설정 가능 (`units: "auto", "secs", "mins", "hours", "days", "weeks"`)

    ``` r
    b1 <- as.Date("170806", format="%y%m%d")
    b2 <- as.Date("170906", format="%y%m%d")
    difftime(b2, b1, units="days")
    #> Time difference of 31 days

    c1 <- strptime("170806", format="%y%m%d", tz="Asia/Seoul")
    c2 <- strptime("170906", format="%y%m%d", tz="Asia/Seoul")
    difftime(c2, c1, units="days")
    #> Time difference of 31 days
    ```

------------------------------------------------------------------------

`lubridate` 패키지
------------------

-   R에서 날짜와 시간을 다루는 패키지

    -   \[참고\] `tribble` 에서 사용하는 시간 타입: `date`, `time`, `dttm`:

    ``` r
    today()
    #> [1] "2017-09-12"
    now()
    #> [1] "2017-09-12 23:29:26 KST"
    ```

-   **문자열 &gt;&gt; 날짜 데이터로 변환**

    ``` r
    ymd("2017-01-31")
    #> [1] "2017-01-31"
    mdy("January 31st, 2017")
    #> [1] "2017-03-01"
    dmy("31-Jan-2017")
    #> [1] "2017-01-31"
    ymd(20170131)
    #> [1] "2017-01-31"
    ymd_hms("2017-01-31 20:11:59")
    #> [1] "2017-01-31 20:11:59 UTC"
    mdy_hm("01/31/2017 08:01")
    #> [1] "2017-01-31 08:01:00 UTC"
    ymd(20170131, tz = "UTC")
    #> [1] "2017-01-31 UTC"
    ```

-   **"년, 월, 일, 시, 분, 초" &gt;&gt; 날짜 데이터로 변환**

    ``` r
    library(nycflights13)

    flights %>% 
    select(year, month, day, hour, minute)
    #> # A tibble: 336,776 x 5
    #>     year month   day  hour minute
    #>    <int> <int> <int> <dbl>  <dbl>
    #>  1  2013     1     1     5     15
    #>  2  2013     1     1     5     29
    #>  3  2013     1     1     5     40
    #>  4  2013     1     1     5     45
    #>  5  2013     1     1     6      0
    #>  6  2013     1     1     5     58
    #>  7  2013     1     1     6      0
    #>  8  2013     1     1     6      0
    #>  9  2013     1     1     6      0
    #> 10  2013     1     1     6      0
    #> # ... with 336,766 more rows

    flights %>% 
    select(year, month, day, hour, minute) %>% 
    mutate(departure = make_datetime(year, month, day, hour, minute))
    #> # A tibble: 336,776 x 6
    #>     year month   day  hour minute           departure
    #>    <int> <int> <int> <dbl>  <dbl>              <dttm>
    #>  1  2013     1     1     5     15 2013-01-01 05:15:00
    #>  2  2013     1     1     5     29 2013-01-01 05:29:00
    #>  3  2013     1     1     5     40 2013-01-01 05:40:00
    #>  4  2013     1     1     5     45 2013-01-01 05:45:00
    #>  5  2013     1     1     6      0 2013-01-01 06:00:00
    #>  6  2013     1     1     5     58 2013-01-01 05:58:00
    #>  7  2013     1     1     6      0 2013-01-01 06:00:00
    #>  8  2013     1     1     6      0 2013-01-01 06:00:00
    #>  9  2013     1     1     6      0 2013-01-01 06:00:00
    #> 10  2013     1     1     6      0 2013-01-01 06:00:00
    #> # ... with 336,766 more rows
    ```

-   **나머지 타입 &gt;&gt; 날짜 데이터로 변환**

    ``` r
    as_datetime(today())
    #> [1] "2017-09-12 UTC"
    as_date(now())
    #> [1] "2017-09-12"
    as_datetime(60 * 60 * 10)
    #> [1] "1970-01-01 10:00:00 UTC"
    as_date(365 * 10 + 2)
    #> [1] "1980-01-01"
    ```

-   **date &gt;&gt; "년, 월, 일, 시, 분, 초"로 변환**

    ``` r
    datetime <- ymd_hms("2016-07-08 12:34:56")

    year(datetime)
    #> [1] 2016
    month(datetime)
    #> [1] 7
    mday(datetime)
    #> [1] 8
    yday(datetime)
    #> [1] 190
    wday(datetime)
    #> [1] 6
    month(datetime, label = T)
    #> [1] Jul
    #> 12 Levels: Jan < Feb < Mar < Apr < May < Jun < Jul < Aug < Sep < ... < Dec
    wday(datetime, label = T, abbr = F)
    #> [1] Friday
    #> 7 Levels: Sunday < Monday < Tuesday < Wednesday < Thursday < ... < Saturday
    ```

-   **날짜/시간 차이 계산**

    -   durations: 시간을 초로 표현

    ``` r
    chaa_age <- today() - ymd(20170425)
    as.duration(chaa_age)
    #> [1] "12096000s (~20 weeks)"

    # duration 표현 (기간을 모두 초로 저장)
    dseconds(15)
    #> [1] "15s"
    dminutes(10)
    #> [1] "600s (~10 minutes)"
    dhours(c(12, 24))
    #> [1] "43200s (~12 hours)" "86400s (~1 days)"
    ddays(0:5)
    #> [1] "0s"                "86400s (~1 days)"  "172800s (~2 days)"
    #> [4] "259200s (~3 days)" "345600s (~4 days)" "432000s (~5 days)"
    dweeks(3)
    #> [1] "1814400s (~3 weeks)"
    dyears(1)
    #> [1] "31536000s (~52.14 weeks)"

    # DST, 섬머타임 이슈
    ymd_hms("2016-03-12 13:00:00", tz = "America/New_York") + ddays(1)
    #> [1] "2016-03-13 14:00:00 EDT"
    ```

    -   periods: 시간을 주나 달로 표현

    ``` r
    seconds(15)
    #> [1] "15S"
    minutes(10)
    #> [1] "10M 0S"
    hours(c(12, 24))
    #> [1] "12H 0M 0S" "24H 0M 0S"
    days(7)
    #> [1] "7d 0H 0M 0S"
    months(1:6)
    #> [1] "1m 0d 0H 0M 0S" "2m 0d 0H 0M 0S" "3m 0d 0H 0M 0S" "4m 0d 0H 0M 0S"
    #> [5] "5m 0d 0H 0M 0S" "6m 0d 0H 0M 0S"
    weeks(3)
    #> [1] "21d 0H 0M 0S"
    years(1)
    #> [1] "1y 0m 0d 0H 0M 0S"

    10 * (months(6) + days(1))
    #> [1] "60m 10d 0H 0M 0S"

    # DST, 섬머타임 이슈 해결
    ymd_hms("2016-03-12 13:00:00", tz = "America/New_York") + days(1)
    #> [1] "2016-03-13 13:00:00 EDT"
    ```

    -   intervals, 시작점과 끝점을 표현

    ``` r
    # 추정치로 계산
    years(1) / days(1)
    #> [1] 365.25

    next_year <- today() + years(1)
    (today() %--% next_year) / ddays(1)
    #> [1] 365

    (today() %--% next_year) %/% days(1)
    #> [1] 365
    ```

-   `lubridate` package를 이용한 시간 데이터 전처리

    ``` r
    library(dplyr)
    data(lakers)

    # raw 데이터 확인
    (lakers <- lakers %>% tbl_df)
    #> # A tibble: 34,624 x 13
    #>        date opponent game_type  time period      etype  team
    #>       <int>    <chr>     <chr> <chr>  <int>      <chr> <chr>
    #>  1 20081028      POR      home 12:00      1  jump ball   OFF
    #>  2 20081028      POR      home 11:39      1       shot   LAL
    #>  3 20081028      POR      home 11:37      1    rebound   LAL
    #>  4 20081028      POR      home 11:25      1       shot   LAL
    #>  5 20081028      POR      home 11:23      1    rebound   LAL
    #>  6 20081028      POR      home 11:22      1       shot   LAL
    #>  7 20081028      POR      home 11:22      1       foul   POR
    #>  8 20081028      POR      home 11:22      1 free throw   LAL
    #>  9 20081028      POR      home 11:00      1       foul   LAL
    #> 10 20081028      POR      home 10:53      1       shot   POR
    #> # ... with 34,614 more rows, and 6 more variables: player <chr>,
    #> #   result <chr>, points <int>, type <chr>, x <int>, y <int>

    # time_index 추가
    lakers <- lakers %>% 
    mutate(date = paste(date, time) %>% ymd_hm) %>% 
        rename(time_index = date) %>% 
        select(-time)
    lakers
    #> # A tibble: 34,624 x 12
    #>             time_index opponent game_type period      etype  team
    #>                 <dttm>    <chr>     <chr>  <int>      <chr> <chr>
    #>  1 2008-10-28 12:00:00      POR      home      1  jump ball   OFF
    #>  2 2008-10-28 11:39:00      POR      home      1       shot   LAL
    #>  3 2008-10-28 11:37:00      POR      home      1    rebound   LAL
    #>  4 2008-10-28 11:25:00      POR      home      1       shot   LAL
    #>  5 2008-10-28 11:23:00      POR      home      1    rebound   LAL
    #>  6 2008-10-28 11:22:00      POR      home      1       shot   LAL
    #>  7 2008-10-28 11:22:00      POR      home      1       foul   POR
    #>  8 2008-10-28 11:22:00      POR      home      1 free throw   LAL
    #>  9 2008-10-28 11:00:00      POR      home      1       foul   LAL
    #> 10 2008-10-28 10:53:00      POR      home      1       shot   POR
    #> # ... with 34,614 more rows, and 6 more variables: player <chr>,
    #> #   result <chr>, points <int>, type <chr>, x <int>, y <int>

    # 월별 평균 데이터 추출
    lakers %>% 
        group_by(month(time_index)) %>% 
        summarize(mean_x = mean(x, na.rm = T), mean_y = mean(y, na.rm = T))
    #> # A tibble: 7 x 3
    #>   `month(time_index)`   mean_x   mean_y
    #>                 <dbl>    <dbl>    <dbl>
    #> 1                   1 25.49382 13.89279
    #> 2                   2 25.01759 13.17499
    #> 3                   3 25.51587 13.20571
    #> 4                   4 25.38344 13.46396
    #> 5                  10 24.92188 13.12500
    #> 6                  11 25.47463 13.36926
    #> 7                  12 25.05895 13.48262

    # 기간 조건 사용
    inter <- interval(ymd_hms("2008-10-28 12:00:00"), ymd_hms("2009-03-09 00:33:00"))
    # inter <- ymd_hms("2008-10-28 12:00:00") %--% ymd_hms("2009-03-09 00:33:00")

    lakers %>% 
        filter(time_index %within% inter)
    #> # A tibble: 25,554 x 12
    #>             time_index opponent game_type period     etype  team
    #>                 <dttm>    <chr>     <chr>  <int>     <chr> <chr>
    #>  1 2008-10-28 12:00:00      POR      home      1 jump ball   OFF
    #>  2 2008-10-29 12:00:00      LAC      away      1 jump ball   OFF
    #>  3 2008-10-29 11:36:00      LAC      away      1      shot   LAL
    #>  4 2008-10-29 11:24:00      LAC      away      1      shot   LAC
    #>  5 2008-10-29 11:24:00      LAC      away      1   rebound   LAL
    #>  6 2008-10-29 11:08:00      LAC      away      1      shot   LAL
    #>  7 2008-10-29 10:58:00      LAC      away      1      shot   LAC
    #>  8 2008-10-29 10:57:00      LAC      away      1   rebound   LAL
    #>  9 2008-10-29 10:41:00      LAC      away      1      shot   LAL
    #> 10 2008-10-29 10:40:00      LAC      away      1   rebound   LAC
    #> # ... with 25,544 more rows, and 6 more variables: player <chr>,
    #> #   result <chr>, points <int>, type <chr>, x <int>, y <int>
    ```

------------------------------------------------------------------------

활용 예제
---------

-   A게임의 접속 정보가 1분에 한번씩 채널 정보가 기록 됨
    1.  유저별 최종 접속 시간 추출
    2.  동일한 채널에 1시간 동안 접속을 유지하고 있는 고객 추출
    3.  유저별 접속 주기 추출 (1분씩 접속한 기록 제외하고 재접속 시간 계산)

    ``` r
    library(tidyverse)
    library(lubridate)

    # 데이터 생성
    raw_dt <- rbind(
        data.frame(usr_id="a002", ch="05", 
                   gn_dt=seq(from=as.POSIXct("2017-09-07 08:00:00"), 
                             to=as.POSIXct("2017-09-07 09:31:00"), by="min")),
        data.frame(usr_id="a004", ch="07",
                   gn_dt=seq(from=as.POSIXct("2017-09-07 08:00:00"), 
                             to=as.POSIXct("2017-09-07 08:31:00"), by="min")),
        data.frame(usr_id="a003", ch="05", 
                   gn_dt=seq(from=as.POSIXct("2017-09-07 08:00:00"), 
                             to=as.POSIXct("2017-09-07 08:31:00"), by="min")),
        data.frame(usr_id="a003", ch="11", 
                   gn_dt=seq(from=as.POSIXct("2017-09-07 21:00:00"), 
                             to=as.POSIXct("2017-09-07 21:44:00"), by="min")),
        data.frame(usr_id="a001", ch="12", 
                   gn_dt=seq(from=as.POSIXct("2017-09-07 19:40:00"), 
                             to=as.POSIXct("2017-09-07 19:51:00"), by="min")),
        data.frame(usr_id="a005", ch="15",
                   gn_dt=seq(from=as.POSIXct("2017-09-07 22:05:00"), 
                             to=as.POSIXct("2017-09-08 01:22:00"), by="min")),
        data.frame(usr_id="a006", ch="13", 
                   gn_dt=seq(from=as.POSIXct("2017-09-07 23:10:00"), 
                             to=as.POSIXct("2017-09-08 00:38:00"), by="min")))

    # tibble 형태로 변환
    raw_dt <- raw_dt %>% 
        map_if(is.factor, as.character) %>%
        as_data_frame

    # 데이터 전처리
    # https://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html
    # http://rfriend.tistory.com/242

    # 1. 유저별 최종 접속 정보 시간
    raw_dt %>% 
        group_by(usr_id) %>% 
        mutate(tm_rnk=row_number(desc(gn_dt))) %>% 
        filter(tm_rnk==1) %>% 
        arrange(usr_id)
    #> # A tibble: 6 x 4
    #> # Groups:   usr_id [6]
    #>   usr_id    ch               gn_dt tm_rnk
    #>    <chr> <chr>              <dttm>  <int>
    #> 1   a001    12 2017-09-07 19:51:00      1
    #> 2   a002    05 2017-09-07 09:31:00      1
    #> 3   a003    11 2017-09-07 21:44:00      1
    #> 4   a004    07 2017-09-07 08:31:00      1
    #> 5   a005    15 2017-09-08 01:22:00      1
    #> 6   a006    13 2017-09-08 00:38:00      1


    # 2. 동일한 채널에 1시간 동안 접속을 유지하고 있는 고객 추출 (방법1)
    raw_dt %>% 
        group_by(usr_id, ch) %>% 
        mutate(contiuous_gp = row_number() +
                   as.integer(difftime(Sys.time(), gn_dt, units="mins"))) %>% 
        summarise(n = n()) %>% 
        filter(n >= 60)
    #> # A tibble: 3 x 3
    #> # Groups:   usr_id [3]
    #>   usr_id    ch     n
    #>    <chr> <chr> <int>
    #> 1   a002    05    92
    #> 2   a005    15   198
    #> 3   a006    13    89

    # 2. 동일한 채널에 1시간 동안 접속을 유지하고 있는 고객 추출 (방법2)
    raw_dt %>% 
        mutate(rnk = row_number()) %>% 
        group_by(usr_id, ch) %>% 
        mutate(contiuous_gp = rnk - row_number()) %>% 
        summarise(n = n()) %>% 
        filter(n >= 60)
    #> # A tibble: 3 x 3
    #> # Groups:   usr_id [3]
    #>   usr_id    ch     n
    #>    <chr> <chr> <int>
    #> 1   a002    05    92
    #> 2   a005    15   198
    #> 3   a006    13    89

    # 3. 접속 주기 추출
    raw_dt %>% 
        group_by(usr_id) %>% 
        mutate(next_gn_dt = lead(gn_dt, n = 1), 
               diffmin=as.numeric(difftime(lead(gn_dt, n = 1), gn_dt, units="mins"))) %>% 
        filter(diffmin > 1) %>% 
        summarise(cnt_tm = mean(diffmin))
    #> # A tibble: 1 x 2
    #>   usr_id cnt_tm
    #>    <chr>  <dbl>
    #> 1   a003    749
    ```
