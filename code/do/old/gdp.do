******* GDP ***************
insheet using "$data_dir/WDI/WDI_GDF_Data.csv", names clear
keep if seriescode == "NY.GDP.PCAP.PP.KD"
keep countrycode v*
rename countrycode cty

reshape long v, i(cty) j(year)
replace year = year+1955
rename v gdp
gen lgdp = ln(gdp)

sort cty year

tempfile gdp
save `gdp', replace

******** INEQUALITY **************
insheet using "$data_dir/Texas/inequality_AVE.csv", names clear
rename code cty
rename avg9099 ineq
sort cty

tempfile ineq
save `ineq', replace

******** GROWTH **************
insheet using "$data_dir/WDI/WDI_GDF_Data.csv", names clear
keep if seriescode == "NY.GDP.MKTP.KD.ZG"
keep countrycode v*
rename countrycode cty

reshape long v, i(cty) j(year)
replace year = year+1955
rename v growth

sort cty year

tempfile growth
save `growth', replace


************ MERGE GDP & GROWTH & INEQUALITY ***************
merge cty year using `gdp'
drop _merge
sort cty year

merge cty using `ineq'
drop _merge
sort cty year

************ GENERATE LAGS ********************
encode cty, gen(ctynum)
tsset ctynum year, yearly
forvalues l =1/20 {
	gen l`l'_gdp = l`l'.gdp
	gen l`l'_lgdp = l`l'.lgdp
	gen l`l'_growth = l`l'.growth
}


sort cty year
*********** SAVE *****************
save "$data_dir/Clean/gdp_growth.dta", replace

