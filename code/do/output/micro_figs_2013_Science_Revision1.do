win man close graph _all

use micro_forFigs_byContinent.dta, clear

label var shapefateyrself_mean "Locus of Control" 
label var helpneighborhood_mean "Help neighbor" 
label var intrinsic_mean "Intrinsic 2" 
label var wouldntwork_mean "Intrinsic movtivation"
label var helpfamily_mean "Help family" 
label var lifemeaningless_mean "Meaningless"
label var lonely_mean "Lonely"
label var godimportant_mean "God important" 
label var risktaking_mean "Risktaking" 
label var livedaytoday_mean "Shortsighted"
label var trustmeetfirsttime_mean "Trust"
label var hap_mean "Happiness" 

foreach v in shapefateyrself hap {	
	preserve 
		use "micro_standardized.dta", clear 
		correl `v' inc
		local p= string(min(2*ttail(r(N)-2, abs(r(rho))*sqrt(r(N)-2)/ sqrt(1-r(rho)^2)),1) , "%5.4f")
		local rho=string(r(rho),"%3.2f")
		dis "Correl `v' inc: `r(rho)' , string = `rho', p=`p'"
	restore 
	
	local varlabel: var label `v'_mean
	
	qui sum `v'_n if continentnum == 0
	local n = `r(sum)'
		
/*	reg `v'_mean inc, r
	predict `v'_fit
	local b=string(_b[inc],"%3.2f")
	local a=string(_b[_cons],"%3.2f")
	local se=string(_se[inc],"%3.2f")
	lowess `v'_mean inc, nograph generate(`v'_low)
*/
	* Make overall trend line
	gen `v'_hi = .
	gen `v'_lo = .
	
	foreach thiscont in "0" "1" "2" "3" "4" "5" "6" {

		reg `v'_mean inc if continentnum== `thiscont', r
		predict `v'_fit`thiscont'
		local b=string(_b[inc],"%3.2f")
		local a=string(_b[_cons],"%3.2f")
		local se=string(_se[inc],"%3.2f")

		capture replace `v'_hi = `v'_mean + invttail(`v'_n-1,0.025)*(`v'_sd / sqrt(`v'_n)) if continentnum==`thiscont'
		capture replace `v'_lo = `v'_mean - invttail(`v'_n-1,0.025)*(`v'_sd / sqrt(`v'_n)) if continentnum==`thiscont'
	}

	
	qui sum `v'_hi
	local ymax = `r(max)' +(`r(max)'-`r(min)')*.1
	qui sum `v'_lo
	local ymin = `r(min)' -(`r(max)'-`r(min)')*.1

	dis "again: `rho'"
    	#delimit ;
		twoway 				
					(line `v'_mean inc if continentnum==1, lcolor(black) lpattern(dot)) 
					(line `v'_mean inc if continentnum==2, lcolor(yellow) lpattern(dot)) 
					(line `v'_mean inc if continentnum==3, lcolor(blue) lpattern(dot)) 
					(line `v'_mean inc if continentnum==4, lcolor(red) lpattern(dot)) 
					(line `v'_mean inc if continentnum==5, lcolor(green) lpattern(dot)) 
					(line `v'_mean inc if continentnum==6, lcolor(cranberry) lpattern(dot)) 
					
					(rcap `v'_hi `v'_lo inc if continentnum==1, lcolor(black) lpattern(dot))
					(rcap `v'_hi `v'_lo inc if continentnum==2, lcolor(yellow) lpattern(dot))
					(rcap `v'_hi `v'_lo inc if continentnum==3, lcolor(blue) lpattern(dot))
					(rcap `v'_hi `v'_lo inc if continentnum==4, lcolor(red) lpattern(dot))
					(rcap `v'_hi `v'_lo inc if continentnum==5, lcolor(green) lpattern(dot))
					(rcap `v'_hi `v'_lo inc if continentnum==6, lcolor(cranberry) lpattern(dot))

					(line `v'_mean inc if continentnum==0, lcolor(gray) lpattern(solid) lwidth(*2)) 
					(rcap `v'_hi `v'_lo inc if continentnum==0, lcolor(gray) lpattern(solid) lwidth(*2))
		,
		xtitle("")
		title("`varlabel'", ring(0) span color(black) size(*.8))
		legend(off)
		xsize(2.5) ysize(2.5)
		name(`v', replace)
		yscale(range(`ymin' `ymax'))
		graphregion(color(white))
				xlabel(1/10) 
		note("N = `n'" "r = `rho', p = `p'", ring(0) pos(7))
	;
	#delimit cr		
	drop `v'_fit* 
	graph export "figs/micro_2013_`v'_Science_Revision1.eps", replace
	graph save "figs/micro1_`v'_Science_Revision1", replace 
}

keep continentnum inc shapefateyrself* hap*
keep continentnum inc *mean *sd *n
label define continent 0 "World" 1 "Africa" 2 "Asia" 3 "Europe" 4 "N. America" 5 "Oceania" 6 "S. America" 
label val continentnum continent
rename continentnum continent
rename inc income
foreach x in "mean" "sd" "n" { 
	rename hap_`x' happiness_`x'
	rename shapefateyrself_`x' locusofcontrol_`x'
	label var happiness_`x' "Happiness (`x')"
	label var locusofcontrol_`x' "Locus of control (`x')"
}
label var continent Continent
label var income Income
sort continent income 
save HaushoferFehr_WVSMicroData_Science.dta, replace
outsheet using HaushoferFehr_WVSMicroData_Science.csv, replace comma

