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
label var shapefateyrself_hat "Locus of Control" 
label var godimportant_hat "God important" 
label var growth "Growth"
label var ineq "Inequality"

******* OLS GDP *****************
eststo clear
eststo: reg shapefateyrself_hat lgdp , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself_hat lgdp educlevel_hat  , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself_hat lgdp godimportant_hat , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself_hat lgdp educlevel_hat godimportant_hat Latitude Landlocked CoastLength Malaria1966 Malaria1994 , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
esttab using "outreg_B/macro_ols_gdp.tex", replace width(19cm) wrap nogaps se label star(* 0.10 ** 0.05 *** 0.01) nonotes title(Locus of Control and Income: Cross-country OLS)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")

*************************************************************
*************** OLS GROWTH *****************
eststo clear
eststo: reg shapefateyrself_hat growth , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself_hat growth educlevel_hat  , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself_hat growth godimportant_hat , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself_hat growth educlevel_hat godimportant_hat Latitude Landlocked CoastLength Malaria1966 Malaria1994 , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
esttab using "outreg_B/macro_ols_growth.tex", replace width(19cm) nogaps wrap se label star(* 0.10 ** 0.05 *** 0.01) nonotes title(Locus of Control and Growth: Cross-country OLS)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")

*************** OLS INEQUALITY *****************
eststo clear
eststo: reg shapefateyrself_hat ineq , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself_hat ineq educlevel_hat  , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself_hat ineq godimportant_hat , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself_hat ineq educlevel_hat godimportant_hat Latitude Landlocked CoastLength Malaria1966 Malaria1994 , r
	local f0 = round(e(F),.01) 
	estadd local F1 = "`f0'"
	estadd local N1 = "`e(N)'"
esttab using "outreg_B/macro_ols_ineq.tex", replace width(19cm) nogaps wrap se label star(* 0.10 ** 0.05 *** 0.01) nonotes title(Locus of Control and Inequality: Cross-country OLS)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")


***********IV *********************************************8
eststo clear
*foreach x of varlist Temperature Latitude Landlocked CoastLength Malaria1966 Malaria1994 SettlerMortality InstitutionQuality1982 ExpropriationRisk {
foreach x of varlist Latitude Landlocked CoastLength Malaria1966 Malaria1994 {
	eststo: ivreg2 shapefateyrself_hat (lgdp=`x'), r first
	mat A = e(first)
	local f0 = round(A[3,1],.01)
	local f1 = string(`f0', "%4.2f")
	local f0 = round(e(F),.01) 
	local f2 = string(`f0', "%4.2f")
	estadd local F1 = "`f1'" 
	estadd local F2 = "`f2'"
	estadd local N2 = "`e(N)'"
	estadd local N3 = "`x'"
}
*eststo: ivreg2 shapefateyrself_hat (lgdp = Temperature Latitude Landlocked CoastLength Malaria1966 Malaria1994 SettlerMortality InstitutionQuality1982 ExpropriationRisk), r first
	eststo: ivreg2 shapefateyrself_hat (lgdp = Latitude Landlocked CoastLength Malaria1966 Malaria1994), r first
	mat A = e(first)
	local f0 = round(A[3,1],.01)
	local f1 = string(`f0', "%4.2f")
	local f0 = round(e(F),.01) 
	local f2 = string(`f0', "%4.2f")
	estadd local F1 = "`f1'" 
	estadd local F2 = "`f2'"
	estadd local N2 = "`e(N)'"
	estadd local N3 = "All instruments"
esttab using "outreg_B/macro_iv_1.tex", replace width(24cm) nogaps wrap se label star(* 0.10 ** 0.05 *** 0.01) nonotes title(Locus of Control and Income: Climate and geography instruments)  stats(F1 F2 N2 N3, labels("First-stage F" "Second-stage F" "Obs." "Instrument")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
* keep(farmerrain) order(_cons triple)


eststo clear
foreach x of varlist SettlerMortality InstitutionQuality1982 ExpropriationRisk {
	eststo: ivreg2 shapefateyrself_hat (lgdp=`x'), r first
	mat A = e(first)
	local f0 = round(A[3,1],.01)
	local f1 = string(`f0', "%4.2f")
	local f0 = round(e(F),.01) 
	local f2 = string(`f0', "%4.2f")
	estadd local F1 = "`f1'" 
	estadd local F2 = "`f2'"
	estadd local N2 = "`e(N)'"
	estadd local N3 = "`x'"
}
	eststo: ivreg2 shapefateyrself_hat (lgdp = SettlerMortality InstitutionQuality1982 ExpropriationRisk), r first
	mat A = e(first)
	local f0 = round(A[3,1],.01)
	local f1 = string(`f0', "%4.2f")
	local f0 = round(e(F),.01) 
	local f2 = string(`f0', "%4.2f")
	estadd local F1 = "`f1'" 
	estadd local F2 = "`f2'"
	estadd local N2 = "`e(N)'"
	estadd local N3 = "All instruments"
esttab using "outreg_B/macro_iv_2.tex", replace width(19cm) nogaps wrap se label star(* 0.10 ** 0.05 *** 0.01) nonotes title(Locus of Control and Income: Institution instruments)  stats(F1 F2 N2 N3, labels("First-stage F" "Second-stage F" "Obs." "Instrument")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
* keep(farmerrain) order(_cons triple)


***********************************************************************
/*
* (Most of) these also work: 
ivreg2 shapefateyrself_hat (lgdp = SettlerMortality  ) Latitude Landlocked CoastLength Malaria1966 Malaria1994, r first
ivreg2 shapefateyrself_hat (lgdp = SettlerMortality  ) godimportant_hat Latitude Landlocked CoastLength Malaria1966 Malaria1994, r first

ivreg2 shapefateyrself_hat (lgdp =  InstitutionQuality1982 ) Latitude Landlocked CoastLength Malaria1966 Malaria1994, r first
ivreg2 shapefateyrself_hat (lgdp =  InstitutionQuality1982) godimportant_hat Latitude Landlocked CoastLength Malaria1966 Malaria1994, r first

ivreg2 shapefateyrself_hat (lgdp =   ExpropriationRisk) Latitude Landlocked CoastLength Malaria1966 Malaria1994, r first
ivreg2 shapefateyrself_hat (lgdp =   ExpropriationRisk) godimportant_hat Latitude Landlocked CoastLength Malaria1966 Malaria1994, r first

ivreg2 shapefateyrself_hat (lgdp = SettlerMortality InstitutionQuality1982 ExpropriationRisk) Latitude Landlocked CoastLength Malaria1966 Malaria1994, r first
ivreg2 shapefateyrself_hat (lgdp = SettlerMortality InstitutionQuality1982 ExpropriationRisk) godimportant_hat Latitude Landlocked CoastLength Malaria1966 Malaria1994, r first

egen bordergain = rowtotal(changeborderacquire*)
egen borderloss = rowtotal(changebordercede*)
gen borderchange = bordergain + borderloss

* all of these work
ivreg shapefateyrself_hat (lgdp=CoastLength), first r
ivreg shapefateyrself_hat (lgdp=CoastLength) bordergain , first r
ivreg shapefateyrself_hat (lgdp=CoastLength)  borderloss, first r
ivreg shapefateyrself_hat (lgdp=CoastLength) bordergain borderloss, first r
ivreg shapefateyrself_hat (lgdp=CoastLength) borderchange, first r

reg shapefateyrself_hat lgdp, r
reg shapefateyrself_hat lgdp godimportant_hat, r

xi: reg shapefateyrself_hat gdp, r
xi: reg shapefateyrself_hat gdp godimportant_hat, r

reg intrinsic_hat lgdp godimportant_hat, r
reg helpneighborhood_hat lgdp godimportant_hat, r
reg helpfamily_hat lgdp godimportant_hat, r
reg lonely_hat lgdp godimportant_hat, r
reg lifemeaningless_hat lgdp godimportant_hat, r
*/
/*
************** Replicating Table 7 from Acemoglu: 
ivreg shapefateyrself_hat (lgdp=settlermort) malfal94, first
ivreg shapefateyrself_hat lat_abst (lgdp=settlermort) malfal94, first

*Columns 3 and 4: Instrumenting only for average protection against expropriaton risk: life expectancy control

ivreg shapefateyrself_hat (lgdp=settlermort) leb95, first
ivreg shapefateyrself_hat lat_abst (lgdp=settlermort) leb95, first

*Columns 5 and 6: Instrumenting only for average protection against expropriaton risk: infant mortality control

ivreg shapefateyrself_hat (lgdp=settlermort) imr95, first
ivreg shapefateyrself_hat lat_abst (lgdp=settlermort) imr95, first

*Column 7: Instrumenting for all RHS variables: malaria control

ivreg shapefateyrself_hat (lgdp malfal94=settlermort latabs CoastLength meantemp), first

*Column 8: Instrumenting for all RHS variables: life expectancy control

ivreg shapefateyrself_hat (lgdp leb95=settlermort latabs CoastLength meantemp), first

*Column 9: Instrumenting for all RHS variables: infant mortality control

ivreg shapefateyrself_hat (lgdp imr95=settlermort latabs lt100km meantemp), first

*Columns 10 and 11: Yellow fever instrument for average protection against expropriation risk

ivreg shapefateyrself_hat (lgdp = yellow), first
*/

