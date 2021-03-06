win man close graph _all

use micro_forFigs_byContinent.dta, clear

label var shapefateyrself_mean "Locus of Control" 
label var helpneighborhood_mean "Help neighbor" 
label var intrinsic_mean "Intrinsic motivation" 
label var wouldntwork_mean "Wouldn't work"
label var helpfamily_mean "Help family" 
label var lifemeaningless_mean "Meaningless"
label var lonely_mean "Lonely"
label var godimportant_mean "God important" 
label var risktaking_mean "Risktaking" 
label var livedaytoday_mean "Shortsighted"
label var trustmeetfirsttime_mean "Trust"
label var hap_mean "Happiness" 
*label var sat_mean "Satisfaction" 

*foreach v in brightfuture risktaking sciencetoofast sciencehealth shapefateyrself financesat scienceopportunity candonothinglaw godmeaningful helpneighborhood believedevil escapepoverty aidtoomuch concernfamily believeresurrection wouldntwork concernhumankind intrinsic helpfamily trustmeetfirsttime sciencebetteroff lifemeaningless expectwar aidtaxwtp lonely {
*foreach v in aidtoomuch wouldntwork intrinsic helpfamily lifemeaningless aidtaxwtp lonely {
foreach v in shapefateyrself wouldntwork intrinsic trustmeetfirsttime helpfamily lonely lifemeaningless livedaytoday risktaking hap {
*foreach v in brightfuture risktaking shapefateyrself candonothinglaw  {
	
	preserve 
	use "micro_standardized.dta", clear 
	correl `v' inc
	local p= string(min(2*ttail(r(N)-2, abs(r(rho))*sqrt(r(N)-2)/ sqrt(1-r(rho)^2)),1) , "%5.4f")
	local rho=string(r(rho),"%3.2f")
	dis "Correl `v' inc: `r(rho)' , string = `rho', p=`p'"
	restore 
	
	local varlabel: var label `v'_mean
	
	qui sum `v'_n
	local n = `r(sum)'
		
/*	reg `v'_mean inc, r
	predict `v'_fit
	local b=string(_b[inc],"%3.2f")
	local a=string(_b[_cons],"%3.2f")
	local se=string(_se[inc],"%3.2f")
	lowess `v'_mean inc, nograph generate(`v'_low)
*	correl `v'_mean inc 
*	local myrho=string(r(rho),"%3.2f")
*/

	* Make overall trend line
	gen `v'_hi = .
	gen `v'_lo = .
	
	foreach thiscont in "0"  {

		reg `v'_mean inc if continentnum== `thiscont', r
		predict `v'_fit`thiscont'
		local b=string(_b[inc],"%3.2f")
		local a=string(_b[_cons],"%3.2f")
		local se=string(_se[inc],"%3.2f")

		capture replace `v'_hi = `v'_mean + invttail(`v'_n-1,0.025)*(`v'_sd / sqrt(`v'_n)) if continentnum==`thiscont'
		capture replace `v'_lo = `v'_mean - invttail(`v'_n-1,0.025)*(`v'_sd / sqrt(`v'_n)) if continentnum==`thiscont'
	}
	
	qui sum `v'_hi
	local ymax = ceil( (`r(max)' +(`r(max)'-`r(min)')*.1)*10 ) / 10
	qui sum `v'_lo
	local ymin = floor( (`r(min)' -(`r(max)'-`r(min)')*.1)*19 ) / 10

	dis "again: `rho'"
    	#delimit ;
    			twoway 				
					(line `v'_mean inc if continentnum==1 & `v'_mean < `ymax' & `v'_mean > `ymin', lcolor(black) lpattern(dot)) 
					(line `v'_mean inc if continentnum==2 & `v'_mean < `ymax' & `v'_mean > `ymin', lcolor(yellow) lpattern(dot)) 
					(line `v'_mean inc if continentnum==3 & `v'_mean < `ymax' & `v'_mean > `ymin', lcolor(blue) lpattern(dot)) 
					(line `v'_mean inc if continentnum==4 & `v'_mean < `ymax' & `v'_mean > `ymin', lcolor(red) lpattern(dot)) 
					(line `v'_mean inc if continentnum==5 & `v'_mean < `ymax' & `v'_mean > `ymin', lcolor(green) lpattern(dot)) 
					(line `v'_mean inc if continentnum==6 & `v'_mean < `ymax' & `v'_mean > `ymin', lcolor(cranberry) lpattern(dot)) 
					

					(line `v'_mean inc if continentnum==0, lcolor(gray) lpattern(solid) lwidth(*2)) 
					(rcap `v'_hi `v'_lo inc if continentnum==0, lcolor(gray) lpattern(solid) lwidth(*2))
	,
		//ytitle("Standardized response", height(10))
		xtitle("")
		title("`varlabel'", ring(0) span color(black) size(*.8))
		legend(off)
		// xsize(10) ysize(7.5)
		// xsize(2.5) ysize(3.5)
		// for slide show:
		xsize(2.5) ysize(2.5)
		name(`v', replace)
		yscale(range(`ymin' `ymax'))
		ylabel(`ymin'(0.1)`ymax')
		graphregion(color(white))
				xlabel(1/10) 
		note("N = `n'" "r = `rho', p = `p'", ring(0) pos(7))
	;
	#delimit cr		
	capture drop `v'_fit 
	capture drop `v'_low
	graph export "figs/micro_2013_`v'.eps", replace
	graph save "figs/micro1_`v'", replace 
}
*	twoway (line `v'_mean inc, lcolor(black)) (rcap `v'_hi `v'_lo inc, lcolor(black))
	
*		(line `v'_fit inc, sort lpattern(solid) lcolor(black))
*		note("y = `a'+`b'*ln(x) [se=`se']" "Correlation: `rho'" "N = `n'", ring(0) pos(7))

*	ycommon
#delimit ;
graph combine shapefateyrself wouldntwork intrinsic trustmeetfirsttime helpfamily lonely lifemeaningless livedaytoday risktaking,
	rows(3) cols(3)
	imargin(tiny)
	l1title("Normalized response", size(small))
	b1title("Income category", size(small))
	xsize(6) ysize(8)
	name(micro1, replace)
	graphregion(color(white))
;
#delimit cr
graph save "figs/micro1.gph", replace
graph export "figs/micro1.eps", replace

* win man close graph _all
