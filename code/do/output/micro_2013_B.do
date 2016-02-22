* This file does the primary analysis of the WVS microdata
clear
clear matrix
*set mem 900m // was 1200m
set matsize 2000 // was 2000

use "micro.dta" if nonrepresentative==0, clear
global controls "sex educ married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 "
global controls_noeduc "sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 "
drop cty 
gen cty=s003a 
drop s001 - f163a
drop trustfriends trustrelatives
xi i.cty, prefix(c_) 
xi i.year, prefix(y_) 
keep $controls cty c_* y_* wave year wt1000 inc lninc brightfuture risktaking sciencetoofast sciencehealth shapefateyrself financesat scienceopportunity candonothinglaw godmeaningful helpneighborhood believedevil escapepoverty aidtoomuch concernfamily believeresurrection wouldntwork concernhumankind intrinsic helpfamily trustmeetfirsttime sciencebetteroff lifemeaningless expectwar aidtaxwtp lonely livedaytoday godimportant

label var shapefateyrself "Locus of Control" 
label var godimportant "God important" 

label var inc "Income (steps 1-10)" 
label var educ "Education (years)"
label var age1 "Age" 
label var age2 "Age2"
label var age3 "Age3"
label var age4 "Age4"
label var fage1 "Female x Age" 
label var fage2 "Female x Age2"
label var fage3 "Female x Age3"
label var fage4 "Female x Age4"
label var sex "Female"
label var married "Married" 
label var kids "Number of children" 
******** RUN THE REGS ****************************************

eststo clear
eststo: reg shapefateyrself inc c_* [pw=wt1000], r cluster(cty)
	estadd local N1 = "`e(N)'"
	estadd local N2 = "Yes"
	estadd local N3 = "Yes"
eststo: reg shapefateyrself inc godimportant c_* [pw=wt1000], r cluster(cty)
	estadd local N1 = "`e(N)'"
	estadd local N2 = "Yes"
	estadd local N3 = "Yes"
eststo: reg shapefateyrself inc godimportant c_* $controls [pw=wt1000], r cluster(cty)
	estadd local N1 = "`e(N)'"
	estadd local N2 = "Yes"
	estadd local N3 = "Yes"
esttab using "outreg_B/micro.tex", replace width(17cm) nogaps wrap se label star(* 0.10 ** 0.05 *** 0.01) keep(inc godimportant sex educ married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4) nonotes title(Locus of Control and Income: Within-country OLS)  stats(N1 N2 N3, labels("Obs." "Country FE" "Country clutsering")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
* keep(farmerrain) order(_cons triple)

/* 
foreach r in "lninc" "inc" {
	local outfile="micro_year_`r'"
	dis "`outfile'"
	*foreach v of varlist brightfuture risktaking sciencetoofast sciencehealth shapefateyrself financesat scienceopportunity candonothinglaw godmeaningful helpneighborhood believedevil escapepoverty aidtoomuch concernfamily believeresurrection wouldntwork concernhumankind intrinsic helpfamily trustmeetfirsttime sciencebetteroff lifemeaningless expectwar aidtaxwtp lonely livedaytoday {
	* foreach v of varlist brightfuture {
foreach v of varlist shapefateyrself  intrinsic  helpneighborhood helpfamily lonely lifemeaningless {

*	foreach v of varlist livedaytoday {
		dis "`v'" 
		if "`v'"=="lonely" | "`v'"=="lifemeaningless"{
			dis "YES" 
			reg `v' `r' $controls_noeduc c_* y_* [pw=wt1000], r 
			}
		else {
			quietly reg `v' `r' $controls c_* y_* [pw=wt1000], r 
		}
		local varlabel: var label `v'
		outreg2 using "`outfile'", append label keep(`r' $controls) excel stats(coef tstat) ctitle(`varlabel') addtext(Country FE, YES, Year FE, YES)
	}
}
*/
*quietly reg `v' `r' $controls c_* y_* [pw=wt1000], r 
*outreg2 using "`outfile'", append keep(`r' $controls) excel stats(coef se tstat pval)

