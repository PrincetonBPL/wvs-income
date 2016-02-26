** Title: wvs_build.do
** Author: Justin Abraham
** Desc: Supposed to take all of the raw data and make them compatible with each other and spit out some raw combined dataset.
** Input: Raw data. 
** Output: Some kind of combined raw data. 

******************************
** National income measures **
******************************

/* ISO country codes */

import delim "$data_dir/ISO/ISOcountryCodes.csv", varnames(1) clear

drop name

tempfile iso
save `iso', replace

/* Penn World Tables (1950 - 2011) */

use "$data_dir/PWT 8.1/pwt81.dta", clear

keep countrycode year pop rgdpe rgdpo cgdpe cgdpo rgdpna
ren countrycode alpha3
drop if year < 1960

tempfile pwt
save `pwt', replace

/* WDI and GDF (1980 - 2015) */

import delim "$data_dir/WDI_csv/WDI_Data.csv", varnames(1) clear

keep if indicatorcode == "NY.GDP.MKTP.KD.ZG" | indicatorcode == "NY.GDP.PCAP.PP.CD" | indicatorcode == "NY.GDP.PCAP.PP.KD" | indicatorcode == "SI.POV.GINI"
encode indicatorcode, gen(series)

ren v* v*_
ren countrycode alpha3

reshape wide v*_ indicatorcode indicatorname, i(alpha3) j(series)

ren v*_1 gdp_growth*
ren v*_2 gdp_percapita*
ren v*_3 gdp_2011percapita*
ren v*_4 gini*

reshape long gdp_growth gdp_percapita gdp_2011percapita gini, i(alpha3) j(year)

la var year "Year"
replace year = year + 1955

levelsof indicatorname1
la var gdp_growth `r(levels)'

levelsof indicatorname2
la var gdp_percapita `r(levels)'

levelsof indicatorname3
la var gdp_2011percapita `r(levels)'

levelsof indicatorname4
la var gini `r(levels)'

replace alpha3 = "AND" if alpha3 == "ADO"
replace alpha3 = "ROU" if alpha3 == "ROM"
replace alpha3 = "TLS" if alpha3 == "TMP"
replace alpha3 = "COD" if alpha3 == "ZAR"

merge 1:1 alpha3 year using `pwt', nogen
merge m:1 alpha3 using `iso' 

drop if _merge == 1
drop indicator* _merge

tempfile national
save `national', replace

***********************************
** Temperature and precipitation **
***********************************

/* U Delaware Air Temperature (1900 - 2014) */

* loc datalist : dir "$data_dir/UDelaware/air_temp_2014" files "air_temp.*"

* foreach csv in `datalist' {

* 	loc root = substr("`csv'", -4, .)

* 	if "`root'" == "1900" {

* 		import delim "$data_dir/UDelaware/air_temp_2014/`csv'", delim(" ", collapse) clear
* 		gen year = real("`root'")
* 		tempfile temperature
* 		save `temperature', replace

* 	}

* 	else {

* 		import delim "$data_dir/UDelaware/air_temp_2014/`csv'", delim(" ", collapse) clear
* 		gen year = real("`root'")
* 		append using `temperature'
* 		save `temperature', replace

* 	}

* }

* drop v15

/* U Delaware Precipitation (1900 - 2014) */

* loc datalist : dir "$data_dir/UDelaware/precip_2014" files "precip.*"

* foreach csv in `datalist' {

* 	loc root = substr("`csv'", -4, .)

* 	if "`root'" == "1900" {

* 		import delim "$data_dir/UDelaware/precip_2014/`csv'", delim(" ", collapse) clear
* 		gen year = real("`root'")
* 		tempfile precipitation
* 		save `precipitation', replace

* 	}

* 	else {

* 		import delim "$data_dir/UDelaware/precip_2014/`csv'", delim(" ", collapse) clear
* 		gen year = real("`root'")
* 		append using `precipitation'
* 		save `precipitation', replace

* 	}

* }

* drop v15

************************
** World Value Survey **
************************

use "$data_dir/WVS 1981-2014/WVS_Longitudinal_1981_2014_stata_v2015_04_18.dta", clear
append using "$data_dir/EVS 1981-2008/ZA4804_v3-0-0.dta"

gen year = S020

gen alpha2 = S009
replace alpha2 = "RS" if S003 == 911 | (S003 == 891 & S003A == 911)
replace alpha2 = "ME" if S003 == 891 & S003A == 912

merge m:1 alpha2 year using `national'

* drop if _merge == 2
* drop _merge

save "$data_dir/Clean/wvs_panel.dta", replace

