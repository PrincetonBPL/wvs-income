window manage close graph _all

use "macro_reg_geo.dta" if nonrepresentative ==0, clear
*xtset ctynum year
drop trustfriends_hat trustrelatives_hat
drop if cty=="ZWE"

label var shapefateyrself_hat "Locus of Control" 
label var helpneighborhood_hat "Help neighbor" 
label var intrinsic_hat "Intrinsic motivation" 
label var wouldntwork_hat "Intrinsic motivation"
label var helpfamily_hat "Help family" 
label var lifemeaningless_hat "Meaningless"
label var lonely_hat "Lonely"
label var godimportant_hat "God important" 
label var risktaking_hat "Risktaking" 
label var livedaytoday_hat "Shortsighted"
label var trustmeetfirsttime_hat "Trust"
label var hap_hat "Happiness" 

//		ylabel(`ymin'(.5)`ymax', angle(horizontal) format(%9.1f))

******************** FIGURE 1 ****************************************
foreach v of varlist shapefateyrself_hat wouldntwork_hat intrinsic_hat trustmeetfirsttime_hat helpfamily_hat lonely_hat lifemeaningless_hat livedaytoday_hat risktaking_hat hap_hat sat_hat {
	preserve 
	levelsof cty, local(cty) 
	foreach thiscty of local cty {
		qui sum wave if cty == "`thiscty'" & `v'~=.
		dis "Country `thiscty' max wave `r(max)'"
		drop if r(max) ~= . & wave < r(max) & cty == "`thiscty'"
	}
		
	local varlabel: var label `v'
	correl `v' lgdp 
	local p= string(min(2*ttail(r(N)-2, abs(r(rho))*sqrt(r(N)-2)/ sqrt(1-r(rho)^2)),1) , "%5.4f")
	local rho=string(r(rho),"%3.2f")
	
	reg `v' lgdp, r
	local n=`e(N)'
	predict `v'_fit
	local b=string(_b[lgdp],"%3.2f")
	local a=string(_b[_cons],"%3.2f")
	local se=string(_se[lgdp],"%3.2f")
	lowess `v' lgdp, nograph generate(`v'_low)

	qui sum lgdp if `v'~=.
	local xmin = (floor(`r(min)'/1000)-2)*1000
	local xmax = (ceil(`r(max)'/1000)+2)*1000

*			xscale(range(`xmin', `xmax'))

	qui sum `v' if `v'~=.
	local ymin = `r(min)' -(`r(max)'-`r(min)')*.1
	local ymax = `r(max)' +(`r(max)'-`r(min)')*.1
	
	*local xsteps round(2*(log(`xmax')-log(`xmin')))-1
	*mat xsteps = J(1,`xsteps',.)
	*forvalues i=1 to `xsteps' {
	*	mat xsteps[1,`i'] = `xmin'*2^`i'
	*	}	
    label define gdplabel 500 ".5" 1000 "1" 2000 "2" 4000 "4" 8000 "8" 16000 "16" 32000 "32" 64000 "64", replace
	label values gdp gdplabel
	separate `v', by(continentnum)
dis "done separating"
	label var `v'1 "Africa"
	label var `v'2 "Asia"
	label var `v'3 "Europe" 
	label var `v'4 "N. America"
	label var `v'5 "Oceania"
	label var `v'6 "S. America" 
	* AF = 1, AS = 2, EU = 3, NA = 4, OC = 5, SA = 6

		#delimit ;
		twoway
		//(scatter `v' gdp, mcolor(black) mlabel(cty) mlabcolor(black))
		(scatter `v'? gdp, mcolor(black yellow blue red green cranberry) mlcolor(black ..) msize(2 ..) legend(on) )
		(line `v'_fit gdp, sort lpattern(solid) lcolor(black))
		if `v' ~= .
		,
		xscale(log)
		yscale(range(`ymin' `ymax'))
		xlabel( 500 1000 2000 4000 8000 16000 32000 64000, valuelabel) 
		xtitle("")
		//title("`varlabel'", ring(1) span color(black) size(*.8))
		legend(position(6) ring(1) size(*0.8) rows(1) cols(6) order(1 2 3 4 6 5 ) symxsize(*2) symysize(*2) region(lwidth(none)))
		note("N = `n'" "r = `rho', p = `p'" , ring(0) pos(7))
		// xsize(2.5) ysize(3.5)
		// for slide show:
		xsize(2.5) ysize(2.5)
		graphregion(color(white))
		name(`v', replace)
	;
	#delimit cr		
	drop `v'_fit `v'_low
	graph export "figs/macro1_2013_`v'.eps", replace
	graph save "figs/macro1_`v'", replace 
	
	restore
}

*graph combine shapefateyrself_hat wouldntwork_hat intrinsic_hat trustmeetfirsttime_hat helpfamily_hat lonely_hat lifemeaningless_hat livedaytoday_hat risktaking_hat ,
#delimit ;
grc1leg shapefateyrself_hat wouldntwork_hat intrinsic_hat trustmeetfirsttime_hat helpfamily_hat lonely_hat lifemeaningless_hat livedaytoday_hat risktaking_hat ,
	rows(3) cols(3)
	imargin(tiny)
	position(6) ring(2) span
	l1title("Normalized response", size(small)  )
	b1title("Real GDP per Capita (thousands of dollars, log scale)", size(small) position(6) ring(1))
	xsize(6.8) ysize(14)
	graphregion(color(white))
	name(macro1, replace)
;
#delimit cr

graph display macro1, xsize(6.8) ysize(10) 
   
   
* graph save "figs/macro1.gph", replace
graph export "figs/macro1_2013.eps", replace
