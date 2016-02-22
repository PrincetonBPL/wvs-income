**************** MAKE MACRO FILE *****************************

use "$data_dir/Clean/micro.dta", clear


* make some room for new vars, otherwise it crashes
drop a0* b0* c0* d0* e0* f0* g0*

* Merge in GDP data
sort cty year
merge cty year using "$data_dir/Clean/gdp_growth.dta"
* merge cty year using "Wolfers data\Processed files\Complete_GDP.dta"
drop if _merge==2
tab country if _merge==1
drop if gdp==.

* my original approach: 
* collapse (first) cty year lgdp gdp nonrepresentative (mean) sex-lninc [pweight=wt1000], by(ctyyear)

*reinstate wolfers approach: 
egen ctywve=group(cty wave)	
egen tag=tag(ctywve)

*entire varlist: save-believesupernatural2
foreach X of varlist changesactboldly-believesupernatural2 {
* Original split: save-expectwar /livedaytoday-believesupernatural2
* New split: 
 * save - trustrelatives
 * othersprefsimportant-helpneighborhood
 * changesactboldly-believesupernatural2
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
keep *gdp* *_hat cty wave year nonrepresentative oecd
save "$data_dir/Clean/macro_reg_3.dta", replace

* to check which countries have missing GDP: collapse (max) gdp growth, by(cty)
