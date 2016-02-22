use xwvsevs_1981_2000_v20060423.dta, clear

* Filter for EVS, excluding Sweden 1999 which is already in the WVS 5-wave aggregate.
keep if s001==1 & s021 != 75204111999

* Adapt S009 format to 3 characters instead of 2. SKIP THIS, DO LATER
* alter type s009 (A3).

* Correct a few recoding mistakes in the official version.
* recode a010 to a019,C059,D020A (2=0).
for X in var a010-a019 c059 d020a: replace X=0 if X==2

* Also, a number of variables were renamed. The battery of variables about neighbours, confidence in
* organizations and trust were renamed to a common variable name, followed by a number for each
* of the groups mentioned.
* The following table summarizes the changes:
* How Johannes made these changes: copy the table into excel. Use Text-to-Columns to separate the two columns with the old and new names. Then copy into do-file editor; it ends up here with Tabs. THen copy to Word: replace ^t with [space]. Now copy back to do-file editor. Done. 

rename a124 a124_01
rename a125 a124_02
rename a126 a124_03
rename a127 a124_04
rename a128 a124_05
rename a129 a124_06
rename a130 a124_07
rename a131 a124_08
rename a132 a124_09
rename a133 a124_10
rename a134 a124_11
rename a135 a124_12
rename a136 a124_13
rename a137 a124_14
rename a138 a124_15
rename a139 a124_16
rename a140 a124_17
rename a141 a124_18
rename a142 a124_19
rename a143 a124_20
rename a144 a124_21
rename a145 a124_22
rename a146 a124_23
rename a147 a124_24
rename a148 a124_25
rename a149 a124_26
rename a150 a124_27
rename a151 a124_28
rename a152 a124_29
rename a153 a124_30
rename a154 a124_31
rename a155 a124_32
rename a156 a124_33
rename a157 a124_34
rename a158 a124_35
rename a159 a124_36
rename a160 a124_37
rename a161 a124_38
rename a162 a124_39
rename a163 a124_40
rename a164 a124_41
rename a177 a124_44
rename a178 a124_45
rename a180 a124_46
rename a182 a124_47
rename a183 a124_48
rename a184 a124_49
rename a185 a124_50
rename a186 a124_51
rename a187 a124_52
rename a188 a124_53
rename c042 c042b1
rename c043 c042b2
rename c044 c042b3
rename c045 c042b4
rename c046 c042b5
rename c047 c042b6
rename c048 c042b7
rename e069 e069_01
rename e070 e069_02
rename e071 e069_03
rename e072 e069_04
rename e073 e069_05
rename e074 e069_06
rename e075 e069_07
rename e076 e069_08
rename e077 e069_09
rename e078 e069_10
rename e079 e069_11
rename e080 e069_12
rename e081 e069_13
rename e082 e069_14
rename e083 e069_15
rename e084 e069_16
rename e085 e069_17
rename e086 e069_18
rename e087 e069_19
rename e088 e069_20
rename e089 e069_21
rename e090 e069_22
rename e091 e069_23
rename e092 e069_24
rename e093 e069_25
rename e094 e069_26
rename e095 e069_27
rename e096 e069_28
rename e097 e069_29
rename e098 e069_30
rename e099 e069_31
rename e100 e069_32
rename e101 e069_33
rename e102 e069_34
rename e103 e069_35
rename e199 e069_36
rename e200 e069_37
rename e201 e069_38
rename e202 e069_39
rename g007 g007_01
rename g008a g007_02
rename g008aa g007_03
rename g008ab g007_04
rename g008ac g007_05
rename g008ad g007_06
rename g008ae g007_07
rename g008af g007_08
rename g008ag g007_09
rename g008ah g007_10
rename g008ai g007_11
rename g008aj g007_12
rename g008ak g007_13
rename g008al g007_14
rename g008am g007_15
rename g008an g007_16
rename g008ao g007_17
rename g008ap g007_18
rename g008aq g007_19
rename g008ar g007_20
rename g008as g007_21
rename g008at g007_22
rename g008au g007_23
rename g008av g007_24
rename g008aw g007_25
rename g008ax g007_26
rename g008ay g007_27
rename g008az g007_28
rename g008b g007_29
rename g008ba g007_30
rename g008bb g007_31
rename g008bc g007_32
rename g008c g007_37
rename g008d g007_38
rename g008e g007_39
rename g008f g007_40
rename g008g g007_41
rename g008h g007_42
rename g008i g007_43
rename g008j g007_44
rename g008k g007_45
rename g008l g007_46
rename g008m g007_47
rename g008n g007_48
rename g008o g007_49
rename g008p g007_50
rename g008q g007_51
rename g008r g007_52
rename g008s g007_53
rename g008t g007_54
rename g008u g007_55
rename g008v g007_56
rename g008w g007_57
rename g008x g007_58
rename g008y g007_59
rename g008z g007_60

* take care of weird Sweden responses to question c043/c042b2: "I do the best I can regardless of pay (mentioned/not mentioned)" 
* all 1049 Swedes said that this was true for them; let's not believe that. The mean is 0.37, and for Norwegians and Fins it's 
* somewhere between 0.5 and 0.6. 
replace c042b2 = . if s003==752

* The file is ready to be merged. Save the EVS 4-wave under evs_1981_1999.sav name excluding some variables that
* will not be included in the aggregate.
* SAVE OUTFILE='c:\your_data_folder\evs_1981_1999.sav' /DROP
* a008a,a059a,a060a,a061a,c036a,c037a,c038a,c039a,c040a,c041a,c042a,c060a,d020a,
* d044a,d056a,d057a,d058a,d061a,d062a,d063a,d064a,d065a,e003a,e004a,e146a,e147a,e148a,e149a,e168a,e169a,e17
* 0a,e171a,e172a,e173a,e174a,e175a,e176a,e177a,f145a,f146a,f147a,f148a,f149a,f150a,f151a,
* f152a,f153a,f154a,f155a,f160a,f161a,f163a
* SKIP THIS - i don't see those vars in the dataset. 

save evs_1981_1999.dta, replace

use wvs1981_2008_v20090914.dta, clear
append using evs_1981_1999.dta, gen(study)

save ../out/wvsevs.dta, replace
