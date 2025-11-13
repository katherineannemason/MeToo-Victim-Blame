* Encoding: UTF-8.
* Victim Blame Study Data Preparation & Cleaning (S1-3).
* Syntax written by the first author.
* Last update: 10.01.2025
    

******************************************************************************************************************

*Import the data for studies 1-3.

GET DATA
  /TYPE=XLS
  /FILE='path/to/Victim_Blame_Data_S1-3.xls'
  /SHEET=name 'SA 3 and 12 new 1'
  /CELLRANGE=FULL
  /READNAMES=ON.
EXECUTE.


*Save as.
*Victim_Blame_Data_S1-3 Original (SPSS raw version).

*Save as again version for data preparation.
*Data Prep Victim_Blame_Data_S1-3 2024.03.30
    
****************************************************************Data Preparation****************************************************************

* Data preparation: Ensures that the data and variables collected for this study are in the correct format. 

*Make sure everyone consented. 

RENAME VARIABLES AgreementIhavereadtheproceduredescribedabove.Byclickin = consent.
VARIABLE LABELS consent 'I consent to take this survey'.

FREQUENCIES VARIABLES=consent
  /ORDER=ANALYSIS.
*All consented.

*******Rename variables *******

* Name character entries "OLD" and recode properly.

** Age **

*Label age and make numeric.
VARIABLE LABELS age 'Age'.
ALTER TYPE age (F2.0).
VARIABLE LEVEL age (SCALE).

** Language **

RENAME VARIABLES IsEnglishyournativelanguage = lang_OLD.

*Make the language variable nominal.
RECODE lang_OLD ('Yes' = 0) ('No'=1) (MISSING=SYSMIS) into lang.
MISSING VALUES lang(-9).
VARIABLE LEVEL lang (NOMINAL).
MISSING VALUES lang (-9). 
ALTER TYPE lang (F7.0).
FORMATS lang (F7.0). 
VARIABLE LABELS lang "Is English your native language?".
VALUE LABELS lang 0 'Yes' 1 'No'.

FREQUENCIES lang.

** Race **

RENAME VARIABLES Pleaseindicatehowyouidentifyyourself = race_OLD.

* Recode race to be numeric.
RECODE race_OLD ('White (including Middle Eastern)' = 0) ('Black or African American' = 1) ('Hispanic or Latino' = 2) 
    ('Asian' = 3) ('American Indian or Alaskan Native' = 4) ('Other (please specify)' = 5) (MISSING=SYSMIS) INTO race.
MISSING VALUES race (-9).
VARIABLE LEVEL race (NOMINAL).
ALTER TYPE race (F7.0).
FORMATS race (F7.0). 
VARIABLE LABELS race "Race".
VALUE LABELS Race 0 'White' 1 'Black/African American'  2 'Hispanic/Latino' 3 'Asian' 4 'American Indian or Alaskan Native' 5 'Other'.

FREQUENCIES race.
 
RENAME VARIABLES V11 = race_other.
VARIABLE LABELS race_other 'Race not listed'.

** Gender **

* Make sure female is first.
COMPUTE sex = -9.
IF (gender = 'Female') sex = 0.
IF (gender = 'Male') sex = 1.
IF (gender = 'Other') sex = 2.
VARIABLE LABELS sex 'Sex recoded into one numerical variable'.
VARIABLE LEVEL sex (NOMINAL).
VALUE LABELS sex 0 'Female' 1 'Male' 2 'Other'.
MISSING VALUES sex (-9). 
ALTER TYPE sex (F2.0).
EXECUTE.

FREQUENCIES sex.

** Sexual orientation **

RENAME VARIABLES Howdoyouidentifyintermsofsexualorientation = sexOrien_OLD.

RENAME VARIABLES V215 = sexOrien_Other.
VARIABLE LABELS sexOrien_Other 'Sexual orientation if selected "other".'.

*Make sexual orientation numeric.  
RECODE sexOrien_OLD ('Heterosexual' = 0) ('Homosexual/Lesbian' = 1) ('Bisexual' = 2) ('Asexual' = 3) ('Other (please specify)' = 4) (MISSING=SYSMIS) INTO sexOrien.
MISSING VALUES sexOrien (-9).
VARIABLE LEVEL sexOrien (NOMINAL).
ALTER TYPE sexOrien (F7.0).
FORMATS sexOrien (F7.0). 
VARIABLE LABELS sexOrien "Sexual orientation".
VALUE LABELS sexOrien 0 'Heterosexual' 1 'Homosexual/Lesbian'  2 'Bisexual' 3 'Asexual' 4 'Other'.

FREQUENCIES sexOrien.

** Religion **

RENAME VARIABLES Whatisyourreligion = religion.
RENAME VARIABLES Howstronglydoyouidentifywithandpracticeyourreligion = relPrac_OLD.

*Make religiosity numeric.   
RECODE relPrac_OLD ('0 - Not at all' = 0) ('1'=1) ('2'=2) ('3'=3) ('4 -Â Fully' = 4) (MISSING=SYSMIS) into relPrac.
MISSING VALUES relPrac (-9).
VARIABLE LEVEL relPrac (SCALE).
ALTER TYPE relPrac (F7.0).
FORMATS relPrac (F7.0). 
VARIABLE LABELS relPrac "How strongly do you identify with and practice your religion?".
VALUE LABELS relPrac 0 'Not at all' 1 '1' 2 '2' 3 '3' 4 'Fully'.

FREQUENCIES relPrac.


*** Social Ideology ***

RENAME VARIABLES Howwouldyourateyourviewsonsocialissues = polSoc_OLD.

RENAME VARIABLES V209 = polSoc_Other.
VARIABLE LABELS polSoc_Other 'Written social political orientation if selected "other".'.

*Make numeric. Code "other" as missing.
RECODE polSoc_OLD ('1 â€“ Strongly liberal' = 1) ('2' = 2) ('3' = 3) ('4 -Â moderate' = 4) ('5' = 5) ('6' = 6) ('7 - Strongly conservative' = 7) (MISSING=SYSMIS) into polSoc.
MISSING VALUES polSoc (-9).
VARIABLE LEVEL polSoc (SCALE).
ALTER TYPE polSoc (F7.0).
FORMATS polSoc (F7.0). 
VARIABLE LABELS polSoc "How would you rate your views on social issues?".
VALUE LABELS polSoc 1 'Strongly liberal' 4 'A moderate' 7 'Strongly conservative'.

FREQUENCIES polSoc.
* 7 missing.

*** Economic Ideology **

RENAME VARIABLES Howwouldyourateyourviewsoneconomicissues = polEco_OLD.

RENAME VARIABLES V211 = polEco_Other.
VARIABLE LABELS polEco_Other 'Written economic political orientation if selected "other".'.

*Make numeric. Code "other" as missing.
RECODE polEco_OLD ('1 â€“ Strongly liberal' = 1) ('2' = 2) ('3' = 3) ('4 - Moderate' = 4) ('5' = 5) ('6' = 6) ('7 - Strongly conservative' = 7) (MISSING=SYSMIS) into polEco.
MISSING VALUES polEco (-9).
VARIABLE LEVEL polEco (SCALE).
ALTER TYPE polEco (F7.0).
FORMATS polEco (F7.0). 
VARIABLE LABELS polEco "How would you rate your views on economic issues?".
VALUE LABELS polEco 1 'Strongly liberal' 4 'A moderate' 7 'Strongly conservative'.

FREQUENCIES polEco.
* 5 missing.

** General Ideology **

RENAME VARIABLES Wouldyoucategorizeyourselfasa = polGen_OLD.

RENAME VARIABLES V213 = polGen_Other.
VARIABLE LABELS polGen_Other 'Written political orientation if selected "other".'.

* Make nominal. Code "other" as missing. 
RECODE polGen_OLD ('Liberal' = 0) ('Moderate'=1) ('Conservative'=2) (MISSING=SYSMIS) into polGen.
MISSING VALUES polGen (-9).
VARIABLE LEVEL polGen (NOMINAL).
ALTER TYPE polGen (F7.0).
FORMATS polGen (F7.0). 
VARIABLE LABELS polGen "Would you categorize yourself as a liberal, moderate, conservative, or other (please specify)".
VALUE LABELS polGen 0 'Liberal' 1 'Moderate ' 2 'Conservative'.

FREQUENCIES polGen.
*41 missing.

*** Session/Wave **

RENAME VARIABLES LastName = session_OLD.
VARIABLE LABELS session_OLD 'Session in which survey was taken, old coding'.
VALUE LABELS session_OLD 1 'Before MeToo' 2 'After MeToo' 3 'After Kavanaugh hearings'.

*Recode session to be numeric and that session 1 is coded as 0.
RECODE session_OLD (1=0) (2=1) (3=2) (MISSING=SYSMIS) into session.
MISSING VALUES session (-9).
VARIABLE LEVEL session (NOMINAL).
FORMATS session (F8.0). 
VARIABLE LABELS session "Study session/wave, session 1 = 0".
VALUE LABELS session 0 'Session 1: Before MeToo' 1 'Session 2: After MeToo' 2 'Session 3: After Kavanaugh hearings'.

*** Fear **

* Whether Ps wrote 3 or 12 items.
RENAME VARIABLES fear = fearItems.
VARIABLE LABELS fearItems 'List 3 or 12 fear items'.

FREQUENCIES fearitems.

* Free response.
RENAME VARIABLES Pleaselist12instanceswhereyoufeltterrifiedandorseverel = fearList.

* How fearful they felt (0-100).
RENAME VARIABLES Howthreateneddoyoufeelrightnowona110scale = fearNow.

*Make fearNow numeric and scale.
ALTER TYPE fearNow (F7.0).
VARIABLE LEVEL fearNow (SCALE).

*Recode fearNow to be 1-10. It is 1-100 in SPSS but was presented to participants on a 1-10 scale.
COMPUTE fear =fearNow/10.
VARIABLE LABELS fear  'Reported threat and fear'.
MISSING VALUES fear (-9). 
EXECUTE.

*** State ***

RENAME VARIABLES Whatstatedoyoucurrentlylivein = state.


*****Rename the general agreement items for the self, the population, and whether the item is a fact or a belief. *****

*First statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement = genSelf_1_OLD.
VARIABLE LABELS genSelf_1_OLD 'How strongly do YOU agree: A hammer is used to pound nails'.

RENAME VARIABLES WhatpercentageoftheadultpopulationÂ wouldagreewiththis = genOther_1_OLD.
VARIABLE LABELS genOther_1_OLD 'What percentage of the adult population would agree: A hammer is used to pound nails'.

RENAME VARIABLES Isthisstatementafactorbelief= genFb_1_OLD.
VARIABLE LABELS genFb_1_OLD 'Is this statments fact or fiction: A hammer is used to pound nails'.

*Second statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_A = genSelf_2_OLD.
VARIABLE LABELS genSelf_2_OLD 'How strongly do YOU agree: Children are happy and carefree'.

RENAME VARIABLES WhatpercentageoftheÂ adultpopulationwouldagreewiththis = genOther_2_OLD.
VARIABLE LABELS genOther_2_OLD 'What percentage of the adult population would agree: Children are happy and carefree'.

RENAME VARIABLES Isthisstatementafactorbelief_A = genFb_2_OLD.
VARIABLE LABELS genFb_2_OLD 'Is this statments fact or fiction: Children are happy and carefree'.

*Third statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_B = genSelf_3_OLD.
VARIABLE LABELS genSelf_3_OLD 'How strongly do YOU agree: Dogs are animals'. 
VALUE LABELS genSelf_3_OLD 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst = genOther_3_OLD.
VARIABLE LABELS genOther_3_OLD 'What percentage of the adult population would agree: Dogs are animals'. 

RENAME VARIABLES Isthisstatementafactorbelief_B = genFb_3_OLD.
VARIABLE LABELS genFb_3_OLD 'Is this statments fact or fiction: Dogs are animals'.

*Fourth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_C = genSelf_4_OLD.
VARIABLE LABELS genSelf_4_OLD 'How strongly do YOU agree: A pen is for writing'.

RENAME VARIABLES WhatpercentageoftheadultpopulationÂ wouldagreewiththis_A= genOther_4_OLD.
VARIABLE LABELS genOther_4_OLD 'What percentage of the adult population would agree: A pen is for writing'.

RENAME VARIABLES Isthisstatementafactorbelief_C = genFb_4_OLD.
VARIABLE LABELS genFb_4_OLD  'Is this statments fact or fiction: A pen is for writing'.

*Fifth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_D = genSelf_5_OLD.
VARIABLE LABELS genSelf_5_OLD 'How strongly do YOU agree: The telephone is the greatest invention of all time.'.
VALUE LABELS genSelf_5_OLD 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_A = genOther_5_OLD.
VARIABLE LABELS genOther_5_OLD 'What percentage of the adult population would agree: The telephone is the greatest invention of all time.'.

RENAME VARIABLES Isthisstatementafactorbelief_D = genFb_5_OLD.
VARIABLE LABELS genFb_5_OLD  'Is this statments fact or fiction: The telephone is the greatest invention of all time.'.

*Sixth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_E = genSelf_6_OLD.
VARIABLE LABELS  genSelf_6_OLD 'How strongly do YOU agree: There are three colors in the American flag.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_B = genOther_6_OLD.
VARIABLE LABELS genOther_6_OLD  'What percentage of the adult population would agree:  There are three colors in the American flag.'.

RENAME VARIABLES Isthisstatementafactorbelief_E = genFb_6_OLD.
VARIABLE LABELS genFb_6_OLD  'Is this statments fact or fiction:  There are three colors in the American flag.'.

*Seventh statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_F = genSelf_7_OLD.
VARIABLE LABELS genSelf_7_OLD 'How strongly do YOU agree: There are seven days in a week.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_C = genOther_7_OLD.
VARIABLE LABELS genOther_7_OLD  'What percentage of the adult population would agree: There are seven days in a week.'.

RENAME VARIABLES Isthisstatementafactorbelief_F = genFb_7_OLD.
VARIABLE LABELS genFb_7_OLD 'Is this statments fact or fiction: There are seven days in a week.'.

*Eighth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_G = genSelf_8_OLD.
VARIABLE LABELS genSelf_8_OLD 'How strongly do YOU agree: Christmas is a holiday primarily for children.'.
VALUE LABELS genSelf_8_OLD 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_D = genOther_8_OLD.
VARIABLE LABELS genOther_8_OLD 'What percentage of the adult population would agree: Christmas is a holiday primarily for children.'.

RENAME VARIABLES Isthisstatementafactorbelief_G = genFb_8_OLD.
VARIABLE LABELS genFb_8_OLD 'Is this statments fact or fiction: Christmas is a holiday primarily for children.'.

*Ninth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_H = genSelf_9_OLD.
VARIABLE LABELS genSelf_9_OLD 'How strongly do YOU agree: Sleeping with the window open is good for you.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_E = genOther_9_OLD.
VARIABLE LABELS genOther_9_OLD 'What percentage of the adult population would agree: Sleeping with the window open is good for you.'.

RENAME VARIABLES Isthisstatementafactorbelief_H = genFb_9_OLD.
VARIABLE LABELS genFb_9_OLD 'Is this statments fact or fiction: Sleeping with the window open is good for you.'.

*Tenth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_I = genSelf_10_OLD.
VARIABLE LABELS genSelf_10_OLD 'How strongly do YOU agree: Thermometers are used to measure temperature.'.
VALUE LABELS genSelf_10_OLD 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RENAME VARIABLES WhatpercentageoftheÂ adultpopulationwouldagreewiththis_A = genOther_10_OLD.
VARIABLE LABELS genOther_10_OLD 'What percentage of the adult population would agree: Thermometers are used to measure temperature.'.

RENAME VARIABLES Isthisstatementafactorbelief_I = genFb_10_OLD.
VARIABLE LABELS genFb_10_OLD 'Is this statments fact or a belief: Thermometers are used to measure temperature.'.

*Eleventh statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_J = genSelf_11_OLD.
VARIABLE LABELS genSelf_11_OLD 'How strongly do YOU agree: A drivers license is required by law to drive a car.'.
VALUE LABELS genSelf_11_OLD 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_F = genOther_11_OLD.
VARIABLE LABELS genOther_11_OLD 'What percentage of the adult population would agree: A drivers license is required by law to drive a car.'.

RENAME VARIABLES Isthisstatementafactorbelief_J = genFb_11_OLD.
VARIABLE LABELS genFb_11_OLD 'What percentage of the adult population would agree: A drivers license is required by law to drive a car.'.

*Twelfth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_K = genSelf_12_OLD.
VARIABLE LABELS genSelf_12_OLD 'How strongly do YOU agree: Books may be borrowed from the library.'.
VALUE LABELS genSelf_12_OLD 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_G = genOther_12_OLD.
VARIABLE LABELS genOther_12_OLD 'What percentage of the adult population would agree: Books may be borrowed from the library.'.

RENAME VARIABLES Isthisstatementafactorbelief_K = genFb_12_OLD.
VARIABLE LABELS genFb_12_OLD 'What percentage of the adult population would agree: Books may be borrowed from the library.'.

*Thirteenth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_L = genSelf_13_OLD.
VARIABLE LABELS genSelf_13_OLD 'How strongly do YOU agree: Rich people are happy people.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_H = genOther_13_OLD.
VARIABLE LABELS genOther_13_OLD 'What percentage of the adult population would agree: Rich people are happy people.'.

RENAME VARIABLES Isthisstatementafactorbelief_L = genFb_13_OLD.
VARIABLE LABELS genFb_13_OLD 'What percentage of the adult population would agree: Rich people are happy people.'.

*Fourteenth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_M = genSelf_14_OLD.
VARIABLE LABELS genSelf_14_OLD 'How strongly do YOU agree: Cats are friendly animals.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_I = genOther_14_OLD.
VARIABLE LABELS genOther_14_OLD 'What percentage of the adult population would agree: Cats are friendly animals.'.

RENAME VARIABLES Isthisstatementafactorbelief_M = genFb_14_OLD.
VARIABLE LABELS genFb_14_OLD 'What percentage of the adult population would agree: Cats are friendly animals.'.

*Fifteenth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_N = genSelf_15_OLD.
VARIABLE LABELS genSelf_15_OLD 'How strongly do YOU agree: Rock music is a bad influence on young children.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_J = genOther_15_OLD.
VARIABLE LABELS genOther_15_OLD 'What percentage of the adult population would agree: Rock music is a bad influence on young children.'.

RENAME VARIABLES Isthisstatementafactorabelief = genFb_15_OLD.
VARIABLE LABELS genFb_15_OLD 'What percentage of the adult population would agree: Rock music is a bad influence on young children.'.

*Sixteenth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_O = genSelf_16_OLD.
VARIABLE LABELS genSelf_16_OLD 'How strongly do YOU agree: It is okay to lie.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_K = genOther_16_OLD.
VARIABLE LABELS genOther_16_OLD 'What percentage of the adult population would agree: It is okay to lie.'.

RENAME VARIABLES Isthisstatementafactorbelief_N = genFb_16_OLD.
VARIABLE LABELS genFb_16_OLD 'What percentage of the adult population would agree: It is okay to lie.'.

*Seventeenth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_P = genSelf_17_OLD.
VARIABLE LABELS genSelf_17_OLD 'How strongly do YOU agree: The longer you stay in school, the smarter you will be.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_L = genOther_17_OLD.
VARIABLE LABELS genOther_17_OLD 'What percentage of the adult population would agree: The longer you stay in school, the smarter you will be.'.

RENAME VARIABLES Isthisstatementafactorbelief_O = genFb_17_OLD.
VARIABLE LABELS genFb_17_OLD 'What percentage of the adult population would agree: The longer you stay in school, the smarter you will be.'.

*Eighteenth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_Q = genSelf_18_OLD.
VARIABLE LABELS genSelf_18_OLD 'How strongly do YOU agree: The earth revolves around the sun.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_M = genOther_18_OLD.
VARIABLE LABELS genOther_18_OLD 'What percentage of the adult population would agree: The earth revolves around the sun.'.

RENAME VARIABLES Isthisstatementafactorbelief_P = genFb_18_OLD.
VARIABLE LABELS genFb_18_OLD 'What percentage of the adult population would agree: The earth revolves around the sun.'.

*Nineteenth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_R = genSelf_19_OLD.
VARIABLE LABELS genSelf_19_OLD 'How strongly do YOU agree: Comic strips are funny.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_N = genOther_19_OLD.
VARIABLE LABELS genOther_19_OLD 'What percentage of the adult population would agree: Comic strips are funny.'.

RENAME VARIABLES Isthisstatementafactorbelief_Q = genFb_19_OLD.
VARIABLE LABELS genFb_19_OLD 'What percentage of the adult population would agree: Comic strips are funny.'.

*Twentieth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_S = genSelf_20_OLD.
VARIABLE LABELS genSelf_20_OLD 'How strongly do YOU agree: The shape of a ball is round.'.

RENAME VARIABLES WhatpercentageofÂ theadultpopulationwouldagreewiththis = genOther_20_OLD.
VARIABLE LABELS genOther_20_OLD 'What percentage of the adult population would agree: The shape of a ball is round.'.

RENAME VARIABLES Isthisstatementfactorbelief = genFb_20_OLD.
VARIABLE LABELS genFb_20_OLD 'What percentage of the adult population would agree: The shape of a ball is round.'.


*Rename the sexual assault items for the self, the population, and whether the item is a fact or a belief.

*First statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_T = SAself_1_OLD.
VARIABLE LABELS SAself_1_OLD 'How strongly do you agree with this statement: Even if a person didnt physically resist sex, it can still be sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_O = SAother_1_OLD.
VARIABLE LABELS SAother_1_OLD 'What percentage of the adult population would agree with this statement: Even if a person didnt physically resist sex, it can still be sexual assault.'.

RENAME VARIABLES Whatpercentageofthosewhoidentifyaswomenwouldagreewith = SAwomen_1_OLD.
VARIABLE LABELS SAwomen_1_OLD 'What percentage of women would agree with this statement: Even if a person didnt physically resist sex, it can still be sexual assault.'.

RENAME VARIABLES WhatpercentageofthosewhoidentifyasmenÂ wouldagreewith = SAmen_1_OLD.
VARIABLE LABELS SAmen_1_OLD 'What percentage of men would agree with this statement: Even if a person didnt physically resist sex, it can still be sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_R = SAFB_1_OLD.
VARIABLE LABELS SAFB_1_OLD 'Is this statement a fact or belief: Even if a person didnt physically resist sex, it can still be sexual assault.'.

*Second statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_U = SAself_2_OLD.
VARIABLE LABELS SAself_2_OLD 'How strongly do you agree with this statement: It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_P = SAother_2_OLD.
VARIABLE LABELS SAother_2_OLD 'What percentage of the adult population would agree with this statement: It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.'.

RENAME VARIABLES Whatpercentageofthosewhoidentifyaswomenwouldagreewith_A = SAwomen_2_OLD.
VARIABLE LABELS SAwomen_2_OLD 'What percentage of women would agree with this statement: It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.'.

RENAME VARIABLES Whatpercentageofthosewhoidentifyasmenwouldagreewithth = SAmen_2_OLD.
VARIABLE LABELS SAmen_2_OLD 'What percentage of men would agree with this statement: It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.'.

RENAME VARIABLES Isthisstatementafactorbelief_S = SAFB_2_OLD.
VARIABLE LABELS SAFB_2_OLD 'Is this statement a fact or belief:  It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.'.

*Third statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_V = SAself_3_OLD.
VARIABLE LABELS SAself_3_OLD 'How strongly do you agree with this statement: The perpetrator is still guilty of sexual assault even if the victim went home with them.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_Q = SAother_3_OLD.
VARIABLE LABELS SAother_3_OLD 'What percentage of the adult population would agree with this statement: The perpetrator is still guilty of sexual assault even if the victim went home with them.'.

RENAME VARIABLES WhatpercentageofthosewhoidentifyaswomenÂ wouldagreewi = SAwomen_3_OLD.
VARIABLE LABELS SAwomen_3_OLD 'What percentage of women would agree with this statement: The perpetrator is still guilty of sexual assault even if the victim went home with them.'.

RENAME VARIABLES WhatpercentageofthosewhoidentifyasmenÂ wouldagreewith_A = SAmen_3_OLD.
VARIABLE LABELS SAmen_3_OLD 'What percentage of men would agree with this statement: The perpetrator is still guilty of sexual assault even if the victim went home with them.'.

RENAME VARIABLES Isthisstatementafactorbelief_T = SAFB_3_OLD.
VARIABLE LABELS SAFB_3_OLD 'Is this statement a fact or belief: The perpetrator is still guilty of sexual assault even if the victim went home with them.'.

*Fourth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_W = SAself_4_OLD.
VARIABLE LABELS SAself_4_OLD 'How strongly do you agree with this statement: Promiscuous actions dont legitimize sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_R = SAother_4_OLD.
VARIABLE LABELS SAother_4_OLD 'What percentage of the adult population would agree with this statement: Promiscuous actions dont legitimize sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree = SAwomen_4_OLD.
VARIABLE LABELS SAwomen_4_OLD 'What percentage of women would agree with this statement: Promiscuous actions dont legitimize sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew = SAmen_4_OLD.
VARIABLE LABELS SAmen_4_OLD 'What percentage of men would agree with this statement: Promiscuous actions dont legitimize sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_U = SAFB_4_OLD.
VARIABLE LABELS SAFB_4_OLD 'Is this statement a fact or belief: Promiscuous actions dont legitimize sexual assault.'.

*Fifth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_X = SAself_5_OLD.
VARIABLE LABELS SAself_5_OLD 'How strongly do you agree with this statement: If someone initiates kissing or hooking up, they cant be surprised if someone assumes they want to have sex.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_S = SAother_5_OLD.
VARIABLE LABELS SAother_5_OLD 'What percentage of the adult population would agree with this statement: If someone initiates kissing or hooking up, they cant be surprised if someone assumes they want to have sex.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_A = SAwomen_5_OLD.
VARIABLE LABELS SAwomen_5_OLD 'What percentage of women would agree with this statement: If someone initiates kissing or hooking up, they cant be surprised if someone assumes they want to have sex.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_A = SAmen_5_OLD.
VARIABLE LABELS SAmen_5_OLD 'What percentage of men would agree with this statement: If someone initiates kissing or hooking up, they cant be surprised if someone assumes they want to have sex.'.

RENAME VARIABLES Isthisstatementafactorbelief_V = SAFB_5_OLD.
VARIABLE LABELS SAFB_5_OLD 'Is this statement a fact or belief: If someone initiates kissing or hooking up, they cant be surprised if someone assumes they want to have sex.'.

*Sixth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_Y = SAself_6_OLD.
VARIABLE LABELS SAself_6_OLD 'How strongly do you agree with this statement: Dressing provocatively does not justify sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_T = SAother_6_OLD.
VARIABLE LABELS SAother_6_OLD 'What percentage of the adult population would agree with this statement: Dressing provocatively does not justify sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_B = SAwomen_6_OLD.
VARIABLE LABELS SAwomen_6_OLD 'What percentage of women would agree with this statement: Dressing provocatively does not justify sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_B = SAmen_6_OLD.
VARIABLE LABELS SAmen_6_OLD 'What percentage of men would agree with this statement: Dressing provocatively does not justify sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_W = SAFB_6_OLD.
VARIABLE LABELS SAFB_6_OLD 'Is this statement a fact or belief: Dressing provocatively does not justify sexual assault.'.

*Seventh statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_Z = SAself_7_OLD.
VARIABLE LABELS SAself_7_OLD 'How strongly do you agree with this statement: If the accused person was found not guilty, it does not mean that sexual assault did not occur.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_U = SAother_7_OLD.
VARIABLE LABELS SAother_7_OLD 'What percentage of the adult population would agree with this statement: If the accused person was found not guilty, it does not mean that sexual assault did not occur.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_C = SAwomen_7_OLD.
VARIABLE LABELS SAwomen_7_OLD 'What percentage of women would agree with this statement: If the accused person was found not guilty, it does not mean that sexual assault did not occur.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_C = SAmen_7_OLD.
VARIABLE LABELS SAmen_7_OLD 'What percentage of men would agree with this statement: If the accused person was found not guilty, it does not mean that sexual assault did not occur.'.

RENAME VARIABLES Isthisstatementafactorbelief_X = SAFB_7_OLD.
VARIABLE LABELS SAFB_7_OLD 'Is this statement a fact or belief: If the accused person was found not guilty, it does not mean that sexual assault did not occur.'.

*Eighth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AA = SAself_8_OLD.
VARIABLE LABELS SAself_8_OLD 'How strongly do you agree with this statement: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_V = SAother_8_OLD.
VARIABLE LABELS SAother_8_OLD 'What percentage of the adult population would agree with this statement: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_D = SAwomen_8_OLD.
VARIABLE LABELS SAwomen_8_OLD 'What percentage of women would agree with this statement: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_D= SAmen_8_OLD.
VARIABLE LABELS SAmen_8_OLD 'What percentage of men would agree with this statement: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past.'.

RENAME VARIABLES Isthisstatementafactorbelief_Y = SAFB_8_OLD.
VARIABLE LABELS SAFB_8_OLD 'Is this statement a fact or belief: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past.'.

*Ninth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AB = SAself_9_OLD.
VARIABLE LABELS SAself_9_OLD 'How strongly do you agree with this statement: Women cannot be considered victims of sexual assault by their husbands.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_W = SAother_9_OLD.
VARIABLE LABELS SAother_9_OLD 'What percentage of the adult population would agree with this statement: Women cannot be considered victims of sexual assault by their husbands.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_E = SAwomen_9_OLD.
VARIABLE LABELS SAwomen_9_OLD 'What percentage of women would agree with this statement: Women cannot be considered victims of sexual assault by their husbands.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_E= SAmen_9_OLD.
VARIABLE LABELS SAmen_9_OLD 'What percentage of men would agree with this statement: Women cannot be considered victims of sexual assault by their husbands.'.

RENAME VARIABLES Isthisstatementafactorbelief_Z = SAFB_9_OLD.
VARIABLE LABELS SAFB_9_OLD 'Is this statement a fact or belief: Women cannot be considered victims of sexual assault by their husbands.'.

*Tenth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AC = SAself_10_OLD.
VARIABLE LABELS SAself_10_OLD 'How strongly do you agree with this statement: If a person goes home with someone, they assume the risk of sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_X = SAother_10_OLD.
VARIABLE LABELS SAother_10_OLD 'What percentage of the adult population would agree with this statement: If a person goes home with someone, they assume the risk of sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_F = SAwomen_10_OLD.
VARIABLE LABELS SAwomen_10_OLD 'What percentage of women would agree with this statement: If a person goes home with someone, they assume the risk of sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_F= SAmen_10_OLD.
VARIABLE LABELS SAmen_10_OLD 'What percentage of men would agree with this statement: If a person goes home with someone, they assume the risk of sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_AA = SAFB_10_OLD.
VARIABLE LABELS SAFB_10_OLD 'Is this statement a fact or belief: If a person goes home with someone, they assume the risk of sexual assault.'.

*Eleventh statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AD = SAself_11_OLD.
VARIABLE LABELS SAself_11_OLD 'How strongly do you agree with this statement: It is still sexual assault, even if charges werent filed immediately.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_Y = SAother_11_OLD.
VARIABLE LABELS SAother_11_OLD 'What percentage of the adult population would agree with this statement: It is still sexual assault, even if charges werent filed immediately.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_G = SAwomen_11_OLD.
VARIABLE LABELS SAwomen_11_OLD 'What percentage of women would agree with this statement: It is still sexual assault, even if charges werent filed immediately.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_G = SAmen_11_OLD.
VARIABLE LABELS SAmen_11_OLD 'What percentage of men would agree with this statement: It is still sexual assault, even if charges werent filed immediately.'.

RENAME VARIABLES Isthisstatementafactorabelief_A = SAFB_11_OLD.
VARIABLE LABELS SAFB_11_OLD 'Is this statement a fact or belief: It is still sexual assault, even if charges werent filed immediately.'.

*Twelfth statement.
 
RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AE = SAself_12_OLD.
VARIABLE LABELS SAself_12_OLD 'How strongly do you agree with this statement: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_Z = SAother_12_OLD.
VARIABLE LABELS SAother_12_OLD 'What percentage of the adult population would agree with this statement: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_H = SAwomen_12_OLD.
VARIABLE LABELS SAwomen_12_OLD 'What percentage of women would agree with this statement: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_H= SAmen_12_OLD.
VARIABLE LABELS SAmen_12_OLD 'What percentage of men would agree with this statement: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_AB = SAFB_12_OLD.
VARIABLE LABELS SAFB_12_OLD 'Is this statement a fact or belief: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.'.

*Thirteenth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AF = SAself_13_OLD.
VARIABLE LABELS SAself_13_OLD 'How strongly do you agree with this statement: When someone cannot verbally or physically resist sex due to fear, it is sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AA = SAother_13_OLD.
VARIABLE LABELS SAother_13_OLD 'What percentage of the adult population would agree with this statement: When someone cannot verbally or physically resist sex due to fear, it is sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_I = SAwomen_13_OLD.
VARIABLE LABELS SAwomen_13_OLD 'What percentage of women would agree with this statement: When someone cannot verbally or physically resist sex due to fear, it is sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_I= SAmen_13_OLD.
VARIABLE LABELS SAmen_13_OLD 'What percentage of men would agree with this statement: When someone cannot verbally or physically resist sex due to fear, it is sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_AC = SAFB_13_OLD.
VARIABLE LABELS SAFB_13_OLD 'Is this statement a fact or belief: When someone cannot verbally or physically resist sex due to fear, it is sexual assault.'.

*Fourteenth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AG = SAself_14_OLD.
VARIABLE LABELS SAself_14_OLD 'How strongly do you agree with this statement: If one person changed their mind midway through a consensual act then it wasnt sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AB = SAother_14_OLD.
VARIABLE LABELS SAother_14_OLD 'What percentage of the adult population would agree with this statement: If one person changed their mind midway through a consensual act then it wasnt sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_J = SAwomen_14_OLD.
VARIABLE LABELS SAwomen_14_OLD 'What percentage of women would agree with this statement: If one person changed their mind midway through a consensual act then it wasnt sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_J = SAmen_14_OLD.
VARIABLE LABELS SAmen_14_OLD 'What percentage of men would agree with this statement: If one person changed their mind midway through a consensual act then it wasnt sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_AD = SAFB_14_OLD.
VARIABLE LABELS SAFB_14_OLD 'Is this statement a fact or belief: If one person changed their mind midway through a consensual act then it wasnt sexual assault.'.

*Fifteenth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AH = SAself_15_OLD.
VARIABLE LABELS SAself_15_OLD 'How strongly do you agree with this statement: Initiating kissing or hooking up is not consent to sex'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AC = SAother_15_OLD.
VARIABLE LABELS SAother_15_OLD 'What percentage of the adult population would agree with this statement: Initiating kissing or hooking up is not consent to sex'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_K = SAwomen_15_OLD.
VARIABLE LABELS SAwomen_15_OLD 'What percentage of women would agree with this statement: Initiating kissing or hooking up is not consent to sex'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_K = SAmen_15_OLD.
VARIABLE LABELS SAmen_15_OLD 'What percentage of men would agree with this statement: Initiating kissing or hooking up is not consent to sex'.

RENAME VARIABLES Isthisstatementafactorbelief_AE = SAFB_15_OLD.
VARIABLE LABELS SAFB_15_OLD 'Is this statement a fact or belief: Initiating kissing or hooking up is not consent to sex'.

*Sixteenth statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AI = SAself_16_OLD.
VARIABLE LABELS SAself_16_OLD 'How strongly do you agree with this statement: Women provoke sexual assaults when they dress provocatively.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AD = SAother_16_OLD.
VARIABLE LABELS SAother_16_OLD 'What percentage of the adult population would agree with this statement: Women provoke sexual assaults when they dress provocatively.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_L = SAwomen_16_OLD.
VARIABLE LABELS SAwomen_16_OLD 'What percentage of women would agree with this statement: Women provoke sexual assaults when they dress provocatively'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_L = SAmen_16_OLD.
VARIABLE LABELS SAmen_16_OLD 'What percentage of men would agree with this statement: Women provoke sexual assaults when they dress provocatively.'.

RENAME VARIABLES Isthisstatementafactorbelief_AF = SAFB_16_OLD.
VARIABLE LABELS SAFB_16_OLD 'Is this statement a fact or belief: Women provoke sexual assaults when they dress provocatively.'.

*Seventeenth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AJ = SAself_17_OLD.
VARIABLE LABELS SAself_17_OLD 'How strongly do you agree with this statement: If someone doesn’t resist physically, it is not sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AE = SAother_17_OLD.
VARIABLE LABELS SAother_17_OLD 'What percentage of the adult population would agree with this statement: If someone doesn’t resist physically, it is not sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_M = SAwomen_17_OLD.
VARIABLE LABELS SAwomen_17_OLD 'What percentage of women would agree with this statement: If someone doesn’t resist physically, it is not sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_M = SAmen_17_OLD.
VARIABLE LABELS SAmen_17_OLD 'What percentage of men would agree with this statement: If someone doesn’t resist physically, it is not sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_AG = SAFB_17_OLD.
VARIABLE LABELS SAFB_17_OLD 'Is this statement a fact or belief: If someone doesn’t resist physically, it is not sexual assault.'.

*Eighteenth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AK = SAself_18_OLD.
VARIABLE LABELS SAself_18_OLD 'How strongly do you agree with this statement: It’s not sexual assault if the accused has had sex with that person before.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AF = SAother_18_OLD.
VARIABLE LABELS SAother_18_OLD 'What percentage of the adult population would agree with this statement: It’s not sexual assault if the accused has had sex with that person before.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_N = SAwomen_18_OLD.
VARIABLE LABELS SAwomen_18_OLD 'What percentage of women would agree with this statement: It’s not sexual assault if the accused has had sex with that person before.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_N = SAmen_18_OLD.
VARIABLE LABELS SAmen_18_OLD 'What percentage of men would agree with this statement: It’s not sexual assault if the accused has had sex with that person before.'.

RENAME VARIABLES Isthisstatementafactorbelief_AH = SAFB_18_OLD.
VARIABLE LABELS SAFB_18_OLD 'Is this statement a fact or belief: It’s not sexual assault if the accused has had sex with that person before.'.

*Nineteenth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AL = SAself_19_OLD.
VARIABLE LABELS SAself_19_OLD 'How strongly do you agree with this statement: People provoke sexual assaults when they act in a promiscuous manner.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AG = SAother_19_OLD.
VARIABLE LABELS SAother_19_OLD 'What percentage of the adult population would agree with this statement: People provoke sexual assaults when they act in a promiscuous manner.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_O = SAwomen_19_OLD.
VARIABLE LABELS SAwomen_19_OLD 'What percentage of women would agree with this statement: People provoke sexual assaults when they act in a promiscuous manner.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_O = SAmen_19_OLD.
VARIABLE LABELS SAmen_19_OLD 'What percentage of men would agree with this statement: People provoke sexual assaults when they act in a promiscuous manner.'.

RENAME VARIABLES Isthisstatementafactorbelief_AI = SAFB_19_OLD.
VARIABLE LABELS SAFB_19_OLD 'Is this statement a fact or belief: People provoke sexual assaults when they act in a promiscuous manner.'.

*Twentieth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AM = SAself_20_OLD.
VARIABLE LABELS SAself_20_OLD 'How strongly do you agree with this statement: A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AH = SAother_20_OLD.
VARIABLE LABELS SAother_20_OLD 'What percentage of the adult population would agree with this statement:  A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_P = SAwomen_20_OLD.
VARIABLE LABELS SAwomen_20_OLD 'What percentage of women would agree with this statement:  A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_P = SAmen_20_OLD.
VARIABLE LABELS SAmen_20_OLD 'What percentage of men would agree with this statement: A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.'.

RENAME VARIABLES Isthisstatementafactorbelief_AJ = SAFB_20_OLD.
VARIABLE LABELS SAFB_20_OLD 'Is this statement a fact or belief: A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.'.

*Twenty-first statement. 

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AN = SAself_21_OLD.
VARIABLE LABELS SAself_21_OLD 'How strongly do you agree with this statement: If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AI = SAother_21_OLD.
VARIABLE LABELS SAother_21_OLD 'What percentage of the adult population would agree with this statement:  If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_Q = SAwomen_21_OLD.
VARIABLE LABELS SAwomen_21_OLD 'What percentage of women would agree with this statement: If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_Q = SAmen_21_OLD.
VARIABLE LABELS SAmen_21_OLD 'What percentage of men would agree with this statement: If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_AK = SAFB_21_OLD.
VARIABLE LABELS SAFB_21_OLD 'Is this statement a fact or belief: If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.'.

*Twenty-second statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AO = SAself_22_OLD.
VARIABLE LABELS SAself_22_OLD 'How strongly do you agree with this statement: Intoxication does not make the assailant innocent of sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AJ = SAother_22_OLD.
VARIABLE LABELS SAother_22_OLD 'What percentage of the adult population would agree with this statement:  Intoxication does not make the assailant innocent of sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_R = SAwomen_22_OLD.
VARIABLE LABELS SAwomen_22_OLD 'What percentage of women would agree with this statement:  Intoxication does not make the assailant innocent of sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_R = SAmen_22_OLD.
VARIABLE LABELS SAmen_22_OLD 'What percentage of men would agree with this statement: Intoxication does not make the assailant innocent of sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_AL = SAFB_22_OLD.
VARIABLE LABELS SAFB_22_OLD 'Is this statement a fact or belief: Intoxication does not make the assailant innocent of sexual assault.'.

*Twenty-third statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AP = SAself_23_OLD.
VARIABLE LABELS SAself_23_OLD 'How strongly do you agree with this statement: If the accused individual was not convicted of sexual assault, it means he/she is innocent.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AK = SAother_23_OLD.
VARIABLE LABELS SAother_23_OLD 'What percentage of the adult population would agree with this statement: If the accused individual was not convicted of sexual assault, it means he/she is innocent.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_S = SAwomen_23_OLD.
VARIABLE LABELS SAwomen_23_OLD 'What percentage of women would agree with this statement: If the accused individual was not convicted of sexual assault, it means he/she is innocent.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_S = SAmen_23_OLD.
VARIABLE LABELS SAmen_23_OLD 'What percentage of men would agree with this statement: If the accused individual was not convicted of sexual assault, it means he/she is innocent.'.

RENAME VARIABLES Isthisstatementafactorbelief_AM = SAFB_23_OLD.
VARIABLE LABELS SAFB_23_OLD 'Is this statement a fact or belief: If the accused individual was not convicted of sexual assault, it means he/she is innocent.'.

*Twenty-fourth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AQ = SAself_24_OLD.
VARIABLE LABELS SAself_24_OLD 'How strongly do you agree with this statement: Sexual assault can occur between a husband and a wife.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AL = SAother_24_OLD.
VARIABLE LABELS SAother_24_OLD 'What percentage of the adult population would agree with this statement: Sexual assault can occur between a husband and a wife.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_T = SAwomen_24_OLD.
VARIABLE LABELS SAwomen_24_OLD 'What percentage of women would agree with this statement: Sexual assault can occur between a husband and a wife.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_T = SAmen_24_OLD.
VARIABLE LABELS SAmen_24_OLD 'What percentage of men would agree with this statement: Sexual assault can occur between a husband and a wife.'.

RENAME VARIABLES Isthisstatementafactorbelief_AN = SAFB_24_OLD.
VARIABLE LABELS SAFB_24_OLD 'Is this statement a fact or belief: Sexual assault can occur between a husband and a wife.'.

*Twenty-fifth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AR = SAself_25_OLD.
VARIABLE LABELS SAself_25_OLD 'How strongly do you agree with this statement: If one person didn’t file sexual assault charges until later on, most likely nothing happened.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AM = SAother_25_OLD.
VARIABLE LABELS SAother_25_OLD 'What percentage of the adult population would agree with this statement: If one person didn’t file sexual assault charges until later on, most likely nothing happened.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_U = SAwomen_25_OLD.
VARIABLE LABELS SAwomen_25_OLD 'What percentage of women would agree with this statement: If one person didn’t file sexual assault charges until later on, most likely nothing happened.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_U = SAmen_25_OLD.
VARIABLE LABELS SAmen_25_OLD 'What percentage of men would agree with this statement: If one person didn’t file sexual assault charges until later on, most likely nothing happened.'.

RENAME VARIABLES Isthisstatementafactorbelief_AO = SAFB_25_OLD.
VARIABLE LABELS SAFB_25_OLD 'Is this statement a fact or belief: If one person didn’t file sexual assault charges until later on, most likely nothing happened.'.

*Twenty-sixth statement.

RENAME VARIABLES Howstronglydoyouagreewiththisstatement_AS = SAself_26_OLD.
VARIABLE LABELS SAself_26_OLD 'How strongly do you agree with this statement: Men can be victims of sexual assault.'.

RENAME VARIABLES Whatpercentageoftheadultpopulationwouldagreewiththisst_AN = SAother_26_OLD.
VARIABLE LABELS SAother_26_OLD 'What percentage of the adult population would agree with this statement: Men can be victims of sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyaswomenÂ wouldagree_V = SAwomen_26_OLD.
VARIABLE LABELS SAwomen_26_OLD 'What percentage of women would agree with this statement: Men can be victims of sexual assault.'.

RENAME VARIABLES WhatpercentageofÂ thosewhoidentifyasmenÂ wouldagreew_V = SAmen_26_OLD.
VARIABLE LABELS SAmen_26_OLD 'What percentage of men would agree with this statement: Men can be victims of sexual assault.'.

RENAME VARIABLES Isthisstatementafactorbelief_AP = SAFB_26_OLD.
VARIABLE LABELS SAFB_26_OLD 'Is this statement a fact or belief: Men can be victims of sexual assault.'.

*Recode the general statements to be numeric.

RECODE genSelf_1_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_1.
MISSING VALUES gSelf_1 (-9).
VARIABLE LEVEL gSelf_1 (SCALE).
ALTER TYPE gSelf_1 (F7.0).
FORMATS gSelf_1 (F7.0). 
VARIABLE LABELS gSelf_1"How strongly do you agree: A hammer is used to pound nails".
VALUE LABELS gSelf_1 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_2_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_2.
MISSING VALUES gSelf_2 (-9).
VARIABLE LEVEL gSelf_2 (SCALE).
ALTER TYPE gSelf_2 (F7.0).
FORMATS gSelf_2 (F7.0). 
VARIABLE LABELS gSelf_2 "How strongly do you agree: Children are happy and carefree.".
VALUE LABELS gSelf_2 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_3_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_3.
MISSING VALUES gSelf_3 (-9).
VARIABLE LEVEL gSelf_3 (SCALE).
ALTER TYPE gSelf_3 (F7.0).
FORMATS gSelf_3 (F7.0). 
VARIABLE LABELS gSelf_3 "How strongly do you agree: Dogs are animals.".
VALUE LABELS gSelf_3 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_4_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_4.
MISSING VALUES gSelf_4 (-9).
VARIABLE LEVEL gSelf_4 (SCALE).
ALTER TYPE gSelf_4 (F7.0).
FORMATS gSelf_4 (F7.0). 
VARIABLE LABELS gSelf_4 "How strongly do you agree: A pen is for writing.".
VALUE LABELS gSelf_4 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_5_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_5.
MISSING VALUES gSelf_5 (-9).
VARIABLE LEVEL gSelf_5 (SCALE).
ALTER TYPE gSelf_5 (F7.0).
FORMATS gSelf_5 (F7.0). 
VARIABLE LABELS gSelf_5"How strongly do you agree: The telephone is the greatest invention of all time.".
VALUE LABELS gSelf_5 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_6_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_6.
MISSING VALUES gSelf_6 (-9).
VARIABLE LEVEL gSelf_6 (SCALE).
ALTER TYPE gSelf_6 (F7.0).
FORMATS gSelf_6 (F7.0). 
VARIABLE LABELS gSelf_6 "How strongly do you agree: There are three colors in the American flag.".
VALUE LABELS gSelf_6 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_7_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_7.
MISSING VALUES gSelf_7 (-9).
VARIABLE LEVEL gSelf_7 (SCALE).
ALTER TYPE gSelf_7 (F7.0).
FORMATS gSelf_7 (F7.0). 
VARIABLE LABELS gSelf_7"How strongly do you agree: There are seven days in a week.".
VALUE LABELS gSelf_7 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_8_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_8.
MISSING VALUES gSelf_8 (-9).
VARIABLE LEVEL gSelf_8 (SCALE).
ALTER TYPE gSelf_8 (F7.0).
FORMATS gSelf_8 (F7.0). 
VARIABLE LABELS gSelf_8 "How strongly do you agree: Christmas is a holiday primarily for children.".
VALUE LABELS gSelf_8 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_9_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_9.
MISSING VALUES gSelf_9 (-9).
VARIABLE LEVEL gSelf_9 (SCALE).
ALTER TYPE gSelf_9 (F7.0).
FORMATS gSelf_9 (F7.0). 
VARIABLE LABELS gSelf_9 "How strongly do you agree: Sleeping with the window open is good for you.".
VALUE LABELS gSelf_9 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_10_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_10.
MISSING VALUES gSelf_10 (-9).
VARIABLE LEVEL gSelf_10 (SCALE).
ALTER TYPE gSelf_10 (F7.0).
FORMATS gSelf_10 (F7.0). 
VARIABLE LABELS gSelf_10 "How strongly do you agree: Thermometers are used to measure temperature.".
VALUE LABELS gSelf_10 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_11_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_11.
MISSING VALUES gSelf_11 (-9).
VARIABLE LEVEL gSelf_11 (SCALE).
ALTER TYPE gSelf_11 (F7.0).
FORMATS gSelf_11 (F7.0). 
VARIABLE LABELS gSelf_11 "How strongly do you agree: A driver's license is required by law to drive a car.".
VALUE LABELS gSelf_11 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_12_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_12.
MISSING VALUES gSelf_12 (-9).
VARIABLE LEVEL gSelf_12 (SCALE).
ALTER TYPE gSelf_12 (F7.0).
FORMATS gSelf_12 (F7.0). 
VARIABLE LABELS gSelf_12 "How strongly do you agree: Books may be borrowed from the library.".
VALUE LABELS gSelf_12 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_13_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_13.
MISSING VALUES gSelf_13 (-9).
VARIABLE LEVEL gSelf_13 (SCALE).
ALTER TYPE gSelf_13 (F7.0).
FORMATS gSelf_13 (F7.0). 
VARIABLE LABELS gSelf_13 "How strongly do you agree: Rich people are happy people.".
VALUE LABELS gSelf_13 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_14_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_14.
MISSING VALUES gSelf_14 (-9).
VARIABLE LEVEL gSelf_14 (SCALE).
ALTER TYPE gSelf_14 (F7.0).
FORMATS gSelf_14 (F7.0). 
VARIABLE LABELS gSelf_14 "How strongly do you agree: Cats are friendly animals.".
VALUE LABELS gSelf_14 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_15_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_15.
MISSING VALUES gSelf_15 (-9).
VARIABLE LEVEL gSelf_15 (SCALE).
ALTER TYPE gSelf_15 (F7.0).
FORMATS gSelf_15 (F7.0). 
VARIABLE LABELS gSelf_15 "How strongly do you agree: Rock music is a bad influence on young children.".
VALUE LABELS gSelf_15 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_16_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_16.
MISSING VALUES gSelf_16 (-9).
VARIABLE LEVEL gSelf_16 (SCALE).
ALTER TYPE gSelf_16 (F7.0).
FORMATS gSelf_16 (F7.0). 
VARIABLE LABELS gSelf_16 "How strongly do you agree: It is okay to lie.".
VALUE LABELS gSelf_16 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_17_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_17.
MISSING VALUES gSelf_17 (-9).
VARIABLE LEVEL gSelf_17 (SCALE).
ALTER TYPE gSelf_17 (F7.0).
FORMATS gSelf_17 (F7.0). 
VARIABLE LABELS gSelf_17 "How strongly do you agree: The longer you stay in school, the smarter you will be.".
VALUE LABELS gSelf_17 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_18_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_18.
MISSING VALUES gSelf_18 (-9).
VARIABLE LEVEL gSelf_18 (SCALE).
ALTER TYPE gSelf_18 (F7.0).
FORMATS gSelf_18 (F7.0). 
VARIABLE LABELS gSelf_18 "How strongly do you agree: The earth revolves around the sun.".
VALUE LABELS gSelf_18 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_19_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_19.
MISSING VALUES gSelf_19 (-9).
VARIABLE LEVEL gSelf_19 (SCALE).
ALTER TYPE gSelf_19 (F7.0).
FORMATS gSelf_19 (F7.0). 
VARIABLE LABELS gSelf_19 "How strongly do you agree: Comic strips are funny.".
VALUE LABELS gSelf_19 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE genSelf_20_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into gSelf_20.
MISSING VALUES gSelf_20 (-9).
VARIABLE LEVEL gSelf_20 (SCALE).
ALTER TYPE gSelf_20 (F7.0).
FORMATS gSelf_20 (F7.0). 
VARIABLE LABELS gSelf_20 "How strongly do you agree: The shape of a ball is round.".
VALUE LABELS gSelf_20 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

*Recode the general estimation of others' opinions statements to be numeric (question asking "What percentage of the adult population would agree").

RECODE genOther_1_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) INTO gOther_1.
MISSING VALUES gOther_1 (-9).
VARIABLE LEVEL gOther_1 (SCALE).
ALTER TYPE gOther_1 (F7.0).
FORMATS gOther_1 (F7.0). 
VARIABLE LABELS gOther_1 "What percentage of the adult population would agree: A hammer is used to pound nails (NUM)".
VALUE LABELS gOther_1 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_2_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_2.
MISSING VALUES gOther_2 (-9).
VARIABLE LEVEL gOther_2 (SCALE).
ALTER TYPE gOther_2 (F7.0).
FORMATS gOther_2 (F7.0). 
VARIABLE LABELS gOther_2 "What percentage of the adult population would agree: Children are happy and carefree.".
VALUE LABELS gOther_2 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_3_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_3.
MISSING VALUES gOther_3 (-9).
VARIABLE LEVEL gOther_3 (SCALE).
ALTER TYPE gOther_3 (F7.0).
FORMATS gOther_3 (F7.0). 
VARIABLE LABELS gOther_3 "What percentage of the adult population would agree: Dogs are animals.".
VALUE LABELS gOther_3 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_4_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_4.
MISSING VALUES gOther_4 (-9).
VARIABLE LEVEL gOther_4 (SCALE).
ALTER TYPE gOther_4 (F7.0).
FORMATS gOther_4 (F7.0). 
VARIABLE LABELS gOther_4 "What percentage of the adult population would agree: A pen is for writing.".
VALUE LABELS gOther_4 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_5_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_5.
MISSING VALUES gOther_5 (-9).
VARIABLE LEVEL gOther_5 (SCALE).
ALTER TYPE gOther_5 (F7.0).
FORMATS gOther_5 (F7.0). 
VARIABLE LABELS gOther_5 "What percentage of the adult population would agree: The telephone is the greatest invention of all time.".
VALUE LABELS gOther_5 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_6_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_6.
MISSING VALUES gOther_6 (-9).
VARIABLE LEVEL gOther_6 (SCALE).
ALTER TYPE gOther_6 (F7.0).
FORMATS gOther_6 (F7.0). 
VARIABLE LABELS gOther_6 "What percentage of the adult population would agree: There are three colors in the American flag.".
VALUE LABELS gOther_6 0 '0%' 25 '25%' 50 '50%' 76 '75%' 100 '100%'.

RECODE genOther_7_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_7.
MISSING VALUES gOther_7 (-9).
VARIABLE LEVEL gOther_7 (SCALE).
ALTER TYPE gOther_7 (F7.0).
FORMATS gOther_7 (F7.0). 
VARIABLE LABELS gOther_7 "What percentage of the adult population would agree: There are seven days in a week.".
VALUE LABELS gOther_7 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_8_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_8.
MISSING VALUES gOther_8 (-9).
VARIABLE LEVEL gOther_8 (SCALE).
ALTER TYPE gOther_8 (F7.0).
FORMATS gOther_8 (F7.0). 
VARIABLE LABELS gOther_8 "What percentage of the adult population would agree: Christmas is a holiday primarily for children.".
VALUE LABELS gOther_8 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_9_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_9.
MISSING VALUES gOther_9 (-9).
VARIABLE LEVEL gOther_9 (SCALE).
ALTER TYPE gOther_9 (F7.0).
FORMATS gOther_9 (F7.0). 
VARIABLE LABELS gOther_9 "What percentage of the adult population would agree: Sleeping with the window open is good for you.".
VALUE LABELS gOther_9 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_10_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_10.
MISSING VALUES gOther_10 (-9).
VARIABLE LEVEL gOther_10 (SCALE).
ALTER TYPE gOther_10 (F7.0).
FORMATS gOther_10 (F7.0). 
VARIABLE LABELS gOther_10 "What percentage of the adult population would agree: Thermometers are used to measure temperature.".
VALUE LABELS gOther_10 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_11_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_11.
MISSING VALUES gOther_11 (-9).
VARIABLE LEVEL gOther_11 (SCALE).
ALTER TYPE gOther_11 (F7.0).
FORMATS gOther_11 (F7.0). 
VARIABLE LABELS gOther_11 "What percentage of the adult population would agree: A driver's license is required by law to drive a car.".
VALUE LABELS gOther_11 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_12_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_12.
MISSING VALUES gOther_12 (-9).
VARIABLE LEVEL gOther_12 (SCALE).
ALTER TYPE gOther_12 (F7.0).
FORMATS gOther_12 (F7.0). 
VARIABLE LABELS gOther_12 "What percentage of the adult population would agree: Books may be borrowed from the library.".
VALUE LABELS gOther_12 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_13_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_13.
MISSING VALUES gOther_13 (-9).
VARIABLE LEVEL gOther_13 (SCALE).
ALTER TYPE gOther_13 (F7.0).
FORMATS gOther_13 (F7.0). 
VARIABLE LABELS gOther_13 "What percentage of the adult population would agree: Rich people are happy people.".
VALUE LABELS gOther_13 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_14_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_14.
MISSING VALUES gOther_14 (-9).
VARIABLE LEVEL gOther_14 (SCALE).
ALTER TYPE gOther_14 (F7.0).
FORMATS gOther_14 (F7.0). 
VARIABLE LABELS gOther_14 "What percentage of the adult population would agree: Cats are friendly animals.".
VALUE LABELS gOther_14 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_15_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_15.
MISSING VALUES gOther_15 (-9).
VARIABLE LEVEL gOther_15 (SCALE).
ALTER TYPE gOther_15 (F7.0).
FORMATS gOther_15 (F7.0). 
VARIABLE LABELS gOther_15 "What percentage of the adult population would agree: Rock music is a bad influence on young children.".
VALUE LABELS gOther_15 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_16_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_16.
MISSING VALUES gOther_16 (-9).
VARIABLE LEVEL gOther_16 (SCALE).
ALTER TYPE gOther_16 (F7.0).
FORMATS gOther_16 (F7.0). 
VARIABLE LABELS gOther_16 "What percentage of the adult population would agree: It is okay to lie.".
VALUE LABELS gOther_16 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_17_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_17.
MISSING VALUES gOther_17 (-9).
VARIABLE LEVEL gOther_17 (SCALE).
ALTER TYPE gOther_17 (F7.0).
FORMATS gOther_17 (F7.0). 
VARIABLE LABELS gOther_17 "What percentage of the adult population would agree: The longer you stay in school, the smarter you will be.".
VALUE LABELS gOther_17 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_18_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_18.
MISSING VALUES gOther_18 (-9).
VARIABLE LEVEL gOther_18 (SCALE).
ALTER TYPE gOther_18 (F7.0).
FORMATS gOther_18 (F7.0). 
VARIABLE LABELS gOther_18 "What percentage of the adult population would agree: The earth revolves around the sun.".
VALUE LABELS gOther_18 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_19_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_19.
MISSING VALUES gOther_19 (-9).
VARIABLE LEVEL gOther_19 (SCALE).
ALTER TYPE gOther_19 (F7.0).
FORMATS gOther_19 (F7.0). 
VARIABLE LABELS gOther_19 "What percentage of the adult population would agree: Comic strips are funny.".
VALUE LABELS gOther_19 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE genOther_20_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into gOther_20.
MISSING VALUES gOther_20 (-9).
VARIABLE LEVEL gOther_20 (SCALE).
ALTER TYPE gOther_20 (F7.0).
FORMATS gOther_20 (F7.0). 
VARIABLE LABELS gOther_20 "What percentage of the adult population would agree: The shape of a ball is round.".
VALUE LABELS gOther_20 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.


*Recode the general fact/belief binary statements as numeric (question asking, "Is this statement a fact or a belief?").
*Belief = 0 and fact = 1.
    
RECODE genFb_1_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_1.
MISSING VALUES gFb_1(-9).
VARIABLE LEVEL gFb_1(NOMINAL).
ALTER TYPE gFb_1(F7.0).
FORMATS gFb_1(F7.0). 
VARIABLE LABELS gFb_1"Is this a fact or belief: A hammer is used to pound nails (NUM)".
VALUE LABELS gFb_1 0 'Belief' 1 'Fact'. 

RECODE genFb_2_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_2.
MISSING VALUES gFb_2 (-9).
VARIABLE LEVEL gFb_2 (NOMINAL).
ALTER TYPE gFb_2 (F7.0).
FORMATS gFb_2 (F7.0). 
VARIABLE LABELS gFb_2 "Is this a fact or belief: Children are happy and carefree (NUM)".
VALUE LABELS gFb_2 0 0 'Belief' 1 'Fact'. 

RECODE genFb_3_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_3.
MISSING VALUES gFb_3 (-9).
VARIABLE LEVEL gFb_3 (NOMINAL).
ALTER TYPE gFb_3 (F7.0).
FORMATS gFb_3 (F7.0). 
VARIABLE LABELS gFb_3 "Is this a fact or belief: Dogs are animals (NUM)".
VALUE LABELS gFb_3 0 'Belief' 1 'Fact'.

RECODE genFb_4_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_4.
MISSING VALUES gFb_4 (-9).
VARIABLE LEVEL gFb_4 (NOMINAL).
ALTER TYPE gFb_4 (F7.0).
FORMATS gFb_4 (F7.0). 
VARIABLE LABELS gFb_4 "Is this a fact or belief: A pen is for writing (NUM)".
VALUE LABELS gFb_4 0 'Belief' 1 'Fact'.

RECODE genFb_5_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_5.
MISSING VALUES gFb_5 (-9).
VARIABLE LEVEL gFb_5 (NOMINAL).
ALTER TYPE gFb_5 (F7.0).
FORMATS gFb_5 (F7.0). 
VARIABLE LABELS gFb_5 "Is this a fact or belief: The telephone is the greatest invention of all time (NUM)".
VALUE LABELS gFb_5 0 'Belief' 1 'Fact'.

RECODE genFb_6_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_6.
MISSING VALUES gFb_6 (-9).
VARIABLE LEVEL gFb_6 (NOMINAL).
ALTER TYPE gFb_6 (F7.0).
FORMATS gFb_6 (F7.0). 
VARIABLE LABELS gFb_6 "Is this a fact or belief: There are three colors in the American flag.".
VALUE LABELS gFb_6 0 'Belief' 1 'Fact'.

RECODE genFb_7_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_7.
MISSING VALUES gFb_7 (-9).
VARIABLE LEVEL gFb_7 (NOMINAL).
ALTER TYPE gFb_7 (F7.0).
FORMATS gFb_7 (F7.0). 
VARIABLE LABELS gFb_7 "Is this a fact or belief: There are seven days in a week.".
VALUE LABELS gFb_7 0 'Belief' 1 'Fact'.

RECODE genFb_8_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_8.
MISSING VALUES gFb_8 (-9).
VARIABLE LEVEL gFb_8 (NOMINAL).
ALTER TYPE gFb_8 (F7.0).
FORMATS gFb_8 (F7.0). 
VARIABLE LABELS gFb_8 "Is this a fact or belief: Christmas is a holiday primarily for children.".
VALUE LABELS gFb_8 0 'Belief' 1 'Fact'.

RECODE genFb_9_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_9.
MISSING VALUES gFb_9 (-9).
VARIABLE LEVEL gFb_9 (NOMINAL).
ALTER TYPE gFb_9 (F7.0).
FORMATS gFb_9 (F7.0). 
VARIABLE LABELS gFb_9 "Is this a fact or belief:  Sleeping with the window open is good for you.".
VALUE LABELS gFb_9 0 'Belief' 1 'Fact'.

RECODE genFb_10_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_10.
MISSING VALUES gFb_10 (-9).
VARIABLE LEVEL gFb_10 (NOMINAL).
ALTER TYPE gFb_10 (F7.0).
FORMATS gFb_10 (F7.0). 
VARIABLE LABELS gFb_10 "Is this a fact or belief: Thermometers are used to measure temperature.".
VALUE LABELS gFb_10 0 'Belief' 1 'Fact'.

RECODE genFb_11_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_11.
MISSING VALUES gFb_11 (-9).
VARIABLE LEVEL gFb_11 (NOMINAL).
ALTER TYPE gFb_11 (F7.0).
FORMATS gFb_11 (F7.0). 
VARIABLE LABELS gFb_11 "Is this a fact or belief:  A drivers license is required by law to drive a car.".
VALUE LABELS gFb_11 0 'Belief' 1 'Fact'.

RECODE genFb_12_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_12.
MISSING VALUES gFb_12 (-9).
VARIABLE LEVEL gFb_12 (NOMINAL).
ALTER TYPE gFb_12 (F7.0).
FORMATS gFb_12 (F7.0). 
VARIABLE LABELS gFb_12 "Is this a fact or belief: Books may be borrowed from the library.".
VALUE LABELS gFb_12 0 'Belief' 1 'Fact'.

RECODE genFb_13_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_13.
MISSING VALUES gFb_13 (-9).
VARIABLE LEVEL gFb_13 (NOMINAL).
ALTER TYPE gFb_13 (F7.0).
FORMATS gFb_13 (F7.0). 
VARIABLE LABELS gFb_13 "Is this a fact or belief: Rich people are happy people.".
VALUE LABELS gFb_13 0 ‘Belief’ 1 ‘Fact’.

RECODE genFb_14_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_14.
MISSING VALUES gFb_14 (-9).
VARIABLE LEVEL gFb_14 (NOMINAL).
ALTER TYPE gFb_14 (F7.0).
FORMATS gFb_14 (F7.0). 
VARIABLE LABELS gFb_14 "Is this a fact or belief: Cats are friendly animals.".
VALUE LABELS gFb_14 0 ‘Belief’ 1 ‘Fact’.

RECODE genFb_15_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_15.
MISSING VALUES gFb_15 (-9).
VARIABLE LEVEL gFb_15 (NOMINAL).
ALTER TYPE gFb_15 (F7.0).
FORMATS gFb_15 (F7.0). 
VARIABLE LABELS gFb_15 "Is this a fact or belief: Rock music is a bad influence on young children.".
VALUE LABELS gFb_15 0 ‘Belief’ 1 ‘Fact’.

RECODE genFb_16_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_16.
MISSING VALUES gFb_16 (-9).
VARIABLE LEVEL gFb_16 (NOMINAL).
ALTER TYPE gFb_16 (F7.0).
FORMATS gFb_16 (F7.0). 
VARIABLE LABELS gFb_16 "Is this a fact or belief: It is okay to lie.".
VALUE LABELS gFb_16 0 ‘Belief’ 1 ‘Fact’.

RECODE genFb_17_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_17.
MISSING VALUES gFb_17 (-9).
VARIABLE LEVEL gFb_17 (NOMINAL).
ALTER TYPE gFb_17 (F7.0).
FORMATS gFb_17 (F7.0). 
VARIABLE LABELS gFb_17 "Is this a fact or belief: The longer you stay in school, the smarter you will be.".
VALUE LABELS gFb_17 0 ‘Belief’ 1 ‘Fact’.

RECODE genFb_18_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_18.
MISSING VALUES gFb_18 (-9).
VARIABLE LEVEL gFb_18 (NOMINAL).
ALTER TYPE gFb_18 (F7.0).
FORMATS gFb_18 (F7.0). 
VARIABLE LABELS gFb_18 "Is this a fact or belief: The earth revolves around the sun.".
VALUE LABELS gFb_18 0 ‘Belief’ 1 ‘Fact’.

RECODE genFb_19_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_19.
MISSING VALUES gFb_19 (-9).
VARIABLE LEVEL gFb_19 (NOMINAL).
ALTER TYPE gFb_19 (F7.0).
FORMATS gFb_19 (F7.0). 
VARIABLE LABELS gFb_19 "Is this a fact or belief: Comic strips are funny.".
VALUE LABELS gFb_19 0 ‘Belief’ 1 ‘Fact’.

RECODE genFb_20_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into gFb_20.
MISSING VALUES gFb_20 (-9).
VARIABLE LEVEL gFb_20 (NOMINAL).
ALTER TYPE gFb_20 (F7.0).
FORMATS gFb_20 (F7.0). 
VARIABLE LABELS gFb_20 "Is this a fact or belief: The shape of a ball is round.".
VALUE LABELS gFb_20 0 ‘Belief’ 1 ‘Fact’.

*Recode sexual assault agreement items to be numeric so a scale can be created.

RECODE SAself_1_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_1.
MISSING VALUES selfPerp_1 (-9).
VARIABLE LEVEL selfPerp_1 (SCALE).
ALTER TYPE selfPerp_1 (F7.0).
FORMATS selfPerp_1(F7.0). 
VARIABLE LABELS selfPerp_1 "How strongly do you agree: Even if a person didnt physically resist sex, it can still be sexual assault.".
VALUE LABELS selfPerp_1 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_2_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_2.
MISSING VALUES selfPerp_2 (-9).
VARIABLE LEVEL selfPerp_2 (SCALE).
ALTER TYPE selfPerp_2 (F7.0).
FORMATS selfPerp_2 (F7.0). 
VARIABLE LABELS selfPerp_2 "How strongly do you agree: It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.".
VALUE LABELS selfPerp_2 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_3_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_3.
MISSING VALUES selfPerp_3 (-9).
VARIABLE LEVEL selfPerp_3 (SCALE).
ALTER TYPE selfPerp_3 (F7.0).
FORMATS selfPerp_3 (F7.0). 
VARIABLE LABELS selfPerp_3 "How strongly do you agree: The perpetrator is still guilty of sexual assault even if the victim went home with them.".
VALUE LABELS selfPerp_3 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_4_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_4.
MISSING VALUES selfPerp_4 (-9).
VARIABLE LEVEL selfPerp_4 (SCALE).
ALTER TYPE selfPerp_4 (F7.0).
FORMATS selfPerp_4 (F7.0). 
VARIABLE LABELS selfPerp_4 "How strongly do you agree: Promiscuous actions dont legitimize sexual assault.".
VALUE LABELS selfPerp_4 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_5_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_1.
MISSING VALUES selfVict_1 (-9).
VARIABLE LEVEL selfVict_1 (SCALE).
ALTER TYPE selfVict_1 (F7.0).
FORMATS selfVict_1 (F7.0). 
VARIABLE LABELS selfVict_1 "How strongly do you agree: If someone initiates kissing or hooking up, they cant be surprised if someone assumes they want to have sex.".
VALUE LABELS selfVict_1 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_6_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_5.
MISSING VALUES selfPerp_5 (-9).
VARIABLE LEVEL selfPerp_5 (SCALE).
ALTER TYPE selfPerp_5 (F7.0).
FORMATS selfPerp_5 (F7.0). 
VARIABLE LABELS selfPerp_5 "How strongly do you agree: Dressing provocatively does not justify sexual assault (NUM)".
VALUE LABELS selfPerp_5 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_7_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_6.
MISSING VALUES selfPerp_6 (-9).
VARIABLE LEVEL selfPerp_6 (SCALE).
ALTER TYPE selfPerp_6 (F7.0).
FORMATS selfPerp_6 (F7.0). 
VARIABLE LABELS selfPerp_6 "How strongly do you agree: If the accused person was found not guilty, it does not mean that sexual assault did not occur.".
VALUE LABELS selfPerp_6 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_8_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_7.
MISSING VALUES selfPerp_7 (-9).
VARIABLE LEVEL selfPerp_7 (SCALE).
ALTER TYPE selfPerp_7 (F7.0).
FORMATS selfPerp_7 (F7.0). 
VARIABLE LABELS selfPerp_7 "How strongly do you agree: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past (NUM)".
VALUE LABELS selfPerp_7 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_9_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_2.
MISSING VALUES selfVict_2 (-9).
VARIABLE LEVEL selfVict_2 (SCALE).
ALTER TYPE selfVict_2 (F7.0).
FORMATS selfVict_2 (F7.0). 
VARIABLE LABELS selfVict_2 "How strongly do you agree: Women cannot be considered victims of sexual assault by their husbands (NUM)".
VALUE LABELS selfVict_2 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_10_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_3.
MISSING VALUES selfVict_3 (-9).
VARIABLE LEVEL selfVict_3 (SCALE).
ALTER TYPE selfVict_3 (F7.0).
FORMATS selfVict_3 (F7.0). 
VARIABLE LABELS selfVict_3 "How strongly do you agree: If a person goes home with someone, they assume the risk of sexual assault.".
VALUE LABELS selfVict_3 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_11_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_8.
MISSING VALUES selfPerp_8 (-9).
VARIABLE LEVEL selfPerp_8 (SCALE).
ALTER TYPE selfPerp_8 (F7.0).
FORMATS selfPerp_8(F7.0). 
VARIABLE LABELS selfPerp_8 "How strongly do you agree: It is still sexual assault, even if charges weren’t filed immediately (NUM)".
VALUE LABELS selfPerp_8 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_12_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_4.
MISSING VALUES selfVict_4(-9).
VARIABLE LEVEL selfVict_4 (SCALE).
ALTER TYPE selfVict_4 (F7.0).
FORMATS selfVict_4 (F7.0). 
VARIABLE LABELS selfVict_4 "How strongly do you agree: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.".
VALUE LABELS selfVict_4 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_13_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_9.
MISSING VALUES selfPerp_9 (-9).
VARIABLE LEVEL selfPerp_9 (SCALE).
ALTER TYPE selfPerp_9 (F7.0).
FORMATS selfPerp_9 (F7.0). 
VARIABLE LABELS selfPerp_9 "How strongly do you agree: When someone cannot verbally or physically resist sex due to fear, it is sexual assault (NUM)".
VALUE LABELS selfPerp_9 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_14_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_5.
MISSING VALUES selfVict_5 (-9).
VARIABLE LEVEL selfVict_5 (SCALE).
ALTER TYPE selfVict_5 (F7.0).
FORMATS selfVict_5 (F7.0). 
VARIABLE LABELS selfVict_5 "How strongly do you agree: If one person changed their mind midway through a consensual act then it wasnt sexual assault.".
VALUE LABELS selfVict_5 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_15_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_10.
MISSING VALUES selfPerp_10 (-9).
VARIABLE LEVEL selfPerp_10 (SCALE).
ALTER TYPE selfPerp_10 (F7.0).
FORMATS selfPerp_10 (F7.0). 
VARIABLE LABELS selfPerp_10 "How strongly do you agree: Initiating kissing or hooking up is not consent to sex.".
VALUE LABELS selfPerp_10 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_16_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_6.
MISSING VALUES selfVict_6 (-9).
VARIABLE LEVEL selfVict_6 (SCALE).
ALTER TYPE selfVict_6 (F7.0).
FORMATS selfVict_6 (F7.0). 
VARIABLE LABELS selfVict_6 "How strongly do you agree: Women provoke sexual assaults when they dress provocatively (NUM)".
VALUE LABELS selfVict_6 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_17_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_7.
MISSING VALUES selfVict_7 (-9).
VARIABLE LEVEL selfVict_7 (SCALE).
ALTER TYPE selfVict_7 (F7.0).
FORMATS selfVict_7 (F7.0). 
VARIABLE LABELS selfVict_7 "How strongly do you agree:  If someone doesn’t resist physically, it is not sexual assault (NUM)".
VALUE LABELS selfVict_7 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_18_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_8.
MISSING VALUES selfVict_8 (-9).
VARIABLE LEVEL selfVict_8 (SCALE).
ALTER TYPE selfVict_8 (F7.0).
FORMATS selfVict_8 (F7.0). 
VARIABLE LABELS selfVict_8 "How strongly do you agree: It’s not sexual assault if the accused has had sex with that person before (NUM)".
VALUE LABELS selfVict_8 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_19_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_9.
MISSING VALUES selfVict_9 (-9).
VARIABLE LEVEL selfVict_9 (SCALE).
ALTER TYPE selfVict_9 (F7.0).
FORMATS selfVict_9 (F7.0). 
VARIABLE LABELS selfVict_9 "How strongly do you agree: People provoke sexual assaults when they act in a promiscuous manner (NUM)".
VALUE LABELS selfVict_9 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_20_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_10.
MISSING VALUES selfVict_10 (-9).
VARIABLE LEVEL selfVict_10 (SCALE).
ALTER TYPE selfVict_10 (F7.0).
FORMATS selfVict_10 (F7.0). 
VARIABLE LABELS selfVict_10 "How strongly do you agree: A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.".
VALUE LABELS selfVict_10 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_21_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_11.
MISSING VALUES selfVict_11 (-9).
VARIABLE LEVEL selfVict_11 (SCALE).
ALTER TYPE selfVict_11 (F7.0).
FORMATS selfVict_11 (F7.0). 
VARIABLE LABELS selfVict_11 "How strongly do you agree: If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.".
VALUE LABELS selfVict_11 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_22_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_11.
MISSING VALUES selfPerp_11 (-9).
VARIABLE LEVEL selfPerp_11 (SCALE).
ALTER TYPE selfPerp_11 (F7.0).
FORMATS selfPerp_11 (F7.0). 
VARIABLE LABELS selfPerp_11 "How strongly do you agree:  Intoxication does not make the assailant innocent of sexual assault.".
VALUE LABELS selfPerp_11 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_23_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_12.
MISSING VALUES selfVict_12 (-9).
VARIABLE LEVEL selfVict_12 (SCALE).
ALTER TYPE selfVict_12 (F7.0).
FORMATS selfVict_12 (F7.0). 
VARIABLE LABELS selfVict_12 "How strongly do you agree: If the accused individual was not convicted of sexual assault, it means he/she is innocent.".
VALUE LABELS selfVict_12 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_24_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into  selfPerp_12.
MISSING VALUES  selfPerp_12 (-9).
VARIABLE LEVEL  selfPerp_12 (SCALE).
ALTER TYPE  selfPerp_12 (F7.0).
FORMATS  selfPerp_12 (F7.0). 
VARIABLE LABELS  selfPerp_12 "How strongly do you agree: Sexual assault can occur between a husband and a wife.".
VALUE LABELS  selfPerp_12 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_25_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfVict_13.
MISSING VALUES selfVict_13 (-9).
VARIABLE LEVEL selfVict_13 (SCALE).
ALTER TYPE selfVict_13 (F7.0).
FORMATS selfVict_13 (F7.0). 
VARIABLE LABELS selfVict_13 "How strongly do you agree: If one person didn’t file sexual assault charges until later on, most likely nothing happened.".
VALUE LABELS selfVict_13 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

RECODE SAself_26_OLD ('strongly disagree' = 1) ('disagree'=2) ('agree'=3) ('strongly agree'=4) (MISSING=SYSMIS) into selfPerp_13.
MISSING VALUES selfPerp_13 (-9).
VARIABLE LEVEL selfPerp_13 (SCALE).
ALTER TYPE selfPerp_13 (F7.0).
FORMATS selfPerp_13 (F7.0). 
VARIABLE LABELS selfPerp_13 "How strongly do you agree: Men can be victims of sexual assault.".
VALUE LABELS selfPerp_13 1 'Strongly disagree' 2 'Disagree ' 3 'Agree' 4 'Strongly agree'.

*Recode the sexual assault estimation of others' opinions statements to be numeric (question asking "What percentage of the adult population would agree").

RECODE SAother_1_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_1.
MISSING VALUES OtherPerp_1 (-9).
VARIABLE LEVEL OtherPerp_1 (SCALE).
ALTER TYPE OtherPerp_1 (F7.0).
FORMATS OtherPerp_1 (F7.0). 
VARIABLE LABELS OtherPerp_1 "What percentage of the adult population would agree: Even if a person didnt physically resist sex, it can still be sexual assault.".
VALUE LABELS OtherPerp_1 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_2_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_2.
MISSING VALUES OtherPerp_2 (-9).
VARIABLE LEVEL OtherPerp_2 (SCALE).
ALTER TYPE OtherPerp_2 (F7.0).
FORMATS OtherPerp_2 (F7.0). 
VARIABLE LABELS OtherPerp_2 "What percentage of the adult population would agree: It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.(NUM)".
VALUE LABELS OtherPerp_2 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_3_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_3.
MISSING VALUES OtherPerp_3 (-9).
VARIABLE LEVEL OtherPerp_3 (SCALE).
ALTER TYPE OtherPerp_3 (F7.0).
FORMATS OtherPerp_3 (F7.0). 
VARIABLE LABELS OtherPerp_3 "What percentage of the adult population would agree: Even if a person didnt physically resist sex, it can still be sexual assault.".
VALUE LABELS OtherPerp_3 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_4_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_4.
MISSING VALUES OtherPerp_4 (-9).
VARIABLE LEVEL OtherPerp_4 (SCALE).
ALTER TYPE OtherPerp_4 (F7.0).
FORMATS OtherPerp_4 (F7.0). 
VARIABLE LABELS OtherPerp_4 "What percentage of the adult population would agree: Promiscuous actions dont legitimize sexual assault.".
VALUE LABELS OtherPerp_4 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_5_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_1.
MISSING VALUES OtherVict_1 (-9).
VARIABLE LEVEL OtherVict_1 (SCALE).
ALTER TYPE OtherVict_1 (F7.0).
FORMATS OtherVict_1 (F7.0). 
VARIABLE LABELS OtherVict_1 "What percentage of the adult population would agree: If someone initiates kissing or hooking up, they can't be surprised if someone assumes they want to have sex.".
VALUE LABELS OtherVict_1 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_6_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_5.
MISSING VALUES OtherPerp_5 (-9).
VARIABLE LEVEL OtherPerp_5 (SCALE).
ALTER TYPE OtherPerp_5 (F7.0).
FORMATS OtherPerp_5 (F7.0). 
VARIABLE LABELS OtherPerp_5 "What percentage of the adult population would agree: Dressing provocatively does not justify sexual assault.".
VALUE LABELS OtherPerp_5 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_7_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_6.
MISSING VALUES OtherPerp_6 (-9).
VARIABLE LEVEL OtherPerp_6 (SCALE).
ALTER TYPE OtherPerp_6 (F7.0).
FORMATS OtherPerp_6 (F7.0). 
VARIABLE LABELS OtherPerp_6 "What percentage of the adult population would agree:  If the accused person was found not guilty, it does not mean that sexual assault did not occur.".
VALUE LABELS OtherPerp_6 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_8_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_7.
MISSING VALUES OtherPerp_7 (-9).
VARIABLE LEVEL OtherPerp_7 (SCALE).
ALTER TYPE OtherPerp_7 (F7.0).
FORMATS OtherPerp_7 (F7.0). 
VARIABLE LABELS OtherPerp_7 "What percentage of the adult population would agree: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past.".
VALUE LABELS OtherPerp_7 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_9_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_2.
MISSING VALUES OtherVict_2 (-9).
VARIABLE LEVEL OtherVict_2 (SCALE).
ALTER TYPE OtherVict_2 (F7.0).
FORMATS OtherVict_2 (F7.0). 
VARIABLE LABELS OtherVict_2 "What percentage of the adult population would agree: Women cannot be considered victims of sexual assault by their husbands.".
VALUE LABELS OtherVict_2 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_10_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_3.
MISSING VALUES OtherVict_3 (-9).
VARIABLE LEVEL OtherVict_3 (SCALE).
ALTER TYPE OtherVict_3 (F7.0).
FORMATS OtherVict_3 (F7.0). 
VARIABLE LABELS OtherVict_3 "What percentage of the adult population would agree: If a person goes home with someone, they assume the risk of sexual assault.".
VALUE LABELS OtherVict_3 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_11_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_8.
MISSING VALUES OtherPerp_8 (-9).
VARIABLE LEVEL OtherPerp_8 (SCALE).
ALTER TYPE OtherPerp_8 (F7.0).
FORMATS OtherPerp_8 (F7.0). 
VARIABLE LABELS OtherPerp_8 "What percentage of the adult population would agree: It is still sexual assault, even if charges werent filed immediately.".
VALUE LABELS OtherPerp_8 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_12_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_4.
MISSING VALUES OtherVict_4 (-9).
VARIABLE LEVEL OtherVict_4 (SCALE).
ALTER TYPE OtherVict_4 (F7.0).
FORMATS OtherVict_4 (F7.0). 
VARIABLE LABELS OtherVict_4 "What percentage of the adult population would agree: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.".
VALUE LABELS OtherVict_4 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_13_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_9.
MISSING VALUES OtherPerp_9 (-9).
VARIABLE LEVEL OtherPerp_9 (SCALE).
ALTER TYPE OtherPerp_9 (F7.0).
FORMATS OtherPerp_9 (F7.0). 
VARIABLE LABELS OtherPerp_9 "What percentage of the adult population would agree: When someone cannot verbally or physically resist sex due to fear, it is sexual assault.".
VALUE LABELS OtherPerp_9 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_14_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_5.
MISSING VALUES OtherVict_5 (-9).
VARIABLE LEVEL OtherVict_5 (SCALE).
ALTER TYPE OtherVict_5 (F7.0).
FORMATS OtherVict_5 (F7.0). 
VARIABLE LABELS OtherVict_5 "What percentage of the adult population would agree: If one person changed their mind midway through a consensual act then it wasnt sexual assault.".
VALUE LABELS OtherVict_5 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_15_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_10.
MISSING VALUES OtherPerp_10 (-9).
VARIABLE LEVEL OtherPerp_10 (SCALE).
ALTER TYPE OtherPerp_10 (F7.0).
FORMATS OtherPerp_10 (F7.0). 
VARIABLE LABELS OtherPerp_10 "What percentage of the adult population would agree: Initiating kissing or hooking up is not consent to sex (NUM)".
VALUE LABELS OtherPerp_10 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_16_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_6.
MISSING VALUES OtherVict_6 (-9).
VARIABLE LEVEL OtherVict_6 (SCALE).
ALTER TYPE OtherVict_6 (F7.0).
FORMATS OtherVict_6 (F7.0). 
VARIABLE LABELS OtherVict_6 "What percentage of the adult population would agree: Women provoke sexual assaults when they dress provocatively.".
VALUE LABELS OtherVict_6 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_17_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_7.
MISSING VALUES OtherVict_7 (-9).
VARIABLE LEVEL OtherVict_7 (SCALE).
ALTER TYPE OtherVict_7 (F7.0).
FORMATS OtherVict_7 (F7.0). 
VARIABLE LABELS OtherVict_7 "What percentage of the adult population would agree: If someone doesn’t resist physically, it is not sexual assault.".
VALUE LABELS OtherVict_7 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_18_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_8.
MISSING VALUES OtherVict_8 (-9).
VARIABLE LEVEL OtherVict_8 (SCALE).
ALTER TYPE OtherVict_8 (F7.0).
FORMATS OtherVict_8 (F7.0). 
VARIABLE LABELS OtherVict_8 "What percentage of the adult population would agree: It’s not sexual assault if the accused has had sex with that person before.".
VALUE LABELS OtherVict_8 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_19_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_9.
MISSING VALUES OtherVict_9 (-9).
VARIABLE LEVEL OtherVict_9 (SCALE).
ALTER TYPE OtherVict_9 (F7.0).
FORMATS OtherVict_9 (F7.0). 
VARIABLE LABELS OtherVict_9 "What percentage of the adult population would agree: People provoke sexual assaults when they act in a promiscuous manner.".
VALUE LABELS OtherVict_9 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_20_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_10.
MISSING VALUES OtherVict_10 (-9).
VARIABLE LEVEL OtherVict_10 (SCALE).
ALTER TYPE OtherVict_10 (F7.0).
FORMATS OtherVict_10 (F7.0). 
VARIABLE LABELS OtherVict_10 "What percentage of the adult population would agree: A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.".
VALUE LABELS OtherVict_10 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_21_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_11.
MISSING VALUES OtherVict_11 (-9).
VARIABLE LEVEL OtherVict_11 (SCALE).
ALTER TYPE OtherVict_11 (F7.0).
FORMATS OtherVict_11 (F7.0). 
VARIABLE LABELS OtherVict_11 "What percentage of the adult population would agree: If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.".
VALUE LABELS OtherVict_11 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_22_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_11.
MISSING VALUES OtherPerp_11 (-9).
VARIABLE LEVEL OtherPerp_11 (SCALE).
ALTER TYPE OtherPerp_11 (F7.0).
FORMATS OtherPerp_11 (F7.0). 
VARIABLE LABELS OtherPerp_11 "What percentage of the adult population would agree: Intoxication does not make the assailant innocent of sexual assault.".
VALUE LABELS OtherPerp_11 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_23_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_12.
MISSING VALUES OtherVict_12 (-9).
VARIABLE LEVEL OtherVict_12 (SCALE).
ALTER TYPE OtherVict_12 (F7.0).
FORMATS OtherVict_12 (F7.0). 
VARIABLE LABELS OtherVict_12 "What percentage of the adult population would agree: If the accused individual was not convicted of sexual assault, it means he/she is innocent.".
VALUE LABELS OtherVict_12 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_24_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_12.
MISSING VALUES OtherPerp_12 (-9).
VARIABLE LEVEL OtherPerp_12 (SCALE).
ALTER TYPE OtherPerp_12 (F7.0).
FORMATS OtherPerp_12 (F7.0). 
VARIABLE LABELS OtherPerp_12 "What percentage of the adult population would agree: Sexual assault can occur between a husband and a wife.".
VALUE LABELS OtherPerp_12 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_25_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherVict_13.
MISSING VALUES OtherVict_13 (-9).
VARIABLE LEVEL OtherVict_13 (SCALE).
ALTER TYPE OtherVict_13 (F7.0).
FORMATS OtherVict_13 (F7.0). 
VARIABLE LABELS OtherVict_13 "What percentage of the adult population would agree: If one person didn’t file sexual assault charges until later on, most likely nothing happened.".
VALUE LABELS OtherVict_13 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAother_26_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into OtherPerp_13.
MISSING VALUES OtherPerp_13 (-9).
VARIABLE LEVEL OtherPerp_13 (SCALE).
ALTER TYPE OtherPerp_13 (F7.0).
FORMATS OtherPerp_13 (F7.0). 
VARIABLE LABELS OtherPerp_13 "What percentage of the adult population would agree: Men can be victims of sexual assault.".
VALUE LABELS OtherPerp_13 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

*Recode the sexual assault estimation of women's opinions statements to be numeric (question asking "What percentage of women would agree").

RECODE SAwomen_1_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into  WomenPerp_1.
MISSING VALUES  WomenPerp_1 (-9).
VARIABLE LEVEL  WomenPerp_1 (SCALE).
ALTER TYPE  WomenPerp_1 (F7.0).
FORMATS  WomenPerp_1 (F7.0). 
VARIABLE LABELS  WomenPerp_1 "What percentage of women would agree: Even if a person didn’t physically resist sex, it can still be sexual assault.".
VALUE LABELS  WomenPerp_1 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_2_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into  WomenPerp_2.
MISSING VALUES  WomenPerp_2 (-9).
VARIABLE LEVEL  WomenPerp_2 (SCALE).
ALTER TYPE  WomenPerp_2 (F7.0).
FORMATS  WomenPerp_2 (F7.0). 
VARIABLE LABELS  WomenPerp_2 "What percentage of women would agree: It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.(NUM)".
VALUE LABELS  WomenPerp_2 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_3_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into  WomenPerp_3.
MISSING VALUES  WomenPerp_3 (-9).
VARIABLE LEVEL  WomenPerp_3 (SCALE).
ALTER TYPE  WomenPerp_3 (F7.0).
FORMATS  WomenPerp_3 (F7.0). 
VARIABLE LABELS WomenPerp_3 "What percentage of women would agree: Even if a person didnt physically resist sex, it can still be sexual assault.".
VALUE LABELS  WomenPerp_3 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_4_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenPerp_4.
MISSING VALUES WomenPerp_4 (-9).
VARIABLE LEVEL WomenPerp_4 (SCALE).
ALTER TYPE  WomenPerp_4 (F7.0).
FORMATS  WomenPerp_4 (F7.0). 
VARIABLE LABELS  WomenPerp_4 "What percentage of women would agree: Promiscuous actions dont legitimize sexual assault.".
VALUE LABELS  WomenPerp_4 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_5_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_1.
MISSING VALUES WomenVict_1 (-9).
VARIABLE LEVEL  WomenVict_1 (SCALE).
ALTER TYPE  WomenVict_1 (F7.0).
FORMATS  WomenVict_1 (F7.0). 
VARIABLE LABELS  WomenVict_1 "What percentage of women would agree: If someone initiates kissing or hooking up, they can't be surprised if someone assumes they want to have sex.".
VALUE LABELS  WomenVict_1 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_6_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenPerp_5.
MISSING VALUES  WomenPerp_5 (-9).
VARIABLE LEVEL  WomenPerp_5 (SCALE).
ALTER TYPE  WomenPerp_5 (F7.0).
FORMATS  WomenPerp_5 (F7.0). 
VARIABLE LABELS  WomenPerp_5 "What percentage of women would agree: Dressing provocatively does not justify sexual assault.".
VALUE LABELS  WomenPerp_5 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_7_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into  WomenPerp_6.
MISSING VALUES  WomenPerp_6 (-9).
VARIABLE LEVEL  WomenPerp_6 (SCALE).
ALTER TYPE  WomenPerp_6 (F7.0).
FORMATS  WomenPerp_6 (F7.0). 
VARIABLE LABELS  WomenPerp_6 "What percentage of women would agree:  If the accused person was found not guilty, it does not mean that sexual assault did not occur.".
VALUE LABELS  WomenPerp_6 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_8_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into  WomenPerp_7.
MISSING VALUES  WomenPerp_7 (-9).
VARIABLE LEVEL  WomenPerp_7 (SCALE).
ALTER TYPE  WomenPerp_7 (F7.0).
FORMATS  WomenPerp_7 (F7.0). 
VARIABLE LABELS  WomenPerp_7 "What percentage of women would agree: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past.".
VALUE LABELS  WomenPerp_7 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_9_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_2.
MISSING VALUES WomenVict_2 (-9).
VARIABLE LEVEL WomenVict_2 (SCALE).
ALTER TYPE WomenVict_2 (F7.0).
FORMATS WomenVict_2 (F7.0). 
VARIABLE LABELS WomenVict_2 "What percentage of women would agree: Women cannot be considered victims of sexual assault by their husbands.".
VALUE LABELS WomenVict_2 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_10_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_3.
MISSING VALUES WomenVict_3 (-9).
VARIABLE LEVEL WomenVict_3 (SCALE).
ALTER TYPE WomenVict_3 (F7.0).
FORMATS WomenVict_3 (F7.0). 
VARIABLE LABELS WomenVict_3 "What percentage of women would agree: If a person goes home with someone, they assume the risk of sexual assault.".
VALUE LABELS WomenVict_3 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_11_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenPerp_8.
MISSING VALUES WomenPerp_8 (-9).
VARIABLE LEVEL WomenPerp_8 (SCALE).
ALTER TYPE WomenPerp_8 (F7.0).
FORMATS WomenPerp_8 (F7.0). 
VARIABLE LABELS WomenPerp_8 "What percentage of women would agree: It is still sexual assault, even if charges werent filed immediately.".
VALUE LABELS WomenPerp_8 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_12_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_4.
MISSING VALUES WomenVict_4 (-9).
VARIABLE LEVEL WomenVict_4 (SCALE).
ALTER TYPE WomenVict_4 (F7.0).
FORMATS WomenVict_4 (F7.0). 
VARIABLE LABELS WomenVict_4 "What percentage of women would agree: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.".
VALUE LABELS WomenVict_4 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_13_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenPerp_9.
MISSING VALUES WomenPerp_9 (-9).
VARIABLE LEVEL WomenPerp_9 (SCALE).
ALTER TYPE WomenPerp_9 (F7.0).
FORMATS WomenPerp_9 (F7.0). 
VARIABLE LABELS WomenPerp_9 "What percentage of women would agree: When someone cannot verbally or physically resist sex due to fear, it is sexual assault.".
VALUE LABELS WomenPerp_9 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_14_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_5.
MISSING VALUES WomenVict_5 (-9).
VARIABLE LEVEL WomenVict_5 (SCALE).
ALTER TYPE WomenVict_5 (F7.0).
FORMATS WomenVict_5 (F7.0). 
VARIABLE LABELS WomenVict_5 "What percentage of women would agree: If one person changed their mind midway through a consensual act then it wasnt sexual assault.".
VALUE LABELS WomenVict_5 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_15_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenPerp_10.
MISSING VALUES WomenPerp_10 (-9).
VARIABLE LEVEL WomenPerp_10 (SCALE).
ALTER TYPE WomenPerp_10 (F7.0).
FORMATS WomenPerp_10 (F7.0). 
VARIABLE LABELS WomenPerp_10 "What percentage of women would agree: Initiating kissing or hooking up is not consent to sex (NUM)".
VALUE LABELS WomenPerp_10 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_16_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_6.
MISSING VALUES WomenVict_6 (-9).
VARIABLE LEVEL WomenVict_6 (SCALE).
ALTER TYPE WomenVict_6 (F7.0).
FORMATS WomenVict_6 (F7.0). 
VARIABLE LABELS WomenVict_6 "What percentage of women would agree: Women provoke sexual assaults when they dress provocatively.".
VALUE LABELS WomenVict_6 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_17_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_7.
MISSING VALUES WomenVict_7 (-9).
VARIABLE LEVEL WomenVict_7 (SCALE).
ALTER TYPE WomenVict_7 (F7.0).
FORMATS WomenVict_7 (F7.0). 
VARIABLE LABELS WomenVict_7 "What percentage of women would agree: If someone doesn’t resist physically, it is not sexual assault.".
VALUE LABELS WomenVict_7 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_18_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_8.
MISSING VALUES WomenVict_8 (-9).
VARIABLE LEVEL WomenVict_8 (SCALE).
ALTER TYPE WomenVict_8 (F7.0).
FORMATS WomenVict_8 (F7.0). 
VARIABLE LABELS WomenVict_8 "What percentage of women would agree: It’s not sexual assault if the accused has had sex with that person before.".
VALUE LABELS WomenVict_8 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_19_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_9.
MISSING VALUES WomenVict_9 (-9).
VARIABLE LEVEL WomenVict_9 (SCALE).
ALTER TYPE WomenVict_9 (F7.0).
FORMATS WomenVict_9 (F7.0). 
VARIABLE LABELS WomenVict_9 "What percentage of women would agree: People provoke sexual assaults when they act in a promiscuous manner.".
VALUE LABELS WomenVict_9 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_20_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_10.
MISSING VALUES WomenVict_10 (-9).
VARIABLE LEVEL WomenVict_10 (SCALE).
ALTER TYPE WomenVict_10 (F7.0).
FORMATS WomenVict_10 (F7.0). 
VARIABLE LABELS WomenVict_10 "What percentage of women would agree: A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.".
VALUE LABELS WomenVict_10 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_21_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_11.
MISSING VALUES WomenVict_11 (-9).
VARIABLE LEVEL WomenVict_11 (SCALE).
ALTER TYPE WomenVict_11 (F7.0).
FORMATS WomenVict_11 (F7.0). 
VARIABLE LABELS WomenVict_11 "What percentage women would agree: If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.".
VALUE LABELS WomenVict_11 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_22_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenPerp_11.
MISSING VALUES WomenPerp_11 (-9).
VARIABLE LEVEL WomenPerp_11 (SCALE).
ALTER TYPE WomenPerp_11 (F7.0).
FORMATS WomenPerp_11 (F7.0). 
VARIABLE LABELS WomenPerp_11 "What percentage women would agree: Intoxication does not make the assailant innocent of sexual assault.".
VALUE LABELS WomenPerp_11 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_23_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_12.
MISSING VALUES WomenVict_12 (-9).
VARIABLE LEVEL WomenVict_12 (SCALE).
ALTER TYPE WomenVict_12 (F7.0).
FORMATS WomenVict_12 (F7.0). 
VARIABLE LABELS WomenVict_12 "What percentage of women would agree: If the accused individual was not convicted of sexual assault, it means he/she is innocent.".
VALUE LABELS WomenVict_12 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_24_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenPerp_12.
MISSING VALUES WomenPerp_12 (-9).
VARIABLE LEVEL WomenPerp_12 (SCALE).
ALTER TYPE WomenPerp_12 (F7.0).
FORMATS WomenPerp_12 (F7.0). 
VARIABLE LABELS WomenPerp_12 "What percentage of women would agree: Sexual assault can occur between a husband and a wife.".
VALUE LABELS WomenPerp_12 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_25_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenVict_13.
MISSING VALUES WomenVict_13 (-9).
VARIABLE LEVEL WomenVict_13 (SCALE).
ALTER TYPE WomenVict_13 (F7.0).
FORMATS WomenVict_13 (F7.0). 
VARIABLE LABELS WomenVict_13 "What percentage of women would agree: If one person didn’t file sexual assault charges until later on, most likely nothing happened.".
VALUE LABELS WomenVict_13 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAwomen_26_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into WomenPerp_13.
MISSING VALUES WomenPerp_13 (-9).
VARIABLE LEVEL WomenPerp_13 (SCALE).
ALTER TYPE WomenPerp_13 (F7.0).
FORMATS WomenPerp_13 (F7.0). 
VARIABLE LABELS WomenPerp_13 "What percentage of women would agree: Men can be victims of sexual assault.".
VALUE LABELS WomenPerp_13 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

*Recode the sexual assault estimation of men’s' opinions statements to be numeric (question asking "What percentage of men population would agree").

RECODE SAmen_1_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_1.
MISSING VALUES MenPerp_1 (-9).
VARIABLE LEVEL MenPerp_1 (SCALE).
ALTER TYPE MenPerp_1 (F7.0).
FORMATS MenPerp_1 (F7.0). 
VARIABLE LABELS MenPerp_1 "What percentage of men would agree: Even if a person didnt physically resist sex, it can still be sexual assault.".
VALUE LABELS MenPerp_1 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_2_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_2.
MISSING VALUES MenPerp_2 (-9).
VARIABLE LEVEL MenPerp_2 (SCALE).
ALTER TYPE MenPerp_2 (F7.0).
FORMATS MenPerp_2 (F7.0). 
VARIABLE LABELS MenPerp_2 "What percentage of men would agree: It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.(NUM)".
VALUE LABELS MenPerp_2 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_3_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_3.
MISSING VALUES MenPerp_3 (-9).
VARIABLE LEVEL MenPerp_3 (SCALE).
ALTER TYPE MenPerp_3 (F7.0).
FORMATS MenPerp_3 (F7.0). 
VARIABLE LABELS MenPerp_3 "What percentage of men would agree: Even if a person didnt physically resist sex, it can still be sexual assault.".
VALUE LABELS MenPerp_3 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_4_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_4.
MISSING VALUES MenPerp_4 (-9).
VARIABLE LEVEL MenPerp_4 (SCALE).
ALTER TYPE MenPerp_4 (F7.0).
FORMATS MenPerp_4 (F7.0). 
VARIABLE LABELS MenPerp_4 "What percentage of men would agree: Promiscuous actions dont legitimize sexual assault.".
VALUE LABELS MenPerp_4 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_5_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_1.
MISSING VALUES MenVict_1 (-9).
VARIABLE LEVEL MenVict_1 (SCALE).
ALTER TYPE MenVict_1 (F7.0).
FORMATS MenVict_1 (F7.0). 
VARIABLE LABELS MenVict_1 "What percentage of men would agree: If someone initiates kissing or hooking up, they can't be surprised if someone assumes they want to have sex.".
VALUE LABELS MenVict_1 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_6_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_5.
MISSING VALUES MenPerp_5 (-9).
VARIABLE LEVEL MenPerp_5 (SCALE).
ALTER TYPE MenPerp_5 (F7.0).
FORMATS MenPerp_5 (F7.0). 
VARIABLE LABELS MenPerp_5 "What percentage of men would agree: Dressing provocatively does not justify sexual assault.".
VALUE LABELS MenPerp_5 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_7_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_6.
MISSING VALUES MenPerp_6 (-9).
VARIABLE LEVEL MenPerp_6 (SCALE).
ALTER TYPE MenPerp_6 (F7.0).
FORMATS MenPerp_6 (F7.0). 
VARIABLE LABELS MenPerp_6 "What percentage of men would agree:  If the accused person was found not guilty, it does not mean that sexual assault did not occur.".
VALUE LABELS MenPerp_6 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_8_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_7.
MISSING VALUES MenPerp_7 (-9).
VARIABLE LEVEL MenPerp_7 (SCALE).
ALTER TYPE MenPerp_7 (F7.0).
FORMATS MenPerp_7 (F7.0). 
VARIABLE LABELS MenPerp_7 "What percentage of men would agree: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past.".
VALUE LABELS MenPerp_7 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_9_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_2.
MISSING VALUES MenVict_2 (-9).
VARIABLE LEVEL MenVict_2 (SCALE).
ALTER TYPE MenVict_2 (F7.0).
FORMATS MenVict_2 (F7.0). 
VARIABLE LABELS MenVict_2 "What percentage of men would agree: Women cannot be considered victims of sexual assault by their husbands.".
VALUE LABELS MenVict_2 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_10_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_3.
MISSING VALUES MenVict_3 (-9).
VARIABLE LEVEL MenVict_3 (SCALE).
ALTER TYPE MenVict_3 (F7.0).
FORMATS MenVict_3 (F7.0). 
VARIABLE LABELS MenVict_3 "What percentage of men would agree: If a person goes home with someone, they assume the risk of sexual assault.".
VALUE LABELS MenVict_3 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_11_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_8.
MISSING VALUES MenPerp_8 (-9).
VARIABLE LEVEL MenPerp_8 (SCALE).
ALTER TYPE MenPerp_8 (F7.0).
FORMATS MenPerp_8 (F7.0). 
VARIABLE LABELS MenPerp_8 "What percentage of men would agree: It is still sexual assault, even if charges werent filed immediately.".
VALUE LABELS MenPerp_8 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_12_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_4.
MISSING VALUES MenVict_4 (-9).
VARIABLE LEVEL MenVict_4 (SCALE).
ALTER TYPE MenVict_4 (F7.0).
FORMATS MenVict_4 (F7.0). 
VARIABLE LABELS MenVict_4 "What percentage of men would agree: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.".
VALUE LABELS MenVict_4 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_13_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_9.
MISSING VALUES MenPerp_9 (-9).
VARIABLE LEVEL MenPerp_9 (SCALE).
ALTER TYPE MenPerp_9 (F7.0).
FORMATS MenPerp_9 (F7.0). 
VARIABLE LABELS MenPerp_9 "What percentage of men would agree: When someone cannot verbally or physically resist sex due to fear, it is sexual assault.".
VALUE LABELS MenPerp_9 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_14_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_5.
MISSING VALUES MenVict_5 (-9).
VARIABLE LEVEL MenVict_5 (SCALE).
ALTER TYPE MenVict_5 (F7.0).
FORMATS MenVict_5 (F7.0). 
VARIABLE LABELS MenVict_5 "What percentage of men would agree: If one person changed their mind midway through a consensual act then it wasnt sexual assault.".
VALUE LABELS MenVict_5 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_15_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_10.
MISSING VALUES MenPerp_10 (-9).
VARIABLE LEVEL MenPerp_10 (SCALE).
ALTER TYPE MenPerp_10 (F7.0).
FORMATS MenPerp_10 (F7.0). 
VARIABLE LABELS MenPerp_10 "What percentage of men would agree: Initiating kissing or hooking up is not consent to sex (NUM)".
VALUE LABELS MenPerp_10 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_16_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_6.
MISSING VALUES MenVict_6 (-9).
VARIABLE LEVEL MenVict_6 (SCALE).
ALTER TYPE MenVict_6 (F7.0).
FORMATS MenVict_6 (F7.0). 
VARIABLE LABELS MenVict_6 "What percentage of men would agree: Women provoke sexual assaults when they dress provocatively.".
VALUE LABELS MenVict_6 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_17_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_7.
MISSING VALUES MenVict_7 (-9).
VARIABLE LEVEL MenVict_7 (SCALE).
ALTER TYPE MenVict_7 (F7.0).
FORMATS MenVict_7 (F7.0). 
VARIABLE LABELS MenVict_7 "What percentage of men would agree: If someone doesn’t resist physically, it is not sexual assault.".
VALUE LABELS MenVict_7 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_18_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_8.
MISSING VALUES MenVict_8 (-9).
VARIABLE LEVEL MenVict_8 (SCALE).
ALTER TYPE MenVict_8 (F7.0).
FORMATS MenVict_8 (F7.0). 
VARIABLE LABELS MenVict_8 "What percentage of men would agree: It’s not sexual assault if the accused has had sex with that person before.".
VALUE LABELS MenVict_8 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_19_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_9.
MISSING VALUES MenVict_9 (-9).
VARIABLE LEVEL MenVict_9 (SCALE).
ALTER TYPE MenVict_9 (F7.0).
FORMATS MenVict_9 (F7.0). 
VARIABLE LABELS MenVict_9 "What percentage of men would agree: People provoke sexual assaults when they act in a promiscuous manner.".
VALUE LABELS MenVict_9 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_20_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_10.
MISSING VALUES MenVict_10 (-9).
VARIABLE LEVEL MenVict_10 (SCALE).
ALTER TYPE MenVict_10 (F7.0).
FORMATS MenVict_10 (F7.0). 
VARIABLE LABELS MenVict_10 "What percentage of men would agree: A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.".
VALUE LABELS MenVict_10 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_21_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_11.
MISSING VALUES MenVict_11 (-9).
VARIABLE LEVEL MenVict_11 (SCALE).
ALTER TYPE MenVict_11 (F7.0).
FORMATS MenVict_11 (F7.0). 
VARIABLE LABELS MenVict_11 "What percentage men would agree: If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.".
VALUE LABELS MenVict_11 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_22_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_11.
MISSING VALUES MenPerp_11 (-9).
VARIABLE LEVEL MenPerp_11 (SCALE).
ALTER TYPE MenPerp_11 (F7.0).
FORMATS MenPerp_11 (F7.0). 
VARIABLE LABELS MenPerp_11 "What percentage men would agree: Intoxication does not make the assailant innocent of sexual assault.".
VALUE LABELS MenPerp_11 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_23_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_12.
MISSING VALUES MenVict_12 (-9).
VARIABLE LEVEL MenVict_12 (SCALE).
ALTER TYPE MenVict_12 (F7.0).
FORMATS MenVict_12 (F7.0). 
VARIABLE LABELS MenVict_12 "What percentage of men would agree: If the accused individual was not convicted of sexual assault, it means he/she is innocent.".
VALUE LABELS MenVict_12 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_24_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_12.
MISSING VALUES MenPerp_12 (-9).
VARIABLE LEVEL MenPerp_12 (SCALE).
ALTER TYPE MenPerp_12 (F7.0).
FORMATS MenPerp_12 (F7.0). 
VARIABLE LABELS MenPerp_12 "What percentage of men would agree: Sexual assault can occur between a husband and a wife.".
VALUE LABELS MenPerp_12 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_25_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenVict_13.
MISSING VALUES MenVict_13 (-9).
VARIABLE LEVEL MenVict_13 (SCALE).
ALTER TYPE MenVict_13 (F7.0).
FORMATS MenVict_13 (F7.0). 
VARIABLE LABELS MenVict_13 "What percentage of men would agree: If one person didn’t file sexual assault charges until later on, most likely nothing happened.".
VALUE LABELS MenVict_13 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.

RECODE SAmen_26_OLD (0 = 0) (25 = 25) (50=50) (75=75) (100=100) (MISSING=SYSMIS) into MenPerp_13.
MISSING VALUES MenPerp_13 (-9).
VARIABLE LEVEL MenPerp_13 (SCALE).
ALTER TYPE MenPerp_13 (F7.0).
FORMATS MenPerp_13 (F7.0). 
VARIABLE LABELS MenPerp_13 "What percentage of men would agree: Men can be victims of sexual assault.".
VALUE LABELS MenPerp_13 0 '0%' 25 '25%' 50 '50%' 75 '75%' 100 '100%'.


*Recode the general fact/belief binary statements as numeric (question asking, "Is this statement a fact or a belief?").
*Belief = 0 and fact = 1.

RECODE SAFB_1_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_1.
MISSING VALUES FBPerp_1 (-9).
VARIABLE LEVEL FBPerp_1 (NOMINAL).
ALTER TYPE FBPerp_1 (F7.0). 
FORMATS FBPerp_1 (F7.6). 
VARIABLE LABELS FBPerp_1 "Is this a fact or belief: Even if a person didnt physically resist sex, it can still be sexual assault.".
VALUE LABELS FBPerp_1 0 'Belief' 1 'Fact'.

RECODE SAFB_2_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_2.
MISSING VALUES FBPerp_2 (-9).
VARIABLE LEVEL FBPerp_2 (NOMINAL).
ALTER TYPE FBPerp_2 (F7.0).
FORMATS FBPerp_2 (F7.6). 
VARIABLE LABELS FBPerp_2 "Is this a fact or belief: It is sexual assault even if the act was consensual at the beginning, but the victim changed their mind at some point.".
VALUE LABELS FBPerp_2 0 'Belief' 1 'Fact'.

RECODE SAFB_3_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_3.
MISSING VALUES FBPerp_3 (-9).
VARIABLE LEVEL FBPerp_3 (NOMINAL).
ALTER TYPE FBPerp_3 (F7.0).
FORMATS FBPerp_3 (F7.6). 
VARIABLE LABELS FBPerp_3 "Is this a fact or belief: The perpetrator is still guilty of sexual assault even if the victim went home with them.".
VALUE LABELS FBPerp_3 0 'Belief' 1 'Fact'. 

RECODE SAFB_4_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_4.
MISSING VALUES FBPerp_4 (-9).
VARIABLE LEVEL FBPerp_4 (NOMINAL).
ALTER TYPE FBPerp_4 (F7.0).
FORMATS FBPerp_4 (F7.6). 
VARIABLE LABELS FBPerp_4 "Is this a fact or belief:  Promiscuous actions don’t legitimize sexual assault.".
VALUE LABELS FBPerp_4 0 'Belief' 1 'Fact'.

* Encoding: UTF-8.
RECODE SAFB_5_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_1.
MISSING VALUES FBVict_1 (-9).
VARIABLE LEVEL FBVict_1 (NOMINAL).
ALTER TYPE FBVict_1 (F7.0).
FORMATS FBVict_1 (F7.6). 
VARIABLE LABELS FBVict_1 "Is this a fact or belief: If someone initiates kissing or hooking up, they cant be surprised if someone assumes they want to have sex.".
VALUE LABELS FBVict_1 0 'Belief' 1 'Fact'.

RECODE SAFB_6_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_5.
MISSING VALUES FBPerp_5 (-9).
VARIABLE LEVEL FBPerp_5 (NOMINAL).
ALTER TYPE FBPerp_5 (F7.0).
FORMATS FBPerp_5 (F7.6). 
VARIABLE LABELS FBPerp_5"Is this a fact or belief: Dressing provocatively does not justify sexual assault.".
VALUE LABELS FBPerp_5 0 'Belief' 1 'Fact'.

RECODE SAFB_7_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_6.
MISSING VALUES FBPerp_6 (-9).
VARIABLE LEVEL FBPerp_6 (NOMINAL).
ALTER TYPE FBPerp_6 (F7.0).
FORMATS FBPerp_6 ( F7.6). 
VARIABLE LABELS FBPerp_6 "Is this a fact or belief: If the accused person was found not guilty, it does not mean that sexual assault did not occur.".
VALUE LABELS FBPerp_6 0 'Belief' 1 'Fact'.

RECODE SAFB_8_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_7.
MISSING VALUES FBPerp_7 (-9).
VARIABLE LEVEL FBPerp_7 (NOMINAL).
ALTER TYPE FBPerp_7 (F7.0).
FORMATS FBPerp_7 (F7.6). 
VARIABLE LABELS FBPerp_7 "Is this a fact or belief: It is still sexual assault, even if the victim has had consensual sex with the perpetrator in the past.".
VALUE LABELS FBPerp_7 0 'Belief' 1 'Fact'.

RECODE SAFB_9_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_2.
MISSING VALUES FBVict_2 (-9).
VARIABLE LEVEL FBVict_2 (NOMINAL).
ALTER TYPE FBVict_2 (F7.0).
FORMATS FBVict_2 (F7.6). 
VARIABLE LABELS FBVict_2 "Is this a fact or belief: Women cannot be considered victims of sexual assault by their husbands.".
VALUE LABELS FBVict_2 0 'Belief' 1 'Fact'.

RECODE SAFB_10_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_3.
MISSING VALUES FBVict_3 (-9).
VARIABLE LEVEL FBVict_3 (NOMINAL).
ALTER TYPE FBVict_3 (F7.0).
FORMATS FBVict_3 (F7.6). 
VARIABLE LABELS FBVict_3 "Is this a fact or belief: If a person goes home with someone, they assume the risk of sexual assault.".
VALUE LABELS FBVict_3 0 'Belief' 1 'Fact'.

*Note belief spelled wrong here in raw data.
RECODE SAFB_11_OLD ('beleif' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_8.
MISSING VALUES FBPerp_8 (-9).
VARIABLE LEVEL FBPerp_8 (NOMINAL).
ALTER TYPE FBPerp_8 (F7.0).
FORMATS FBPerp_8 (F7.6). 
VARIABLE LABELS FBPerp_8 "Is this a fact or belief: It is still sexual assault, even if charges werent filed immediately.".
VALUE LABELS FBPerp_8 0 'Belief' 1 'Fact'.

RECODE SAFB_12_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_4.
MISSING VALUES FBVict_4 (-9).
VARIABLE LEVEL FBVict_4 (NOMINAL).
ALTER TYPE FBVict_4 (F7.0).
FORMATS FBVict_4 (F7.6). 
VARIABLE LABELS FBVict_4 "Is this a fact or belief: If the attacker was intoxicated, it is not their fault and they should not be charged with sexual assault.".
VALUE LABELS FBVict_4 0 'Belief' 1 'Fact'.

RECODE SAFB_13_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_9.
MISSING VALUES FBPerp_9 (-9).
VARIABLE LEVEL FBPerp_9 (NOMINAL).
ALTER TYPE FBPerp_9 (F7.0).
FORMATS FBPerp_9 (F7.6). 
VARIABLE LABELS FBPerp_9 "Is this a fact or belief: When someone cannot verbally or physically resist sex due to fear, it is sexual assault.".
VALUE LABELS FBPerp_9 0 'Belief' 1 'Fact'.

RECODE SAFB_14_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_5.
MISSING VALUES FBVict_5 (-9).
VARIABLE LEVEL FBVict_5 (NOMINAL).
ALTER TYPE FBVict_5 (F7.0).
FORMATS FBVict_5 (F7.6). 
VARIABLE LABELS FBVict_5 "Is this a fact or belief: If one person changed their mind midway through a consensual act then it wasnt sexual assault.".
VALUE LABELS FBVict_5 0 'Belief' 1 'Fact'.

RECODE SAFB_15_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_10.
MISSING VALUES FBPerp_10 (-9).
VARIABLE LEVEL FBPerp_10 (NOMINAL).
ALTER TYPE FBPerp_10 (F7.0).
FORMATS FBPerp_10 (F7.6). 
VARIABLE LABELS FBPerp_10 "Is this a fact or belief: Initiating kissing or hooking up is not consent to sex (NUM)".
VALUE LABELS FBPerp_10 0 'Belief' 1 'Fact'.

RECODE SAFB_16_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_6.
MISSING VALUES FBVict_6 (-9).
VARIABLE LEVEL FBVict_6 (NOMINAL).
ALTER TYPE FBVict_6 (F7.0).
FORMATS FBVict_6 (F7.6). 
VARIABLE LABELS FBVict_6 "Is this a fact or belief: Women provoke sexual assaults when they dress provocatively.".
VALUE LABELS FBVict_6 0 'Belief' 1 'Fact'.

RECODE SAFB_17_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_7.
MISSING VALUES FBVict_7 (-9).
VARIABLE LEVEL FBVict_7 (NOMINAL).
ALTER TYPE FBVict_7 (F7.0).
FORMATS FBVict_7 (F7.6). 
VARIABLE LABELS FBVict_7 "Is this a fact or belief:  If someone doesn’t resist physically, it is not sexual assault.".
VALUE LABELS FBVict_7 0 'Belief' 1 'Fact'.

RECODE SAFB_18_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_8.
MISSING VALUES FBVict_8 (-9).
VARIABLE LEVEL FBVict_8  (NOMINAL).
ALTER TYPE FBVict_8  (F7.6).
FORMATS FBVict_8  (F7.6). 
VARIABLE LABELS FBVict_8 "Is this a fact or belief:  It’s not sexual assault if the accused has had sex with that person before.".
VALUE LABELS FBVict_8 0 'Belief' 1 'Fact'.

RECODE SAFB_19_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_9.
MISSING VALUES FBVict_9 (-9).
VARIABLE LEVEL FBVict_9 (NOMINAL).
ALTER TYPE FBVict_9 (F7.0).
FORMATS FBVict_9 (F7.6). 
VARIABLE LABELS FBVict_9 "Is this a fact or belief:  People provoke sexual assaults when they act in a promiscuous manner.".
VALUE LABELS FBVict_9 0 'Belief' 1 'Fact'.

RECODE SAFB_20_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_10.
MISSING VALUES FBVict_10 (-9).
VARIABLE LEVEL FBVict_10 (NOMINAL).
ALTER TYPE FBVict_10 (F7.0).
FORMATS FBVict_10 (F7.6). 
VARIABLE LABELS FBVict_10 "Is this a fact or belief: A man cannot be sexually assaulted because he couldve taken care of himself and fought off the other person.".
VALUE LABELS FBVict_10 0 'Belief' 1 'Fact'.

RECODE SAFB_21_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_11.
MISSING VALUES FBVict_11 (-9).
VARIABLE LEVEL FBVict_11 (NOMINAL).
ALTER TYPE FBVict_11 (F7.0).
FORMATS FBVict_11 (F7.6). 
VARIABLE LABELS FBVict_11 "Is this a fact or belief: If someone doesn’t resist sex verbally or physically because they are afraid, it can’t be considered sexual assault.".
VALUE LABELS FBVict_11 0 'Belief' 1 'Fact'.

RECODE SAFB_22_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_11.
MISSING VALUES FBPerp_11 (-9).
VARIABLE LEVEL FBPerp_11 (NOMINAL).
ALTER TYPE FBPerp_11 (F7.0).
FORMATS FBPerp_11 (F7.6). 
VARIABLE LABELS FBPerp_11 "Is this a fact or belief: Intoxication does not make the assailant innocent of sexual assault.".
VALUE LABELS FBPerp_11 0 'Belief' 1 'Fact'.

RECODE SAFB_23_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_12.
MISSING VALUES FBVict_12 (-9).
VARIABLE LEVEL FBVict_12 (NOMINAL).
ALTER TYPE FBVict_12 (F7.0).
FORMATS FBVict_12 (F7.6). 
VARIABLE LABELS FBVict_12 "Is this a fact or belief: If the accused individual was not convicted of sexual assault, it means he/she is innocent.".
VALUE LABELS FBVict_12 0 'Belief' 1 'Fact'.

RECODE SAFB_24_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_12.
MISSING VALUES FBPerp_12 (-9).
VARIABLE LEVEL FBPerp_12 (NOMINAL).
ALTER TYPE FBPerp_12 (F7.0).
FORMATS FBPerp_12 (F7.6). 
VARIABLE LABELS FBPerp_12 "Is this a fact or belief: Sexual assault can occur between a husband and a wife.".
VALUE LABELS FBPerp_12 0 'Belief' 1 'Fact'.

RECODE SAFB_25_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBVict_13.
MISSING VALUES FBVict_13 (-9).
VARIABLE LEVEL FBVict_13 (NOMINAL).
ALTER TYPE FBVict_13 (F7.0).
FORMATS FBVict_13 (F7.6). 
VARIABLE LABELS FBVict_13 "Is this a fact or belief: If one person didn’t file sexual assault charges until later on, most likely nothing happened.".
VALUE LABELS FBVict_13 0 'Belief' 1 'Fact'.

RECODE SAFB_26_OLD ('belief' = 0) ('fact' = 1) (MISSING=SYSMIS) into FBPerp_13.
MISSING VALUES FBPerp_13 (-9).
VARIABLE LEVEL FBPerp_13 (NOMINAL).
ALTER TYPE FBPerp_13 (F7.0).
FORMATS FBPerp_13 (F7.6). 
VARIABLE LABELS FBPerp_13  "Is this a fact or belief: Men can be victims of sexual assault.".
VALUE LABELS FBPerp_13 0 'Belief' 1 'Fact'.

* SAVE AS: Prepped file with new vars.

* Delete old variables that are no longer needed.

DELETE VARIABLES CollectorID EmailAddress session_OLD CustomData1 lang_OLD state genSelf_1_OLD genOther_1_OLD genFb_1_OLD 
genSelf_2_OLD genOther_2_OLD genFb_2_OLD genSelf_3_OLD genOther_3_OLD genFb_3_OLD genSelf_4_OLD genOther_4_OLD genFb_4_OLD 
genSelf_5_OLD genOther_5_OLD genFb_5_OLD genSelf_6_OLD genOther_6_OLD genFb_6_OLD genSelf_7_OLD genOther_7_OLD 
genFb_7_OLD genSelf_8_OLD genOther_8_OLD genFb_8_OLD genSelf_9_OLD genOther_9_OLD genFb_9_OLD genSelf_10_OLD 
genOther_10_OLD genFb_10_OLD genSelf_11_OLD genOther_11_OLD genFb_11_OLD genSelf_12_OLD genOther_12_OLD 
genFb_12_OLD genSelf_13_OLD genOther_13_OLD genFb_13_OLD genSelf_14_OLD genOther_14_OLD genFb_14_OLD genSelf_15_OLD 
genOther_15_OLD genFb_15_OLD genSelf_16_OLD genOther_16_OLD genFb_16_OLD genSelf_17_OLD genOther_17_OLD genFb_17_OLD 
genSelf_18_OLD genOther_18_OLD genFb_18_OLD genSelf_19_OLD genOther_19_OLD genFb_19_OLD genSelf_20_OLD genOther_20_OLD 
genFb_20_OLD SAself_1_OLD SAother_1_OLD SAWomen_1_OLD SAmen_1_OLD SAFB_1_OLD SAself_2_OLD SAother_2_OLD SAWomen_2_OLD 
SAmen_2_OLD SAFB_2_OLD SAself_3_OLD SAother_3_OLD SAWomen_3_OLD SAmen_3_OLD SAFB_3_OLD SAself_4_OLD SAother_4_OLD 
SAWomen_4_OLD SAmen_4_OLD SAFB_4_OLD SAself_5_OLD SAother_5_OLD SAWomen_5_OLD SAmen_5_OLD SAFB_5_OLD SAself_6_OLD 
SAother_6_OLD SAWomen_6_OLD SAmen_6_OLD SAFB_6_OLD SAself_7_OLD SAother_7_OLD SAWomen_7_OLD SAmen_7_OLD SAFB_7_OLD 
SAself_8_OLD SAother_8_OLD SAWomen_8_OLD SAmen_8_OLD SAFB_8_OLD SAself_9_OLD SAother_9_OLD SAWomen_9_OLD SAmen_9_OLD 
SAFB_9_OLD SAself_10_OLD SAother_10_OLD SAWomen_10_OLD SAmen_10_OLD SAFB_10_OLD SAself_11_OLD SAother_11_OLD 
SAWomen_11_OLD SAmen_11_OLD SAFB_11_OLD SAself_12_OLD SAother_12_OLD SAWomen_12_OLD SAmen_12_OLD SAFB_12_OLD 
SAself_13_OLD SAother_13_OLD SAWomen_13_OLD SAmen_13_OLD SAFB_13_OLD SAself_14_OLD SAother_14_OLD SAWomen_14_OLD 
SAmen_14_OLD SAFB_14_OLD SAself_15_OLD SAother_15_OLD SAWomen_15_OLD SAmen_15_OLD SAFB_15_OLD SAself_16_OLD 
SAother_16_OLD SAWomen_16_OLD SAmen_16_OLD SAFB_16_OLD SAself_17_OLD SAother_17_OLD SAWomen_17_OLD SAmen_17_OLD 
SAFB_17_OLD SAself_18_OLD SAother_18_OLD SAWomen_18_OLD SAmen_18_OLD SAFB_18_OLD SAself_19_OLD SAother_19_OLD 
SAWomen_19_OLD SAmen_19_OLD SAFB_19_OLD SAself_20_OLD SAother_20_OLD SAWomen_20_OLD SAmen_20_OLD SAFB_20_OLD 
SAself_21_OLD SAother_21_OLD SAWomen_21_OLD SAmen_21_OLD SAFB_21_OLD SAself_22_OLD SAother_22_OLD SAWomen_22_OLD 
SAmen_22_OLD SAFB_22_OLD SAself_23_OLD SAother_23_OLD SAWomen_23_OLD SAmen_23_OLD SAFB_23_OLD SAself_24_OLD 
SAother_24_OLD SAWomen_24_OLD SAmen_24_OLD SAFB_24_OLD SAself_25_OLD SAother_25_OLD SAWomen_25_OLD SAmen_25_OLD 
SAFB_25_OLD SAself_26_OLD SAother_26_OLD SAWomen_26_OLD SAmen_26_OLD SAFB_26_OLD polSoc_OLD polEco_OLD polGen_OLD
sexOrien_OLD relPrac_OLD fearNow race_OLD gender.

***************************************************************DATA CLEANING***************************************************************

 * Data cleaning: Syntax related to exclusions, creation of new variables for analyses, scale 
    formation, and other relevant syntax.

*** Flagging and filtering participants ***
    
*Flag those who indicate that English is not their first language.

IF (lang = 1) flagLang=1.
VARIABLE LABELS  flaglang 'Flagged if participants report that their first language is not English.'.
VARIABLE LEVEL flaglang (SCALE).
FORMATS flaglang (F8.0).
EXECUTE.

FREQUENCIES FlagLang.
*16.

*Flag if took less than 10 minutes and more than an hour.

*Time taken to complete survey from Qualtrics. 
COMPUTE Time_Qualtrics=(EndDate - StartDate)/60.
VARIABLE LABELS Time_Qualtrics 'Qualtrics Time Taken to Complete Survey (in mins)'.
VARIABLE LEVEL Time_Qualtrics (SCALE).
MISSING VALUES Time_Qualtrics (-99).
FORMATS Time_Qualtrics (F8.0).
EXECUTE.

IF (Time_Qualtrics > 60) flagTime = 1.
IF (Time_Qualtrics < 10) flagTime = 1.
VARIABLE LABELS flagTime 'Flagged as 1 if deviated extremely from average survey time.'.
VARIABLE LEVEL flagTime (SCALE).
MISSING VALUES flagTime (-99).
FORMATS flagTime (F8.0).
EXECUTE.

FREQUENCIES flagTime.
*132.
*Note that the year was imported wrong. Raw data shows that the data was collected in the years and months outlined in the main paper.

*Examine whether there is variability in answers. 

*Within-person variability (used later to flag low variability in scales).

*General items for the self.
COMPUTE gSelf_SD=SD(gSelf_1, gSelf_2, gSelf_3, gSelf_4, gSelf_5, gSelf_6, gSelf_7, gSelf_8, gSelf_9, gSelf_10, gSelf_11, gSelf_12, gSelf_13, gSelf_14, gSelf_15, gSelf_16, gSelf_17, gSelf_18, gSelf_19, gSelf_20).
VARIABLE LABELS gSelf_SD "Within person variability for general items for the self".
MISSING VALUES gSelf_SD (-9).
VARIABLE LEVEL gSelf_SD (SCALE).
EXECUTE.

*General items for the population prediction.
COMPUTE gOther_SD=SD(gOther_1, gOther_2, gOther_3, gOther_4, gOther_5, gOther_6, gOther_7, gOther_8, gOther_9, gOther_10, gOther_11, gOther_12, gOther_13, gOther_14, gOther_15, gOther_16, gOther_17, gOther_18, gOther_19, gOther_20).
VARIABLE LABELS gOther_SD "Within person variability for general items for the population prediction".
MISSING VALUES gOther_SD (-9).
VARIABLE LEVEL gOther_SD (SCALE).
EXECUTE.

*General items for fact/belief.
COMPUTE gFB_SD=SD(gFb_1, gFb_2, gFb_3, gFb_4, gFb_5, gFb_6, gFb_7, gFb_8, gFb_9, gFb_10, gFb_11, gFb_12, gFb_13, gFb_14, gFb_15, gFb_16, gFb_17, gFb_18, gFb_19, gFb_20).
VARIABLE LABELS gFB_SD "Within person variability for fact/belief general items".
MISSING VALUES gFB_SD (-9).
VARIABLE LEVEL gFB_SD (SCALE).
EXECUTE.
     
*Victim and perpetrator blame items together (more likely to be variability compared to if they were each examined independently.

*Blame items for the self. 
COMPUTE SAself_SD=SD (selfVict_1,selfVict_2,selfVict_3,selfVict_4,selfVict_5,selfVict_6,selfVict_7,selfVict_8,
selfVict_9,selfVict_10,selfVict_11,selfVict_12,selfVict_13, selfPerp_1, selfPerp_2, selfPerp_3, selfPerp_4, 
selfPerp_5, selfPerp_6, selfPerp_7, selfPerp_8, selfPerp_9, selfPerp_10, selfPerp_11, selfPerp_12, selfPerp_13).
VARIABLE LABELS SAself_SD "Within person variability for blame items for the self".
MISSING VALUES SAself_SD (-9).
VARIABLE LEVEL SAself_SD (SCALE).
EXECUTE.

*Blame items for the population. 
COMPUTE SAother_SD=SD(OtherVict_1, OtherVict_2, OtherVict_3, OtherVict_4, OtherVict_5, OtherVict_6, OtherVict_7, OtherVict_8, 
OtherVict_9, OtherVict_10, OtherVict_11, OtherVict_12, OtherVict_13, OtherPerp_1,OtherPerp_2, OtherPerp_3,OtherPerp_4,
OtherPerp_5, OtherPerp_6, OtherPerp_7, OtherPerp_8, OtherPerp_9, OtherPerp_10, OtherPerp_11, OtherPerp_12, OtherPerp_13).
VARIABLE LABELS SAother_SD "Within person variability for blame items for the population".
MISSING VALUES SAother_SD (-9).
VARIABLE LEVEL SAother_SD (SCALE).
EXECUTE.

*Blame items for women. 
COMPUTE SAwomen_SD=SD (WomenVict_1, WomenVict_2, WomenVict_3, WomenVict_4, WomenVict_5, WomenVict_6, WomenVict_7, 
WomenVict_8, WomenVict_9, WomenVict_10, WomenVict_11, WomenVict_12, WomenVict_13, WomenPerp_1, WomenPerp_2, 
WomenPerp_3, WomenPerp_4, WomenPerp_5, WomenPerp_6, WomenPerp_7, WomenPerp_8, WomenPerp_9, WomenPerp_10, 
WomenPerp_11, WomenPerp_12, WomenPerp_13).
VARIABLE LABELS SAwomen_SD "Within person variability for blame items for women".
MISSING VALUES SAwomen_SD (-9).
VARIABLE LEVEL SAwomen_SD (SCALE).
EXECUTE.

*Blame items for men. 
COMPUTE SAmen_SD=SD (MenVict_1, MenVict_2, MenVict_3, MenVict_4, MenVict_5, MenVict_6, MenVict_7, MenVict_8, MenVict_9, 
MenVict_10, MenVict_11, MenVict_12, MenVict_13, MenPerp_1, MenPerp_2, MenPerp_3, MenPerp_4, MenPerp_5, MenPerp_6, 
MenPerp_7, MenPerp_8, MenPerp_9, MenPerp_10, MenPerp_11, MenPerp_12, MenPerp_13).
VARIABLE LABELS SAmen_SD "Within person variability for blame items for men".
MISSING VALUES SAmen_SD (-9).
VARIABLE LEVEL SAmen_SD (SCALE).
EXECUTE.

*Blame items for fact/belief.
COMPUTE SAFB1_SD=SD(FBVict_1, FBVict_2, FBVict_3, FBVict_4, FBVict_5, FBVict_6, FBVict_7, FBVict_8, FBVict_9, FBVict_10, FBVict_11, 
FBVict_12, FBVict_13, FBPerp_1, FBPerp_2, FBPerp_3, FBPerp_4, FBPerp_5, FBPerp_6, FBPerp_7, FBPerp_8, FBPerp_9, FBPerp_10, 
FBPerp_11, FBPerp_12, FBPerp_13).
VARIABLE LABELS SAFB1_SD "Within person variability for blame items fact/belief".
MISSING VALUES SAFB1_SD (-9).
VARIABLE LEVEL SAFB1_SD (SCALE).
EXECUTE.

*Frequencies for within-person variability.
FREQUENCIES gSelf_SD gOther_SD gFB_SD SAself_SD SAother_SD SAwomen_SD SAmen_SD SAFB1_SD
  /HISTOGRAM
  /ORDER=ANALYSIS.

*Count the number of scales for which within-person variability = 0.

COMPUTE LowVar = 0.
VARIABLE LABELS LowVar 'Number of scales for which within-person variability = 0'.
MISSING VALUES LowVar (-9). 
VARIABLE LEVEL LowVar (SCALE).
ALTER TYPE LowVar (F8.0).
EXECUTE.

DO REPEAT
LIST = gSelf_SD gOther_SD gFB_SD SAself_SD SAother_SD SAwomen_SD SAmen_SD SAFB1_SD.
 IF LIST = 0 
 LowVar = LowVar + 1.
END REPEAT.
EXECUTE.

*Create a flag for low variability on scales (i.e. if variability = 0 on two or more scales).
IF  (LowVar  = 2) flagLowVar=1.
IF (LowVar > 2) flagLowVar = 2.
VARIABLE LABELS  flagLowVar 'Flagged as 1 if variability = 0 on 1 scales and as 2 if variability = 0 on more than 2 scales.'.
VARIABLE LEVEL flagLowVar (SCALE).
FORMATS flagLowVar (F8.0).
EXECUTE.

FREQUENCIES flagLowVar.
*One flag: 18
*Two flags: 26.

*Flag those who indicate a fact is a belief and a belief is a fact.

*Facts 
*0 = beliefs
*1 = facts).

*A hammer is used to pound nails - FACT.
IF (gFb_1 = 0) fbFlag1 = 1.

*Children are happy and carefree - BELIEF.
IF (gFb_2 = 1) fbFlag2 = 1.

*Dogs are animals - FACT.
IF (gFb_3 = 0) fbFlag3 = 1.

*A pen is for writing - FACT.
IF (gFb_4 = 0) fbFlag4 = 1.

*The telephone is the greatest invention of all time - BELIEF.
IF (gFb_5 = 1) fbFlag5 = 1.

*There are three colors in the American flag - FACT.
IF (gFb_6 = 0) fbFlag6 = 1.

*There are seven days in a week - FACT.
IF (gFb_7 = 0) fbFlag7 = 1.

*Christmas is a holiday primarily for children - BELIEF.
IF (gFb_8 = 1) fbFlag8 = 1.

*Sleeping with the window open is good for you - BELIEF.
IF (gFb_9 = 1) fbFlag9 = 1.

*Thermometers are used to measure temperature FACT.
IF (gFb_10 = 0) fbFlag10 = 1. 

*A driver's license is required by law to drive a car - FACT.
IF (gFb_11 = 0) fbFlag11 = 1. 

*Books may be borrowed from the library - FACT.
IF (gFb_12 = 0) fbFlag12 = 1. 

*Rich people are happy people - BELIEF.
IF (gFb_13 = 1) fbFlag13 = 1. 

*Cats are friendly animals. - BELIEF.
IF (gFb_14 = 1) fbFlag14 = 1. 

*Rock music is a bad influence on young children - BELIEF.
IF (gFb_15 = 1) fbFlag15 = 1. 

*It is okay to lie - BELIEF.
IF (gFb_16 = 1) fbFlag16 = 1. 

*The longer you stay in school, the smarter you will be - BELIEF.
IF (gFb_17 = 1) fbFlag17 = 1. 

*The earth revolves around the sun - FACT.
IF (gFb_18 = 0) fbFlag18 = 1. 

*Comic strips are funny - BELIEF.
IF (gFb_19 = 1) fbFlag19 = 1.

*The shape of a ball is round - FACT.
IF (gFb_20 = 0) fbFlag20 = 1.  

FREQUENCIES VARIABLES=fbFlag1 fbFlag2 fbFlag3 fbFlag4 fbFlag5 fbFlag6 fbFlag7 fbFlag8 fbFlag9 
    fbFlag10 fbFlag11 fbFlag12 fbFlag13 fbFlag14 fbFlag15 fbFlag16 fbFlag17 fbFlag18 fbFlag19 fbFlag20
  /ORDER=ANALYSIS.
*Each one has over 100 people who failed.

***Free response flags (coded by first author and RAs) ***

*1 flag.
IF (RespondentID = 2) flagOpen=1.
IF (RespondentID = 3) flagOpen=1.
IF (RespondentID = 7) flagOpen=1.
IF (RespondentID = 9) flagOpen=1.
IF (RespondentID = 12) flagOpen=1.
IF (RespondentID = 420) flagOpen=1.
IF (RespondentID = 15) flagOpen=1.
IF (RespondentID = 16) flagOpen=1.
IF (RespondentID = 19) flagOpen=1.
IF (RespondentID = 20) flagOpen=1.
IF (RespondentID = 24) flagOpen=1.
IF (RespondentID = 33) flagOpen=1.
IF (RespondentID = 42) flagOpen=1.
IF (RespondentID = 43) flagOpen=1.
IF (RespondentID = 44) flagOpen=1.
IF (RespondentID = 45) flagOpen=1.
IF (RespondentID = 64) flagOpen=1.
IF (RespondentID = 67) flagOpen=1.
IF (RespondentID = 74) flagOpen=1.
IF (RespondentID = 117) flagOpen=1.
IF (RespondentID = 122) flagOpen=1.
IF (RespondentID = 123) flagOpen=1.
IF (RespondentID = 126) flagOpen=1.
IF (RespondentID = 131) flagOpen=1.
IF (RespondentID = 135) flagOpen=1.
IF (RespondentID = 136) flagOpen=1.
IF (RespondentID = 144) flagOpen=1.
IF (RespondentID = 168) flagOpen=1.
IF (RespondentID = 169) flagOpen=1.
IF (RespondentID = 172) flagOpen=1.
IF (RespondentID = 184) flagOpen=1.
IF (RespondentID = 205) flagOpen=1.
IF (RespondentID = 206) flagOpen=1.
IF (RespondentID = 217) flagOpen=1.
IF (RespondentID = 231) flagOpen=1.
IF (RespondentID = 232) flagOpen=1.
IF (RespondentID = 240) flagOpen=1.
IF (RespondentID = 242) flagOpen=1.
IF (RespondentID = 244) flagOpen=1.
IF (RespondentID = 247) flagOpen=1.
IF (RespondentID = 249) flagOpen=1.
IF (RespondentID = 251) flagOpen=1.
IF (RespondentID = 259) flagOpen=1.
IF (RespondentID = 262) flagOpen=1.
IF (RespondentID = 263) flagOpen=1.
IF (RespondentID = 265) flagOpen=1.
IF (RespondentID = 266) flagOpen=1.
IF (RespondentID = 278) flagOpen=1.
IF (RespondentID = 281) flagOpen=1.
IF (RespondentID = 283) flagOpen=1.
IF (RespondentID = 284) flagOpen=1.
IF (RespondentID = 291) flagOpen=1.
IF (RespondentID = 293) flagOpen=1.
IF (RespondentID = 297) flagOpen=1.
IF (RespondentID = 304) flagOpen=1.
IF (RespondentID = 306) flagOpen=1.
IF (RespondentID = 307) flagOpen=1.
IF (RespondentID = 312) flagOpen=1.
IF (RespondentID = 315) flagOpen=1.
IF (RespondentID = 316) flagOpen=1.
IF (RespondentID = 321) flagOpen=1.
IF (RespondentID = 323) flagOpen=1.
IF (RespondentID = 324) flagOpen=1.
IF (RespondentID = 330) flagOpen=1.
IF (RespondentID = 332) flagOpen=1.
IF (RespondentID = 333) flagOpen=1.
IF (RespondentID = 341) flagOpen=1.
IF (RespondentID = 342) flagOpen=1.
IF (RespondentID = 343) flagOpen=1.
IF (RespondentID = 353) flagOpen=1.
IF (RespondentID = 358) flagOpen=1.
IF (RespondentID = 359) flagOpen=1.
IF (RespondentID = 360) flagOpen=1.
IF (RespondentID = 370) flagOpen=1.
IF (RespondentID = 371) flagOpen=1.
IF (RespondentID = 372) flagOpen=1.
IF (RespondentID = 377) flagOpen=1.
IF (RespondentID = 383) flagOpen=1.
IF (RespondentID = 384) flagOpen=1.
IF (RespondentID = 388) flagOpen=1.
IF (RespondentID = 393) flagOpen=1.
IF (RespondentID = 395) flagOpen=1.
IF (RespondentID = 398) flagOpen=1.
IF (RespondentID = 404) flagOpen=1.
IF (RespondentID = 407) flagOpen=1.
IF (RespondentID = 410) flagOpen=1.
IF (RespondentID = 419) flagOpen=1.
IF (RespondentID = 425) flagOpen=1.
IF (RespondentID = 426) flagOpen=1.
IF (RespondentID = 429) flagOpen=1.
IF (RespondentID = 436) flagOpen=1.
IF (RespondentID = 450) flagOpen=1.
IF (RespondentID = 436) flagOpen=1.
IF (RespondentID = 459) flagOpen=1.
IF (RespondentID = 462) flagOpen=1.
IF (RespondentID = 468) flagOpen=1.
IF (RespondentID = 469) flagOpen=1.
IF (RespondentID = 472) flagOpen=1.
IF (RespondentID = 476) flagOpen=1.
IF (RespondentID = 478) flagOpen=1.
IF (RespondentID = 479) flagOpen=1.
IF (RespondentID = 486) flagOpen=1.
IF (RespondentID = 493) flagOpen=1.
IF (RespondentID = 496) flagOpen=1.
IF (RespondentID = 503) flagOpen=1.
IF (RespondentID = 504) flagOpen=1.
IF (RespondentID = 506) flagOpen=1.
IF (RespondentID = 516) flagOpen=1.
IF (RespondentID = 517) flagOpen=1.
IF (RespondentID = 519) flagOpen=1.
IF (RespondentID = 521) flagOpen=1.
IF (RespondentID = 526) flagOpen=1.
IF (RespondentID = 528) flagOpen=1.
IF (RespondentID = 529) flagOpen=1.
IF (RespondentID = 532) flagOpen=1.
IF (RespondentID = 535) flagOpen=1.
IF (RespondentID = 536) flagOpen=1.
IF (RespondentID = 538) flagOpen=1.
IF (RespondentID = 540) flagOpen=1.
IF (RespondentID = 541) flagOpen=1.
IF (RespondentID = 545) flagOpen=1.
IF (RespondentID = 548) flagOpen=1.
IF (RespondentID = 557) flagOpen=1.
IF (RespondentID = 565) flagOpen=1.
IF (RespondentID = 574) flagOpen=1.
IF (RespondentID = 592) flagOpen=1.
IF (RespondentID = 593) flagOpen=1.
IF (RespondentID = 594) flagOpen=1.
IF (RespondentID = 600) flagOpen=1.
IF (RespondentID = 604) flagOpen=1.
IF (RespondentID = 605) flagOpen=1.
IF (RespondentID = 612) flagOpen=1.
IF (RespondentID = 616) flagOpen=1.
IF (RespondentID = 618) flagOpen=1.
IF (RespondentID = 622) flagOpen=1.
IF (RespondentID = 623) flagOpen=1.
IF (RespondentID = 629) flagOpen=1.
IF (RespondentID = 630) flagOpen=1.
IF (RespondentID = 650) flagOpen=1.
IF (RespondentID = 673) flagOpen=1.
IF (RespondentID = 700) flagOpen=1.
IF (RespondentID = 704) flagOpen=1.
IF (RespondentID = 738) flagOpen=1.
IF (RespondentID = 744) flagOpen=1.
IF (RespondentID = 767) flagOpen=1.
IF (RespondentID = 768) flagOpen=1.
IF (RespondentID = 769) flagOpen=1.
IF (RespondentID = 791) flagOpen=1.
IF (RespondentID = 793) flagOpen=1.
IF (RespondentID = 806) flagOpen=1.
IF (RespondentID = 809) flagOpen=1.
IF (RespondentID = 812) flagOpen=1.
IF (RespondentID = 814) flagOpen=1.
IF (RespondentID = 822) flagOpen=1.
IF (RespondentID = 854) flagOpen=1.
IF (RespondentID = 858) flagOpen=1.
IF (RespondentID = 882) flagOpen=1.
IF (RespondentID = 911) flagOpen=1.
IF (RespondentID = 921) flagOpen=1.
IF (RespondentID = 944) flagOpen=1.
IF (RespondentID = 996) flagOpen=1.
IF (RespondentID = 1023) flagOpen=1.
IF (RespondentID = 1030) flagOpen=1.
IF (RespondentID = 1046) flagOpen=1.
IF (RespondentID = 1054) flagOpen=1.
IF (RespondentID = 1129) flagOpen=1.
IF (RespondentID = 1140) flagOpen=1.
IF (RespondentID = 1145) flagOpen=1.
IF (RespondentID = 1148) flagOpen=1.
IF (RespondentID = 1150) flagOpen=1.
IF (RespondentID = 1180) flagOpen=1.
IF (RespondentID = 1187) flagOpen=1.

*2 flags.
IF (RespondentID = 26) flagOpen=2.
IF (RespondentID = 52) flagOpen=2.
IF (RespondentID = 66) flagOpen=2.
IF (RespondentID = 87) flagOpen=2.
IF (RespondentID = 92) flagOpen=2.
IF (RespondentID = 109) flagOpen=2.
IF (RespondentID = 127) flagOpen=2.
IF (RespondentID = 162) flagOpen=2.
IF (RespondentID = 164) flagOpen=2.
IF (RespondentID = 166) flagOpen=2.
IF (RespondentID = 195) flagOpen=2.
IF (RespondentID = 204) flagOpen=2.
IF (RespondentID = 228) flagOpen=2.
IF (RespondentID = 250) flagOpen=2.
IF (RespondentID = 277) flagOpen=2.
IF (RespondentID = 309) flagOpen=2.
IF (RespondentID = 347) flagOpen=2.
IF (RespondentID = 204) flagOpen=2.
IF (RespondentID = 474) flagOpen=2.
IF (RespondentID = 522) flagOpen=2.
IF (RespondentID = 533) flagOpen=2.
IF (RespondentID = 561) flagOpen=2.
IF (RespondentID = 576) flagOpen=2.
IF (RespondentID = 607) flagOpen=2.
IF (RespondentID = 615) flagOpen=2.
IF (RespondentID = 627) flagOpen=2.
IF (RespondentID = 679) flagOpen=2.
IF (RespondentID = 683) flagOpen=2.
IF (RespondentID = 684) flagOpen=2.
IF (RespondentID = 696) flagOpen=2.
IF (RespondentID = 733) flagOpen=2.
IF (RespondentID = 831) flagOpen=2.
IF (RespondentID = 834) flagOpen=2.
IF (RespondentID = 835) flagOpen=2.
IF (RespondentID = 847) flagOpen=2.
IF (RespondentID = 922) flagOpen=2.
IF (RespondentID = 1003) flagOpen=2.
IF (RespondentID = 1090) flagOpen=2.
IF (RespondentID = 1152) flagOpen=2.

*3 flags.
IF (RespondentID = 208) flagOpen=3.
IF (RespondentID = 56) flagOpen=3.
IF (RespondentID = 63) flagOpen=3.
IF (RespondentID = 97) flagOpen=3.
IF (RespondentID = 101) flagOpen=3.
IF (RespondentID = 105) flagOpen=3.
IF (RespondentID = 106) flagOpen=3.
IF (RespondentID = 107) flagOpen=3.
IF (RespondentID = 120) flagOpen=3.
IF (RespondentID = 177) flagOpen=3.
IF (RespondentID = 203) flagOpen=3.
IF (RespondentID = 300) flagOpen=3.
IF (RespondentID = 562) flagOpen=3.
IF (RespondentID = 674) flagOpen=3.
IF (RespondentID = 575) flagOpen=3.
IF (RespondentID = 576) flagOpen=3.
IF (RespondentID = 688) flagOpen=3.
IF (RespondentID = 689) flagOpen=3.
IF (RespondentID = 690) flagOpen=3.
IF (RespondentID = 692) flagOpen=3.
IF (RespondentID = 695) flagOpen=3.
IF (RespondentID = 713) flagOpen=3.
IF (RespondentID = 758) flagOpen=3.
IF (RespondentID = 783) flagOpen=3.
IF (RespondentID = 723) flagOpen=3.
IF (RespondentID = 852) flagOpen=3.
IF (RespondentID = 933) flagOpen=3.
IF (RespondentID = 1074) flagOpen=3.
IF (RespondentID = 1182) flagOpen=3.


*4 flags.
IF (RespondentID = 4) flagOpen=4.
IF (RespondentID = 8) flagOpen=4.
IF (RespondentID = 14) flagOpen=4.
IF (RespondentID = 18) flagOpen=4.
IF (RespondentID = 29) flagOpen=4.
IF (RespondentID = 46) flagOpen=4.
IF (RespondentID = 47) flagOpen=4.
IF (RespondentID = 49) flagOpen=4.
IF (RespondentID = 54) flagOpen=4.
IF (RespondentID = 58) flagOpen=4.
IF (RespondentID = 59) flagOpen=4.
IF (RespondentID = 60) flagOpen=4.
IF (RespondentID = 61) flagOpen=4.
IF (RespondentID = 62) flagOpen=4.
IF (RespondentID = 69) flagOpen=4.
IF (RespondentID = 71) flagOpen=4.
IF (RespondentID = 72) flagOpen=4.
IF (RespondentID = 73) flagOpen=4.
IF (RespondentID = 81) flagOpen=4.
IF (RespondentID = 83) flagOpen=4.
IF (RespondentID = 84) flagOpen=4.
IF (RespondentID = 94) flagOpen=4.
IF (RespondentID = 95) flagOpen=4.
IF (RespondentID = 96) flagOpen=4.
IF (RespondentID = 98) flagOpen=4.
IF (RespondentID = 100) flagOpen=4.
IF (RespondentID = 101) flagOpen=4.
IF (RespondentID = 102) flagOpen=4.
IF (RespondentID = 103) flagOpen=4.
IF (RespondentID = 104) flagOpen=4.
IF (RespondentID = 112) flagOpen=4.
IF (RespondentID = 113) flagOpen=4.
IF (RespondentID = 133) flagOpen=4.
IF (RespondentID = 138) flagOpen=4.
IF (RespondentID = 145) flagOpen=4.
IF (RespondentID = 151) flagOpen=4.
IF (RespondentID = 157) flagOpen=4.
IF (RespondentID = 158) flagOpen=4.
IF (RespondentID = 160) flagOpen=4.
IF (RespondentID = 173) flagOpen=4.
IF (RespondentID = 174) flagOpen=4.
IF (RespondentID = 175) flagOpen=4.
IF (RespondentID = 180) flagOpen=4.
IF (RespondentID = 185) flagOpen=4.
IF (RespondentID = 186) flagOpen=4.
IF (RespondentID = 187) flagOpen=4.
IF (RespondentID = 189) flagOpen=4.
IF (RespondentID = 190) flagOpen=4.
IF (RespondentID = 191) flagOpen=4.
IF (RespondentID = 194) flagOpen=4.
IF (RespondentID = 199) flagOpen=4.
IF (RespondentID = 209) flagOpen=4.
IF (RespondentID = 213) flagOpen=4.
IF (RespondentID = 214) flagOpen=4.
IF (RespondentID = 225) flagOpen=4.
IF (RespondentID = 226) flagOpen=4.
IF (RespondentID = 236) flagOpen=4.
IF (RespondentID = 239) flagOpen=4.
IF (RespondentID = 245) flagOpen=4.
IF (RespondentID = 248) flagOpen=4.
IF (RespondentID = 290) flagOpen=4.
IF (RespondentID = 294) flagOpen=4.
IF (RespondentID = 302) flagOpen=4.
IF (RespondentID = 303) flagOpen=4.
IF (RespondentID = 308) flagOpen=4.
IF (RespondentID = 314) flagOpen=4.
IF (RespondentID = 338) flagOpen=4.
IF (RespondentID = 378) flagOpen=4.
IF (RespondentID = 391) flagOpen=4.
IF (RespondentID = 396) flagOpen=4.
IF (RespondentID = 397) flagOpen=4.
IF (RespondentID = 414) flagOpen=4.
IF (RespondentID = 416) flagOpen=4.
IF (RespondentID = 423) flagOpen=4.
IF (RespondentID = 446) flagOpen=4.
IF (RespondentID = 482) flagOpen=4.
IF (RespondentID = 515) flagOpen=4.
IF (RespondentID = 608) flagOpen=4.
IF (RespondentID = 610) flagOpen=4.
IF (RespondentID = 611) flagOpen=4.
IF (RespondentID = 635) flagOpen=4.
IF (RespondentID = 664) flagOpen=4.
IF (RespondentID = 678) flagOpen=4.
IF (RespondentID = 680) flagOpen=4.
IF (RespondentID = 687) flagOpen=4.
IF (RespondentID = 694) flagOpen=4.
IF (RespondentID = 697) flagOpen=4.
IF (RespondentID = 697) flagOpen=4.
IF (RespondentID = 698) flagOpen=4.
IF (RespondentID = 703) flagOpen=4.
IF (RespondentID = 705) flagOpen=4.
IF (RespondentID = 706) flagOpen=4.
IF (RespondentID = 707) flagOpen=4.
IF (RespondentID = 708) flagOpen=4.
IF (RespondentID = 709) flagOpen=4.
IF (RespondentID = 710) flagOpen=4.
IF (RespondentID = 711) flagOpen=4.
IF (RespondentID = 712) flagOpen=4.
IF (RespondentID = 714) flagOpen=4.
IF (RespondentID = 715) flagOpen=4.
IF (RespondentID = 716) flagOpen=4.
IF (RespondentID = 717) flagOpen=4.
IF (RespondentID = 718) flagOpen=4.
IF (RespondentID = 719) flagOpen=4.
IF (RespondentID = 720) flagOpen=4.
IF (RespondentID = 723) flagOpen=4.
IF (RespondentID = 741) flagOpen=4.
IF (RespondentID = 750) flagOpen=4.
IF (RespondentID = 757) flagOpen=4.
IF (RespondentID = 771) flagOpen=4.
IF (RespondentID = 784) flagOpen=4.
IF (RespondentID = 795) flagOpen=4.
IF (RespondentID = 800) flagOpen=4.
IF (RespondentID = 801) flagOpen=4.
IF (RespondentID = 802) flagOpen=4.
IF (RespondentID = 803) flagOpen=4.
IF (RespondentID = 805) flagOpen=4.
IF (RespondentID = 810) flagOpen=4.
IF (RespondentID = 813) flagOpen=4.
IF (RespondentID = 816) flagOpen=4.
IF (RespondentID = 818) flagOpen=4.
IF (RespondentID = 824) flagOpen=4.
IF (RespondentID = 825) flagOpen=4.
IF (RespondentID = 827) flagOpen=4.
IF (RespondentID = 828) flagOpen=4.
IF (RespondentID = 830) flagOpen=4.
IF (RespondentID = 832) flagOpen=4.
IF (RespondentID = 839) flagOpen=4.
IF (RespondentID = 843) flagOpen=4.
IF (RespondentID = 844) flagOpen=4.
IF (RespondentID = 849) flagOpen=4.
IF (RespondentID = 851) flagOpen=4.
IF (RespondentID = 856) flagOpen=4.
IF (RespondentID = 864) flagOpen=4.
IF (RespondentID = 867) flagOpen=4.
IF (RespondentID = 970) flagOpen=4.
IF (RespondentID = 875) flagOpen=4.
IF (RespondentID = 876) flagOpen=4.
IF (RespondentID = 1081) flagOpen=4.
IF (RespondentID = 1198) flagOpen=4.

*Total flags. 
COMPUTE TotalFlags=SUM(flagLang,flagTime,flagLowVar,fbFlag1,fbFlag2,fbFlag3,fbFlag4,fbFlag5,fbFlag6,fbFlag7,
    fbFlag8,fbFlag9,fbFlag10,fbFlag11,fbFlag12,fbFlag13,fbFlag14,fbFlag15,fbFlag16,fbFlag17,fbFlag18,fbFlag19,fbFlag20,flagOpen).
VARIABLE LABELS TotalFlags 'Sum of flags'.
MISSING VALUES TotalFlags (-9). 
VARIABLE LEVEL TotalFlags (SCALE).
FORMATS TotalFlags (F8.0).
EXECUTE.

*Average flags.
DESCRIPTIVES TotalFlags.
FREQUENCIES TotalFlags.
*Mean = 5.2 SD = 5.2.

* Create a filter.

*10 (mean + ~ 1 SD) flag cutoff resulted in much better free response quality.
COMPUTE filterP = 0.
IF (TotalFlags > 10) filterP = 1.

FREQUENCIES filterP.
*About 14% of the sample.

* Save as the post-exclusions data set.

*Before filter: n = 1263.

* SAVE AS: Pre-filter

*Filter. 
SELECT IF (filterP = 0).
EXECUTE.

*After filter: n = 1086.

* Filter out duplicates.
FILTER OFF.
USE ALL.
SELECT IF (NOT (RespondentID = 694 OR RespondentID = 709 OR RespondentID = 682)).
EXECUTE.

*Remaining: n = 1086.

* SAVE AS: Post-filter

**************

*Set missing values. 
MISSING VALUES age lang fear (-9).
EXECUTE.

*Delete the flagging variables.
DELETE VARIABLES flagLang flagTime,flagLowVar,fbFlag1,fbFlag2,fbFlag3,fbFlag4,fbFlag5,fbFlag6,fbFlag7,
    fbFlag8,fbFlag9,fbFlag10,fbFlag11,fbFlag12,fbFlag13,fbFlag14,fbFlag15,fbFlag16,fbFlag17,fbFlag18,fbFlag19,fbFlag20,flagOpen, TotalFlags filterP lowVar
    Time_Qualtrics,gSelf_SD,gOther_SD,gFB_SD,SAself_SD,SAother_SD,SAwomen_SD,SAmen_SD,SAFB1_SD.

*Recode demographics.

*Recode sex as binary.
RECODE sex (0=0) (1=1) (2=SYSMIS) (MISSING=SYSMIS) INTO sexBin.
VALUE LABELS sexBin 0 'Female' 1 'Male'.
VARIABLE LABELS sexBin 'Female vs. Male (Other/Missing as Missing)'.
VARIABLE LEVEL sexBin (NOMINAL).
MISSING VALUES sexBin (-9). 
ALTER TYPE sexBin (F2.0).

FREQUENCIES sexBin.
*439 men, 636 women, 8 missing.

*Recode sexual orientation as binary (helps with model convergence in MLMs).
RECODE sexOrien (0=0) (1=1) (2=1) (3=1) (4=1) into sexOrien_Bin.
VARIABLE LABELS  sexOrien_Bin 'Sexual orientation recoded to be binary'.
FORMATS sexOrien_Bin (F8.0).
VARIABLE LEVEL  sexOrien_Bin (NOMINAL). 
MISSING VALUES sexOrien_Bin (-9). 
VALUE LABELS sexOrien_Bin 0 'Straight' 1 'Non-straight'.

FREQUENCIES sexOrien sexOrien_Bin.

*Make condition variable from the number of fear items that they wrote about.
IF (fearItems = 3) condition = 0.
IF (fearItems = 12) condition = 1.
VARIABLE LABELS condition 'Fear condition'.
VALUE LABELS condition 0 ' 3 items' 1 '12 items'.

FREQUENCIES fearItems condition.

*Delete fearitems variable.
DELETE VARIABLES fearItems.

*Participant agreement with blame the victim items.

RELIABILITY
  /VARIABLES= selfVict_1,selfVict_2,selfVict_3,selfVict_4,selfVict_5,selfVict_6,selfVict_7,selfVict_8
selfVict_9,selfVict_10,selfVict_11,selfVict_12,selfVict_13
  /SCALE('selfVict') ALL
  /MODEL=ALPHA
  /STATISTICS= DESCRIPTIVE SCALE CORRELATIONS
  /SUMMARY=TOTAL CORR.
*Alpha=.89.

*Participant agreement with blame the perpetrator items.
RELIABILITY
  /VARIABLES= selfPerp_1, selfPerp_2, selfPerp_3, selfPerp_4, selfPerp_5, selfPerp_6, selfPerp_7, selfPerp_8, selfPerp_9, selfPerp_10, selfPerp_11, selfPerp_12, selfPerp_13
  /SCALE('selfPerp') ALL
  /MODEL=ALPHA
  /STATISTICS= DESCRIPTIVE SCALE CORRELATIONS
  /SUMMARY=TOTAL CORR.
*Alpha=.89.

* Create the scales 
 
* Participant agreement with blame the victim items.
COMPUTE selfVict=MEAN(selfVict_1,selfVict_2,selfVict_3,selfVict_4,selfVict_5,selfVict_6,selfVict_7,selfVict_8,
selfVict_9,selfVict_10,selfVict_11,selfVict_12,selfVict_13). 
VARIABLE LABELS selfVict "Participant agreement with blame the victim items (scale)".
MISSING VALUES selfVict (-9).
VARIABLE LEVEL selfVict (SCALE).
VALUE LABELS selfVict 1 'Strongly disagree' 4 'Strongly agree'.
EXECUTE.

* Participant agreement with blame the perpetrator items.
COMPUTE selfPerp =MEAN(selfPerp_1, selfPerp_2, selfPerp_3, selfPerp_4, selfPerp_5, selfPerp_6, 
 selfPerp_7, selfPerp_8, selfPerp_9, selfPerp_10, selfPerp_11, selfPerp_12, selfPerp_13). 
VARIABLE LABELS selfPerp "Participant agreement with blame the perpetrator items (scale)".
MISSING VALUES selfPerp (-9).
VARIABLE LEVEL selfPerp (SCALE).
VALUE LABELS selfPerp 1 'Strongly disagree' 4 'Strongly agree'.
EXECUTE.

* Difference score.
COMPUTE difScore = selfPerp - selfVict.
VARIABLE LABELS difScore "Blame difference score".
MISSING VALUES difScore (-9).
VARIABLE LEVEL difScore (SCALE).
EXECUTE.

* Merge the data with the data set where RAs coded for how many fear items one wrote.
DATASET ACTIVATE DataSet1.
SORT CASES BY RespondentID.
DATASET ACTIVATE DataSet2.
SORT CASES BY RespondentID.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY RespondentID.
EXECUTE.

* Correlations between items written and DVs.
CORRELATIONS
  /VARIABLES=ItemsWritten fear selfPerp selfVict
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

*Frequencies and histograms.
FREQUENCIES VARIABLES=ItemsWritten
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.

*Frequencies and histograms.
FREQUENCIES VARIABLES=Age relPrac sexBin sexOrien sexOrien_Bin polSoc polEco polGen session fear selfPerp selfVict difScore
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.


******Center variables ******.

DESCRIPTIVES fear polSoc polEco age relPrac.
*Fear mean = 1.73801886792453, SD = 2.596936133234109.
*polSoc Mean = 3.590529247910866, SD = 1.829239842102104
*polEcoMean = 3.977736549165117, SD = 1.778721249221656
*Age mean = 36.36691312384476, SD = 12.066319034080916
*Religiosity mean = 1.818097876269623, SD = 1.53190507614384.

COMPUTE fear_c= fear - 1.73801886792453.
VARIABLE LABELS fear_c 'Fear centered'.

COMPUTE age_c= Age - 36.36691312384476.
VARIABLE LABELS Age_c 'Age centered'.

COMPUTE rel_c= relPrac - 1.818097876269623.
VARIABLE LABELS rel_c 'Religiosity centered'.

*Check to make sure they were centered properly.
DESCRIPTIVES fear_c age_c rel_c.

*Create high and low levels for fear.
COMPUTE fear_L = fear_c-(-2.596936133234109).
COMPUTE fear_H = fear_c-(2.596936133234109).
VARIABLE LABELS fear_L 'Fear 1 SD below the mean'.
VARIABLE LABELS fear_H 'Fear 1 SD above the mean'.

DESCRIPTIVES fear_H fear_L.

*Create high and low levels for age.
COMPUTE age_L = age_c-(-12.066319034080916).
COMPUTE age_H = age_c-(12.066319034080916).
VARIABLE LABELS age_L 'Age 1 SD below the mean'.
VARIABLE LABELS age_H 'Age 1 SD above the mean'.

DESCRIPTIVES age_H age_L.

* Center social and economic ideology at moderate (make 0 the new 4).

COMPUTE polS_c= polSoc - 4.
VARIABLE LABELS polS_c 'Social ideology centered at moderate'.

COMPUTE pSoc_L = polS_c-(-2).
COMPUTE pSoc_H = polS_c-(2).
VARIABLE LABELS pSoc_L 'Social ideology 2 units below moderate'.
VARIABLE LABELS pSoc_H 'Social ideology 2 units above moderate'.

DESCRIPTIVES polS_c pSoc_L pSoc_H.

COMPUTE polE_c= polEco - 4.
VARIABLE LABELS polE_c 'Economic ideology centered at moderate'.

COMPUTE pEco_L = polE_c-(-2).
COMPUTE pEco_H = polE_c-(2).
VARIABLE LABELS pEco_L 'Economic ideology 2 units below moderate'.
VARIABLE LABELS pEco_H 'Economic ideology 2 units above moderate'.

DESCRIPTIVES polE_c pEco_L  pEco_H.

******Create dummy and effects coded variables******.
    
**Gender effects code**

RECODE sexBin (0 = -.5) (1=.5) (MISSING=SYSMIS) INTO sexBinE.
VARIABLE LABELS  sexBinE 'Binary sex, effects coded'.
FORMATS sexBinE (F4.2).
MISSING VALUES sexBinE (-9).
VARIABLE LEVEL  sexBinE (SCALE).

* Mean.
DESCRIPTIVES VARIABLES=sexBinE.
*.09.

**Ideology**

*Dummy variables for ideology, original coding with liberal as the reference. 

*Liberals as the reference, compared to moderates.
RECODE polGen (1=1) (MISSING=SYSMIS) (ELSE=0) INTO pgen_dc1.
VARIABLE LABELS pgen_dc1 'Dummy variable - moderates, liberals as reference'.
FORMATS pgen_dc1 (F8.0).
VARIABLE LEVEL pgen_dc1 (NOMINAL).
MISSING VALUES pgen_dc1 (-9).

*Liberals as the reference, compared to conservatives.
RECODE polgen (2=1) (MISSING=SYSMIS) (ELSE=0) INTO pgen_dc2. 
VARIABLE LABELS pgen_dc2 'Dummy variable - conservatives, liberals as reference'. 
FORMATS pgen_dc2 (F8.0). 
VARIABLE LEVEL pgen_dc2 (NOMINAL).
MISSING VALUES pgen_dc2 (-9).

RECODE polGen (0=1) (1=2) (2=0) (MISSING=SYSMIS) into polGen_R.
VARIABLE LABELS polGen_R 'Ideology recoded so that conservatives are the reference condition'.
MISSING VALUES polGen_R (-9).
VARIABLE LEVEL polGen_R (NOMINAL).
ALTER TYPE polGen_R (F7.0).
FORMATS polGen_R(F7.0). 
VALUE LABELS polGen_R 0 'Conservative' 1 'Liberal' 2 'Moderate'.

FREQUENCIES polGen polGen_R.

*Dummy variables for ideology, conservatives as the reference. 

*Conservatives as the reference, compared to liberals.
RECODE polGen_R (1=1) (MISSING=SYSMIS) (ELSE=0) INTO pgen2_dc1.
VARIABLE LABELS pgen2_dc1 'Dummy variable - liberals, conservatives as reference'.
FORMATS pgen2_dc1 (F8.0).
VARIABLE LEVEL pgen2_dc1 (NOMINAL).
MISSING VALUES pgen2_dc1 (-9).

* Moderates as the reference, compared to conservatives.
RECODE polGen_R (2=1) (MISSING=SYSMIS) (ELSE=0) INTO pgen2_dc2.
VARIABLE LABELS pgen2_dc2 'Dummy variable - moderates, conservatives as reference'.
FORMATS pgen2_dc2 (F8.0).
VARIABLE LEVEL pgen2_dc2 (NOMINAL). 
MISSING VALUES pgen2_dc2 (-9).

FREQUENCIES polGen pgen_dc1 pgen_dc2 polGen_R pgen2_dc1 pgen2_dc2.

*Effects coded variables for ideology, original coding with liberal as the reference. 

*Liberal as the reference, compared to moderate.
RECODE polGen (1=.666) (MISSING=SYSMIS) (ELSE=-.333) INTO pgen_ec1.
VARIABLE LABELS  pgen_ec1 'Effects code, liberal reference compared to moderate'.
FORMATS pgen_ec1 (F4.2).
MISSING VALUES pgen_ec1 (-9).
VARIABLE LEVEL  pgen_ec1 (SCALE).

*Liberal as the reference, compared to conservative.
RECODE polGen (2=.666) (MISSING=SYSMIS) (ELSE=-.333) INTO pgen_ec2. 
VARIABLE LABELS pgen_ec2 'Effects code, liberal reference compared to conservative'. 
FORMATS pgen_ec2 (F4.2).
MISSING VALUES pgen_ec2 (-9).
VARIABLE LEVEL pgen_ec2(SCALE).

DESCRIPTIVES VARIABLES= pgen_ec1 pgen_ec2.
FREQUENCIES polGen pgen_ec1 pgen_ec2.

*Effects coded variables for ideology, conservatives as the reference. 

*Conservatives as the reference, compared to liberals.
RECODE polGen_R (1=.666) (MISSING=SYSMIS) (ELSE=-.333) INTO pgen2_ec1.
VARIABLE LABELS  pgen2_ec1 'Effects code, conservatives reference compared to liberals (again)'.
FORMATS pgen2_ec1 (F4.2).
VARIABLE LEVEL  pgen2_ec1 (SCALE).

*Conservatives as the reference, compared to conservatives.
RECODE polGen_R (2=.666) (MISSING=SYSMIS) (ELSE=-.333) INTO pgen2_ec2.
VARIABLE LABELS  pgen2_ec2 'Effects code, conservatives reference compared to moderates'.
FORMATS pgen2_ec2 (F4.2).
VARIABLE LEVEL  pgen2_ec2 (SCALE).

DESCRIPTIVES VARIABLES= pgen2_ec1 pgen2_ec2.
FREQUENCIES VARIABLES= polGen_R pgen2_ec1 pgen2_ec2.
 
* Multiply effects codes with conservatives as the reference by -1 so going in the same direction as effects codes where liberals are the reference.

COMPUTE rpgen2_ec1 = pgen2_ec1*-1.
COMPUTE rpgen2_ec2 = pgen2_ec2*-1.

FREQUENCIES pgen2_ec1 rpgen2_ec1 pgen2_ec2 rpgen2_ec2.


** Session **
    
*Dummy variables for session, coding with session 1 as the reference. 

*Session 1 as the reference, compared to session 2.
RECODE session (1=1) (MISSING=SYSMIS) (ELSE=0) INTO sess_dc1.
VARIABLE LABELS sess_dc1 'Dummy variable - session 2, session 1 as reference'.
FORMATS sess_dc1 (F8.0).
VARIABLE LEVEL sess_dc1 (NOMINAL).
MISSING VALUES sess_dc1 (-9).

*Session 1 as the reference, compared to session 3.
RECODE session (2=1) (MISSING=SYSMIS) (ELSE=0) INTO sess_dc2.
VARIABLE LABELS sess_dc2 'Dummy variable - session 3, session 1 as reference'.
FORMATS sess_dc2 (F8.0).
VARIABLE LEVEL sess_dc2 (NOMINAL).
MISSING VALUES sess_dc2 (-9).

*Recode session so that session 3 is the reference session.
RECODE session (0=1) (1=2) (2=0) (MISSING=SYSMIS) into session_R.
VARIABLE LABEL session_R 'Session recoded so that session 3 is the reference condition, then session 1, then session 2'.
MISSING VALUES session_R (-9).
VARIABLE LEVEL session_R (NOMINAL).
ALTER TYPE session_R (F7.0).
FORMATS session_R (F7.0). 
VALUE LABELS session_R 0 'Session 3' 1 'Session 1' 2 'Session 2'.

FREQUENCIES session session_R.

*Dummy variables for session, coding with session 3 as the reference. 

*Session 3 as the reference, compared to session 1.
RECODE session_R (1=1) (MISSING=SYSMIS) (ELSE=0) INTO sess2_dc1.
VARIABLE LABELS sess2_dc1 'Dummy variable - session 1, session 3 as reference'.
FORMATS sess2_dc1 (F8.0).
VARIABLE LEVEL sess2_dc1 (NOMINAL).
MISSING VALUES sess2_dc1 (-9).

*Session 3 as the reference, compared to session 3.
RECODE session_R (2=1) (MISSING=SYSMIS) (ELSE=0) INTO sess2_dc2.
VARIABLE LABELS sess2_dc2 'Dummy variable - session 2, session 3 as reference'.
FORMATS sess2_dc2 (F8.0).
VARIABLE LEVEL sess2_dc2 (NOMINAL).
MISSING VALUES sess2_dc2 (-9).

DESCRIPTIVES sess2_dc1 sess2_dc2.
FREQUENCIES session_R sess2_dc1 sess2_dc2.


*Effects coded variables for session, coding with session 1 as the reference. 

* Session 1 as the reference, compared to session 2.
RECODE session (1=.666) (MISSING=SYSMIS) (ELSE=-.333) INTO sess_ec1.
VARIABLE LABELS  sess_ec1 'Effects code, session 1 reference compared to session 2'.
FORMATS sess_ec1 (F4.2).
VARIABLE LEVEL sess_ec1 (SCALE).

* Session 1 as the reference, compared to session 3.
RECODE session (2=.666) (MISSING=SYSMIS) (ELSE=-.333) INTO sess_ec2.
VARIABLE LABELS  sess_ec2 'Effects code, session 1 reference compared to session 3'.
FORMATS sess_ec1 (F4.2). 
VARIABLE LEVEL sess_ec1 (SCALE).

DESCRIPTIVES VARIABLES=sess_ec1 sess_ec2.

**Effects coded variables for session, coding with session 3 as the reference. 

* Session 3 as the reference, compared to session 1.
RECODE session_R (1=.666) (MISSING=SYSMIS) (ELSE=-.333) INTO sess2_ec1.
VARIABLE LABELS  sess2_ec1 'Effects code, session 3 reference compared to session 1 (again)'.
FORMATS sess2_ec1 (F4.2).
VARIABLE LEVEL sess2_ec1 (SCALE).

*Session 2 as the reference,  compared to session 3.
RECODE session_R (2=.666) (MISSING=SYSMIS) (ELSE=-.333) INTO sess2_ec2.
VARIABLE LABELS  sess2_ec2 'Effects code, session 3 reference compared to session 2'.
FORMATS sess2_ec2 (F4.2).
VARIABLE LEVEL  sess2_ec2 (SCALE).
    
DESCRIPTIVES VARIABLES = sess2_ec1 sess2_ec2.
FREQUENCIES VARIABLES = session_R sess2_ec1 sess2_ec2.

* Multiply effects codes with conservatives as the reference by -1 so going in the same direction as effects codes where liberals are the reference.

COMPUTE rsess2_ec1 = sess2_ec1*-1.
COMPUTE rsess2_ec2 = sess2_ec2*-1.

FREQUENCIES sess2_ec1 rsess2_ec1 sess2_ec2 rsess2_ec2.

**Sexual orientation effects code**.

*Heterosexual versus other. 
RECODE sexOrien_Bin (0 = -.5) (1=.5) (MISSING=SYSMIS) INTO sexOrBin_E.
VARIABLE LABELS  sexOrBin_E 'Binary sexual orientation effects coded'.
FORMATS sexOrBin_E (F4.2).
VARIABLE LEVEL sexOrBin_E (SCALE).

DESCRIPTIVES VARIABLES=sexOrBin_E.

* Keep only the variables needed.

DELETE VARIABLES StartDate	EndDate consent gSelf_1 gSelf_2 TO gFb_20 OtherPerp_1 TO FBPerp_13.

* Standardize continuous variables.
DESCRIPTIVES VARIABLES=age_c fear_c rel_c 
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.

* Standardized polSoc polEco without centering to keep 0 = moderate.
DESCRIPTIVES polS_c polE_c.

COMPUTE zpolS_c = polS_c/1.829239842102104.
VARIABLE LABELS zpolS_c 'Standardized social ideology'.  

COMPUTE zpolE_c = polE_c/1.778721249221657.
VARIABLE LABELS zpolE_c 'Standardized economic ideology'. 

DESCRIPTIVES zpolS_c zpolE_c.

*Standardized high and low social ideology (based on 2 units of of original scale).
COMPUTE zpSoc_L = zpolS_c-(1.09335).
VARIABLE LABELS ZpSoc_L 'Standardized low social ideology'. 
EXECUTE.

COMPUTE zpSoc_H = zpolS_c-(-1.09335).
VARIABLE LABELS ZpSoc_H 'Standardized high social ideology'. 
EXECUTE.

*Standardized high and low economic ideology (based on 2 of original scale).
COMPUTE zpEco_L = zpolE_c-(1.124403).
VARIABLE LABELS zpEco_L 'Standardized low economic ideology'. 
EXECUTE.

COMPUTE zpEco_H = zpolE_c-(-1.124403).
VARIABLE LABELS zpEco_H 'Standardized high economic ideology'. 
EXECUTE.

DESCRIPTIVES zpolS_c ZpSoc_L zpSoc_H zpolE_c zpEco_L zpEco_H.

* Data cleaning finished. Save as final wide data set with all vars.

************************************************ STACK DATA FOR BLAME ANALYSES *************************************************

VARSTOCASES
  /MAKE selfBlame FROM selfVict selfPerp
  /INDEX=Index1(2) 
  /KEEP=RespondentID race_other Age fearList polSoc_Other polEco_Other polGen_Other sexOrien_Other 
    religion lang race sex sexOrien relPrac polSoc polEco polGen session fear selfPerp_1 selfPerp_2 
    selfPerp_3 selfPerp_4 selfVict_1 selfPerp_5 selfPerp_6 selfPerp_7 selfVict_2 selfVict_3 selfPerp_8 
    selfVict_4 selfPerp_9 selfVict_5 selfPerp_10 selfVict_6 selfVict_7 selfVict_8 selfVict_9 
    selfVict_10 selfVict_11 selfPerp_11 selfVict_12 selfPerp_12 selfVict_13 selfPerp_13 sexBin 
    sexOrien_Bin condition fear_c age_c rel_c fear_L fear_H age_L age_H polS_c pSoc_L pSoc_H polE_c 
    pEco_L pEco_H sexBinE pgen_dc1 pgen_dc2 polGen_R pgen2_dc1 pgen2_dc2 pgen_ec1 pgen_ec2 pgen2_ec1 
    pgen2_ec2 rpgen2_ec1 rpgen2_ec2 sess_dc1 sess_dc2 session_R sess2_dc1 sess2_dc2 sess_ec1 sess_ec2 
    sess2_ec1 sess2_ec2 rsess2_ec1 rsess2_ec2 sexOrBin_E Zage_c Zfear_c Zrel_c zpolS_c zpolE_c zpSoc_L zpSoc_H zpEco_L zpEco_H
  /NULL=KEEP.

*Rename variable labels. 
VARIABLE LABELS SelfBlame 'Participant agreement with blame items'.

*Make target variable.
COMPUTE VictVsPerp=Index1-1. 
RECODE Index1 (2=0) (ELSE=Copy) INTO PerpVsVict.

VARIABLE LABELS VictVsPerp 'Target: victim as reference'.
VARIABLE LABELS PerpVsVict 'Target: perpetrator as reference'.

* Standardize.
DESCRIPTIVES VARIABLES=selfBlame
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.

DELETE VARIABLES Index1.

* Save as long data.




