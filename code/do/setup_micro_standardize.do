* Setup micro standardize. This is ONLY needed for the micro analysis; not relevant for macro since that setup script does its own standardization! 
* JH Jan 2013

clear

use "micro.dta" if nonrepresentative==0, clear

drop s001 - f163a
drop trustfriends trustrelatives
xi i.cty, prefix(c_) 
xi i.year, prefix(y_) 
xi i.wave, prefix(w_)
egen ctywave = group(cty wave)
xi i.ctywave, prefix(cw_)
global controls "sex educ married kids age1 age2 age3 age4 fage1 fage2 fage3 fage4 "

keep $controls cty ctywave cw_* c_* y_* w_* wave year wt1000 hap sat inc lninc brightfuture risktaking sciencetoofast sciencehealth shapefateyrself financesat scienceopportunity candonothinglaw godmeaningful helpneighborhood believedevil escapepoverty aidtoomuch concernfamily believeresurrection wouldntwork concernhumankind intrinsic helpfamily trustmeetfirsttime sciencebetteroff lifemeaningless expectwar aidtaxwtp lonely livedaytoday godimportant

/*
foreach x of varlist shapefateyrself wouldntwork intrinsic trustmeetfirsttime helpfamily lonely lifemeaningless livedaytoday risktaking  {
	qui reg `x' inc c_* w_*  [pw=wt1000], r cluster(ctywave)
	qui local n1 = `e(N)'
	qui sum `x' if inc~= . & wt1000 ~=. & ctywave~=.
	qui local n2 = `r(N)'
	dis "`x': `n1' = `n2'"
}
shapefateyrself: 59003 = 59003
wouldntwork: 35096 = 35096
intrinsic: 35096 = 35096
trustmeetfirsttime: 61882 = 61882
helpfamily: 31443 = 31443
lonely: 15823 = 15823
lifemeaningless: 15703 = 15703
livedaytoday: 24009 = 24009
risktaking: 62025 = 62025
*/
* godimportant brightfuture livedaytoday risktaking sciencetoofast  sciencehealth  shapefateyrself  financesat scienceopportunity candonothinglaw  godmeaningful helpneighborhood believedevil  escapepoverty  aidtoomuch  concernfamily  believeresurrection  wouldntwork  concernhumankind  intrinsic  helpfamily  trustmeetfirsttime  sciencebetteroff  lifemeaningless  expectwar aidtaxwtp lonely 

foreach X of varlist shapefateyrself wouldntwork intrinsic trustmeetfirsttime helpfamily lonely lifemeaningless livedaytoday risktaking hap sat {
	xi: reg `X' cw_* [pw=wt] 
	predict `X'_res if `X'~=., res
	gen `X'_std = .
	dis "`X'"
	qui summ ctywave
	qui local thismax = `r(max)'
	forvalues cw = 1/`thismax' {
		qui summ `X'_res if ctywave == `cw'
		qui replace `X'_std = `X'_res/r(sd) if ctywave == `cw'
		}
	}
		
save micro_standardized.dta, replace 
