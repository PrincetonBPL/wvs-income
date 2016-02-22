use "micro_standardized.dta", clear //nonrep already excluded
*use "micro.dta" if nonrepresentative==0, clear
capture drop _merge

/*
drop s001 - f163a
drop trustfriends trustrelatives
xi i.cty, prefix(c_) 
xi i.year, prefix(y_) 
xi i.wave, prefix(w_)
egen ctywave = group(cty wave)
xi i.ctywave, prefix(cw_)
*/

global controls "sex educ married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 "

keep $controls cty ctywave cw_* c_* y_* w_* wave year wt1000 hap sat inc lninc brightfuture risktaking sciencetoofast sciencehealth shapefateyrself financesat scienceopportunity candonothinglaw godmeaningful helpneighborhood believedevil escapepoverty aidtoomuch concernfamily believeresurrection wouldntwork concernhumankind intrinsic helpfamily trustmeetfirsttime sciencebetteroff lifemeaningless expectwar aidtaxwtp lonely livedaytoday godimportant *_std

*erase firstresults_likewolfers.xml
*erase firstresults_likewolfers.txt
sort cty year
merge cty year using "gdp/gdp_growth.dta"
* merge cty year using "Wolfers data\Processed files\Complete_GDP.dta"
drop if _merge==2
tab cty if _merge==1
drop _merge

sort cty
merge cty using "geo/allgeo_jh.dta"

replace eu = 1 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace asia = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace africa= 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace eseasia = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace latam = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace safri = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace sasia = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")

replace south = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")

order cty country continent continentnum 

*duplicates drop cty wave, force

save micro_standardized_geo, replace
