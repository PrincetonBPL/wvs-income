forvalues x=1/3 {
	use macro_reg_`x'.dta, clear
	capture drop _merge
	sort cty wave
	save, replace
}

use macro_reg_1.dta, clear
merge cty wave using macro_reg_2.dta
l if _merge~=3
drop _merge
sort cty wave
merge cty wave using macro_reg_3.dta
l if _merge~=3
drop _merge
save macro_reg.dta, replace
