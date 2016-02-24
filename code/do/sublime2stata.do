import delim "$data_dir/Texas/inequality_AVE.csv", varnames(1) clear

* drop country
ren code countrycode
ren avg9099 inequality
la var inequality "avg9099"

sort countrycode

tempfile inequality
save `inequality', replace
