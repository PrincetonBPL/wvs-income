use micro_standardized.dta, clear

foreach X in shapefateyrself wouldntwork intrinsic trustmeetfirsttime helpfamily lonely lifemeaningless livedaytoday risktaking hap sat {
	drop `X'
	rename `X'_std `X'
	}

#delimit ;
		
collapse (mean) 
hap_mean = hap 
sat_mean = sat
godimportant_mean = godimportant 
brightfuture_mean=brightfuture 
livedaytoday_mean=livedaytoday 
risktaking_mean=risktaking 
sciencetoofast_mean=sciencetoofast 
sciencehealth_mean= sciencehealth 
shapefateyrself_mean= shapefateyrself 
financesat_mean= financesat 
scienceopportunity_mean= scienceopportunity 
candonothinglaw_mean= candonothinglaw 
godmeaningful_mean= godmeaningful 
helpneighborhood_mean= helpneighborhood 
believedevil_mean= believedevil 
escapepoverty_mean= escapepoverty 
aidtoomuch_mean= aidtoomuch 
concernfamily_mean= concernfamily 
believeresurrection_mean= believeresurrection 
wouldntwork_mean= wouldntwork 
concernhumankind_mean= concernhumankind 
intrinsic_mean= intrinsic 
helpfamily_mean= helpfamily 
trustmeetfirsttime_mean= trustmeetfirsttime 
sciencebetteroff_mean= sciencebetteroff 
lifemeaningless_mean= lifemeaningless 
expectwar_mean= expectwar 
aidtaxwtp_mean=aidtaxwtp 
lonely_mean=lonely 

(sd) godimportant_sd = godimportant 
brightfuture_sd=brightfuture 
livedaytoday_sd = livedaytoday 
risktaking_sd=risktaking 
sciencetoofast_sd=sciencetoofast 
sciencehealth_sd= sciencehealth 
shapefateyrself_sd= shapefateyrself 
financesat_sd= financesat 
scienceopportunity_sd= scienceopportunity 
candonothinglaw_sd= candonothinglaw 
godmeaningful_sd= godmeaningful 
helpneighborhood_sd= helpneighborhood 
believedevil_sd= believedevil 
escapepoverty_sd= escapepoverty 
aidtoomuch_sd= aidtoomuch 
concernfamily_sd= concernfamily 
believeresurrection_sd= believeresurrection 
wouldntwork_sd= wouldntwork 
concernhumankind_sd= concernhumankind 
intrinsic_sd= intrinsic 
helpfamily_sd= helpfamily 
trustmeetfirsttime_sd= trustmeetfirsttime 
hap_sd = hap 
sat_sd = sat
sciencebetteroff_sd= sciencebetteroff 
lifemeaningless_sd= lifemeaningless 
expectwar_sd= expectwar 
aidtaxwtp_sd=aidtaxwtp 
lonely_sd=lonely 

(count) godimportant_n = godimportant 
brightfuture_n=brightfuture 
risktaking_n=risktaking 
sciencetoofast_n=sciencetoofast 
sciencehealth_n= sciencehealth 
shapefateyrself_n= shapefateyrself 
financesat_n= financesat 
scienceopportunity_n= scienceopportunity 
candonothinglaw_n= candonothinglaw 
godmeaningful_n= godmeaningful 
helpneighborhood_n= helpneighborhood 
believedevil_n= believedevil 
escapepoverty_n= escapepoverty 
aidtoomuch_n= aidtoomuch 
concernfamily_n= concernfamily 
believeresurrection_n= believeresurrection 
wouldntwork_n= wouldntwork 
concernhumankind_n= concernhumankind 
intrinsic_n= intrinsic 
helpfamily_n= helpfamily 
trustmeetfirsttime_n= trustmeetfirsttime 
sciencebetteroff_n= sciencebetteroff 
lifemeaningless_n= lifemeaningless 
expectwar_n= expectwar 
hap_n = hap 
sat_n = sat
aidtaxwtp_n=aidtaxwtp 
lonely_n=lonely 
livedaytoday_n=livedaytoday 

if inc~= . & wt1000 ~=. & ctywave~=., by(inc);

#delimit cr		
	
*collapse (mean) shapefateyrself wouldntwork intrinsic trustmeetfirsttime helpfamily lonely lifemeaningless livedaytoday risktaking

drop if inc ==.
save micro_forFigs.dta, replace
