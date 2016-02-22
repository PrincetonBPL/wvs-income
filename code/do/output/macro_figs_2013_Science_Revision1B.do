cd "/Users/haushofer/Dropbox/data/wvs"

window manage close graph _all
graph drop _all

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
local thisvarlist "shapefateyrself_hat hap_hat"
foreach v in `thisvarlist' {
	preserve 
	* Pick the most recent wave for each country:
	levelsof cty, local(cty) 
	foreach thiscty of local cty {
		qui sum wave if cty == "`thiscty'" & `v'~=.
		dis "Country `thiscty' max wave `r(max)'"
		drop if r(max) ~= . & wave < r(max) & cty == "`thiscty'"
	}
	
    label define gdplabel 500 ".5" 1000 "1" 2000 "2" 4000 "4" 8000 "8" 16000 "16" 32000 "32" 64000 "64", replace
	label values gdp gdplabel
	separate `v', by(continentnum)
	label var `v'1 "Africa"
	label var `v'2 "Asia"
	label var `v'3 "Europe" 
	label var `v'4 "N. America"
	label var `v'5 "Oceania"
	label var `v'6 "S. America" 
	* AF = 1, AS = 2, EU = 3, NA = 4, OC = 5, SA = 6

	local varlabel: var label `v'
	correl `v' lgdp 
	local p= string(min(2*ttail(r(N)-2, abs(r(rho))*sqrt(r(N)-2)/ sqrt(1-r(rho)^2)),1) , "%5.4f")
	local rho=string(r(rho),"%3.2f")
	
	cap gen lgdp2 = lgdp^2
	
	* Make overall trend line
	foreach thiscont in "" "1" "2" "3" "4" "5" "6" {
		if "`thiscont'" == "" {
			reg `v'`thiscont' lgdp, r
			predict `v'_fit`thiscont'
*			reg `v'`thiscont' lgdp lgdp2, r
*			predict `v'_fitsquare`thiscont'
			lowess `v'`thiscont' lgdp, nograph generate(`v'_fitsquare`thiscont')
			local n=`e(N)'
		}
		else {
			cap reg `v'`thiscont' lgdp if continentnum== `thiscont', r
			predict `v'_fit`thiscont'
*			cap reg `v'`thiscont' lgdp lgdp2 if continentnum== `thiscont', r
*			predict `v'_fitsquare`thiscont'
			lowess `v'`thiscont' lgdp if continentnum == `thiscont', nograph generate(`v'_fitsquare`thiscont')
		}
	}
	
	qui sum lgdp if `v'~=.
	local xmin = (floor(`r(min)'/1000)-2)*1000
	local xmax = (ceil(`r(max)'/1000)+2)*1000

	qui sum `v' if `v'~=.
	local ymin = `r(min)' -(`r(max)'-`r(min)')*.1
	local ymax = `r(max)' +(`r(max)'-`r(min)')*.1
	
		#delimit ;
		twoway
		(scatter `v'? gdp, mcolor(black yellow blue red green cranberry) mlcolor(black ..) msize(2 ..) msymbol(o ..) legend(on) )
		(line `v'_fit gdp, sort lpattern(solid) lcolor(gray)  lwidth(*2))
		(line `v'_fitsquare gdp, sort lpattern(dash) lcolor(gray)  lwidth(*2))

		if `v' ~= .
		,
		xscale(log)
		yscale(range(`ymin' `ymax'))
		xlabel( 500 1000 2000 4000 8000 16000 32000 64000, valuelabel) 
		xtitle("Country log GDP (PPP)")
		//title("`varlabel'", ring(1) span color(black) size(*.8))
		legend(position(6) ring(1) size(*0.8) rows(1) cols(6) order(1 2 3 4 6 5 ) symxsize(*2) symysize(*2) region(lwidth(none)))
		//legend(off)
		note("N = `n'" "r = `rho', p = `p'" , ring(0) pos(7))
		xsize(2.5) ysize(2.5)
		graphregion(color(white))
		name(`v', replace)
					note(B, ring(1) pos(10) size(*2))

	;
	#delimit cr		
	graph dir
	drop `v'_fit* 
	graph export "figs/macro1_2013_`v'_Science_Revision1B.eps", replace
	graph save "figs/macro1_`v'_Science_Revision1B", replace 

	restore
}
*(line `v'_fit5 gdp if `v'_fit5 > `ymin' & `v'_fit5 < `ymax', sort lpattern(dot ..) lcolor(green))
*		(line `v'_fit1 gdp if `v'_fit1 > `ymin' & `v'_fit1 < `ymax', sort lpattern(dot ..) lcolor(black))
*		(line `v'_fit2 gdp if `v'_fit2 > `ymin' & `v'_fit2 < `ymax', sort lpattern(dot ..) lcolor(yellow))
*		(line `v'_fit3 gdp if `v'_fit3 > `ymin' & `v'_fit3 < `ymax', sort lpattern(dot ..) lcolor(blue))
*		(line `v'_fit4 gdp if `v'_fit4 > `ymin' & `v'_fit4 < `ymax', sort lpattern(dot ..) lcolor(red))
*		(line `v'_fit6 gdp if `v'_fit6 > `ymin' & `v'_fit6 < `ymax', sort lpattern(dot ..) lcolor(cranberry))
		
* SAVE FOR SCIENCE: 
	levelsof cty, local(cty) 
	foreach thiscty of local cty {
		qui sum wave if cty == "`thiscty'" & hap_hat~=.
		dis "Country `thiscty' max wave `r(max)'"
		drop if r(max) ~= . & wave < r(max) & cty == "`thiscty'"
	}
keep cty year lgdp shapefateyrself_hat hap_hat
rename cty country
rename hap_hat happiness
rename shapefateyrself_hat locusofcontrol
label var country "Country"
label var lgdp "Log GDP"
label var year "Year"
sort country year
save HaushoferFehr_WVSMacroData_Science.dta, replace
outsheet using HaushoferFehr_WVSMacroData_Science.csv, replace comma
