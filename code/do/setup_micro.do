clear
use "merge_evs/wvsevs.dta", clear

* Using s003a as the country variable: Today's countries, followed back through history.
gen str3 cty=""
replace cty="ALB" if s003a==8
replace cty="DZA" if s003a==12
replace cty="AZE" if s003a==31
replace cty="ARG" if s003a==32
replace cty="AUS" if s003a==36
replace cty="AUT" if s003a==40
replace cty="BGD" if s003a==50
replace cty="ARM" if s003a==51
replace cty="BEL" if s003a==56

replace cty="BRA" if s003a==76
replace cty="BGR" if s003a==100
replace cty="BLR" if s003a==112
replace cty="CAN" if s003a==124
replace cty="CHL" if s003a==152
replace cty="CHN" if s003a==156
replace cty="TWN" if s003a==158
replace cty="COL" if s003a==170
replace cty="HRV" if s003a==191
replace cty="CZE" if s003a==203
replace cty="DNK" if s003a==208
replace cty="DOM" if s003a==214
replace cty="SLV" if s003a==222
replace cty="EST" if s003a==233
replace cty="FIN" if s003a==246
replace cty="FRA" if s003a==250
replace cty="GEO" if s003a==268

replace cty="GRC" if s003a==300
replace cty="HUN" if s003a==348
replace cty="ISL" if s003a==352
replace cty="IND" if s003a==356
replace cty="IDN" if s003a==360
replace cty="IRN" if s003a==364
replace cty="IRQ" if s003a==368
replace cty="IRL" if s003a==372
replace cty="ISR" if s003a==376
replace cty="ITA" if s003a==380
replace cty="JPN" if s003a==392
replace cty="JOR" if s003a==400
replace cty="KOR" if s003a==410
replace cty="KGZ" if s003a==417
replace cty="LVA" if s003a==428
replace cty="LTU" if s003a==440
replace cty="LUX" if s003a==442
replace cty="MLT" if s003a==470
replace cty="MEX" if s003a==484
replace cty="MDA" if s003a==498
replace cty="MAR" if s003a==504
replace cty="NLD" if s003a==528
replace cty="NZL" if s003a==554
replace cty="NGA" if s003a==566
replace cty="NOR" if s003a==578
replace cty="PAK" if s003a==586
replace cty="PER" if s003a==604
replace cty="PHL" if s003a==608
replace cty="POL" if s003a==616
replace cty="PRT" if s003a==620
replace cty="PRI" if s003a==630
replace cty="ROU" if s003a==642  
*Is it ROM or ROU?*/ johannes: it's rou (romania), as per some UN website. 
replace cty="RUS" if s003a==643
replace cty="SAU" if s003a==682
replace cty="SGP" if s003a==702
replace cty="SVK" if s003a==703
replace cty="VNM" if s003a==704
replace cty="SVN" if s003a==705
replace cty="ZAF" if s003a==710
replace cty="ZWE" if s003a==716
replace cty="ESP" if s003a==724
replace cty="SWE" if s003a==752
replace cty="CHE" if s003a==756
replace cty="TUR" if s003a==792
replace cty="UGA" if s003a==800
replace cty="UKR" if s003a==804
replace cty="MKD" if s003a==807
replace cty="EGY" if s003a==818
replace cty="GBR" if s003a==826
replace cty="TZA" if s003a==834
replace cty="USA" if s003a==840
replace cty="URY" if s003a==858
replace cty="VEN" if s003a==862
replace cty="DEU" if s003a==900 
* This is the code I use for West Germany (should be DEU) */
replace cty="DDR" if s003a==901 
* Actual code should be DDR */
replace cty="NIR" if s003a==909 
* There is no official code for Northern Ireland*/
replace cty="SRB" if s003a==911
replace cty="MNE" if s003a==912
replace cty="SRP" if s003a==913 
* Srpska is officially part of BIH - Bosnia and Herzogovnia */
replace cty="BSF" if s003a==914 
* Bosnian Federation is officially part of BIH - Bosnia and Herzogovnia */

* new countries in 2005 wave JH: 
replace cty="AND" if s003a==20
replace cty="CYP" if s003a==196
replace cty="ETH" if s003a==231
replace cty="GHA" if s003a==288
replace cty="HKG" if s003a==344
replace cty="MYS" if s003a==458
replace cty="MLI" if s003a==466
replace cty="RWA" if s003a==646
replace cty="THA" if s003a==764
replace cty="TTO" if s003a==780
replace cty="BFA" if s003a==854
replace cty="ZMB" if s003a==894
replace cty="GTM" if s003a==320

replace cty="BIH" if cty=="SRP" | cty=="BSF" /* Combine them into Bosnia and Herzogovnia*/
replace cty="SCG" if cty=="SRB" | cty=="MNE" /* Combine Serbia and Montenegro */
replace cty="DEU" if cty=="DEU" | cty=="DDR" /* Combine East and West Germany into one country */
gen oecd=.
for X in any AUT BEL CAN DNK FRA DEU GRC ISL IRL ITA LUX NLD NOR PRT ESP SWE CHE TUR GBR USA JPN FIN AUS NZL MEX CZE KOR HUN POL SVK: replace oecd=1 if cty=="X"


gen str30 country=""
replace country="Albania" if s003a==8
replace country="Algeria" if s003a==12
replace country="Azerbaijan" if s003a==31
replace country="Argentina" if s003a==32
replace country="Australia" if s003a==36
replace country="Austria" if s003a==40
replace country="Bangladesh" if s003a==50
replace country="Armenia" if s003a==51
replace country="Belgium" if s003a==56
replace country="Brazil" if s003a==76
replace country="Bulgaria" if s003a==100
replace country="Belarus" if s003a==112
replace country="Canada" if s003a==124
replace country="Chile" if s003a==152
replace country="China" if s003a==156
replace country="Taiwan" if s003a==158
replace country="Colombia" if s003a==170
replace country="Croatia" if s003a==191
replace country="Czech Republic" if s003a==203
replace country="Denmark" if s003a==208
replace country="Dominican Republic" if s003a==214
replace country="El Salvador" if s003a==222
replace country="Estonia" if s003a==233
replace country="Finland" if s003a==246
replace country="France" if s003a==250
replace country="Georgia" if s003a==268
replace country="Greece" if s003a==300
replace country="Hungary" if s003a==348
replace country="Iceland" if s003a==352
replace country="India" if s003a==356
replace country="Indonesia" if s003a==360
replace country="Iran (Islamic Republic Of)" if s003a==364
replace country="Iraq" if s003a==368
replace country="Ireland" if s003a==372
replace country="Israel" if s003a==376
replace country="Italy" if s003a==380
replace country="Japan" if s003a==392
replace country="Jordan" if s003a==400
replace country="South Korea" if s003a==410
replace country="Kyrgyzstan" if s003a==417
replace country="Latvia" if s003a==428
replace country="Lithuania" if s003a==440
replace country="Luxembourg" if s003a==442
replace country="Malta" if s003a==470
replace country="Mexico" if s003a==484
replace country="Moldova" if s003a==498
replace country="Morocco" if s003a==504
replace country="Netherlands" if s003a==528
replace country="New Zealand" if s003a==554
replace country="Nigeria" if s003a==566
replace country="Norway" if s003a==578
replace country="Pakistan" if s003a==586
replace country="Peru" if s003a==604
replace country="Philippines" if s003a==608
replace country="Poland" if s003a==616
replace country="Portugal" if s003a==620
replace country="Puerto Rico" if s003a==630
replace country="Romania" if s003a==642
replace country="Russia" if s003a==643
replace country="Saudi Arabia" if s003a==682
replace country="Singapore" if s003a==702
replace country="Slovakia" if s003a==703
replace country="Viet Nam" if s003a==704
replace country="Slovenia" if s003a==705
replace country="South Africa" if s003a==710
replace country="Zimbabwe" if s003a==716
replace country="Spain" if s003a==724
replace country="Sweden" if s003a==752
replace country="Switzerland" if s003a==756
replace country="Turkey" if s003a==792
replace country="Uganda" if s003a==800
replace country="Ukraine" if s003a==804
replace country="Macedonia" if s003a==807
replace country="Egypt" if s003a==818
replace country="Great Britain" if s003a==826
replace country="Tanzania" if s003a==834
replace country="United States" if s003a==840
replace country="Uruguay" if s003a==858
replace country="Venezuela" if s003a==862
replace country="West Germany" if s003a==900
replace country="East Germany" if s003a==901
replace country="Northern Ireland" if s003a==909
replace country="Serbia" if s003a==911
replace country="Montenegro" if s003a==912
replace country="Srpska" if s003a==913
replace country="Bosnia Federation" if s003a==914

*new in 2005 wave:
replace country="Andorra" if s003a==20
replace country="Cyprus" if s003a==196
replace country="Ethiopia" if s003a==231
replace country="Ghana" if s003a==288
replace country="Hong Kong" if s003a==344
replace country="Malaysia" if s003a==458
replace country="Mali" if s003a==466
replace country="Rwanda" if s003a==646
replace country="Thailand" if s003a==764
replace country="Trinidad and Tobago" if s003a==780
replace country="Burkina Faso" if s003a==854
replace country="Zambia" if s003a==894
replace country="Guatemala" if s003a==320

replace country="Bosnia & Herzegovina" if cty=="BIH"
replace country="Germany" if cty=="DEU"
replace country="Serbia & Montenegro" if cty=="SCG"

gen wave=.
label define waves 1982 "1981-84 wave" 1990 "1989-93 wave" 1996 "1994-99 wave" 2000 "1999-2004 wave" 2005 "2005-2008 wave"
label values wave waves
for X in num 1/5 \ Y in num 1982 1990 1996 2000 2005: replace wave=Y if s002==X

* Add a marker for non-representative national samples (where there are no weights to correct this).
gen nonrepresentative=0
replace nonrepresentative=1 if cty=="ARG" & (wave==1982 | wave==1990 | wave==1996)
replace nonrepresentative=1 if cty=="BGD" & (wave==1996)
replace nonrepresentative=1 if cty=="CHL" & (wave==1990 | wave==1996 | wave==2005)
replace nonrepresentative=2 if cty=="CHL" & (wave==2000)
replace nonrepresentative=1 if cty=="CHN" & (wave==1990)
replace nonrepresentative=2 if cty=="CHN" & (wave==1996)
replace nonrepresentative=1 if cty=="DOM" & (wave==1996)
replace nonrepresentative=1 if cty=="EGY" & (wave==2000)
replace nonrepresentative=1 if cty=="IND" & (wave==1990)
replace nonrepresentative=2 if cty=="IND" & (wave==1996)
replace nonrepresentative=1 if cty=="MEX" & (wave==1990)
replace nonrepresentative=1 if cty=="NGA" & (wave==1990)
replace nonrepresentative=2 if cty=="NGA" & (wave==1996)
replace nonrepresentative=1 if cty=="PAK" & (wave==1996)
replace nonrepresentative=1 if cty=="ZAF" & (wave==1990)

******** GENERATE VARIABLES OF INTEREST ****************
* survey properties
gen year=s020
gen wt=s017a
gen wt1000=s018a

* Sociodemographics
gen sex=x001 // 1=male, 2=female
gen age=x003
gen marital=x007 
gen married = x007==1 | x007==2 | x007==8
gen kids=x011
replace kids =8 if kids > 8
gen educ = x025
* number of ppl in household
gen pplhhd = x013
drop if age < 18 | age ==. | sex==.
for X in num 1/4: gen ageX=age^X \ gen fageX=ageX*(sex==2)
* replace age=-1 if age==.
* gen age_missing=age==-1
* Restrict sample to adults; no age codes for HUN, KOR*/
* replace sex=-1 if sex==.
* gen sex_missing=(sex==-1)

gen save = 5-x044 // more savings, higher value
* subjective socioeconomic class:
* x045b has 6 categories; x045 has 5. 
*           1 upper class
 *          2 upper middle class
  *         3 middle middle class
   *        4 lower middle class
    *       5 working class
     *      6 lower class
gen class = x045b
replace class = 6 if x045==5 
replace class = 5 if x045==4 
replace class = 4 if x045==3 
replace class = 2 if x045==2
replace class = 1 if x045==1
replace class = 7-class // higher values, higher class
* skip x046 - also about class, but categories don't match up. 77k observations.

gen financesgetbetter = 7-c007
gen humilnotwork = 6-c037
gen hap = 5-a008
gen feeldepressed = a009
gen panasexcited = a010

*PANAS (Bradburn 1969)
gen panasrestless = a011
gen panasproud = a012
gen panaslonely = a013
gen panaspleased = a014
gen panasbored =a015
gen panastopoftheworld = a016
gen panasdepressed = a017
gen panasgoingmyway =a018
gen panasupset=a019

gen lonely = 5-a122

gen sat = a170
gen sat5ago = a171
gen satin5 = a172

gen lifemeaningless = 5-f002
gen thinkdeath = 5-f003
gen lifenomeaning = .
replace lifenomeaning = 1 if f002==2
replace lifenomeaning = 2 if f002==3
replace lifenomeaning = 3 if f002==1 //higher values, less meaning

gen financesat = c006
gen homelifesat = d002

gen trust = 3-a165 // can't be too careful - most can be trusted
gen youngtrustold = a166 //10 steps
gen oldtrustyoung = a167
gen othersfair = a168 // most people will take advantage - try to be fair
replace othersfair = 1 if a168a <=5
replace othersfair = 2 if a168a >=6 //add other var that has a scale from 1-10

gen trustfamily = 6-d001
gen trustpeopleincountry = 6-g007_01
gen trustfriends = 6-g007_17
gen trustneighborhood = 6-g007_18
gen trustpeopleknow = 6-g007_33
gen trustmeetfirsttime = 6-g007_34

replace trust = 1 if g007_64 >3
replace trust = 2 if g007_64 <3 // g007_64: how much do you trust people in general? 5pt scale, but 3 not used by respondents. Only 485 obs. 

gen trustrelatives = 6-g007_65

replace a169 = . if a169>2
gen othersprefsimportant = 3-a169 // has more categories, but only the "other" cat has a small no of obs, so get rid

gen freedomchoicecontrol = a173
gen decideowngoals = 5-d080
gen bemyself = 5-d079
gen hardworksuccess = 11-e040
gen candonothinglaw = 6-e060
gen shapefateyrself = f198
gen autonomy = y003 // this is an index, from -2/+2, more determination, perseverance/independence for +2

* shapefateyrself f198
*  intrinsic c042b2
* helpneighborhood 5-e164
* helpfamily 5-e163
*lonely 5-a122
* lifemeaningless 5-f002

gen risktaking = 7-a195
gen jobsecurity = c013 // important no/yes
gen expectwar = e013
gen livedaytoday = 3-e144

replace b017=. if b017>2
gen brightfuture = 3-b017 //bleak vs bright future

gen expectsuccess = e048

replace e132 =. if e132>2
gen escapepoverty = 3-e132
gen intrinsic = c042b2
* c042b2          byte   %8.0g       c042b2     why people work: i do the best i can regardless of pay NOT FOUND
gen wouldntwork = c042b3
* c042b3          byte   %8.0g       c042b3     why people work: i wouldn’t work if i didn’t have to

gen prisonaim = e011
*           the main aim of imprisonment |      Freq.     Percent        Cum.
*----------------------------------------+-----------------------------------
*        1     to re-educate the prisoner |      8,073       45.74       45.74
*2 to make those who have done wrong pay f |      4,755       26.94       72.68
*         3     to protect other citizens |      3,321       18.81       91.49
*      4  to act as a deterrent to others |      1,502        8.51      100.00

gen sciencehelps = .
replace sciencehelps = 1 if e022==2
replace sciencehelps = 2 if e022==3
replace sciencehelps = 3 if e022==1 //higher score, science does more good than harm

gen expertdecisions = e115 // good to have experts make decisions?
replace expertdecisions = 1 if e115_mx==1
replace expertdecisions = 2 if e115_mx==2
replace expertdecisions = 3 if e115_mx==3
replace expertdecisions = 4 if e115_mx==4
replace expertdecisions = 5-expertdecisions

gen sciencehealth = e217
gen scienceopportunity = e218
gen sciencetoofast = e219
gen sciencedependtoomuch = e220
gen sciencebetteroff = e234

gen competitiongood = 11-e039

gen aidtoomuch = e129a
gen aidhowmuchmore = e129b
gen aidtaxwtp = e129c

gen concernfamily = 6-e153
gen concernneighborhood = 6-e154
gen concernregion = 6-e155
gen concerncountry = 6-e156
gen concernhumankind = 6-e158

gen helpfamily = 6-e163
gen helpneighborhood = 6-e164

gen changesactboldly = e045
gen changeswelcome = e047

gen godmeaningful = .
replace godmeaningful = 1 if f004==2
replace godmeaningful = 2 if f004==3
replace godmeaningful = 3 if f004==1
gen godimportant = f063

gen believegod = f050 // n/y
gen believeafterlife = f051
gen believesoul = f052
gen believehell = f053
gen believeheaven = f054
gen believesin = f055
gen believetelepathy = f056
replace believetelepathy =. if believetelepathy ==2 // weird coding error?
gen believereincarnation = f057
replace believereincarnation =. if believereincarnation==2 // weird coding error?
gen believeangels = f058
replace believeangels =. if believeangels ==2 // weird coding error?
gen believedevil = f059
replace believedevil=. if believedevil==2 // weird coding error?
gen believeresurrection = f060


gen believesupernatural4 = 5-f097
gen believesupernatural2 = believesupernatural4 < 2 
replace believesupernatural2 = believesupernatural2 + 1


**************** INCOME DATA **************
* Household-specific income data
* egen ctywve=group(cty wave)
* do "income_coding_jh.do"
* this creates two new variables, inc and lninc, containing the midpoints of the country-specific income brackets.
* this is how wolfers does it, using x047cs, ie country-specific income data. Instead use the 10 steps provided by WVS:
replace x047 = 10 if x047==11 // some place has 11 income categories for some reason. 
gen inc = x047
gen lninc = ln(inc)

egen ctyyear = group(cty year)

compress
saveold "micro.dta", replace

* * now compute MLD - SKIP THIS
* * s024a is country-wave variable
* xi: reg inc i.s024a [pw=wt]
* * this should find the mean household income per country-wave combination
* predict inchat if inc~=.
* * tomode inchat, by(s024a) replace
* xi: reg lninc i.s024a [pw=wt]
* predict lninchat if lninc~=.
* * tomode lninchat, by(s024a) replace
* gen mld=ln(inchat)-lninchat
* xi: reg mld i.ctywve [pw=wt]
* predict mldav if mld~=.
* tomode mldav, by (ctywve) replace
* drop mld inchat lninchat
* rename mldav mld

* Skip this: this replaces the yearly GDP values with country/wave specific ones, ie each country has only one GDP value for each wave, even if the interviews for that country in that wave stretched over several years
* xi: reg gdp i.cty*i.wave [aw=wt1000]
* predict gdpav if gdp~=.
* drop gdp
* rename gdpav gdp
* la var gdp "GDP per capita at PPP"
* gen lgdp=ln(gdp)


