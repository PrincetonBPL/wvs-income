use "$data_dir/Clean/macro_reg.dta" if nonrepresentative ==0, clear
capture drop _merge
	
*erase firstresults_likewolfers.xml
*erase firstresults_likewolfers.txt
sort cty year
merge cty year using "$data_dir/Clean//gdp_growth.dta"
* merge cty year using "Wolfers data\Processed files\Complete_GDP.dta"
drop if _merge==2
tab cty if _merge==1
drop _merge

sort cty
merge cty using "$data_dir/Clean//allgeo_jh.dta"

replace eu = 1 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace asia = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace africa= 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace eseasia = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace latam = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace safri = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")
replace sasia = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")

replace south = 0 if (cty=="CYP"  | cty=="ISL"  | cty=="LUX"  | cty=="MLT")

order cty country continent continentnum 

duplicates drop cty wave, force

save "$data_dir/Clean/macro_reg_geo", replace
