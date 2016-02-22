** Title: wvs_master.do
** Author: Justin Abraham
** Desc: Master .do file for re-creating dataset and running analysis for WVS and income project.
** Note: The public repo does not include data. Need a soluation to place the data into proper hierarchy within the repo.

clear all
set maxvar 10000
set matsize 10000
set more off

timer clear
timer on 1

cd "../../"

***********
** Setup **
***********

glo project_dir "`c(pwd)'" 
glo ado_dir "$project_dir/code/ado"
glo data_dir "/Users/Justin/Box Sync/_Behavior and Policy Lab/WVS and Income/data"
glo do_dir "$project_dir/code/do"
glo fig_dir "$project_dir/figures"
glo tab_dir "$project_dir/tables"

sysdir set PERSONAL "$ado_dir"
cap cd "$project_dir"

/* Customize program */

glo builddataflag = 0		 // Build combined dataset from raw
glo cleandataflag = 0		 // Clean combined dataset
glo summaryflag = 0	 		 // Output summary stats
glo estimateflag = 0         // Output regression tables
glo figuresflag = 0 		 // Output graphs and figures

/* Analysis options */

glo USDconvertflag = 1 		 // Runs analysis in USD-PPP
glo ppprate = (1/38.84) 	 // PPP exchange rate from KSH (2009-2013)
glo iterations = 10000		 // Number of iterations for calculating FWER adjusted p-values

*************
** Program **
*************

/* Stop! Can't touch this */

glo currentdate = date("$S_DATE", "DMY")
glo date : di %td_CY.N.D date("$S_DATE", "DMY")
glo stamp = trim("$date")

if $builddataflag do "$do_dir/wvs_build.do"
if $cleandataflag do "$do_dir/wvs_clean.do"
if $summaryflag do "$do_dir/wvs_summary.do"
if $figuresflag do "$do_dir/wvs_figures.do"
if $estimateflag do "$do_dir/wvs_estimate.do"

/* Old scripts */

do "$do_dir/old/gdp.do" 					// And another do file from the geo folder
do "$do_dir/old/merge_evs.do"  			    // Input: xwvsevs_1981_2000_v20060423.dta, Output: wvsevs.dta
do "$do_dir/old/setup_micro.do" 		    // Input: wvsevs.dta, Output: micro.dta
do "$do_dir/old/setup_micro_standardize.do" // Input: micro.dta, Output: micro_standardized.dta
do "$do_dir/old/setup_micro_merge_geo.do"   // Input: micro_standardized.dta, Output: micro_standardized_geo.dta
do "$do_dir/old/setup_macro.do" 			// Input: micro.dta, Output: macro_reg_3.dta
do "$do_dir/old/setup_macro_reg_splice.do"  // Input: macro_reg_`i'.dta, Output: macro_reg.dta
do "$do_dir/old/setup_macro_merge_geo.do"   // Input: macro_reg.dta, Output: macro_reg_geo.dta

timer off 1
qui timer list 1
di "Finished in `r(t1)' seconds."

/**********
** Notes **
***********
