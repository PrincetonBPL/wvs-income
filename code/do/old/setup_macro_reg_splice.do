forvalues x=1/3 {
	use "$data_dir/Clean/macro_reg_`x'.dta", clear
	capture drop _merge
	sort cty wave
	save, replace
}

use "$data_dir/Clean/macro_reg_1.dta", clear
merge cty wave using "$data_dir/Clean/macro_reg_2.dta"
l if _merge~=3
drop _merge
sort cty wave
merge cty wave using "$data_dir/Clean/macro_reg_3.dta"
l if _merge~=3
drop _merge
save "$data_dir/Clean/macro_reg.dta", replace
