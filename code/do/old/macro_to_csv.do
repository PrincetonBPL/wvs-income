use macro, clear

sort cty year
merge cty year using "gdp/gdp_growth.dta"
drop if _merge==2
drop _merge

outsheet using "macro.csv", replace

