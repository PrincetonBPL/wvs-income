* This file does the primary analysis of the WVS microdata
clear
clear matrix
*set mem 900m // was 1200m
set matsize 2000 // was 2000

use "micro_standardized.dta", clear 
*not "if not nonrepresentative" because that's already done in the setup micro standardize do file.
global controls "sex educ married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 "

foreach X in shapefateyrself wouldntwork intrinsic trustmeetfirsttime helpfamily lonely lifemeaningless livedaytoday risktaking {
	drop `X'
	rename `X'_std `X'
	}
	

*keep $controls cty ctywave cw_* c_* y_* w_* wave year wt1000 inc lninc brightfuture risktaking sciencetoofast sciencehealth shapefateyrself financesat scienceopportunity candonothinglaw godmeaningful helpneighborhood believedevil escapepoverty aidtoomuch concernfamily believeresurrection wouldntwork concernhumankind intrinsic helpfamily trustmeetfirsttime sciencebetteroff lifemeaningless expectwar aidtaxwtp lonely livedaytoday godimportant

label var shapefateyrself "Control" 
label var helpneighborhood "Help neighbor" 
label var intrinsic "Intrinsic 2" 
label var wouldntwork "Intrinsic 1"
label var helpfamily "Help family" 
label var lifemeaningless "Meaningless"
label var lonely "Lonely"
label var godimportant "God important" 
label var risktaking "Risktaking" 
label var livedaytoday "Shortsighted"
label var trustmeetfirsttime "Trust"

label var godimportant "God important" 

label var inc "Income" 
label var educ "Education"
label var age1 "Age" 
label var age2 "Age2"
label var age3 "Age3"
label var age4 "Age4"
label var fage1 "Fem. x Age" 
label var fage2 "Fem. x Age2"
label var fage3 "Fem. x Age3"
label var fage4 "Fem. x Age4"
label var sex "Female"
label var married "Married" 
label var kids "Children"

******** RUN THE REGS ****************************************

/* foreach x of varlist brightfuture risktaking candonothinglaw wouldntwork trustmeetfirsttime livedaytoday {
quietly capture reg `x'  inc cw_* $controls [pw=wt1000], r cluster(cty)
dis "`x',`e(N)'," _b[inc]/_se[inc]
}
*/

capture rm "outreg/micro_1_gdp.tex"
eststo clear
eststo: reg shapefateyrself inc cw_*  [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg shapefateyrself inc cw_* sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 educ [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg wouldntwork inc cw_*  [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg wouldntwork inc cw_* sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg intrinsic inc  cw_*  [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg intrinsic inc  cw_* sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/micro_1_gdp.tex", keep(inc sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 educ) replace width(19cm) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Psychological variables and Within-country Income)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")

capture rm "outreg/micro_2_gdp.tex"
eststo clear
eststo: reg trustmeetfirsttime inc cw_* [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg trustmeetfirsttime inc cw_* sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4  educ [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg helpfamily inc cw_* [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg helpfamily inc cw_* sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 educ [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg lonely inc cw_* [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg lonely inc cw_* sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/micro_2_gdp.tex", replace width(19cm) keep(inc sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 educ) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Psychological variables and Within-country Income)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")

capture rm "outreg/micro_3_gdp.tex"
eststo clear
eststo: reg lifemeaningless inc cw_* [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg lifemeaningless inc cw_* sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg livedaytoday inc cw_* [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg livedaytoday inc cw_* sex  married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 educ [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg risktaking inc cw_* [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
eststo: reg risktaking inc cw_* sex  married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 educ [pw=wt1000], r cluster(ctywave)
	estadd local N1 = "`e(N)'"
esttab using "outreg_A/micro_3_gdp.tex", replace width(19cm) keep(inc sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 educ) wrap nogaps label se star(* 0.10 ** 0.05 *** 0.01) nonotes title(Psychological variables and Within-country Income)  stats(N1, labels("Obs.")) addnotes("Robust standard errors in parentheses. * p < 0.10, ** p < 0:05, *** p < 0.01.")
 

