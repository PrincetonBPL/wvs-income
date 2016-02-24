** Title: wvs_build.do
** Author: Justin Abraham
** Desc: Supposed to take all of the raw data and make them compatible with each other and spit out some raw combined dataset.
** Input: Raw data. 
** Output: Some kind of combined raw data. 

******************************
** National income measures **
******************************

/* Texas Inequality (????) */

import delim "$data_dir/Texas/inequality_AVE.csv", varnames(1) clear

drop country
ren code countrycode
ren avg9099 inequality
la var inequality "avg9099"

sort countrycode

tempfile inequality
save `inequality', replace

/* WDI and GDF (1980 - 2009) */

import delim "$data_dir/WDI_GDF/WDI_GDF_Data.csv", varnames(1) clear

keep if seriescode == "NY.GDP.PCAP.PP.KD" | seriescode == "NY.GDP.MKTP.KD.ZG"

encode seriescode, gen(series)
encode countrycode, gen(country)

ren v* v*_
reshape wide v*_ seriescode seriesname, i(country) j(series)

ren v*_1 gdpgrowth*
ren v*_2 gdppercapita*

reshape long gdpgrowth gdppercapita, i(country) j(year)

replace year = year + 1955

levelsof seriesname2
la var gdppercapita `r(levels)'

levelsof seriesname1
la var gdpgrowth `r(levels)'

merge m:1 countrycode using `inequality'

keep if _merge != 2

drop series* countrycode _merge

tempfile national
save `national', replace

************************
** World Value Survey **
************************

use "$data_dir/WVS-EVS/xwvsevs_1981_2000_v20060423.dta", clear
