**************** MAKE MACRO FILE *****************************
use "micro.dta", clear

drop a0* b0* c0* d0* e0* f0* g0*

* Merge in GDP data
sort cty year
merge cty year using "gdp/gdp_growth.dta"
drop if _merge==2
tab country if _merge==1
drop if gdp==.

egen ctywve=group(cty wave)	
egen tag=tag(ctywve)

rename x023 educyears
rename x025 educlevel

replace educyears = . if educyears < 0
replace educlevel = . if educlevel < 0

foreach X of varlist educyears educlevel {
	quietly xi: reg `X' i.ctywve [pw=wt] 
	quietly predict `X'_hat if `X'~=., xb
	quietly predict `X'_hat2 if `X'~=., res
	tomode `X'_hat, by(ctywve) replace
	summ `X'_hat if tag==1
	replace `X'_hat=`X'_hat-r(mean)
	summ `X'_hat2 if tag==1
	replace `X'_hat = `X'_hat/r(sd)

}

keep if tag==1
keep cty wave educyears_hat educlevel_hat
keep if wave ==2005
sort cty wave 
save "temp.dta", replace

use macro_reg.dta, clear
capture drop educyears_hat 
capture drop educlevel_hat
capture drop educyears
capture drop _merge
sort cty wave
merge cty wave using temp.dta
l cty wave _merge if _merge ~=3
save, replace
