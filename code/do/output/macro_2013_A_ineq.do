use macro_reg_geo, clear

replace latabs = abs(cen_lat)/90
drop lat_abst

/* finding good instruments: 
log using test.log, replace
foreach x of varlist dens65c-cen_cr {
	quietly ivreg shapefateyrself_hat (lgdp=`x') godimportant_hat , first r
	local t = round(_b[lgdp]/_se[lgdp],.001)
	dis "`x',`e(N)',`t'"				
	}
	
	log close
*/	
label var shapefateyrself_hat "Control" 
label var helpneighborhood_hat "Help neighbor" 
label var intrinsic_hat "Intrinsic 2" 
label var wouldntwork_hat "Intrinsic 1"
label var helpfamily_hat "Help family" 
label var lifemeaningless_hat "Meaningless"
label var lonely_hat "Lonely"
label var godimportant_hat "God important" 
label var risktaking_hat "Risktaking" 
label var livedaytoday_hat "Shortsighted"
label var trustmeetfirsttime_hat "Trust"

rename meantemp Temperature
rename latabs Latitude
rename landlock Landlocked
replace Landlocked = 0 if cty=="CYP"
rename lc100km CoastLength
rename malfal94 Malaria1994
rename malfal66 Malaria1966
rename settlermort SettlerMortality
rename icrg82 InstitutionQuality1982
rename avexpr ExpropriationRisk

label var godimportant_hat "God important"
label var educlevel_hat "Education"
label var Temperature "Temperature"
label var Latitude "Latitude"
label var Landlocked "Landlocked"
label var CoastLength "Coast length"
label var Malaria1994 "Malaria index 1994" 
label var Malaria1966 "Malaria index 1966" 
label var SettlerMortality "Settler Mortality"
label var InstitutionQuality1982 "Institution quality 1982" 
label var ExpropriationRisk "Expropriation Risk" 
label var lgdp "Log GDP" 
label var growth "Growth"
label var ineq "Inequality"

label var tropicar "Tropical area"
label var troppop "Tropical pop"
label var south "South"
label var landarea "Area"
label var socialst "Socialist"
label var urbpop95 "Urban pop"
label var wardum "War"
label var pop95 "Population"
label var eu "Europe"
label var safri "Sub-Sah Africa"
label var sasia "South Asia"
label var latam "Latin America"
label var eseasia "SE Asia"
label var asia "Asia"
label var africa "Africa"
label var Latitude "Latitude"
label var elev "Elevation"

***********************************************
*******************
******************************************************************
******************************************************************
capture rm "outreg_A/macro_ineq_fate.tex" 
capture rm "outreg_A/macro_ineq_fate.rtf" 
eststo clear
global controls ""
eststo: reg shapefateyrself_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
local controls = "godimportant_hat socialst urbpop95 wardum pop95 "
eststo: reg shapefateyrself_hat ineq `controls', r
	estadd local N1 = "`e(N)'"
global controls "Landlocked tropicar troppop south landarea Latitude elev"
eststo: reg shapefateyrself_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "eu safri sasia latam eseasia asia africa"
eststo: reg shapefateyrself_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "godimportant_hat Landlocked tropicar troppop south landarea socialst urbpop95 wardum pop95 eu safri sasia latam eseasia asia africa Latitude elev"
eststo: reg shapefateyrself_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/macro_ineq_fate.tex", replace width(17cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Locus of Control and Inequality)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")

capture rm "outreg_A/macro_ineq_risk.tex" 
capture rm "outreg_A/macro_ineq_risk.rtf" 
eststo clear
global controls ""
eststo: reg risktaking_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
local controls = "godimportant_hat socialst urbpop95 wardum pop95 "
eststo: reg risktaking_hat ineq `controls', r
	estadd local N1 = "`e(N)'"
global controls "Landlocked tropicar troppop south landarea Latitude elev"
eststo: reg risktaking_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "eu safri sasia latam eseasia asia africa"
eststo: reg risktaking_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "godimportant_hat Landlocked tropicar troppop south landarea socialst urbpop95 wardum pop95 eu safri sasia latam eseasia asia africa Latitude elev"
eststo: reg risktaking_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/macro_ineq_risk.tex", replace width(17cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Risktaking and Inequality)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")

capture rm "outreg_A/macro_ineq_work.tex" 
capture rm "outreg_A/macro_ineq_work.rtf" 
eststo clear
global controls ""
eststo: reg wouldntwork_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
local controls = "godimportant_hat socialst urbpop95 pop95 "
eststo: reg wouldntwork_hat  ineq `controls', r
	estadd local N1 = "`e(N)'"
global controls "Landlocked tropicar landarea Latitude elev"
eststo: reg wouldntwork_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "eu  latam "
eststo: reg wouldntwork_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "godimportant_hat Landlocked tropicar landarea socialst urbpop95 pop95 eu latam Latitude elev"
eststo: reg wouldntwork_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/macro_ineq_work.tex", replace width(17cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Intrinsic motivation and Inequality (1))  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
/*note: troppop omitted because of collinearity
note: south omitted because of collinearity
note: wardum omitted because of collinearity
note: safri omitted because of collinearity
note: sasia omitted because of collinearity
note: eseasia omitted because of collinearity
note: asia omitted because of collinearity
note: africa omitted because of collinearity*/

capture rm "outreg_A/macro_ineq_trust.tex" 
capture rm "outreg_A/macro_ineq_trust.rtf" 
eststo clear
global controls ""
eststo: reg trustmeetfirsttime_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
local controls = "godimportant_hat socialst urbpop95 wardum pop95 "
eststo: reg trustmeetfirsttime_hat ineq `controls', r
	estadd local N1 = "`e(N)'"
global controls "Landlocked tropicar troppop south landarea Latitude elev"
eststo: reg trustmeetfirsttime_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "eu safri sasia latam eseasia asia africa"
eststo: reg trustmeetfirsttime_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "godimportant_hat Landlocked tropicar troppop south landarea socialst urbpop95 wardum pop95 eu safri sasia latam eseasia asia africa Latitude elev"
eststo: reg trustmeetfirsttime_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/macro_ineq_trust.tex", replace width(17cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Trust and Inequality)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")

capture rm "outreg_A/macro_ineq_daytoday.tex" 
capture rm "outreg_A/macro_ineq_daytoday.rtf" 
eststo clear
global controls ""
eststo: reg livedaytoday_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
local controls = "godimportant_hat socialst urbpop95  pop95 "
eststo: reg livedaytoday_hat ineq `controls', r
	estadd local N1 = "`e(N)'"
global controls "Landlocked tropicar landarea Latitude elev"
eststo: reg livedaytoday_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "eu"
eststo: reg livedaytoday_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "godimportant_hat Landlocked tropicar landarea socialst urbpop95 pop95 eu Latitude elev"
eststo: reg livedaytoday_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/macro_ineq_daytoday.tex", replace width(17cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Short-sightedness and Inequality)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
/*note: troppop omitted because of collinearity
note: south omitted because of collinearity
note: wardum omitted because of collinearity
note: safri omitted because of collinearity
note: sasia omitted because of collinearity
note: latam omitted because of collinearity
note: eseasia omitted because of collinearity
note: asia omitted because of collinearity
note: africa omitted because of collinearity*/

capture rm "outreg_A/macro_ineq_intrinsic.tex" 
capture rm "outreg_A/macro_ineq_intrinsic.rtf" 
eststo clear
global controls ""
eststo: reg intrinsic_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
local controls = "godimportant_hat socialst urbpop95 pop95 "
eststo: reg intrinsic_hat ineq `controls', r
	estadd local N1 = "`e(N)'"
global controls "Landlocked tropicar  landarea Latitude elev"
eststo: reg intrinsic_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "eu latam "
eststo: reg intrinsic_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "godimportant_hat Landlocked tropicar landarea socialst urbpop95 pop95 eu latam Latitude elev"
eststo: reg intrinsic_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/macro_ineq_intrinsic.tex", replace width(17cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Intrinsic motivation and Inequality (2))  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
/*
note: troppop omitted because of collinearity
note: south omitted because of collinearity
note: wardum omitted because of collinearity
note: safri omitted because of collinearity
note: sasia omitted because of collinearity
note: eseasia omitted because of collinearity
note: asia omitted because of collinearity
note: africa omitted because of collinearity*/

capture rm "outreg_A/macro_ineq_lonely.tex" 
capture rm "outreg_A/macro_ineq_lonely.rtf" 
eststo clear
global controls ""
eststo: reg lonely_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
local controls = "godimportant_hat  urbpop95 pop95 "
eststo: reg lonely_hat  ineq `controls', r
	estadd local N1 = "`e(N)'"
global controls " tropicar  landarea Latitude elev"
eststo: reg lonely_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "eu  "
eststo: reg lonely_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "godimportant_hat  tropicar landarea  urbpop95  pop95 eu  Latitude elev"
eststo: reg lonely_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/macro_ineq_lonely.tex", replace width(17cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Loneliness and Inequality)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
/*note: Landlocked omitted because of collinearity
note: troppop omitted because of collinearity
note: south omitted because of collinearity
note: socialst omitted because of collinearity
note: wardum omitted because of collinearity
note: safri omitted because of collinearity
note: sasia omitted because of collinearity
note: latam omitted because of collinearity
note: eseasia omitted because of collinearity
note: asia omitted because of collinearity
note: africa omitted because of collinearity*/

capture rm "outreg_A/macro_ineq_meaning.tex" 
capture rm "outreg_A/macro_ineq_meaning.rtf" 
eststo clear
global controls ""
eststo: reg lifemeaningless_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
local controls = "godimportant_hat  urbpop95  pop95 "
eststo: reg lifemeaningless_hat  ineq `controls', r
	estadd local N1 = "`e(N)'"
global controls " tropicar landarea Latitude elev"
eststo: reg lifemeaningless_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "eu "
eststo: reg lifemeaningless_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "godimportant_hat  tropicar landarea  urbpop95  pop95 eu "
eststo: reg lifemeaningless_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/macro_ineq_meaning.tex", replace width(17cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Meaninglessness and Inequality)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
/*note: Landlocked omitted because of collinearity
note: troppop omitted because of collinearity
note: south omitted because of collinearity
note: socialst omitted because of collinearity
note: wardum omitted because of collinearity
note: safri omitted because of collinearity
note: sasia omitted because of collinearity
note: latam omitted because of collinearity
note: eseasia omitted because of collinearity
note: asia omitted because of collinearity
note: africa omitted because of collinearity*/

capture rm "outreg_A/macro_ineq_helpfam.tex" 
capture rm "outreg_A/macro_ineq_helpfam.rtf" 
eststo clear
global controls ""
eststo: reg helpfamily_hat ineq $controls, r
	estadd local N1 = "`e(N)'"
local controls = "godimportant_hat socialst urbpop95  pop95 "
eststo: reg helpfamily_hat  ineq `controls', r
	estadd local N1 = "`e(N)'"
global controls "Landlocked landarea Latitude elev"
eststo: reg helpfamily_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
global controls "godimportant_hat Landlocked landarea socialst urbpop95  pop95 Latitude elev"
eststo: reg helpfamily_hat  ineq $controls, r
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/macro_ineq_helpfam.tex", replace width(17cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Altruism and Inequality)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
/*note: tropicar omitted because of collinearity
note: troppop omitted because of collinearity
note: south omitted because of collinearity
note: wardum omitted because of collinearity
note: eu omitted because of collinearity
note: safri omitted because of collinearity
note: sasia omitted because of collinearity
note: latam omitted because of collinearity
note: eseasia omitted because of collinearity
note: asia omitted because of collinearity
note: africa omitted because of collinearity*/

