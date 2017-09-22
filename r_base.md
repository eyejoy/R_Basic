R 기초 정리
================
성상모
2017-09-23

-   [데이터 타입](#데이터-타입)
-   [데이터 구조](#데이터-구조)
-   [데이터 추출](#데이터-추출)
-   [주요 함수](#주요-함수)
-   [데이터 불러오기](#데이터-불러오기)

------------------------------------------------------------------------

데이터 타입
-----------

-   R에서는 아래와 같은 데이터 타입을 사용하고 `str()`, `typeof()` 함수로 확인 가능

    |        이름        |    설명    |                                                                  예제|
    |:------------------:|:----------:|---------------------------------------------------------------------:|
    | `numeric`/`double` |    숫자    |                                                               2, 10.5|
    |      `integer`     |    정수    |                                          1, 5, 10 (입력시 `L`로 표기)|
    |      `string`      |    문자    |                                                              "a", "b"|
    |      `logical`     | Boolean 값 |  `TRUE` / `FALSE` (`T` / `F`로도 사용, 숫자형인 1 / 0 으로 변환 가능)|
    |      `complex`     |   복소수   |                                                                  1+3i|

    ``` r
    # numeric / double
    str(10.5); typeof(10.5)
    ##>  num 10.5
    ##> [1] "double"

    # integer
    str(1L); typeof(1L)
    ##>  int 1
    ##> [1] "integer"

    # integer
    str(1L); typeof(1L)
    ##>  int 1
    ##> [1] "integer"

    # logical
    str(T); typeof(F)
    ##>  logi TRUE
    ##> [1] "logical"

    as.numeric(T);sum(T)
    ##> [1] 1
    ##> [1] 1

    # complex
    str(1+3i); typeof(1+3i)
    ##>  cplx 1+3i
    ##> [1] "complex"
    ```

데이터 구조
-----------

-   R에서 데이터 구조는 차원에 따라 아래와 같이 구분함

    -   `Homogeneous`: 동일한 데이터 타입을 할당 가능
    -   `Heterogeneous`: 다른 데이터 타입을 할당할 수 있음

    | Dimension | Homogeneous | Heterogeneous |
    |:---------:|:-----------:|:-------------:|
    |   `1-d`   |   `Vector`  |     `List`    |
    |   `2-d`   |   `Matrix`  |  `Data Frame` |
    |   `n-d`   |   `Arrary`  |               |

    -   참고: <https://dhaine.github.io/2014-11-06-fmv/novice/epi/01-data-structures.html>
-   `Vector`

    -   가장 기본적인 데이터 구조로 1차원으로 구성. 복수의 원소를 할당할 때 `c()`를 사용

    ``` r
    # vector
    v <- c(1, 2, 3)
    v
    ##> [1] 1 2 3
    length(v)
    ##> [1] 3

    # structure
    str(v)
    ##>  num [1:3] 1 2 3
    ```

-   `Matrix`

    -   숫자의 사각 행렬로 2개 이상의 `Vector`의 결합으로 구성
    -   matrix를 생성할 때, column의 수와 row의 수(`ncol`, `nrow` 옵션) 지정 가능, 데이터 입력 순서는 기본값이 column 기준인데 row기준으로 변경 가능(`byrow` 옵션)
    -   `Vector`의 결합으로 `Matrix`를 생성할 때는 `cbind()`, `rbind()` 함수 사용

    ``` r
    # matrix
    (m1 <- matrix(c(1, 2, 3, 4), ncol = 2))
    ##>      [,1] [,2]
    ##> [1,]    1    3
    ##> [2,]    2    4
    dim(m1)
    ##> [1] 2 2

    (m2 <- matrix(c(1, 2, 3, 4), 2, byrow = T))
    ##>      [,1] [,2]
    ##> [1,]    1    2
    ##> [2,]    3    4

    # cbind & rbind
    cbind(c(1, 2), c(3, 4))
    ##>      [,1] [,2]
    ##> [1,]    1    3
    ##> [2,]    2    4
    rbind(c(1, 2), c(3, 4))
    ##>      [,1] [,2]
    ##> [1,]    1    2
    ##> [2,]    3    4

    # structure
    str(m1)
    ##>  num [1:2, 1:2] 1 2 3 4
    ```

-   `Array`

    -   2차원 이상의 데이터 구조로 `Matrix`가 여러 방으로 구성된 것과 비슷한 개념

    ``` r
    # array
    (a <- array(1:24, c(3,4,2)))
    ##> , , 1
    ##> 
    ##>      [,1] [,2] [,3] [,4]
    ##> [1,]    1    4    7   10
    ##> [2,]    2    5    8   11
    ##> [3,]    3    6    9   12
    ##> 
    ##> , , 2
    ##> 
    ##>      [,1] [,2] [,3] [,4]
    ##> [1,]   13   16   19   22
    ##> [2,]   14   17   20   23
    ##> [3,]   15   18   21   24
    dim(a)
    ##> [1] 3 4 2

    # structure
    str(a)
    ##>  int [1:3, 1:4, 1:2] 1 2 3 4 5 6 7 8 9 10 ...
    ```

-   `List`

    -   다른 타입의 객체들의 모임으로 `Vector`가 여러 방으로 구성된 것과 비슷한 개념

    ``` r
    # list
    (l <- list(name = c("samsung", "apple", "LG"), 
               phone = c("Galaxy Note 8", "iPhone X", "LG V30"), 
               age = c(1, 2, 3)))
    ##> $name
    ##> [1] "samsung" "apple"   "LG"     
    ##> 
    ##> $phone
    ##> [1] "Galaxy Note 8" "iPhone X"      "LG V30"       
    ##> 
    ##> $age
    ##> [1] 1 2 3

    # structure
    str(l)
    ##> List of 3
    ##>  $ name : chr [1:3] "samsung" "apple" "LG"
    ##>  $ phone: chr [1:3] "Galaxy Note 8" "iPhone X" "LG V30"
    ##>  $ age  : num [1:3] 1 2 3
    ```

-   `Data Frame`

    -   다른 타입의 `Vector`를 테이블 형태로 저장하는 것으로 데이터 분석용으로 가장 적절한 데이터 구조

    ``` r
    # Data Frame
    (df <- data.frame(name = c("samsung", "apple", "LG"), 
                      phone = c("Galaxy Note 8", "iPhone X", "LG V30"), 
                      age = c(1, 2, 3)))
    ##>      name         phone age
    ##> 1 samsung Galaxy Note 8   1
    ##> 2   apple      iPhone X   2
    ##> 3      LG        LG V30   3
    dim(df)
    ##> [1] 3 3

    # structure
    str(df)
    ##> 'data.frame':   3 obs. of  3 variables:
    ##>  $ name : Factor w/ 3 levels "apple","LG","samsung": 3 1 2
    ##>  $ phone: Factor w/ 3 levels "Galaxy Note 8",..: 1 2 3
    ##>  $ age  : num  1 2 3
    ```

-   `Factor`

    -   `Vector`의 일종으로 범주형 변수를 저장할 때 사용. `levels()`를 통해 어떤 항목이 존재하는지 파악할 수 있음

    ``` r
    # Data Frame
    (f <- factor(c("samsung", "apple", "LG", "apple", "LG", 
                   "apple", "LG", "apple", "apple", "apple")))
    ##>  [1] samsung apple   LG      apple   LG      apple   LG      apple  
    ##>  [9] apple   apple  
    ##> Levels: apple LG samsung
    levels(f)
    ##> [1] "apple"   "LG"      "samsung"

    # structure
    str(f)
    ##>  Factor w/ 3 levels "apple","LG","samsung": 3 1 2 1 2 1 2 1 1 1
    ```

-   \[참고\] 기타 값

    -   `Inf`, `NAN`, `NA` 존재 (Infinity, Not a number, Null value)

    ``` r
    # Inf, NAN, NA
    1/0; 1/Inf
    ##> [1] Inf
    ##> [1] 0
    0/0
    ##> [1] NaN
    c(1, 2, 3, NA)
    ##> [1]  1  2  3 NA
    ```

데이터 추출
-----------

-   각 데이터 구조에서 데이터 원소에 접근 하는 것

    -   대괄호는 데이터 슬라이싱, 괄호는 함수

    ``` r
    # vector
    v
    ##> [1] 1 2 3

    v[1]
    ##> [1] 1

    v[-1]
    ##> [1] 2 3

    # matrix
    m1
    ##>      [,1] [,2]
    ##> [1,]    1    3
    ##> [2,]    2    4

    m1[1, ]
    ##> [1] 1 3

    m1[, 1]
    ##> [1] 1 2

    m1[1, 1]
    ##> [1] 1

    # array
    a
    ##> , , 1
    ##> 
    ##>      [,1] [,2] [,3] [,4]
    ##> [1,]    1    4    7   10
    ##> [2,]    2    5    8   11
    ##> [3,]    3    6    9   12
    ##> 
    ##> , , 2
    ##> 
    ##>      [,1] [,2] [,3] [,4]
    ##> [1,]   13   16   19   22
    ##> [2,]   14   17   20   23
    ##> [3,]   15   18   21   24

    a[, , 1]
    ##>      [,1] [,2] [,3] [,4]
    ##> [1,]    1    4    7   10
    ##> [2,]    2    5    8   11
    ##> [3,]    3    6    9   12

    a[1, , 1]
    ##> [1]  1  4  7 10

    # df
    df
    ##>      name         phone age
    ##> 1 samsung Galaxy Note 8   1
    ##> 2   apple      iPhone X   2
    ##> 3      LG        LG V30   3

    df$name
    ##> [1] samsung apple   LG     
    ##> Levels: apple LG samsung

    df[, 1]
    ##> [1] samsung apple   LG     
    ##> Levels: apple LG samsung
    ```

주요 함수
---------

-   함수: 어떤 데이터를 입력했을 때 출력 값이 나오는 것

    -   괄호를 사용하면 모두 함수
    -   새로운 함수를 만들 때는 `function()`를 사용. 출력값을 지정할 때는 `return()` 함수 사용
    -   아래 코드에서 `word`는 함수의 옵션 값이고, `word`에 "hello world"를 기본 값으로 할당

    ``` r
    # function
    func <- function(word = "hello world"){
        print(word)
    }

    # function 실행
    func()
    ##> [1] "hello world"
    func(word = "hello world!!!!")
    ##> [1] "hello world!!!!"

    # structure
    str(func)
    ##> function (word = "hello world")  
    ##>  - attr(*, "srcref")=Class 'srcref'  atomic [1:8] 2 9 4 1 9 1 2 4
    ##>   .. ..- attr(*, "srcfile")=Classes 'srcfilecopy', 'srcfile' <environment: 0x000000000df01578>
    ```

-   도움말: `help`, `?`

    -   함수에 대한 설명, 리턴 값, 샘플 코드 제공

    ``` r
    ?sum
    ?summary
    ```

-   데이터 타입 확인 / 변환: `is.*`, `as.*`

    -   `is.*`: \*에 해당하는 데이터 타입이 맞는지 `logical` 타입 결과 출력
    -   `as.*`: \*에 해당하는 데이터 타입으로 변환

    ``` r
    # numeric, integer, character
    is.numeric(1)
    ##> [1] TRUE
    is.character(1)
    ##> [1] FALSE

    as.integer(1.4)
    ##> [1] 1
    as.character(1.4)
    ##> [1] "1.4"

    # factor
    dat <- c("a", "b")
    is.factor(dat)
    ##> [1] FALSE

    dat <- as.factor(dat)
    is.factor(dat)
    ##> [1] TRUE
    ```

-   순차 / 반복 데이터 함수: `seq`, `rep`, `strrep`

    -   `seq`: sequence의 약자로, 순차적인 숫자 벡터 생성 (숫자 간격의 기본값 1)
    -   `rep`: replicate의 약자로, 반복적인 숫자/문자 벡터 생성 (반복 기본 옵션은 times)
    -   `strrep`: 반복적인 문자 벡터 생성

    ``` r
    # seq function
    seq(1, 5)
    ##> [1] 1 2 3 4 5
    seq(1, 8, by = 2)
    ##> [1] 1 3 5 7

    # rep function
    rep(5, 5)
    ##> [1] 5 5 5 5 5
    rep("a", 5)
    ##> [1] "a" "a" "a" "a" "a"

    rep(1:3, times = 5)
    ##>  [1] 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3
    rep(1:3, each = 5)
    ##>  [1] 1 1 1 1 1 2 2 2 2 2 3 3 3 3 3

    # strrep function
    strrep("X", 3)
    ##> [1] "XXX"
    ```

-   비교연산자

    -   비교 결과를 `logical` 타입으로 결과 출력

    ``` r
    1 == 2
    ##> [1] FALSE
    1 != 2
    ##> [1] TRUE
    1 >= 2
    ##> [1] FALSE
    1 <= 2
    ##> [1] TRUE
    1 < 2
    ##> [1] TRUE
    1 > 2
    ##> [1] FALSE
    ```

-   산술연산자

    -   덧셈, 뺄셈, 곱셈, 나눗셈, 몫, 제곱, 루트 계산 가능
    -   벡터/매트릭스 연산은 동일 크기일 경우 동일 위치 값 연산

    ``` r
    # 덧셈
    1 + 2
    ##> [1] 3

    # 뺄셈
    1 - 2
    ##> [1] -1

    # 곱셈
    1 * 2
    ##> [1] 2

    # 나눗셈
    1 / 2
    ##> [1] 0.5

    # 나머지
    1 %% 2
    ##> [1] 1

    # 몫
    1 %/% 2
    ##> [1] 0

    # 제곱
    1^2
    ##> [1] 1

    # 루트
    sqrt(2)
    ##> [1] 1.414214

    # 벡터 연산
    c(1, 2, 3) + c(2, 3, 5)
    ##> [1] 3 5 8

    # 메트릭스 연산
    matrix(c(1, 2, 3, 4), 2) + matrix(c(2, 5, 4, 7), 2)
    ##>      [,1] [,2]
    ##> [1,]    3    7
    ##> [2,]    7   11
    ```

-   조건문 / 반복문: `if`, `for`

    -   `if`: 일반적인 프로그램의 조건문
    -   `for`: 일반적인 프로그램의 반복문

    ``` r
    aa <- 1

    # if
    if(aa == 1){
       print("aa는 1이다!")
    } else{
       "aa는 1이 아니다!"
       }
    ##> [1] "aa는 1이다!"

    # for
    for(i in 1:5){
       print(i)
    }
    ##> [1] 1
    ##> [1] 2
    ##> [1] 3
    ##> [1] 4
    ##> [1] 5
    ```

데이터 불러오기
---------------

-   작업공간 함수: `getwd`, `setwd`

    -   `getwd`: 현재 작업공간 출력
    -   `setwd`: 작업공간 변경
    -   RStudio: 파일 위치로 작업공간 변경 (Session &gt; Set Working Directory &gt; To Source File Location)

    ``` r
    getwd()
    ##> [1] "D:/Dropbox/Public/study/git/R_Basic"

    #setwd("D:/...")
    ```

-   외부데이터 불러오기: `read.csv`, `head`

    -   외부데이터는 csv, txt, xlsx, sas파일, spss파일 등등 가능하지만 여기서는 csv 파일을 사용
    -   `read.csv`: csv 파일 불러오는 함수
    -   `read.csv`의 `header` 옵션은 첫 행이 데이터가 아니라 열이름인 경우 `T`로 설정.(기본값은 `T`) 데이터 위치는 명시적 표현 가능("d:...\*.csv")하고 작업공간에 데이터가 있는 경우 작업공간 이하 위치만 표기 ("data\*.csv")
    -   `head`: 앞에 6개 행만 출력 (반대로 `tail`함수는 뒤에 6개 행이 출력)
    -   `read.csv`는 base 함수이고, 주로 `readr` 패키지의 `read_csv`함수나 `data.table` 패키지의 `fread`함수 사용
    -   \[참고\] 데이터 출처: <https://www.kaggle.com/uciml/iris/data>

    ``` r
    # header = T
    iris_raw <- read.csv("Iris.csv", header = T)
    head(iris_raw)
    ##>   Id SepalLengthCm SepalWidthCm PetalLengthCm PetalWidthCm     Species
    ##> 1  1           5.1          3.5           1.4          0.2 Iris-setosa
    ##> 2  2           4.9          3.0           1.4          0.2 Iris-setosa
    ##> 3  3           4.7          3.2           1.3          0.2 Iris-setosa
    ##> 4  4           4.6          3.1           1.5          0.2 Iris-setosa
    ##> 5  5           5.0          3.6           1.4          0.2 Iris-setosa
    ##> 6  6           5.4          3.9           1.7          0.4 Iris-setosa

    # header = F: 첫행에 header 값이 들어감
    head(read.csv("Iris.csv", header = F))
    ##>   V1            V2           V3            V4           V5          V6
    ##> 1 Id SepalLengthCm SepalWidthCm PetalLengthCm PetalWidthCm     Species
    ##> 2  1           5.1          3.5           1.4          0.2 Iris-setosa
    ##> 3  2           4.9          3.0           1.4          0.2 Iris-setosa
    ##> 4  3           4.7          3.2           1.3          0.2 Iris-setosa
    ##> 5  4           4.6          3.1           1.5          0.2 Iris-setosa
    ##> 6  5           5.0          3.6           1.4          0.2 Iris-setosa
    ```
