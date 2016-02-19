* This file does the primary analysis of the WVS microdata
clear
clear matrix
*set mem 900m // was 1200m
set matsize 11000 // was 2000

cd "/users/haushofer/dropbox/data/wvs/"
sysdir set PERSONAL "/users/haushofer/dropbox/uct/ado/personal"

use "micro_standardized_geo.dta", clear 
*not "if not nonrepresentative" because that's already done in the setup micro standardize do file.
global controls "sex educ married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 "

*keep $controls cty ctywave cw_* c_* y_* w_* wave year wt1000 inc lninc brightfuture risktaking sciencetoofast sciencehealth shapefateyrself financesat scienceopportunity candonothinglaw godmeaningful helpneighborhood believedevil escapepoverty aidtoomuch concernfamily believeresurrection wouldntwork concernhumankind intrinsic helpfamily trustmeetfirsttime sciencebetteroff lifemeaningless expectwar aidtaxwtp lonely livedaytoday godimportant

* Country weights (weight all countries equally)
		capture drop freq 
		capture drop f
		bys ctywave: gen freq = _N 
		gen f= 1/freq
		
foreach X of varlist shapefateyrself wouldntwork intrinsic trustmeetfirsttime helpfamily lonely lifemeaningless livedaytoday risktaking hap sat {
	xi: reg `X' [aw=f]
	predict `X'_res if `X'~=., res
	gen `X'_macrostd = .
	dis "`X'"
	qui summ `X'_res
	qui replace `X'_macrostd = `X'_res/r(sd)
	}


foreach suffix in "" "_std" "_macrostd" {
	label var hap`suffix' "Happiness" 
	label var shapefateyrself`suffix' "Control" 
*	label var helpneighborhood`suffix' "\specialcell{Help\\neighbor}" 
	label var intrinsic`suffix' "\specialcell{Intrinsic\\motivation}" 
	label var wouldntwork`suffix' "\specialcell{Wouldn't\\work}"
	label var helpfamily`suffix' "\specialcell{Help\\family}" 
	label var lifemeaningless`suffix' "Meaningless"
	label var lonely`suffix' "Lonely"
*	label var godimportant`suffix' "God important" 
	label var risktaking`suffix' "Risktaking" 
	label var livedaytoday`suffix' "Shortsighted"
	label var trustmeetfirsttime`suffix' "Trust"
}

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

rename meantemp Temperature
rename lat_abst Latitude
rename landlock Landlocked
replace Landlocked = 0 if cty=="CYP"
rename lc100km CoastLength
rename malfal94 Malaria1994
rename malfal66 Malaria1966
rename settlermort SettlerMortality
rename icrg82 InstitutionQuality1982
rename avexpr ExpropriationRisk

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


******** RUN THE REGS ****************************************

/* foreach x of varlist brightfuture risktaking candonothinglaw wouldntwork trustmeetfirsttime livedaytoday {
quietly capture reg `x'  inc cw_* $controls [pw=wt1000], r cluster(cty)
dis "`x',`e(N)'," _b[inc]/_se[inc]
}
*/
global microcontrols "sex married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4"
global macrocontrols "Landlocked tropicar troppop south landarea socialst urbpop95 wardum pop95 eu safri sasia latam eseasia asia africa elev"

fillmissing $microcontrols $macrocontrols
global microcontrols_full ""
global macrocontrols_full ""
foreach x in $microcontrols {
	global microcontrols_full "$microcontrols_full `x'_full `x'_miss"
	}
foreach x in $macrocontrols {
	global macrocontrols_full "$macrocontrols_full `x'_full `x'_miss"
	}
dis "$macrocontrols_full"

global depvarlist ""shapefateyrself" "wouldntwork" "intrinsic" "trustmeetfirsttime" "helpfamily" "lonely" "lifemeaningless" "livedaytoday" "risktaking""
*global depvarlist ""shapefateyrself" "wouldntwork""


*******************************
* Across countries: GDP (no FE)
*******************************
local colnames "" 
foreach thisindepvar in "lgdp" "growth" "ineq" {
	eststo clear 
	local count1 = 100
	foreach depvar in  $depvarlist  {
		local thisdepvarlabel: variable label `depvar'
		local thisindepvarlabel: variable label `thisindepvar'
		local colnames `"`colnames' "`thisdepvarlabel'""'
		eststo m`count1': reg `depvar'_macrostd `thisindepvar' [aw=f], r cluster(ctywave)
			pstar `thisindepvar'
			estadd local b1 "`r(bstar)'": m`count1'
			estadd local se1 "`r(sestar)'" : m`count1'
			estadd local thisn "{`e(N)'}"
		eststo m`count2': reg `depvar'_macrostd `thisindepvar' $macrocontrols_full $microcontrols_full [aw=f], r cluster(ctywave)
			pstar `thisindepvar'
			estadd local b2 "`r(bstar)'": m`count1'
			estadd local se2 "`r(sestar)'" : m`count1'
		local ++count1
	*esttab m1* using "outreg_new/macro_`thisindepvar'.tex", cells(none) compress booktabs alignment(S) b(3) replace wrap nogaps label se(3) nonotes  stats(thisvarlabeldummy b1 se1 b2 se2 thisn, labels("\bf{`thisvarlabel'}" "\hspace{0.1cm} No controls" " " "\midrule \hspace{0.1cm} With controls" " " "\midrule \emph{N}"))
	}

	** SUEST
	local suest1 "suest " 
	local suest2 "suest " 
	local count1 = 100
	local count2 = 200
	local colnames `"`colnames' "\specialcell{Joint test\\(chi2/p)}""'
	foreach depvar in  $depvarlist {
		eststo suest`count1': reg `depvar'_macrostd `thisindepvar' [aw=f]
		eststo suest`count2': reg `depvar'_macrostd `thisindepvar' $macrocontrols_full $microcontrols_full [aw=f]
		local suest1 "`suest1' suest`count1'"
		local suest2 "`suest2' suest`count2'"
		local ++count1
		local ++count2
*		label var `depvar' "`thisvarlabel'"
	}
	di "`suest1'"
	`suest1', r cluster(ctywave) 
		test `thisindepvar'
		pstar, b(`r(chi2)') p(`r(p)')
		estadd local b1 "`r(bstar)'": suest100
		estadd local se1 "`r(pstar)'": suest100	
	`suest2', r cluster(ctywave) 
		test `thisindepvar'
		pstar, b(`r(chi2)') p(`r(p)')
		estadd local b2 "`r(bstar)'": suest100
		estadd local se2 "`r(pstar)'": suest100	

	esttab m1* suest100 using "outreg_new/macro_`thisindepvar'.tex", cells(none) compress booktabs alignment(S) b(3) replace wrap nogaps label se(3) nonotes mtitle(`colnames') stats(thisvarlabeldummy b1 se1 b2 se2 thisn, labels("\bf{`thisindepvarlabel'}" "\hspace{0.1cm} No controls" " " "\midrule \hspace{0.1cm} With controls" " " "\midrule \emph{N}"))
	}

*********************************
* Within countries
*********************************
local colnames "" 
eststo clear 
local count1 = 100
local thisvarlabel: variable label inc
foreach depvar in $depvarlist {
		local thisdepvarlabel: variable label `depvar'
		local thisindepvarlabel: variable label inc
		local colnames `"`colnames' "`thisdepvarlabel'""'
	eststo m`count1': reg `depvar'_std inc cw_* [pw=wt1000], r cluster(ctywave)
		pstar inc
		estadd local b1 "`r(bstar)'": m`count1'
		estadd local se1 "`r(sestar)'" : m`count1'

		estadd local fe "{Yes}": m`count1'
		estadd local thisn "{`e(N)'}": m`count1'
	reg `depvar'_std inc cw_* $microcontrols_full [pw=wt1000], r cluster(ctywave)
		pstar inc
		estadd local b2 "`r(bstar)'": m`count1'
		estadd local se2 "`r(sestar)'" : m`count1'
	local ++count1
}

** SUEST
local suest1 "suest " 
local suest2 "suest " 
local count1 = 100
local count2 = 200
local colnames `"`colnames' "\specialcell{Joint test\\(chi2/p)}""'
	foreach depvar in  $depvarlist {
		eststo suest`count1': reg `depvar'_std inc cw_* [iw=wt1000]
		eststo suest`count2': reg `depvar'_std inc cw_*  $microcontrols_full [iw=wt1000]
		local suest1 "`suest1' suest`count1'"
		local suest2 "`suest2' suest`count2'"
		local ++count1
		local ++count2
*		label var `depvar' "`thisvarlabel'"
	}
	di "`suest1'"
	query
	pause
	
	`suest1', r cluster(ctywave) 
		test inc
		pstar, b(`r(chi2)') p(`r(p)')
		estadd local b1 "`r(bstar)'": suest100
		estadd local se1 "`r(pstar)'": suest100	
	`suest2', r cluster(ctywave) 
		test inc
		pstar, b(`r(chi2)') p(`r(p)')
		estadd local b2 "`r(bstar)'": suest100
		estadd local se2 "`r(pstar)'": suest100	

esttab m1* suest100 using "outreg_new/micro_inc.tex", cells(none) compress booktabs alignment(S) replace wrap nogaps label se(3) b(3) mtitle(`colnames') nonotes stats(thisvarlabeldummy b1 se1 b2 se2 thisn fe, labels("\bf{`thisvarlabel'}" "\hspace{0.1cm} No controls" " " "\midrule \hspace{0.1cm} With controls" " " "\midrule \emph{N}" "Country-wave FE"))
