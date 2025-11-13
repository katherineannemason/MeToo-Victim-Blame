* Victim Blame Primary Analyses:
  1. Victim and perpetrator blame across sessions among liberal, moderate, and conservative males and females. (c path)
  2. Threat within and across session among liberal, moderate, and conservative males and females (a path)
  3. Mediation of blame by threat across session among liberal, moderate, and conservative males and females (multi-level moderated mediation, see R script for indirect effect estimates)

* Written by the fifth, second, and first authors in 2024/2025
* Data files: 
  VB S1-3 STACKED.xlsx
  VB S1-3 WIDE.xlsx
* Last edited 2025.10.16.

********************************************** PREPARE DATA ***********************************************;

* Start by taking care of all data preparation for all analyses;

************************* PREPARE BLAME DATA *******************************;

* Import file;
libname long xlsx "/home/u63541235/sasuser.v94/Victim Blame Files/1. Blame + Threat + Mediation/Victim Blame S1-3 LONG 2025.08.04.xlsx";

* Make sure data sets accessible in the working library;
data long; set long.long; run;

* Sort by ID and target;
proc sort data=long; by respondentid VictVsPerp; run;

* Make sure SAS recognizes that fear, age, and religiosity are numeric; 
data long; /* Create new data set, use the same dataset name */
  set long; /* Read data from the original dataset */
  /* Convert character variables to numeric using INPUT function */
  age_c = input(age_c, best32.); 
  zage_c = input(zage_c, best32.);
  fear_c = input(fear_c, best32.); 
  zfear_c = input(zfear_c, best32.);
  rel_c = input(rel_c, best32.); 
  zrel_c = input(zrel_c, best32.); 
  polS_c = input(polS_c, best32.); 
  zpolS_c = input(zpolS_c, best32.);
  selfblame = input(selfblame, best32.);
  zselfblame = input(zselfblame, best32.);
run;

* All effects coded variables also need to be recognized as numeric;
data long; 
  set long; 
  sexBinE = input(sexBinE, best32.); 
  sexBin = input(sexBin, best32.); 
  pgen_ec1 = input(pgen_ec1, best32.); 
  pgen_ec2 = input(pgen_ec2, best32.); 
  rpgen2_ec1 = input(rpgen2_ec1, best32.); 
  rpgen2_ec2 = input(rpgen2_ec2, best32.); 
  sess_ec1 = input(sess_ec1, best32.); 
  sess_ec2 = input(sess_ec2, best32.); 
  rsess2_ec1 = input(rsess2_ec1, best32.); 
  rsess2_ec2 = input(rsess2_ec2, best32.);   
  sexOrien_Bin = input(sexOrien_Bin, best32.);
  sexOrBin_E = input(sexOrBin_E, best32.);
run;

* Check the frequencies to make sure all categorical variables coded right;
proc freq data=long; 
   tables VictVsPerp PerpVsVict sexBin sexBinE polGen pgen_ec1 pgen_ec2 rpgen2_ec1 rpgen2_ec2 sess_ec1 sess_ec2
   rsess2_ec1 rsess2_ec2 sexOrien_Bin sexOrBin_E
   / nocol norow nopercent; 
run;

* Check means of the continuous variables;
proc means data=long n mean std min max;
    var age_c fear_c rel_c selfblame polS_c
    zage_c zfear_c zrel_c zselfblame zpolS_c;
run;

************************* PREPARE WIDE DATA *******************************;

* Now do much the same as above for the wide dataset;

* Import file;
libname wide xlsx "/home/u63541235/sasuser.v94/Victim Blame Files/1. Blame + Threat + Mediation/Victim Blame S1-3 WIDE 2025.08.04.xlsx";

* Make sure data sets accessible in the working library;
data wide; set wide.wide; run;

* Sort by ID;
proc sort data=wide; by respondentid; run;

* Make sure SAS recognizes that fear, age, and religiosity are numeric;
data wide; 
  set wide; 
  age_c = input(age_c, best32.); 
  fear_c = input(fear_c, best32.); 
  rel_c = input(rel_c, best32.); 
run;

* All effects coded variables also need to be recognized as numeric;
data wide; 
  set wide; 
  sexBin = input(sexBin, best32.); 
  sexBinE = input(sexBinE, best32.); 
  pgen_ec1 = input(pgen_ec1, best32.); 
  pgen_ec2 = input(pgen_ec2, best32.); 
  rpgen2_ec1 = input(rpgen2_ec1, best32.); 
  rpgen2_ec2 = input(rpgen2_ec2, best32.); 
  sess_ec1 = input(sess_ec1, best32.); 
  sess_ec2 = input(sess_ec2, best32.); 
  rsess2_ec1 = input(rsess2_ec1, best32.); 
  rsess2_ec2 = input(rsess2_ec2, best32.);   
  sexOrien_Bin = input(sexOrien_Bin, best32.);
  sexOrBin_E = input(sexOrBin_E, best32.);
run;


* Check the frequencies to make sure all categorical variables coded right;
proc freq data=wide; 
   tables sexBin sexBinE polGen pgen_ec1 pgen_ec2 rpgen2_ec1 rpgen2_ec2 sess_ec1 sess_ec2
   rsess2_ec1 rsess2_ec2 sexOrien_Bin sexOrBin_E
   / nocol norow nopercent; 
run;

* Check means of the continuous variables;
proc means data=wide n mean std min max;
    var age_c fear_c rel_c zage_c zfear_c zrel_c;
run;

************************* PREPARE STACKED DATA *******************************;

* Now create stacked data with separate rows for the mediator (threat, k = 1) and outcome (blame, k = 2) for the mediation analyses;

* Fear/threat data;
 /*Can use the raw value as the outcome and then use the centered value as the predictor in next section, but using the centered in both for consistency*/
data threatdv; set wide;
m=1; y=0; 
outcome=fear_c;
run;
proc sort data=threatdv; by respondentid; run;

* Blame data;
data blamedv; set long;
m=0; y=1;
outcome=selfblame;
run;
proc sort data=blamedv; by respondentid; run;

* Stack them together;
data stacked; set threatdv blamedv; run;
proc sort data=stacked; by respondentid m y; run;

* Carry down values in the data that came from the wide data where it would otherwise be missing;
data stacked; set stacked;
if VictVsPerp=. then VictVsPerp=.5; * Only in the stacked data, NOT SURE WHY .5 THOUGH, does it matter?;
if PerpVsVict=. then PerpVsVict=.5;
if m=1 and selfblame=. then dv2=1; 
if m=0 & VictVsPerp=1 then dv2=2;
if m=0 & VictVsPerp=0 then dv2=2;
run;

* Check the frequencies to make sure all categorical variables coded right;
proc freq data=stacked; 
   tables VictVsPerp PerpVsVict sexBin sexBinE polGen pgen_ec1 pgen_ec2 rpgen2_ec1 rpgen2_ec2 sess_ec1 sess_ec2
   rsess2_ec1 rsess2_ec2 sexOrien_Bin sexOrBin_E
   / nocol norow nopercent; 
run;

* Check means of the continuous variables;
proc means data=stacked n mean std min max;
    var age_c fear_c rel_c selfblame zage_c zfear_c zrel_c zselfblame;
run;

********************************************** CORRELATIONS ***********************************************;

PROC CORR DATA=wide;
    VAR selfPerp selfVict fear sexBin pgen_ec1 pgen_ec2 polSoc sess_ec1 
    sess_ec2 age relPrac sexOrien_Bin ;
RUN;

********************************************** CONDITION ON DVS ***********************************************;

* Condition on victim blame;
proc ttest data=wide;
   class condition;        
   var selfVict;        
run;

* Condition on perpetrator blame;
proc ttest data=wide;
   class condition;        
   var selfPerp;        
run;

* Condition on threat/fear;
proc ttest data=wide;
   class condition;        
   var fear;        
run;

********************************************** BLAME MODEL (c path) ***********************************************;

* Model 1;

* Base full factorial model with covariates, with class variables;
 */note that depending on system, might need to switch 0.00 to 0 in class statement; 
 */note that lsmeans gets mad if covariates are treated as class so effects coded sexOrBin_E instead;
proc mixed data=long noclprint covtest method=REML;
class respondentid VictVsPerp (ref="0.00") Session (ref="0") sexBin (ref="0") polGen (ref="0");
model selfblame =
VictVsPerp Session sexBin polGen
age_c rel_c sexOrBin_E
VictVsPerp*Session VictVsPerp*sexBin VictVsPerp*polGen Session*sexBin Session*polGen sexBin*polGen
VictVsPerp*age_c VictVsPerp*rel_c VictVsPerp*sexOrBin_E
Session*age_c Session*rel_c Session*sexOrBin_E
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E
polGen*age_c polGen*rel_c polGen*sexOrBin_E
VictVsPerp*Session*sexBin VictVsPerp*Session*polGen VictVsPerp*sexBin*polGen Session*sexBin*polGen
VictVsPerp*Session*age_c VictVsPerp*Session*rel_c VictVsPerp*Session*sexOrBin_E
VictVsPerp*sexBin*age_c VictVsPerp*sexBin*rel_c VictVsPerp*sexBin*sexOrBin_E
VictVsPerp*polGen*age_c VictVsPerp*polGen*rel_c VictVsPerp*polGen*sexOrBin_E
Session*sexBin*age_c Session*sexBin*rel_c Session*sexBin*sexOrBin_E
Session*polGen*age_c Session*polGen*rel_c Session*polGen*sexOrBin_E
VictVsPerp*Session*sexBin*polGen
VictVsPerp*Session*sexBin*age_c VictVsPerp*Session*sexBin*rel_c VictVsPerp*Session*sexBin*sexOrBin_E
VictVsPerp*Session*polGen*age_c VictVsPerp*Session*polGen*rel_c VictVsPerp*Session*polGen*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;

*Model 2;

* Same as above, drop 4-way interactions because all nonsignificant;
* Model ls means to compare to results of social ideology;
proc mixed data=long noclprint covtest method=REML;
class respondentid VictVsPerp (ref="0.00") Session (ref="0") sexBin (ref="0") polGen (ref="0");
model selfblame =
VictVsPerp Session sexBin polGen
age_c rel_c sexOrBin_E
VictVsPerp*Session VictVsPerp*sexBin VictVsPerp*polGen Session*sexBin Session*polGen sexBin*polGen
VictVsPerp*age_c VictVsPerp*rel_c VictVsPerp*sexOrBin_E
Session*age_c Session*rel_c Session*sexOrBin_E
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E
polGen*age_c polGen*rel_c polGen*sexOrBin_E
VictVsPerp*Session*sexBin VictVsPerp*Session*polGen VictVsPerp*sexBin*polGen Session*sexBin*polGen
VictVsPerp*Session*age_c VictVsPerp*Session*rel_c VictVsPerp*Session*sexOrBin_E
VictVsPerp*sexBin*age_c VictVsPerp*sexBin*rel_c VictVsPerp*sexBin*sexOrBin_E
VictVsPerp*polGen*age_c VictVsPerp*polGen*rel_c VictVsPerp*polGen*sexOrBin_E
Session*sexBin*age_c Session*sexBin*rel_c Session*sexBin*sexOrBin_E
Session*polGen*age_c Session*polGen*rel_c Session*polGen*sexOrBin_E
/ s ddfm=kr;
lsmeans VictVsPerp session sexBin polgen /*4 main effects*/
VictVsPerp*session VictVsPerp*sexBin VictVsPerp*polgen session*sexBin session*polgen sexBin*polgen /*6 2-ways*/ 
VictVsPerp*Session*sexBin VictVsPerp*Session*polGen VictVsPerp*sexBin*polGen Session*sexBin*polGen /*4 3-ways*/ 
/ at (age_c rel_c sexOrBin_E)= (0 0 0) tdiff pdiff;
repeated / subject=respondentid type=un;
RUN;

* Model 3;

* Drop 3-way interactions because all nonsignificant;
* Final c path model to obtain marginal means;

proc mixed data=long noclprint covtest method=REML;
class respondentid VictVsPerp (ref="0.00") Session (ref="0") sexBin (ref="0") polGen (ref="0");
model selfblame =
VictVsPerp Session sexBin polGen
age_c rel_c sexOrBin_E
VictVsPerp*Session VictVsPerp*sexBin VictVsPerp*polGen Session*sexBin Session*polGen sexBin*polGen
VictVsPerp*age_c VictVsPerp*rel_c VictVsPerp*sexOrBin_E
Session*age_c Session*rel_c Session*sexOrBin_E
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E
polGen*age_c polGen*rel_c polGen*sexOrBin_E
/ s ddfm=kr;
lsmeans VictVsPerp session sexBin polgen /*4 main effects*/
VictVsPerp*session VictVsPerp*sexBin VictVsPerp*polgen session*sexBin session*polgen sexBin*polgen /*6 2-ways*/ 
/ at (age_c rel_c sexOrBin_E)= (0 0 0) tdiff pdiff;
repeated / subject=respondentid type=un;
ods output lsmeans=blamegroupmeans;
RUN;

* Model 3a;

* Final c path model to obtain regression output for Appendix;

 */VictVsPerp 0 = Vict, 1 = Perp;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */SexBinE -.5 Female, .5 Male;
 */pgen_ec1 = -.333 Lib, .666 Mod (compares Lib to Mod);
 */pgen_ec2 = -.333 Lib, .666 Con (compares Lib to Con);
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for victime, averaged across everything else;
* Impact of being a man (versus woman) on blame for victims, averaged across everything else;
* Impact of being moderate/conservative (versus liberal) on blame for victims, averaged across everything else;
proc mixed data=long noclprint covtest method=REML;
class respondentid;
model selfblame =
VictVsPerp sess_ec1 sess_ec2 SexBinE pgen_ec1 pgen_ec2 
age_c rel_c sexOrBin_E
VictVsPerp*sess_ec1 VictVsPerp*sess_ec2 VictVsPerp*SexBinE VictVsPerp*pgen_ec1 VictVsPerp*pgen_ec2 
sess_ec1*SexBinE sess_ec2*SexBinE 
sess_ec1*pgen_ec1 sess_ec2*pgen_ec1 sess_ec1*pgen_ec2 sess_ec2*pgen_ec2 SexBinE*pgen_ec1 SexBinE*pgen_ec2 
VictVsPerp*age_c VictVsPerp*rel_c VictVsPerp*sexOrBin_E 
sess_ec1*age_c sess_ec1*rel_c sess_ec1*sexOrBin_E
sess_ec2*age_c sess_ec2*rel_c sess_ec2*sexOrBin_E
SexBinE*age_c SexBinE*rel_c SexBinE*sexOrBin_E
pgen_ec1*age_c pgen_ec1*rel_c pgen_ec1*sexOrBin_E
pgen_ec2*age_c pgen_ec2*rel_c pgen_ec2*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;

* Additional models for total effect in medatiation 

* Model 3b 

 */VictVsPerp 0 = Perp, 1 = Vict;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */SexBinE -.5 Female, .5 Male;
 */pgen_ec1 = -.333 Lib, .666 Mod (compares Lib to Mod);
 */pgen_ec2 = -.333 Lib, .666 Con (compares Lib to Con);
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for perpetrators, averaged across everything else;
* Impact of being a man (versus woman) on blame for perpetrators, averaged across everything else;
* Impact of being moderate/conservative (versus liberal) on blame for perpetrators, averaged across everything else;
  */This is the same as Model 3a except switch VictVsPerp to PerpVsVict;
proc mixed data=long noclprint covtest method=REML;
class respondentid;
model selfblame =
PerpVsVict sess_ec1 sess_ec2 SexBinE pgen_ec1 pgen_ec2 
age_c rel_c sexOrBin_E
PerpVsVict*sess_ec1 PerpVsVict*sess_ec2 PerpVsVict*SexBinE PerpVsVict*pgen_ec1 PerpVsVict*pgen_ec2 sess_ec1*SexBinE sess_ec2*SexBinE 
sess_ec1*pgen_ec1 sess_ec2*pgen_ec1 sess_ec1*pgen_ec2 sess_ec2*pgen_ec2 SexBinE*pgen_ec1 SexBinE*pgen_ec2 
PerpVsVict*age_c PerpVsVict*rel_c PerpVsVict*sexOrBin_E 
sess_ec1*age_c sess_ec1*rel_c sess_ec1*sexOrBin_E
sess_ec2*age_c sess_ec2*rel_c sess_ec2*sexOrBin_E
SexBinE*age_c SexBinE*rel_c SexBinE*sexOrBin_E
pgen_ec1*age_c pgen_ec1*rel_c pgen_ec1*sexOrBin_E
pgen_ec2*age_c pgen_ec2*rel_c pgen_ec2*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;

* Model 3c  
  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)
  - Liberal/Conservative = -.66/.33 (rpgen2_ec1)
  - Moderate/Conservative = -.66/.33 (rpgen2_ec2);
  
* Impact of Session 1/2 (versus 3) on blame for victims, averaged across everything else;
* Impact of being liberal/moderate (vs. conservative) on blame for victims, averaged across everything else;
  */This is the same as Model 3a except changed sess and pgen variables;
proc mixed data=long noclprint covtest method=REML;
class respondentid;
model selfblame =
VictVsPerp rsess2_ec1 rsess2_ec2 SexBinE rpgen2_ec1 rpgen2_ec2 
age_c rel_c sexOrBin_E
VictVsPerp*rsess2_ec1 VictVsPerp*rsess2_ec2 VictVsPerp*SexBinE VictVsPerp*rpgen2_ec1 VictVsPerp*rpgen2_ec2 rsess2_ec1*SexBinE rsess2_ec2*SexBinE 
rsess2_ec1*rpgen2_ec1 rsess2_ec2*rpgen2_ec1 rsess2_ec1*rpgen2_ec2 rsess2_ec2*rpgen2_ec2 SexBinE*rpgen2_ec1 SexBinE*rpgen2_ec2 
VictVsPerp*age_c VictVsPerp*rel_c VictVsPerp*sexOrBin_E 
rsess2_ec1*age_c rsess2_ec1*rel_c rsess2_ec1*sexOrBin_E
rsess2_ec2*age_c rsess2_ec2*rel_c rsess2_ec2*sexOrBin_E
SexBinE*age_c SexBinE*rel_c SexBinE*sexOrBin_E
rpgen2_ec1*age_c rpgen2_ec1*rel_c rpgen2_ec1*sexOrBin_E
rpgen2_ec2*age_c rpgen2_ec2*rel_c rpgen2_ec2*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;

* Model 3d 
  - Perpetrator/Victim = 0/1 (PerpVsVict)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)
  - Liberal/Conservative = -.66/.33 (rpgen2_ec1)
  - Moderate/Conservative = -.66/.33 (rpgen2_ec2);
  
* Impact of Session 1/2 (versus 3) on blame for perpetrators, averaged across everything else;
* Impact of being liberal/moderate (vs. conservative) on blame for perpetrators, averaged across everything else;
  */This is the same as Model 3c except switched VictVsPerp to PerpVsVict;
proc mixed data=long noclprint covtest method=REML;
class respondentid;
model selfblame =
PerpVsVict rsess2_ec1 rsess2_ec2 SexBinE rpgen2_ec1 rpgen2_ec2 
age_c rel_c sexOrBin_E
PerpVsVict*rsess2_ec1 PerpVsVict*rsess2_ec2 PerpVsVict*SexBinE PerpVsVict*rpgen2_ec1 PerpVsVict*rpgen2_ec2 rsess2_ec1*SexBinE rsess2_ec2*SexBinE 
rsess2_ec1*rpgen2_ec1 rsess2_ec2*rpgen2_ec1 rsess2_ec1*rpgen2_ec2 rsess2_ec2*rpgen2_ec2 SexBinE*rpgen2_ec1 SexBinE*rpgen2_ec2 
PerpVsVict*age_c PerpVsVict*rel_c PerpVsVict*sexOrBin_E 
rsess2_ec1*age_c rsess2_ec1*rel_c rsess2_ec1*sexOrBin_E
rsess2_ec2*age_c rsess2_ec2*rel_c rsess2_ec2*sexOrBin_E
SexBinE*age_c SexBinE*rel_c SexBinE*sexOrBin_E
rpgen2_ec1*age_c rpgen2_ec1*rel_c rpgen2_ec1*sexOrBin_E
rpgen2_ec2*age_c rpgen2_ec2*rel_c rpgen2_ec2*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;


* Difference score robustness check

Model 4a;
* Dummy coded version for marginal means;
proc glm data=wide;
class Session (ref="0") sexBin (ref="0") polGen (ref="0");
model difScore =
Session sexBin polGen 
age_c rel_c sexOrBin_E
Session*sexBin Session*polGen 
sexBin*polGen 
Session*age_c Session*rel_c Session*sexOrBin_E
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E
polGen*age_c polGen*rel_c polGen*sexOrBin_E
/ solution;
lsmeans session sexBin polgen 
session*sexBin session*polgen sexBin*polgen 
/ at (age_c rel_c sexOrBin_E)= (0 0 0) tdiff stderr pdiff;
ods output lsmeans=threatgroupmeans;
RUN;

* Final c path model to obtain regression output for Appendix;

* Model 4b;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */SexBinE -.5 Female, .5 Male;
 */pgen_ec1 = -.333 Lib, .666 Mod (compares Lib to Mod);
 */pgen_ec2 = -.333 Lib, .666 Con (compares Lib to Con);
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on difference score, averaged across everything else;
* Impact of being a man (versus woman) on difference score, averaged across everything else;
* Impact of being moderate/conservative (versus liberal) on difference score, averaged across everything else;
proc glm data=wide;
model difScore =
sess_ec1 sess_ec2 SexBinE pgen_ec1 pgen_ec2 
age_c rel_c sexOrBin_E
sess_ec1*SexBinE sess_ec2*SexBinE 
sess_ec1*pgen_ec1 sess_ec2*pgen_ec1 sess_ec1*pgen_ec2 sess_ec2*pgen_ec2 
SexBinE*pgen_ec1 SexBinE*pgen_ec2 
sess_ec1*age_c sess_ec1*rel_c sess_ec1*sexOrBin_E
sess_ec2*age_c sess_ec2*rel_c sess_ec2*sexOrBin_E
SexBinE*age_c SexBinE*rel_c SexBinE*sexOrBin_E
pgen_ec1*age_c pgen_ec1*rel_c pgen_ec1*sexOrBin_E
pgen_ec2*age_c pgen_ec2*rel_c pgen_ec2*sexOrBin_E
/ solution;
RUN;

* Model 4c
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)
  - Liberal/Conservative = -.66/.33 (rpgen2_ec1)
  - Moderate/Conservative = -.66/.33 (rpgen2_ec2);
 
* Impact of Session 2/3 (versus 1) on difference score, averaged across everything else;
* Impact of being a man (versus woman) on difference score, averaged across everything else;
* Impact of being moderate/conservative (versus liberal) on difference score, averaged across everything else;
  */This is the same as Model 4a except changed sess and pgen variables;
proc glm data=wide;
model difScore =
rsess2_ec1 rsess2_ec2 SexBinE rpgen2_ec1 rpgen2_ec2 
age_c rel_c sexOrBin_E
rsess2_ec1*SexBinE rsess2_ec2*SexBinE 
rsess2_ec1*rpgen2_ec1 rsess2_ec2*rpgen2_ec1 rsess2_ec1*rpgen2_ec2 rsess2_ec2*rpgen2_ec2 
SexBinE*rpgen2_ec1 SexBinE*rpgen2_ec2 
rsess2_ec1*age_c rsess2_ec1*rel_c rsess2_ec1*sexOrBin_E
rsess2_ec2*age_c rsess2_ec2*rel_c rsess2_ec2*sexOrBin_E
SexBinE*age_c SexBinE*rel_c SexBinE*sexOrBin_E
rpgen2_ec1*age_c rpgen2_ec1*rel_c rpgen2_ec1*sexOrBin_E
rpgen2_ec2*age_c rpgen2_ec2*rel_c rpgen2_ec2*sexOrBin_E
/ solution;
RUN;


********************************************** THREAT MODEL (a path) ***********************************************;

* Model 5;

* Base full factorial model with covariates, with class variables;
proc glm data=wide;
class Session (ref="0") sexBin (ref="0") polgen (ref="0");
model fear = 
session sexBin polGen 
age_c rel_c sexOrBin_E
session*sexBin session*polGen sexBin*polGen
Session*age_c Session*rel_c Session*sexOrBin_E 
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E 
polgen*age_c polgen*rel_c polgen*sexOrBin_E
session*sexBin*polGen
session*sexBin*age_c session*sexBin*rel_c session*sexBin*sexOrBin_e
session*polGen*age_c session*polGen*rel_c session*polGen*sexOrBin_e
/ solution;
run;

* Model 6.

* Drop all 3-way interactions because none significant;
* Final a path model to obtain marginal means;
* /Note that regression version is identical to mediation output below so don't need to estimate it here;

proc glm data=wide;
class Session (ref="0") sexBin (ref="0") polgen (ref="0");
model fear = 
session sexBin polGen 
age_c rel_c sexOrBin_E 
session*sexBin session*polGen sexBin*polGen 
Session*age_c Session*rel_c Session*sexOrBin_E 
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E 
polgen*age_c polgen*rel_c polgen*sexOrBin_E 
/ solution;
lsmeans session sexBin polgen 
session*sexBin session*polgen sexBin*polgen 
/ at (age_c rel_c sexOrBin_E)= (0 0 0) tdiff stderr pdiff;
ods output lsmeans=threatgroupmeans;
run;


***************************************************************** MEDIATION MODEL ***********************************************************************;

* This model stacks the a and c models on top of each other and "tricks" it into estimating the multilevel mediation;
  */ Cite Bauer, Preacher, and Gil, 2006;
  
* Indirect effects to test
  -Impact of sex on blame through threat, separate moderated paths for victim/perpetrator (b & c), averaged across everything else 
  -Impact of pol on blame through threat, separate moderated paths for victim/perpetrator (b & c), averaged across everything else
  -Impact of session on blame through threat, separate moderated paths for victim/perpetrator (b & c), averaged across everything else;

********** TEST THAT STACKING A AND C MODELS REPLICATES SEPARATE MODELS *************;

* Model 7;
  
* Dummy code everything to confirm that you replicate the separate a and c paths;
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2 VictVsPerp (ref="0.00") Session (ref="0") sexBin (ref="0") polgen (ref="0");
model  outcome =
/*a path - fear-threat part*/										/*Moderation part*/														/*Covariates*/
m m*session m*sexBin m*polGen 										m*session*sexBin m*session*polGen m*sexBin*polGen 				   		m*age_c m*rel_c m*sexOrBin_E 
         																																	m*session*age_c m*session*rel_c m*session*sexOrBin_E 
        																																	m*sexBin*age_c m*sexBin*rel_c m*sexBin*sexOrBin_E 
        																																	m*polGen*age_c m*polGen*rel_c m*polGen*sexOrBin_E 
/*c path - blame part*/
y y*VictVsPerp y*Session y*sexBin y*polGen  						y*VictVsPerp*Session y*VictVsPerp*sexBin y*VictVsPerp*polGen  			y*Age_c y*Rel_c y*sexOrBin_E
																	y*Session*sexBin y*Session*polGen y*sexBin*polGen  						y*VictVsPerp*Age_c y*VictVsPerp*Rel_c y*VictVsPerp*sexOrBin_E
																																			y*Session*Age_c y*Session*Rel_c y*Session*sexOrBin_E
																																			y*sexBin*Age_c y*sexBin*Rel_c y*sexBin*sexOrBin_E
																																			y*polGen*Age_c y*polGen*Rel_c y*polGen*sexOrBin_E
/ noint covb ddfm=kr s cl;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

* The group=dv2 statement within the repeated option specifies that different covariance structures 
  will be estimated for different levels of dv2. Each level of dv2 gets its own unique covariance 
  matrix rather than assuming the same covariance structure for all levels

********************************************* PRIMARY OMNIBUS MODEL *********************************************;

*Model 8;

* Dummy code everything;
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2 VictVsPerp (ref="0.00") Session (ref="0") sexBin (ref="0") polgen (ref="0");
model  outcome =
/*a path - fear-threat part*/										/*Moderation part*/														/*Covariates*/
m m*session m*sexBin m*polGen 										m*session*sexBin m*session*polGen m*sexBin*polGen 				   		 m*age_c m*rel_c m*sexOrBin_E 
         																																	m*session*age_c m*session*rel_c m*session*sexOrBin_E 
        																																	m*sexBin*age_c m*sexBin*rel_c m*sexBin*sexOrBin_E 
        																																	m*polGen*age_c m*polGen*rel_c m*polGen*sexOrBin_E 
/*c path - blame part*/
y y*VictVsPerp y*Session y*sexBin y*polGen  						y*VictVsPerp*Session y*VictVsPerp*sexBin y*VictVsPerp*polGen  			y*Age_c y*Rel_c y*sexOrBin_E
																	y*Session*sexBin y*Session*polGen y*sexBin*polGen  						y*VictVsPerp*Age_c y*VictVsPerp*Rel_c y*VictVsPerp*sexOrBin_E
																																			y*Session*Age_c y*Session*Rel_c y*Session*sexOrBin_E
																																			y*sexBin*Age_c y*sexBin*Rel_c y*sexBin*sexOrBin_E
																																			y*polGen*Age_c y*polGen*Rel_c y*polGen*sexOrBin_E
/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c
/ noint covb ddfm=kr s cl;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

********* PRIMARY MODEL - SESSION 2 & 3 (VS. 1), GENDER, AND MODERATE & CONSERVATIVE (VS. LIBERAL) ON VICTIM BLAME *********;

* Model 8a;

* Final model to be included in the Appendix where everything except RM is effects coded with 
  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/2 = -.333/.666 (sess_ec1)
  - Session 1/3 = -.333/.666 (sess_ec1)
  - Female/Male = -.5/.5 (rSexBinE)
  - Liberal/Moderate =  -.333/.666 (pgen_ec1)
  - Liberal/Conservative = -.333/.666 (pgen_ec2);
  
* Impact of Session 2/3 (versus 1) on blame through threat, for victims (b & c paths), averaged across everything else;
* Impact of being a man (versus woman) on blame through threat, for victims (b & c paths), averaged across everything else;
* Impact of being moderate/conservative (versus liberal) on blame through threat, for victims (b & c), averaged across everything else;
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/											/*Moderation part*/														/*Covariates*/
m m*sess_ec1 m*sess_ec2 m*sexBinE m*pgen_ec1 m*pgen_ec2 				m*sess_ec1*sexBinE m*sess_ec2*sexBinE 							    	m*age_c m*rel_c m*sexOrBin_E
         																m*sess_ec1*pgen_ec1 m*sess_ec1*pgen_ec2   								m*sess_ec1*age_c m*sess_ec1*rel_c m*sess_ec1*sexOrBin_E 
																		m*sess_ec2*pgen_ec1 m*sess_ec2*pgen_ec2 								m*sess_ec2*age_c m*sess_ec2*rel_c m*sess_ec2*sexOrBin_E 
        																m*sexBinE*pgen_ec1 m*sexBinE*pgen_ec2									m*sexBinE*age_c m*sexBinE*rel_c m*sexBinE*sexOrBin_E 
																																				m*pgen_ec1*age_c m*pgen_ec1*rel_c m*pgen_ec1*sexOrBin_E 
        																																		m*pgen_ec2*age_c m*pgen_ec2*rel_c m*pgen_ec2*sexOrBin_E 
/*c path - blame part*/
y y*VictVsPerp y*sess_ec1 y*sess_ec2 y*sexBinE y*pgen_ec1 y*pgen_ec2 	y*VictVsPerp*sess_ec1 y*VictVsPerp*sess_ec2								y*Age_c y*Rel_c y*sexOrBin_E
																		y*VictVsPerp*SexBinE y*VictVsPerp*pgen_ec1 y*VictVsPerp*pgen_ec2 		y*VictVsPerp*Age_c y*VictVsPerp*Rel_c y*VictVsPerp*sexOrBin_E
																		y*sess_ec1*sexBinE y*sess_ec2*sexBinE   								y*sess_ec1*Age_c y*sess_ec1*Rel_c y*sess_ec1*sexOrBin_E
																		y*sess_ec1*pgen_ec1 y*sess_ec1*pgen_ec2   								y*sess_ec2*Age_c y*sess_ec2*Rel_c y*sess_ec2*sexOrBin_E
																		y*sess_ec2*pgen_ec1 y*sess_ec2*pgen_ec2 								y*sexBinE*Age_c y*sexBinE*Rel_c y*sexBinE*sexOrBin_E
																		y*sexBinE*pgen_ec1 y*sexBinE*pgen_ec2									y*pgen_ec1*Age_c y*pgen_ec1*Rel_c y*pgen_ec1*sexOrBin_E
																																				y*pgen_ec2*Age_c y*pgen_ec2*Rel_c y*pgen_ec2*sexOrBin_E
/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

************* GENDER, SESSION 2 & 3 (VS. 1), AND MODERATE & CONSERVATIVE (VS. LIBERAL) ON PERPETRATOR BLAME *********;

*Now need to change reference groups to estimate remaining indirect effects;

* Model 8b;
* Impact of Session 2/3 (versus 1) on blame through threat, for perpetrators (b & c paths), averaged across everything else;
* Impact of being a man (versus woman) on blame through threat, for perpetrators (b & c paths), averaged across everything else;
* Impact of being moderate/conservative (versus liberal) on blame through threat, for perpetrators (b & c), averaged across everything else;
  */This is the same as Model 7a except switch VictVsPerp to PerpVsVict;
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/											/*Moderation part*/														/*Covariates*/
m m*sess_ec1 m*sess_ec2 m*sexBinE m*pgen_ec1 m*pgen_ec2 				m*sess_ec1*sexBinE m*sess_ec2*sexBinE 							   		m*age_c m*rel_c m*sexOrBin_E
         																m*sess_ec1*pgen_ec1 m*sess_ec1*pgen_ec2   								m*sess_ec1*age_c m*sess_ec1*rel_c m*sess_ec1*sexOrBin_E 
																		m*sess_ec2*pgen_ec1 m*sess_ec2*pgen_ec2 								m*sess_ec2*age_c m*sess_ec2*rel_c m*sess_ec2*sexOrBin_E 
        																m*sexBinE*pgen_ec1 m*sexBinE*pgen_ec2									m*sexBinE*age_c m*sexBinE*rel_c m*sexBinE*sexOrBin_E 
																																				m*pgen_ec1*age_c m*pgen_ec1*rel_c m*pgen_ec1*sexOrBin_E 
        																																		m*pgen_ec2*age_c m*pgen_ec2*rel_c m*pgen_ec2*sexOrBin_E 
/*c path - blame part*/
y y*PerpVsVict y*sess_ec1 y*sess_ec2 y*sexBinE y*pgen_ec1 y*pgen_ec2 	y*PerpVsVict*sess_ec1 y*PerpVsVict*sess_ec2								y*age_c y*rel_c y*sexOrBin_E
																		y*PerpVsVict*SexBinE y*PerpVsVict*pgen_ec1 y*PerpVsVict*pgen_ec2 		y*PerpVsVict*age_c y*PerpVsVict*rel_c y*PerpVsVict*sexOrBin_E
																		y*sess_ec1*sexBinE y*sess_ec2*sexBinE   								y*sess_ec1*age_c y*sess_ec1*rel_c y*sess_ec1*sexOrBin_E
																		y*sess_ec1*pgen_ec1 y*sess_ec1*pgen_ec2   								y*sess_ec2*age_c y*sess_ec2*rel_c y*sess_ec2*sexOrBin_E
																		y*sess_ec2*pgen_ec1 y*sess_ec2*pgen_ec2 								y*sexBinE*age_c y*sexBinE*rel_c y*sexBinE*sexOrBin_E
																		y*sexBinE*pgen_ec1 y*sexBinE*pgen_ec2									y*pgen_ec1*age_c y*pgen_ec1*rel_c y*pgen_ec1*sexOrBin_E
																																				y*pgen_ec2*age_c y*pgen_ec2*rel_c y*pgen_ec2*sexOrBin_E
/*b path - blame part*/
y*fear_c y*PerpVsVict*fear_c
/ noint covb ddfm=kr s /*cl*/;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

********************** GENDER, SESSION 1 & 2 (VS. 3), AND LIBERAL & MODERATIVE (VS. CONSERVATIVE) ON VICTIM BLAME *********************;

* Model 8c;

* Coded with 
  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/3 = -.666/.333 (rsess3_ec1)
  - Session 2/3 = -.666/.333 (rsess3_ec2)
  - Female/Male = -.5/.5 (rSexBinE)
  - Liberal/Conservative = -.66/.33 (rpgen3_ec1)
  - Moderate/Conservative = -.66/.33 (rpgen3_ec2);
  
* Impact of Session 1/2 (versus 3) on blame through threat, for victims (b & c paths), averaged across everything else;
* Impact of being liberal/moderate (vs. conservative) on blame through threat, for victims (b & c), averaged across everything else;
  */This is the same as Model 7a except change sess and pgen variables;
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/													/*Moderation part*/														/*Covariates*/
m m*rsess2_ec1 m*rsess2_ec2 m*SexBinE m*rpgen2_ec1 m*rpgen2_ec2 				m*rsess2_ec1*SexBinE m*rsess2_ec2*SexBinE 								m*age_c m*rel_c m*sexOrBin_E
         																		m*rsess2_ec1*rpgen2_ec1 m*rsess2_ec1*rpgen2_ec2   						m*rsess2_ec1*age_c m*rsess2_ec1*rel_c m*rsess2_ec1*sexOrBin_E 
																				m*rsess2_ec2*rpgen2_ec1 m*rsess2_ec2*rpgen2_ec2 						m*rsess2_ec2*age_c m*rsess2_ec2*rel_c m*rsess2_ec2*sexOrBin_E 
        																		m*SexBinE*rpgen2_ec1 m*SexBinE*rpgen2_ec2								m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																						m*rpgen2_ec1*age_c m*rpgen2_ec1*rel_c m*rpgen2_ec1*sexOrBin_E 
        																																				m*rpgen2_ec2*age_c m*rpgen2_ec2*rel_c m*rpgen2_ec2*sexOrBin_E 
/*c path - blame part*/
y y*VictVsPerp y*rsess2_ec1 y*rsess2_ec2 y*SexBinE y*rpgen2_ec1 y*rpgen2_ec2 	y*VictVsPerp*rsess2_ec1 y*VictVsPerp*rsess2_ec2							y*age_c y*rel_c y*sexOrBin_E
																				y*VictVsPerp*SexBinE y*VictVsPerp*rpgen2_ec1 y*VictVsPerp*rpgen2_ec2 	y*VictVsPerp*age_c y*VictVsPerp*rel_c y*VictVsPerp*sexOrBin_E
																				y*rsess2_ec1*SexBinE y*rsess2_ec2*SexBinE   							y*rsess2_ec1*age_c y*rsess2_ec1*rel_c y*rsess2_ec1*sexOrBin_E
																				y*rsess2_ec1*rpgen2_ec1 y*rsess2_ec1*rpgen2_ec2   						y*rsess2_ec2*age_c y*rsess2_ec2*rel_c y*rsess2_ec2*sexOrBin_E
																				y*rsess2_ec2*rpgen2_ec1 y*rsess2_ec2*rpgen2_ec2 						y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
																				y*SexBinE*rpgen2_ec1 y*SexBinE*rpgen2_ec2								y*rpgen2_ec1*age_c y*rpgen2_ec1*rel_c y*rpgen2_ec1*sexOrBin_E
																																						y*rpgen2_ec2*age_c y*rpgen2_ec2*rel_c y*rpgen2_ec2*sexOrBin_E
/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

********************** GENDER, SESSION 1 & 2 (VS. 3), AND LIBERAL & MODERATIVE (VS. CONSERVATIVE) ON PERPETRATOR BLAME *********************;

* Model 8d; 
  
* Impact of Session 1/2 (versus 3) on blame through threat, for perpetrators (b & c paths), averaged across everything else;
* Impact of being liberal/moderate (vs. conservative) on blame through threat, for perpetrators (b & c), averaged across everything else;
  */This is the same as Model 7c except switch VictVsPerp to PerpVsVict;
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/													/*Moderation part*/														/*Covariates*/
m m*rsess2_ec1 m*rsess2_ec2 m*SexBinE m*rpgen2_ec1 m*rpgen2_ec2 				m*rsess2_ec1*SexBinE m*rsess2_ec2*SexBinE 								m*age_c m*rel_c m*sexOrBin_E
         																		m*rsess2_ec1*rpgen2_ec1 m*rsess2_ec1*rpgen2_ec2   						m*rsess2_ec1*age_c m*rsess2_ec1*rel_c m*rsess2_ec1*sexOrBin_E 
																				m*rsess2_ec2*rpgen2_ec1 m*rsess2_ec2*rpgen2_ec2 						m*rsess2_ec2*age_c m*rsess2_ec2*rel_c m*rsess2_ec2*sexOrBin_E 
        																		m*SexBinE*rpgen2_ec1 m*SexBinE*rpgen2_ec2								m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																						m*rpgen2_ec1*age_c m*rpgen2_ec1*rel_c m*rpgen2_ec1*sexOrBin_E 
        																																				m*rpgen2_ec2*age_c m*rpgen2_ec2*rel_c m*rpgen2_ec2*sexOrBin_E 
/*c path - blame part*/
y y*PerpVsVict y*rsess2_ec1 y*rsess2_ec2 y*SexBinE y*rpgen2_ec1 y*rpgen2_ec2 	y*PerpVsVict*rsess2_ec1 y*PerpVsVict*rsess2_ec2							y*Age_c y*Rel_c y*sexOrBin_E
																				y*PerpVsVict*SexBinE y*PerpVsVict*rpgen2_ec1 y*PerpVsVict*rpgen2_ec2 	y*PerpVsVict*Age_c y*PerpVsVict*Rel_c y*PerpVsVict*sexOrBin_E
																				y*rsess2_ec1*SexBinE y*rsess2_ec2*SexBinE   							y*rsess2_ec1*Age_c y*rsess2_ec1*Rel_c y*rsess2_ec1*sexOrBin_E
																				y*rsess2_ec1*rpgen2_ec1 y*rsess2_ec1*rpgen2_ec2   						y*rsess2_ec2*Age_c y*rsess2_ec2*Rel_c y*rsess2_ec2*sexOrBin_E
																				y*rsess2_ec2*rpgen2_ec1 y*rsess2_ec2*rpgen2_ec2 						y*SexBinE*Age_c y*SexBinE*Rel_c y*SexBinE*sexOrBin_E
																				y*SexBinE*rpgen2_ec1 y*SexBinE*rpgen2_ec2								y*rpgen2_ec1*Age_c y*rpgen2_ec1*Rel_c y*rpgen2_ec1*sexOrBin_E
																																						y*rpgen2_ec2*Age_c y*rpgen2_ec2*Rel_c y*rpgen2_ec2*sexOrBin_E
/*b path - blame part*/
y*fear_c y*PerpVsVict*fear_c
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

*********************************** INDIRECT EFFECT CONFIDENCE INTERVALS ***********************************************************;

* Now go to R to estimate the CIs for the indirect effects;


**************************************************************************************************************************************
*************************************************** ANALYSES USING SOCIAL IDEOLOGY ***************************************************
**************************************************************************************************************************************


********************************************** BLAME MODEL (c path) ***********************************************;

* Model 9 (paralell to Model 1);
* Base full factorial model with covariates, with class variables;

proc mixed data=long noclprint covtest method=REML;
class respondentid VictVsPerp (ref="0.00") Session (ref="0") sexBin (ref="0");
model selfblame =
VictVsPerp Session sexBin polS_c
age_c rel_c sexOrBin_E
VictVsPerp*Session VictVsPerp*sexBin VictVsPerp*polS_c Session*sexBin Session*polS_c sexBin*polS_c
VictVsPerp*age_c VictVsPerp*rel_c VictVsPerp*sexOrBin_E
Session*age_c Session*rel_c Session*sexOrBin_E
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E
polS_c*age_c polS_c*rel_c polS_c*sexOrBin_E
VictVsPerp*Session*sexBin VictVsPerp*Session*polS_c VictVsPerp*sexBin*polS_c Session*sexBin*polS_c
VictVsPerp*Session*age_c VictVsPerp*Session*rel_c VictVsPerp*Session*sexOrBin_E
VictVsPerp*sexBin*age_c VictVsPerp*sexBin*rel_c VictVsPerp*sexBin*sexOrBin_E
VictVsPerp*polS_c*age_c VictVsPerp*polS_c*rel_c VictVsPerp*polS_c*sexOrBin_E
Session*sexBin*age_c Session*sexBin*rel_c Session*sexBin*sexOrBin_E
Session*polS_c*age_c Session*polS_c*rel_c Session*polS_c*sexOrBin_E
VictVsPerp*Session*sexBin*polS_c
VictVsPerp*Session*sexBin*age_c VictVsPerp*Session*sexBin*rel_c VictVsPerp*Session*sexBin*sexOrBin_E
VictVsPerp*Session*polS_c*age_c VictVsPerp*Session*polS_c*rel_c VictVsPerp*Session*polS_c*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;

* Model 10 (paralell to Model 2);
* Same as above, drop 4-way interactions because all nonsignificant;
* Final c path model, break down in future models since can't get marginal means because polSoc is continuous;

proc mixed data=long noclprint covtest method=REML;
class respondentid VictVsPerp (ref="0.00") Session (ref="0") sexBin (ref="0");
model selfblame =
VictVsPerp Session sexBin polS_c
age_c rel_c sexOrBin_E
VictVsPerp*Session VictVsPerp*sexBin VictVsPerp*polS_c Session*sexBin Session*polS_c sexBin*polS_c
VictVsPerp*age_c VictVsPerp*rel_c VictVsPerp*sexOrBin_E
Session*age_c Session*rel_c Session*sexOrBin_E
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E
polS_c*age_c polS_c*rel_c polS_c*sexOrBin_E
VictVsPerp*Session*sexBin VictVsPerp*Session*polS_c VictVsPerp*sexBin*polS_c Session*sexBin*polS_c
VictVsPerp*Session*age_c VictVsPerp*Session*rel_c VictVsPerp*Session*sexOrBin_E
VictVsPerp*sexBin*age_c VictVsPerp*sexBin*rel_c VictVsPerp*sexBin*sexOrBin_E
VictVsPerp*polS_c*age_c VictVsPerp*polS_c*rel_c VictVsPerp*polS_c*sexOrBin_E
Session*sexBin*age_c Session*sexBin*rel_c Session*sexBin*sexOrBin_E
Session*polS_c*age_c Session*polS_c*rel_c Session*polS_c*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;
* polS_c*VictVs*session significant, keep 3-ways 


* Model 10a (No parallel since did not break down 3-ways in models using polGen)

* Final c path model to obtain regression output for Appendix;

* All effect coded except for VictVsPerp
 */VictVsPerp 0 = Perp, 1 = Vict;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */rSexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for victims for moderates, averaged across everything else;
 
proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
VictVsPerp sess_ec1 sess_ec2 SexBinE polS_c age_c rel_c sexOrBin_E
VictVsPerp*sess_ec1 VictVsPerp*sess_ec2  VictVsPerp*sexBinE  VictVsPerp*polS_c 
sess_ec1*SexBinE sess_ec2*SexBinE sess_ec1*polS_c sess_ec2*polS_c sexBinE*polS_c 
VictVsPerp*age_c  VictVsPerp*rel_c  VictVsPerp*sexOrBin_E
sess_ec1*age_c sess_ec1*rel_c sess_ec1*sexOrBin_E
sess_ec2*age_c sess_ec2*rel_c sess_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
polS_c*age_c polS_c*rel_c polS_c*sexOrBin_E
VictVsPerp*sess_ec1*sexBinE  VictVsPerp*sess_ec2*sexBinE 
VictVsPerp*sess_ec1*polS_c  VictVsPerp*sess_ec2*polS_c 
VictVsPerp*sexBinE*polS_c 
sess_ec1*sexBinE*polS_c sess_ec2*sexBinE*polS_c
VictVsPerp*sess_ec1*age_c  VictVsPerp*sess_ec2*age_c 
VictVsPerp*sess_ec1*rel_c VictVsPerp*sess_ec2*rel_c 
VictVsPerp*sess_ec1*sexOrBin_E VictVsPerp*sess_ec2*sexOrBin_E
VictVsPerp*sexBinE*age_c  VictVsPerp*sexBinE*rel_c  VictVsPerp*sexBinE*sexOrBin_E
VictVsPerp*polS_c*age_c  VictVsPerp*polS_c*rel_c VictVsPerp*polS_c*sexOrBin_E
sess_ec1*sexBinE*age_c  sess_ec2*sexBinE*age_c 
sess_ec1*sexBinE*rel_c sess_ec2*sexBinE*rel_c 
sess_ec1*sexBinE*sexOrBin_E sess_ec2*sexBinE*sexOrBin_E
sess_ec1*polS_c*age_c sess_ec2*polS_c*age_c 
sess_ec1*polS_c*rel_c sess_ec2*polS_c*rel_c 
sess_ec1*polS_c*sexOrBin_E sess_ec2*polS_c*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;


* Model 10b 

 */VictVsPerp 0 = Perp, 1 = Vict;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */rSexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for perpetrators for moderates, averaged across everything else;

* This is the same as Model 9a except changed target to be perpetrator;
 
proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
PerpVsVict sess_ec1 sess_ec2 SexBinE polS_c age_c rel_c sexOrBin_E
PerpVsVict*sess_ec1 PerpVsVict*sess_ec2  PerpVsVict*sexBinE  PerpVsVict*polS_c 
sess_ec1*SexBinE sess_ec2*SexBinE sess_ec1*polS_c sess_ec2*polS_c sexBinE*polS_c 
PerpVsVict*age_c  PerpVsVict*rel_c  PerpVsVict*sexOrBin_E
sess_ec1*age_c sess_ec1*rel_c sess_ec1*sexOrBin_E
sess_ec2*age_c sess_ec2*rel_c sess_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
polS_c*age_c polS_c*rel_c polS_c*sexOrBin_E
PerpVsVict*sess_ec1*sexBinE  PerpVsVict*sess_ec2*sexBinE 
PerpVsVict*sess_ec1*polS_c  PerpVsVict*sess_ec2*polS_c 
PerpVsVict*sexBinE*polS_c 
sess_ec1*sexBinE*polS_c sess_ec2*sexBinE*polS_c
PerpVsVict*sess_ec1*age_c  PerpVsVict*sess_ec2*age_c 
PerpVsVict*sess_ec1*rel_c PerpVsVict*sess_ec2*rel_c 
PerpVsVict*sess_ec1*sexOrBin_E PerpVsVict*sess_ec2*sexOrBin_E
PerpVsVict*sexBinE*age_c  PerpVsVict*sexBinE*rel_c  PerpVsVict*sexBinE*sexOrBin_E
PerpVsVict*polS_c*age_c  PerpVsVict*polS_c*rel_c PerpVsVict*polS_c*sexOrBin_E
sess_ec1*sexBinE*age_c  sess_ec2*sexBinE*age_c 
sess_ec1*sexBinE*rel_c sess_ec2*sexBinE*rel_c 
sess_ec1*sexBinE*sexOrBin_E sess_ec2*sexBinE*sexOrBin_E
sess_ec1*polS_c*age_c sess_ec2*polS_c*age_c 
sess_ec1*polS_c*rel_c sess_ec2*polS_c*rel_c 
sess_ec1*polS_c*sexOrBin_E sess_ec2*polS_c*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;


* Model 10c  

  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for victims for moderates, averaged across everything else;

* This is the same as Model 9a except change session variables;
 
proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
VictVsPerp rsess2_ec1 rsess2_ec2 SexBinE polS_c age_c rel_c sexOrBin_E
VictVsPerp*rsess2_ec1 VictVsPerp*rsess2_ec2  VictVsPerp*sexBinE  VictVsPerp*polS_c 
rsess2_ec1*SexBinE rsess2_ec2*SexBinE rsess2_ec1*polS_c rsess2_ec2*polS_c sexBinE*polS_c 
VictVsPerp*age_c  VictVsPerp*rel_c  VictVsPerp*sexOrBin_E
rsess2_ec1*age_c rsess2_ec1*rel_c rsess2_ec1*sexOrBin_E
rsess2_ec2*age_c rsess2_ec2*rel_c rsess2_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
polS_c*age_c polS_c*rel_c polS_c*sexOrBin_E
VictVsPerp*rsess2_ec1*sexBinE  VictVsPerp*rsess2_ec2*sexBinE 
VictVsPerp*rsess2_ec1*polS_c  VictVsPerp*rsess2_ec2*polS_c 
VictVsPerp*sexBinE*polS_c 
rsess2_ec1*sexBinE*polS_c rsess2_ec2*sexBinE*polS_c
VictVsPerp*rsess2_ec1*age_c  VictVsPerp*rsess2_ec2*age_c 
VictVsPerp*rsess2_ec1*rel_c VictVsPerp*rsess2_ec2*rel_c 
VictVsPerp*rsess2_ec1*sexOrBin_E VictVsPerp*rsess2_ec2*sexOrBin_E
VictVsPerp*sexBinE*age_c  VictVsPerp*sexBinE*rel_c  VictVsPerp*sexBinE*sexOrBin_E
VictVsPerp*polS_c*age_c  VictVsPerp*polS_c*rel_c VictVsPerp*polS_c*sexOrBin_E
rsess2_ec1*sexBinE*age_c  rsess2_ec2*sexBinE*age_c 
rsess2_ec1*sexBinE*rel_c rsess2_ec2*sexBinE*rel_c 
rsess2_ec1*sexBinE*sexOrBin_E rsess2_ec2*sexBinE*sexOrBin_E
rsess2_ec1*polS_c*age_c rsess2_ec2*polS_c*age_c 
rsess2_ec1*polS_c*rel_c rsess2_ec2*polS_c*rel_c 
rsess2_ec1*polS_c*sexOrBin_E rsess2_ec2*polS_c*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;

* Model 10d  

  - Perpetrator/Victim = 0/1 (PerpVsVict)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for perpetrator for moderates, averaged across everything else;

* This is the same as Model 10b except change session variables;

proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
PerpVsVict rsess2_ec1 rsess2_ec2 SexBinE polS_c age_c rel_c sexOrBin_E
PerpVsVict*rsess2_ec1 PerpVsVict*rsess2_ec2  PerpVsVict*sexBinE  PerpVsVict*polS_c 
rsess2_ec1*SexBinE rsess2_ec2*SexBinE rsess2_ec1*polS_c rsess2_ec2*polS_c sexBinE*polS_c 
PerpVsVict*age_c  PerpVsVict*rel_c PerpVsVict*sexOrBin_E
rsess2_ec1*age_c rsess2_ec1*rel_c rsess2_ec1*sexOrBin_E
rsess2_ec2*age_c rsess2_ec2*rel_c rsess2_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
polS_c*age_c polS_c*rel_c polS_c*sexOrBin_E
PerpVsVict*rsess2_ec1*sexBinE PerpVsVict*rsess2_ec2*sexBinE 
PerpVsVict*rsess2_ec1*polS_c PerpVsVict*rsess2_ec2*polS_c 
PerpVsVict*sexBinE*polS_c 
rsess2_ec1*sexBinE*polS_c rsess2_ec2*sexBinE*polS_c
PerpVsVict*rsess2_ec1*age_c PerpVsVict*rsess2_ec2*age_c 
PerpVsVict*rsess2_ec1*rel_c PerpVsVict*rsess2_ec2*rel_c 
PerpVsVict*rsess2_ec1*sexOrBin_E PerpVsVict*rsess2_ec2*sexOrBin_E
PerpVsVict*sexBinE*age_c PerpVsVict*sexBinE*rel_c  PerpVsVict*sexBinE*sexOrBin_E
PerpVsVict*polS_c*age_c PerpVsVict*polS_c*rel_c PerpVsVict*polS_c*sexOrBin_E
rsess2_ec1*sexBinE*age_c rsess2_ec2*sexBinE*age_c 
rsess2_ec1*sexBinE*rel_c rsess2_ec2*sexBinE*rel_c 
rsess2_ec1*sexBinE*sexOrBin_E rsess2_ec2*sexBinE*sexOrBin_E
rsess2_ec1*polS_c*age_c rsess2_ec2*polS_c*age_c 
rsess2_ec1*polS_c*rel_c rsess2_ec2*polS_c*rel_c 
rsess2_ec1*polS_c*sexOrBin_E rsess2_ec2*polS_c*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;

**** Recoded for liberals ****

* Model 10e

 */VictVsPerp 0 = Vict, 1 = Perp;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */rSexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for victims for liberals, averaged across everything else;
 
* Same as 9a, but for liberals;

proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
VictVsPerp sess_ec1 sess_ec2 SexBinE pSoc_L age_c rel_c sexOrBin_E
VictVsPerp*sess_ec1 VictVsPerp*sess_ec2  VictVsPerp*sexBinE  VictVsPerp*pSoc_L 
sess_ec1*SexBinE sess_ec2*SexBinE sess_ec1*pSoc_L sess_ec2*pSoc_L sexBinE*pSoc_L 
VictVsPerp*age_c VictVsPerp*rel_c  VictVsPerp*sexOrBin_E
sess_ec1*age_c sess_ec1*rel_c sess_ec1*sexOrBin_E
sess_ec2*age_c sess_ec2*rel_c sess_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
pSoc_L*age_c pSoc_L*rel_c pSoc_L*sexOrBin_E
VictVsPerp*sess_ec1*sexBinE VictVsPerp*sess_ec2*sexBinE 
VictVsPerp*sess_ec1*pSoc_L VictVsPerp*sess_ec2*pSoc_L 
VictVsPerp*sexBinE*pSoc_L 
sess_ec1*sexBinE*pSoc_L sess_ec2*sexBinE*pSoc_L
VictVsPerp*sess_ec1*age_c VictVsPerp*sess_ec2*age_c 
VictVsPerp*sess_ec1*rel_c VictVsPerp*sess_ec2*rel_c 
VictVsPerp*sess_ec1*sexOrBin_E VictVsPerp*sess_ec2*sexOrBin_E
VictVsPerp*sexBinE*age_c VictVsPerp*sexBinE*rel_c  VictVsPerp*sexBinE*sexOrBin_E
VictVsPerp*pSoc_L*age_c VictVsPerp*pSoc_L*rel_c VictVsPerp*pSoc_L*sexOrBin_E
sess_ec1*sexBinE*age_c sess_ec2*sexBinE*age_c 
sess_ec1*sexBinE*rel_c sess_ec2*sexBinE*rel_c 
sess_ec1*sexBinE*sexOrBin_E sess_ec2*sexBinE*sexOrBin_E
sess_ec1*pSoc_L*age_c sess_ec2*pSoc_L*age_c 
sess_ec1*pSoc_L*rel_c sess_ec2*pSoc_L*rel_c 
sess_ec1*pSoc_L*sexOrBin_E sess_ec2*pSoc_L*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;


* Model 10f

 */PerpVsVict 0 = Perp, 1 = Vict;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */rSexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for perpetrators for liberals, averaged across everything else;
 
* Same as 9b, but for liberals;

proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
PerpVsVict sess_ec1 sess_ec2 SexBinE pSoc_L age_c rel_c sexOrBin_E
PerpVsVict*sess_ec1 PerpVsVict*sess_ec2  PerpVsVict*sexBinE  PerpVsVict*pSoc_L 
sess_ec1*SexBinE sess_ec2*SexBinE sess_ec1*pSoc_L sess_ec2*pSoc_L sexBinE*pSoc_L 
PerpVsVict*age_c PerpVsVict*rel_c  PerpVsVict*sexOrBin_E
sess_ec1*age_c sess_ec1*rel_c sess_ec1*sexOrBin_E
sess_ec2*age_c sess_ec2*rel_c sess_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
pSoc_L*age_c pSoc_L*rel_c pSoc_L*sexOrBin_E
PerpVsVict*sess_ec1*sexBinE PerpVsVict*sess_ec2*sexBinE 
PerpVsVict*sess_ec1*pSoc_L PerpVsVict*sess_ec2*pSoc_L 
PerpVsVict*sexBinE*pSoc_L 
sess_ec1*sexBinE*pSoc_L sess_ec2*sexBinE*pSoc_L
PerpVsVict*sess_ec1*age_c PerpVsVict*sess_ec2*age_c 
PerpVsVict*sess_ec1*rel_c PerpVsVict*sess_ec2*rel_c 
PerpVsVict*sess_ec1*sexOrBin_E PerpVsVict*sess_ec2*sexOrBin_E
PerpVsVict*sexBinE*age_c PerpVsVict*sexBinE*rel_c  PerpVsVict*sexBinE*sexOrBin_E
PerpVsVict*pSoc_L*age_c PerpVsVict*pSoc_L*rel_c PerpVsVict*pSoc_L*sexOrBin_E
sess_ec1*sexBinE*age_c sess_ec2*sexBinE*age_c 
sess_ec1*sexBinE*rel_c sess_ec2*sexBinE*rel_c 
sess_ec1*sexBinE*sexOrBin_E sess_ec2*sexBinE*sexOrBin_E
sess_ec1*pSoc_L*age_c sess_ec2*pSoc_L*age_c 
sess_ec1*pSoc_L*rel_c sess_ec2*pSoc_L*rel_c 
sess_ec1*pSoc_L*sexOrBin_E sess_ec2*pSoc_L*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;


* Model 10g
  
  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for victims for liberals, averaged across everything else;

* This is the same as Model 9c, but for liberals;
 
proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
VictVsPerp rsess2_ec1 rsess2_ec2 SexBinE pSoc_L age_c rel_c sexOrBin_E
VictVsPerp*rsess2_ec1 VictVsPerp*rsess2_ec2  VictVsPerp*sexBinE  VictVsPerp*pSoc_L 
rsess2_ec1*SexBinE rsess2_ec2*SexBinE rsess2_ec1*pSoc_L rsess2_ec2*pSoc_L sexBinE*pSoc_L 
VictVsPerp*age_c  VictVsPerp*rel_c  VictVsPerp*sexOrBin_E
rsess2_ec1*age_c rsess2_ec1*rel_c rsess2_ec1*sexOrBin_E
rsess2_ec2*age_c rsess2_ec2*rel_c rsess2_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
pSoc_L*age_c pSoc_L*rel_c pSoc_L*sexOrBin_E
VictVsPerp*rsess2_ec1*sexBinE  VictVsPerp*rsess2_ec2*sexBinE 
VictVsPerp*rsess2_ec1*pSoc_L  VictVsPerp*rsess2_ec2*pSoc_L 
VictVsPerp*sexBinE*pSoc_L 
rsess2_ec1*sexBinE*pSoc_L rsess2_ec2*sexBinE*pSoc_L
VictVsPerp*rsess2_ec1*age_c  VictVsPerp*rsess2_ec2*age_c 
VictVsPerp*rsess2_ec1*rel_c VictVsPerp*rsess2_ec2*rel_c 
VictVsPerp*rsess2_ec1*sexOrBin_E VictVsPerp*rsess2_ec2*sexOrBin_E
VictVsPerp*sexBinE*age_c  VictVsPerp*sexBinE*rel_c  VictVsPerp*sexBinE*sexOrBin_E
VictVsPerp*pSoc_L*age_c  VictVsPerp*pSoc_L*rel_c VictVsPerp*pSoc_L*sexOrBin_E
rsess2_ec1*sexBinE*age_c  rsess2_ec2*sexBinE*age_c 
rsess2_ec1*sexBinE*rel_c rsess2_ec2*sexBinE*rel_c 
rsess2_ec1*sexBinE*sexOrBin_E rsess2_ec2*sexBinE*sexOrBin_E
rsess2_ec1*pSoc_L*age_c rsess2_ec2*pSoc_L*age_c 
rsess2_ec1*pSoc_L*rel_c rsess2_ec2*pSoc_L*rel_c 
rsess2_ec1*pSoc_L*sexOrBin_E rsess2_ec2*pSoc_L*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;


* Model 10h

  - Perpetrator/Victim = 0/1 (PerpVsVict)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for perpetrator for liberals, averaged across everything else;

* This is the same as Model 9d but for liberals;

proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
PerpVsVict rsess2_ec1 rsess2_ec2 SexBinE pSoc_L age_c rel_c sexOrBin_E
PerpVsVict*rsess2_ec1 PerpVsVict*rsess2_ec2  PerpVsVict*sexBinE  PerpVsVict*pSoc_L 
rsess2_ec1*SexBinE rsess2_ec2*SexBinE rsess2_ec1*pSoc_L rsess2_ec2*pSoc_L sexBinE*pSoc_L 
PerpVsVict*age_c  PerpVsVict*rel_c PerpVsVict*sexOrBin_E
rsess2_ec1*age_c rsess2_ec1*rel_c rsess2_ec1*sexOrBin_E
rsess2_ec2*age_c rsess2_ec2*rel_c rsess2_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
pSoc_L*age_c pSoc_L*rel_c pSoc_L*sexOrBin_E
PerpVsVict*rsess2_ec1*sexBinE PerpVsVict*rsess2_ec2*sexBinE 
PerpVsVict*rsess2_ec1*pSoc_L PerpVsVict*rsess2_ec2*pSoc_L 
PerpVsVict*sexBinE*pSoc_L 
rsess2_ec1*sexBinE*pSoc_L rsess2_ec2*sexBinE*pSoc_L
PerpVsVict*rsess2_ec1*age_c PerpVsVict*rsess2_ec2*age_c 
PerpVsVict*rsess2_ec1*rel_c PerpVsVict*rsess2_ec2*rel_c 
PerpVsVict*rsess2_ec1*sexOrBin_E PerpVsVict*rsess2_ec2*sexOrBin_E
PerpVsVict*sexBinE*age_c PerpVsVict*sexBinE*rel_c  PerpVsVict*sexBinE*sexOrBin_E
PerpVsVict*pSoc_L*age_c PerpVsVict*pSoc_L*rel_c PerpVsVict*pSoc_L*sexOrBin_E
rsess2_ec1*sexBinE*age_c rsess2_ec2*sexBinE*age_c 
rsess2_ec1*sexBinE*rel_c rsess2_ec2*sexBinE*rel_c 
rsess2_ec1*sexBinE*sexOrBin_E rsess2_ec2*sexBinE*sexOrBin_E
rsess2_ec1*pSoc_L*age_c rsess2_ec2*pSoc_L*age_c 
rsess2_ec1*pSoc_L*rel_c rsess2_ec2*pSoc_L*rel_c 
rsess2_ec1*pSoc_L*sexOrBin_E rsess2_ec2*pSoc_L*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;


**** Recoded for conservatives ****

* Model 10i

 */VictVsPerp 0 = Vict, 1 = Perp;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */rSexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for victims for conservatives, averaged across everything else;
 
* Same as 9a, but for conservatives;

proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
VictVsPerp sess_ec1 sess_ec2 SexBinE pSoc_H age_c rel_c sexOrBin_E
VictVsPerp*sess_ec1 VictVsPerp*sess_ec2  VictVsPerp*sexBinE  VictVsPerp*pSoc_H 
sess_ec1*SexBinE sess_ec2*SexBinE sess_ec1*pSoc_H sess_ec2*pSoc_H sexBinE*pSoc_H 
VictVsPerp*age_c VictVsPerp*rel_c  VictVsPerp*sexOrBin_E
sess_ec1*age_c sess_ec1*rel_c sess_ec1*sexOrBin_E
sess_ec2*age_c sess_ec2*rel_c sess_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
pSoc_H*age_c pSoc_H*rel_c pSoc_H*sexOrBin_E
VictVsPerp*sess_ec1*sexBinE VictVsPerp*sess_ec2*sexBinE 
VictVsPerp*sess_ec1*pSoc_H VictVsPerp*sess_ec2*pSoc_H 
VictVsPerp*sexBinE*pSoc_H 
sess_ec1*sexBinE*pSoc_H sess_ec2*sexBinE*pSoc_H
VictVsPerp*sess_ec1*age_c VictVsPerp*sess_ec2*age_c 
VictVsPerp*sess_ec1*rel_c VictVsPerp*sess_ec2*rel_c 
VictVsPerp*sess_ec1*sexOrBin_E VictVsPerp*sess_ec2*sexOrBin_E
VictVsPerp*sexBinE*age_c VictVsPerp*sexBinE*rel_c  VictVsPerp*sexBinE*sexOrBin_E
VictVsPerp*pSoc_H*age_c VictVsPerp*pSoc_H*rel_c VictVsPerp*pSoc_H*sexOrBin_E
sess_ec1*sexBinE*age_c sess_ec2*sexBinE*age_c 
sess_ec1*sexBinE*rel_c sess_ec2*sexBinE*rel_c 
sess_ec1*sexBinE*sexOrBin_E sess_ec2*sexBinE*sexOrBin_E
sess_ec1*pSoc_H*age_c sess_ec2*pSoc_H*age_c 
sess_ec1*pSoc_H*rel_c sess_ec2*pSoc_H*rel_c 
sess_ec1*pSoc_H*sexOrBin_E sess_ec2*pSoc_H*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;


* Model 10j

 */VictVsPerp 0 = Perp, 1 = Vict;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */SexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for perpetrators for conservatives, averaged across everything else;

* Same as 9b, but for conservatives;
 
proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
PerpVsVict sess_ec1 sess_ec2 SexBinE pSoc_H age_c rel_c sexOrBin_E
PerpVsVict*sess_ec1 PerpVsVict*sess_ec2 PerpVsVict*sexBinE PerpVsVict*pSoc_H 
sess_ec1*SexBinE sess_ec2*SexBinE sess_ec1*pSoc_H sess_ec2*pSoc_H sexBinE*pSoc_H 
PerpVsVict*age_c PerpVsVict*rel_c PerpVsVict*sexOrBin_E
sess_ec1*age_c sess_ec1*rel_c sess_ec1*sexOrBin_E
sess_ec2*age_c sess_ec2*rel_c sess_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
pSoc_H*age_c pSoc_H*rel_c pSoc_H*sexOrBin_E
PerpVsVict*sess_ec1*sexBinE PerpVsVict*sess_ec2*sexBinE 
PerpVsVict*sess_ec1*pSoc_H PerpVsVict*sess_ec2*pSoc_H 
PerpVsVict*sexBinE*pSoc_H 
sess_ec1*sexBinE*pSoc_H sess_ec2*sexBinE*pSoc_H
PerpVsVict*sess_ec1*age_c PerpVsVict*sess_ec2*age_c 
PerpVsVict*sess_ec1*rel_c PerpVsVict*sess_ec2*rel_c 
PerpVsVict*sess_ec1*sexOrBin_E PerpVsVict*sess_ec2*sexOrBin_E
PerpVsVict*sexBinE*age_c PerpVsVict*sexBinE*rel_c  PerpVsVict*sexBinE*sexOrBin_E
PerpVsVict*pSoc_H*age_c PerpVsVict*pSoc_H*rel_c PerpVsVict*pSoc_H*sexOrBin_E
sess_ec1*sexBinE*age_c sess_ec2*sexBinE*age_c 
sess_ec1*sexBinE*rel_c sess_ec2*sexBinE*rel_c 
sess_ec1*sexBinE*sexOrBin_E sess_ec2*sexBinE*sexOrBin_E
sess_ec1*pSoc_H*age_c sess_ec2*pSoc_H*age_c 
sess_ec1*pSoc_H*rel_c sess_ec2*pSoc_H*rel_c 
sess_ec1*pSoc_H*sexOrBin_E sess_ec2*pSoc_H*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;


* Model 10k 

  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for victims for conservatives, averaged across everything else;

* Same as 9c, but for conservatives;
 
proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
VictVsPerp rsess2_ec1 rsess2_ec2 SexBinE pSoc_H age_c rel_c sexOrBin_E
VictVsPerp*rsess2_ec1 VictVsPerp*rsess2_ec2  VictVsPerp*sexBinE  VictVsPerp*pSoc_H 
rsess2_ec1*SexBinE rsess2_ec2*SexBinE rsess2_ec1*pSoc_H rsess2_ec2*pSoc_H sexBinE*pSoc_H 
VictVsPerp*age_c  VictVsPerp*rel_c  VictVsPerp*sexOrBin_E
rsess2_ec1*age_c rsess2_ec1*rel_c rsess2_ec1*sexOrBin_E
rsess2_ec2*age_c rsess2_ec2*rel_c rsess2_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
pSoc_H*age_c pSoc_H*rel_c pSoc_H*sexOrBin_E
VictVsPerp*rsess2_ec1*sexBinE  VictVsPerp*rsess2_ec2*sexBinE 
VictVsPerp*rsess2_ec1*pSoc_H  VictVsPerp*rsess2_ec2*pSoc_H 
VictVsPerp*sexBinE*pSoc_H 
rsess2_ec1*sexBinE*pSoc_H rsess2_ec2*sexBinE*pSoc_H
VictVsPerp*rsess2_ec1*age_c  VictVsPerp*rsess2_ec2*age_c 
VictVsPerp*rsess2_ec1*rel_c VictVsPerp*rsess2_ec2*rel_c 
VictVsPerp*rsess2_ec1*sexOrBin_E VictVsPerp*rsess2_ec2*sexOrBin_E
VictVsPerp*sexBinE*age_c  VictVsPerp*sexBinE*rel_c  VictVsPerp*sexBinE*sexOrBin_E
VictVsPerp*pSoc_H*age_c  VictVsPerp*pSoc_H*rel_c VictVsPerp*pSoc_H*sexOrBin_E
rsess2_ec1*sexBinE*age_c  rsess2_ec2*sexBinE*age_c 
rsess2_ec1*sexBinE*rel_c rsess2_ec2*sexBinE*rel_c 
rsess2_ec1*sexBinE*sexOrBin_E rsess2_ec2*sexBinE*sexOrBin_E
rsess2_ec1*pSoc_H*age_c rsess2_ec2*pSoc_H*age_c 
rsess2_ec1*pSoc_H*rel_c rsess2_ec2*pSoc_H*rel_c 
rsess2_ec1*pSoc_H*sexOrBin_E rsess2_ec2*pSoc_H*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;

* Model 10l

  - Perpetrator/Victim = 0/1 (PerpVsVict)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for perpetrator for moderates, averaged across everything else;

* This is the same as Model 9d but for conservatives;

proc mixed data=long noclprint covtest method=REML;
class respondentid ;
model selfblame =
PerpVsVict rsess2_ec1 rsess2_ec2 SexBinE pSoc_H age_c rel_c sexOrBin_E
PerpVsVict*rsess2_ec1 PerpVsVict*rsess2_ec2  PerpVsVict*sexBinE  PerpVsVict*pSoc_H 
rsess2_ec1*SexBinE rsess2_ec2*SexBinE rsess2_ec1*pSoc_H rsess2_ec2*pSoc_H sexBinE*pSoc_H 
PerpVsVict*age_c  PerpVsVict*rel_c PerpVsVict*sexOrBin_E
rsess2_ec1*age_c rsess2_ec1*rel_c rsess2_ec1*sexOrBin_E
rsess2_ec2*age_c rsess2_ec2*rel_c rsess2_ec2*sexOrBin_E
sexBinE*age_c sexBinE*rel_c sexBinE*sexOrBin_E
pSoc_H*age_c pSoc_H*rel_c pSoc_H*sexOrBin_E
PerpVsVict*rsess2_ec1*sexBinE PerpVsVict*rsess2_ec2*sexBinE 
PerpVsVict*rsess2_ec1*pSoc_H PerpVsVict*rsess2_ec2*pSoc_H 
PerpVsVict*sexBinE*pSoc_H 
rsess2_ec1*sexBinE*pSoc_H rsess2_ec2*sexBinE*pSoc_H
PerpVsVict*rsess2_ec1*age_c PerpVsVict*rsess2_ec2*age_c 
PerpVsVict*rsess2_ec1*rel_c PerpVsVict*rsess2_ec2*rel_c 
PerpVsVict*rsess2_ec1*sexOrBin_E PerpVsVict*rsess2_ec2*sexOrBin_E
PerpVsVict*sexBinE*age_c PerpVsVict*sexBinE*rel_c  PerpVsVict*sexBinE*sexOrBin_E
PerpVsVict*pSoc_H*age_c PerpVsVict*pSoc_H*rel_c PerpVsVict*pSoc_H*sexOrBin_E
rsess2_ec1*sexBinE*age_c rsess2_ec2*sexBinE*age_c 
rsess2_ec1*sexBinE*rel_c rsess2_ec2*sexBinE*rel_c 
rsess2_ec1*sexBinE*sexOrBin_E rsess2_ec2*sexBinE*sexOrBin_E
rsess2_ec1*pSoc_H*age_c rsess2_ec2*pSoc_H*age_c 
rsess2_ec1*pSoc_H*rel_c rsess2_ec2*pSoc_H*rel_c 
rsess2_ec1*pSoc_H*sexOrBin_E rsess2_ec2*pSoc_H*sexOrBin_E
/ s ddfm=kr;
repeated / subject=respondentid type=un;
RUN;

********************************************** THREAT MODEL (a path) ***********************************************;

*Model 11

*Base full factorial model with covariates, with class variables;
proc glm data=wide;
class Session (ref="0") sexBin (ref="0");
model fear = 
session sexBin polS_c 
age_c rel_c sexOrBin_E
session*sexBin session*polS_c sexBin*polS_c
Session*age_c Session*rel_c Session*sexOrBin_E 
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E 
polS_c*age_c polS_c*rel_c polS_c*sexOrBin_E
session*sexBin*polS_c
session*sexBin*age_c session*sexBin*rel_c session*sexBin*sexOrBin_e
session*polS_c*age_c session*polS_c*rel_c session*polS_c*sexOrBin_e
/ solution;
run;


* Model 12

* Drop all 3-way interactions because none significant;
* Final a path model;
* Note that regression version is identical to mediation output below so don't need to estimate it here;

proc glm data=wide;
class Session (ref="0") sexBin (ref="0");
model fear = 
session sexBin polS_c 
age_c rel_c sexOrBin_E 
session*sexBin session*polS_c sexBin*polS_c 
Session*age_c Session*rel_c Session*sexOrBin_E 
sexBin*age_c sexBin*rel_c sexBin*sexOrBin_E 
polS_c*age_c polS_c*rel_c polS_c*sexOrBin_E 
/ solution;
run;

***************************************************************** MEDIATION MODEL ***********************************************************************;

* This model stacks the a and c models on top of each other and "tricks" it into estimating the multilevel mediation;
  */ Cite Bauer, Preacher, and Gil, 2006;
  
* Indirect effects to test
  -Impact of sex on blame through threat, separate moderated paths for victim/perpetrator (b & c), averaged across everything else 
  -Impact of pol on blame through threat, separate moderated paths for victim/perpetrator (b & c), averaged across everything else
  
  -Impact of session on blame through threat, separate moderated paths for victim/perpetrator (b & c), averaged across everything else (political moderates)
  -Impact of session on blame through threat, separate moderated paths for victim/perpetrator (b & c) for social liberals, averaged across everything else
  -Impact of session on blame through threat, separate moderated paths for victim/perpetrator (b & c) for social conservatives, averaged across everything else;

********** TEST THAT STACKING A AND C MODELS REPLICATES SEPARATE MODELS *************;

* Model 13;
  
* Dummy code everything to confirm that you replicate the separate a and c paths;

proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2 VictVsPerp (ref="0.00") Session (ref="0") sexBin (ref="0");
model  outcome =
/*a path - fear-threat part*/						/*Moderation part*/													/*Covariates*/
m m*session m*sexBin m*polS_c 						m*session*sexBin m*session*polS_c m*sexBin*polS_c 				    m*age_c m*rel_c m*sexOrBin_E 
         																												m*session*age_c m*session*rel_c m*session*sexOrBin_E 
        																												m*sexBin*age_c m*sexBin*rel_c m*sexBin*sexOrBin_E 
        																												m*polS_c*age_c m*polS_c*rel_c m*polS_c*sexOrBin_E 






/*c path - blame part*/
y y*VictVsPerp y*Session y*sexBin y*polS_c  		y*VictVsPerp*Session y*VictVsPerp*sexBin y*VictVsPerp*polS_c  		y*age_c y*rel_c y*sexOrBin_E
													y*Session*sexBin y*Session*polS_c y*sexBin*polS_c  					y*VictVsPerp*age_c y*VictVsPerp*rel_c y*VictVsPerp*sexOrBin_E
													y*VictVsPerp*Session*sexBin y*VictVsPerp*Session*polS_c				y*Session*age_c y*Session*rel_c y*Session*sexOrBin_E
													y*VictVsPerp*sexBin*polS_c y*Session*sexBin*polS_c					y*sexBin*age_c y*sexBin*rel_c y*sexBin*sexOrBin_E
																														y*polS_c*age_c y*polS_c*rel_c y*polS_c*sexOrBin_E
																														y*VictVsPerp*Session*age_c  y*VictVsPerp*Session*rel_c y*VictVsPerp*Session*sexOrBin_E
																														y*VictVsPerp*sexBin*age_c y*VictVsPerp*sexBin*rel_c y*VictVsPerp*sexBin*sexOrBin_E
																														y*VictVsPerp*polS_c*age_c y*VictVsPerp*polS_c*rel_c y*VictVsPerp*polS_c*sexOrBin_E
																														y*Session*sexBin*age_c y*Session*sexBin*rel_c y*Session*sexBin*sexOrBin_E
																														y*Session*polS_c*age_c y*Session*polS_c*rel_c y*Session*polS_c*sexOrBin_E

/ noint covb ddfm=kr s cl;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;
 

********************************************* PRIMARY OMNIBUS MODEL *********************************************;

* Model 14;
  
* Dummy code everything;
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2 VictVsPerp (ref="0.00") Session (ref="0") sexBin (ref="0");
model  outcome =
/*a path - fear-threat part*/						/*Moderation part*/													/*Covariates*/
m m*session m*sexBin m*polS_c 						m*session*sexBin m*session*polS_c m*sexBin*polS_c 				    m*age_c m*rel_c m*sexOrBin_E 
         																												m*session*age_c m*session*rel_c m*session*sexOrBin_E 
        																												m*sexBin*age_c m*sexBin*rel_c m*sexBin*sexOrBin_E 
        																												m*polS_c*age_c m*polS_c*rel_c m*polS_c*sexOrBin_E 






/*c path - blame part*/
y y*VictVsPerp y*Session y*sexBin y*polS_c  		y*VictVsPerp*Session y*VictVsPerp*sexBin y*VictVsPerp*polS_c  		y*age_c y*rel_c y*sexOrBin_E
													y*Session*sexBin y*Session*polS_c y*sexBin*polS_c  					y*VictVsPerp*age_c y*VictVsPerp*rel_c y*VictVsPerp*sexOrBin_E
													y*VictVsPerp*Session*sexBin y*VictVsPerp*Session*polS_c				y*Session*age_c y*Session*rel_c y*Session*sexOrBin_E
													y*VictVsPerp*sexBin*polS_c y*Session*sexBin*polS_c					y*sexBin*age_c y*sexBin*rel_c y*sexBin*sexOrBin_E
																														y*polS_c*age_c y*polS_c*rel_c y*polS_c*sexOrBin_E
																														y*VictVsPerp*Session*age_c  y*VictVsPerp*Session*rel_c y*VictVsPerp*Session*sexOrBin_E
																														y*VictVsPerp*sexBin*age_c y*VictVsPerp*sexBin*rel_c y*VictVsPerp*sexBin*sexOrBin_E
																														y*VictVsPerp*polS_c*age_c y*VictVsPerp*polS_c*rel_c y*VictVsPerp*polS_c*sexOrBin_E
																														y*Session*sexBin*age_c y*Session*sexBin*rel_c y*Session*sexBin*sexOrBin_E
																														y*Session*polS_c*age_c y*Session*polS_c*rel_c y*Session*polS_c*sexOrBin_E

/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c
/ noint covb ddfm=kr s cl;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

********* PRIMARY MODEL - SESSION 2 & 3 (VS. 1), GENDER, AND CENTERED SOCIAL IDEOLOGY ON VICTIM BLAME *********;

* Final model to be included in the Appendix where everything except RM is effects coded with 
  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/2 = -.333/.666 (sess_ec1)
  - Session 1/3 = -.333/.666 (sess_ec1)
  - Female/Male = -.5/.5 (rSexBinE)
  
* Impact of Session 2/3 (versus 1) on blame through threat, for victims (b & c paths), averaged across everything else;
* Impact of being a man (versus woman) on blame through threat, for victims (b & c paths), averaged across everything else;
* Impact of ideology (centered) on blame through threat, for victims (b & c), averaged across everything else;

************* GENDER, SESSION 2 & 3 (VS. 1), AND CENTERED CENTERED SOCIAL IDEOLOGY ON PERPETRATOR BLAME *********;

* Now need to change reference groups to estimate remaining indirect effects;

* Model 14a; 

* Final model to be included in the Appendix where everything except RM is effects coded 

* Coded with 
  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/2 = -.333/.666 (sess_ec1)
  - Session 1/3 = -.333/.666 (sess_ec1)
  - Female/Male = -.5/.5 (SexBinE)
  
* Impact of Session 2/3 (versus 1) on blame through threat, for victims (b & c paths), averaged across everything else;

proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*sess_ec1 m*sess_ec2 m*SexBinE m*polS_c						m*sess_ec1*SexBinE m*sess_ec2*SexBinE									m*age_c m*rel_c m*sexOrBin_E
																m*sess_ec1*polS_c   m*sess_ec2*polS_c									m*sess_ec1*age_c m*sess_ec1*rel_c m*sess_ec1*sexOrBin_E 
																m*SexBinE*polS_c														m*sess_ec2*age_c m*sess_ec2*rel_c m*sess_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*polS_c*age_c m*polS_c*rel_c m*polS_c*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*VictVsPerp y*sess_ec1 y*sess_ec2 y*SexBinE y*polS_c			y*VictVsPerp*sess_ec1 y*VictVsPerp*sess_ec2								y*age_c y*rel_c y*sexOrBin_E
																y*VictVsPerp*SexBinE y*VictVsPerp*polS_c                       			y*VictVsPerp*age_c y*VictVsPerp*rel_c y*VictVsPerp*sexOrBin_E
																y*sess_ec1*SexBinE y*sess_ec2*SexBinE   								y*sess_ec1*age_c y*sess_ec1*rel_c y*sess_ec1*sexOrBin_E
																y*sess_ec1*polS_c  y*sess_ec2*polS_c    								y*sess_ec2*age_c y*sess_ec2*rel_c y*sess_ec2*sexOrBin_E
																y*SexBinE*polS_c								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*polS_c*age_c y*polS_c*rel_c y*polS_c*sexOrBin_E

																y*VictVsPerp*sess_ec1*sexBinE  y*VictVsPerp*sess_ec2*sexBinE 
																y*VictVsPerp*sess_ec1*polS_c  y*VictVsPerp*sess_ec2*polS_c 
																y*VictVsPerp*sexBinE*polS_c 
																y*sess_ec1*sexBinE*polS_c y*sess_ec2*sexBinE*polS_c
																y*VictVsPerp*sess_ec1*age_c y*VictVsPerp*sess_ec2*age_c 
																y*VictVsPerp*sess_ec1*rel_c y*VictVsPerp*sess_ec2*rel_c 
																y*VictVsPerp*sess_ec1*sexOrBin_E y*VictVsPerp*sess_ec2*sexOrBin_E
																y*VictVsPerp*sexBinE*age_c y*VictVsPerp*sexBinE*rel_c y*VictVsPerp*sexBinE*sexOrBin_E
																y*VictVsPerp*polS_c*age_c y*VictVsPerp*polS_c*rel_c y*VictVsPerp*polS_c*sexOrBin_E
																y*sess_ec1*sexBinE*age_c y*sess_ec2*sexBinE*age_c 
																y*sess_ec1*sexBinE*rel_c y*sess_ec2*sexBinE*rel_c 
																y*sess_ec1*sexBinE*sexOrBin_E y*sess_ec2*sexBinE*sexOrBin_E
																y*sess_ec1*polS_c*age_c y*sess_ec2*polS_c*age_c 	
																y*sess_ec1*polS_c*rel_c y*sess_ec2*polS_c*rel_c 		
																y*sess_ec1*polS_c*sexOrBin_E y*sess_ec2*polS_c*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

********************** GENDER, SESSION 1 & 2 (VS. 3), AND CENTERED SOCIAL IDEOLOGY ON VICTIM BLAME *********************;

* Model 14b;

* Coded with 
  - Perpetrator/Victim = 0/1 (PerpVsVict)
  - Session 1/2 = -.333/.666 (sess_ec1)
  - Session 1/3 = -.333/.666 (sess_ec1)
  - Female/Male = -.5/.5 (SexBinE)
  
* Impact of Session 2/3 (versus 1) on blame through threat, for perpetrators (b & c paths), averaged across everything else;

* Same as Model 13a except for perpetrators;

proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*sess_ec1 m*sess_ec2 m*SexBinE m*polS_c						m*sess_ec1*SexBinE m*sess_ec2*SexBinE									m*age_c m*rel_c m*sexOrBin_E
																m*sess_ec1*polS_c   m*sess_ec2*polS_c									m*sess_ec1*age_c m*sess_ec1*rel_c m*sess_ec1*sexOrBin_E 
																m*SexBinE*polS_c														m*sess_ec2*age_c m*sess_ec2*rel_c m*sess_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*polS_c*age_c m*polS_c*rel_c m*polS_c*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*PerpVsVict y*sess_ec1 y*sess_ec2 y*SexBinE y*polS_c			y*PerpVsVict*sess_ec1 y*PerpVsVict*sess_ec2								y*age_c y*rel_c y*sexOrBin_E
																y*PerpVsVict*SexBinE y*PerpVsVict*polS_c                       			y*PerpVsVict*age_c y*PerpVsVict*rel_c y*PerpVsVict*sexOrBin_E
																y*sess_ec1*SexBinE y*sess_ec2*SexBinE   								y*sess_ec1*age_c y*sess_ec1*rel_c y*sess_ec1*sexOrBin_E
																y*sess_ec1*polS_c  y*sess_ec2*polS_c    								y*sess_ec2*age_c y*sess_ec2*rel_c y*sess_ec2*sexOrBin_E
																y*SexBinE*polS_c								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*polS_c*age_c y*polS_c*rel_c y*polS_c*sexOrBin_E

																y*PerpVsVict*sess_ec1*sexBinE y*PerpVsVict*sess_ec2*sexBinE 
																y*PerpVsVict*sess_ec1*polS_c y*PerpVsVict*sess_ec2*polS_c 
																y*PerpVsVict*sexBinE*polS_c 
																y*sess_ec1*sexBinE*polS_c y*sess_ec2*sexBinE*polS_c
																y*PerpVsVict*sess_ec1*age_c y*PerpVsVict*sess_ec2*age_c 
																y*PerpVsVict*sess_ec1*rel_c y*PerpVsVict*sess_ec2*rel_c 
																y*PerpVsVict*sess_ec1*sexOrBin_E y*PerpVsVict*sess_ec2*sexOrBin_E
																y*PerpVsVict*sexBinE*age_c y*PerpVsVict*sexBinE*rel_c y*PerpVsVict*sexBinE*sexOrBin_E
																y*PerpVsVict*polS_c*age_c y*PerpVsVict*polS_c*rel_c y*PerpVsVict*polS_c*sexOrBin_E
																y*sess_ec1*sexBinE*age_c  y*sess_ec2*sexBinE*age_c 
																y*sess_ec1*sexBinE*rel_c y*sess_ec2*sexBinE*rel_c 
																y*sess_ec1*sexBinE*sexOrBin_E y*sess_ec2*sexBinE*sexOrBin_E
																y*sess_ec1*polS_c*age_c y*sess_ec2*polS_c*age_c 	
																y*sess_ec1*polS_c*rel_c y*sess_ec2*polS_c*rel_c 		
																y*sess_ec1*polS_c*sexOrBin_E y*sess_ec2*polS_c*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*PerpVsVict*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

* Model 14c  

  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for victims for moderates, averaged across everything else;

* Same as Model 13a except change session variables;
 
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*rsess2_ec1 m*rsess2_ec2 m*SexBinE m*polS_c					m*rsess2_ec1*SexBinE m*rsess2_ec2*SexBinE								m*age_c m*rel_c m*sexOrBin_E
																m*rsess2_ec1*polS_c   m*rsess2_ec2*polS_c								m*rsess2_ec1*age_c m*rsess2_ec1*rel_c m*rsess2_ec1*sexOrBin_E 
																m*SexBinE*polS_c														m*rsess2_ec2*age_c m*rsess2_ec2*rel_c m*rsess2_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*polS_c*age_c m*polS_c*rel_c m*polS_c*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*VictVsPerp y*rsess2_ec1 y*rsess2_ec2 y*SexBinE y*polS_c		y*VictVsPerp*rsess2_ec1 y*VictVsPerp*rsess2_ec2							y*age_c y*rel_c y*sexOrBin_E
																y*VictVsPerp*SexBinE y*VictVsPerp*polS_c                       			y*VictVsPerp*age_c y*VictVsPerp*rel_c y*VictVsPerp*sexOrBin_E
																y*rsess2_ec1*SexBinE y*rsess2_ec2*SexBinE   							y*rsess2_ec1*age_c y*rsess2_ec1*rel_c y*rsess2_ec1*sexOrBin_E
																y*rsess2_ec1*polS_c  y*rsess2_ec2*polS_c    							y*rsess2_ec2*age_c y*rsess2_ec2*rel_c y*rsess2_ec2*sexOrBin_E
																y*SexBinE*polS_c								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*polS_c*age_c y*polS_c*rel_c y*polS_c*sexOrBin_E

																y*VictVsPerp*rsess2_ec1*sexBinE y*VictVsPerp*rsess2_ec2*sexBinE 
																y*VictVsPerp*rsess2_ec1*polS_c y*VictVsPerp*rsess2_ec2*polS_c 
																y*VictVsPerp*sexBinE*polS_c 
																y*rsess2_ec1*sexBinE*polS_c y*rsess2_ec2*sexBinE*polS_c
																y*VictVsPerp*rsess2_ec1*age_c y*VictVsPerp*rsess2_ec2*age_c 
																y*VictVsPerp*rsess2_ec1*rel_c y*VictVsPerp*rsess2_ec2*rel_c 
																y*VictVsPerp*rsess2_ec1*sexOrBin_E y*VictVsPerp*rsess2_ec2*sexOrBin_E
																y*VictVsPerp*sexBinE*age_c y*VictVsPerp*sexBinE*rel_c  y*VictVsPerp*sexBinE*sexOrBin_E
																y*VictVsPerp*polS_c*age_c y*VictVsPerp*polS_c*rel_c y*VictVsPerp*polS_c*sexOrBin_E
																y*rsess2_ec1*sexBinE*age_c y*rsess2_ec2*sexBinE*age_c 
																y*rsess2_ec1*sexBinE*rel_c y*rsess2_ec2*sexBinE*rel_c 
																y*rsess2_ec1*sexBinE*sexOrBin_E y*rsess2_ec2*sexBinE*sexOrBin_E
																y*rsess2_ec1*polS_c*age_c y*rsess2_ec2*polS_c*age_c 	
																y*rsess2_ec1*polS_c*rel_c y*rsess2_ec2*polS_c*rel_c 		
																y*rsess2_ec1*polS_c*sexOrBin_E y*rsess2_ec2*polS_c*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;


* Model 14d  

  - Perpetrator/Victim = 0/1 (PerpVsVict)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for perpetrator for moderates, averaged across everything else;

* Same as Model 13b except change session variables;

proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*rsess2_ec1 m*rsess2_ec2 m*SexBinE m*polS_c					m*rsess2_ec1*SexBinE m*rsess2_ec2*SexBinE								m*age_c m*rel_c m*sexOrBin_E
																m*rsess2_ec1*polS_c   m*rsess2_ec2*polS_c								m*rsess2_ec1*age_c m*rsess2_ec1*rel_c m*rsess2_ec1*sexOrBin_E 
																m*SexBinE*polS_c														m*rsess2_ec2*age_c m*rsess2_ec2*rel_c m*rsess2_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*polS_c*age_c m*polS_c*rel_c m*polS_c*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*PerpVsVict y*rsess2_ec1 y*rsess2_ec2 y*SexBinE y*polS_c		y*PerpVsVict*rsess2_ec1 y*PerpVsVict*rsess2_ec2							y*age_c y*rel_c y*sexOrBin_E
																y*PerpVsVict*SexBinE y*PerpVsVict*polS_c                       			y*PerpVsVict*age_c y*PerpVsVict*rel_c y*PerpVsVict*sexOrBin_E
																y*rsess2_ec1*SexBinE y*rsess2_ec2*SexBinE   							y*rsess2_ec1*age_c y*rsess2_ec1*rel_c y*rsess2_ec1*sexOrBin_E
																y*rsess2_ec1*polS_c y*rsess2_ec2*polS_c    								y*rsess2_ec2*age_c y*rsess2_ec2*rel_c y*rsess2_ec2*sexOrBin_E
																y*SexBinE*polS_c								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*polS_c*age_c y*polS_c*rel_c y*polS_c*sexOrBin_E

																y*PerpVsVict*rsess2_ec1*sexBinE y*PerpVsVict*rsess2_ec2*sexBinE 
																y*PerpVsVict*rsess2_ec1*polS_c  y*PerpVsVict*rsess2_ec2*polS_c 
																y*PerpVsVict*sexBinE*polS_c 
																y*rsess2_ec1*sexBinE*polS_c y*rsess2_ec2*sexBinE*polS_c
																y*PerpVsVict*rsess2_ec1*age_c y*PerpVsVict*rsess2_ec2*age_c 
																y*PerpVsVict*rsess2_ec1*rel_c y*PerpVsVict*rsess2_ec2*rel_c 
																y*PerpVsVict*rsess2_ec1*sexOrBin_E y*PerpVsVict*rsess2_ec2*sexOrBin_E
																y*PerpVsVict*sexBinE*age_c y*PerpVsVict*sexBinE*rel_c y*PerpVsVict*sexBinE*sexOrBin_E
																y*PerpVsVict*polS_c*age_c y*PerpVsVict*polS_c*rel_c y*PerpVsVict*polS_c*sexOrBin_E
																y*rsess2_ec1*sexBinE*age_c y*rsess2_ec2*sexBinE*age_c 
																y*rsess2_ec1*sexBinE*rel_c y*rsess2_ec2*sexBinE*rel_c 
																y*rsess2_ec1*sexBinE*sexOrBin_E y*rsess2_ec2*sexBinE*sexOrBin_E
																y*rsess2_ec1*polS_c*age_c y*rsess2_ec2*polS_c*age_c 	
																y*rsess2_ec1*polS_c*rel_c y*rsess2_ec2*polS_c*rel_c 		
																y*rsess2_ec1*polS_c*sexOrBin_E y*rsess2_ec2*polS_c*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*PerpVsVict*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

**** Recoded for liberals ****

* Model 14e

 */VictVsPerp 0 = Vict, 1 = Perp;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */rSexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for victims for liberals, averaged across everything else;
 
* Same as 13a, but for liberals;

proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*sess_ec1 m*sess_ec2 m*SexBinE m*pSoc_L						m*sess_ec1*SexBinE m*sess_ec2*SexBinE									m*age_c m*rel_c m*sexOrBin_E
																m*sess_ec1*pSoc_L  m*sess_ec2*pSoc_L									m*sess_ec1*age_c m*sess_ec1*rel_c m*sess_ec1*sexOrBin_E 
																m*SexBinE*pSoc_L														m*sess_ec2*age_c m*sess_ec2*rel_c m*sess_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*pSoc_L*age_c m*pSoc_L*rel_c m*pSoc_L*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*VictVsPerp y*sess_ec1 y*sess_ec2 y*SexBinE y*pSoc_L			y*VictVsPerp*sess_ec1 y*VictVsPerp*sess_ec2								y*age_c y*rel_c y*sexOrBin_E
																y*VictVsPerp*SexBinE y*VictVsPerp*pSoc_L                       			y*VictVsPerp*age_c y*VictVsPerp*rel_c y*VictVsPerp*sexOrBin_E
																y*sess_ec1*SexBinE y*sess_ec2*SexBinE   								y*sess_ec1*age_c y*sess_ec1*rel_c y*sess_ec1*sexOrBin_E
																y*sess_ec1*pSoc_L y*sess_ec2*pSoc_L    									y*sess_ec2*age_c y*sess_ec2*rel_c y*sess_ec2*sexOrBin_E
																y*SexBinE*pSoc_L								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*pSoc_L*age_c y*pSoc_L*rel_c y*pSoc_L*sexOrBin_E

																y*VictVsPerp*sess_ec1*sexBinE y*VictVsPerp*sess_ec2*sexBinE 
																y*VictVsPerp*sess_ec1*pSoc_L y*VictVsPerp*sess_ec2*pSoc_L 
																y*VictVsPerp*sexBinE*pSoc_L 
																y*sess_ec1*sexBinE*pSoc_L y*sess_ec2*sexBinE*pSoc_L
																y*VictVsPerp*sess_ec1*age_c y*VictVsPerp*sess_ec2*age_c 
																y*VictVsPerp*sess_ec1*rel_c y*VictVsPerp*sess_ec2*rel_c 
																y*VictVsPerp*sess_ec1*sexOrBin_E y*VictVsPerp*sess_ec2*sexOrBin_E
																y*VictVsPerp*sexBinE*age_c y*VictVsPerp*sexBinE*rel_c y*VictVsPerp*sexBinE*sexOrBin_E
																y*VictVsPerp*pSoc_L*age_c y*VictVsPerp*pSoc_L*rel_c y*VictVsPerp*pSoc_L*sexOrBin_E
																y*sess_ec1*sexBinE*age_c y*sess_ec2*sexBinE*age_c 
																y*sess_ec1*sexBinE*rel_c y*sess_ec2*sexBinE*rel_c 
																y*sess_ec1*sexBinE*sexOrBin_E y*sess_ec2*sexBinE*sexOrBin_E
																y*sess_ec1*pSoc_L*age_c y*sess_ec2*pSoc_L*age_c 	
																y*sess_ec1*pSoc_L*rel_c y*sess_ec2*pSoc_L*rel_c 		
																y*sess_ec1*pSoc_L*sexOrBin_E y*sess_ec2*pSoc_L*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;


* Model 14f

 */PerpVsVict 0 = Perp, 1 = Vict;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */rSexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for perpetrators for liberals, averaged across everything else;
 
* Same as 13b, but for liberals;

proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*sess_ec1 m*sess_ec2 m*SexBinE m*pSoc_L						m*sess_ec1*SexBinE m*sess_ec2*SexBinE									m*age_c m*rel_c m*sexOrBin_E
																m*sess_ec1*pSoc_L  m*sess_ec2*pSoc_L									m*sess_ec1*age_c m*sess_ec1*rel_c m*sess_ec1*sexOrBin_E 
																m*SexBinE*pSoc_L														m*sess_ec2*age_c m*sess_ec2*rel_c m*sess_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*pSoc_L*age_c m*pSoc_L*rel_c m*pSoc_L*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*PerpVsVict y*sess_ec1 y*sess_ec2 y*SexBinE y*pSoc_L			y*PerpVsVict*sess_ec1 y*PerpVsVict*sess_ec2								y*age_c y*rel_c y*sexOrBin_E
																y*PerpVsVict*SexBinE y*PerpVsVict*pSoc_L                       			y*PerpVsVict*age_c y*PerpVsVict*rel_c y*PerpVsVict*sexOrBin_E
																y*sess_ec1*SexBinE y*sess_ec2*SexBinE   								y*sess_ec1*age_c y*sess_ec1*rel_c y*sess_ec1*sexOrBin_E
																y*sess_ec1*pSoc_L y*sess_ec2*pSoc_L    									y*sess_ec2*age_c y*sess_ec2*rel_c y*sess_ec2*sexOrBin_E
																y*SexBinE*pSoc_L								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*pSoc_L*age_c y*pSoc_L*rel_c y*pSoc_L*sexOrBin_E

																y*PerpVsVict*sess_ec1*sexBinE y*PerpVsVict*sess_ec2*sexBinE 
																y*PerpVsVict*sess_ec1*pSoc_L y*PerpVsVict*sess_ec2*pSoc_L 
																y*PerpVsVict*sexBinE*pSoc_L 
																y*sess_ec1*sexBinE*pSoc_L y*sess_ec2*sexBinE*pSoc_L
																y*PerpVsVict*sess_ec1*age_c y*PerpVsVict*sess_ec2*age_c 
																y*PerpVsVict*sess_ec1*rel_c y*PerpVsVict*sess_ec2*rel_c 
																y*PerpVsVict*sess_ec1*sexOrBin_E y*PerpVsVict*sess_ec2*sexOrBin_E
																y*PerpVsVict*sexBinE*age_c y*PerpVsVict*sexBinE*rel_c y*PerpVsVict*sexBinE*sexOrBin_E
																y*PerpVsVict*pSoc_L*age_c y*PerpVsVict*pSoc_L*rel_c y*PerpVsVict*pSoc_L*sexOrBin_E
																y*sess_ec1*sexBinE*age_c y*sess_ec2*sexBinE*age_c 
																y*sess_ec1*sexBinE*rel_c y*sess_ec2*sexBinE*rel_c 
																y*sess_ec1*sexBinE*sexOrBin_E y*sess_ec2*sexBinE*sexOrBin_E
																y*sess_ec1*pSoc_L*age_c y*sess_ec2*pSoc_L*age_c 	
																y*sess_ec1*pSoc_L*rel_c y*sess_ec2*pSoc_L*rel_c 		
																y*sess_ec1*pSoc_L*sexOrBin_E y*sess_ec2*pSoc_L*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*PerpVsVict*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;


* Model 14g 
  
  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for victims for liberals, averaged across everything else;

* This is the same as Model 13c, but for liberals;
 
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*rsess2_ec1 m*rsess2_ec2 m*SexBinE m*pSoc_L					m*rsess2_ec1*SexBinE m*rsess2_ec2*SexBinE								m*age_c m*rel_c m*sexOrBin_E
																m*rsess2_ec1*pSoc_L   m*rsess2_ec2*pSoc_L								m*rsess2_ec1*age_c m*rsess2_ec1*rel_c m*rsess2_ec1*sexOrBin_E 
																m*SexBinE*pSoc_L														m*rsess2_ec2*age_c m*rsess2_ec2*rel_c m*rsess2_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*pSoc_L*age_c m*pSoc_L*rel_c m*pSoc_L*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*VictVsPerp y*rsess2_ec1 y*rsess2_ec2 y*SexBinE y*pSoc_L		y*VictVsPerp*rsess2_ec1 y*VictVsPerp*rsess2_ec2							y*age_c y*rel_c y*sexOrBin_E
																y*VictVsPerp*SexBinE y*VictVsPerp*pSoc_L                       			y*VictVsPerp*age_c y*VictVsPerp*rel_c y*VictVsPerp*sexOrBin_E
																y*rsess2_ec1*SexBinE y*rsess2_ec2*SexBinE   							y*rsess2_ec1*age_c y*rsess2_ec1*rel_c y*rsess2_ec1*sexOrBin_E
																y*rsess2_ec1*pSoc_L  y*rsess2_ec2*pSoc_L    							y*rsess2_ec2*age_c y*rsess2_ec2*rel_c y*rsess2_ec2*sexOrBin_E
																y*SexBinE*pSoc_L								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*pSoc_L*age_c y*pSoc_L*rel_c y*pSoc_L*sexOrBin_E

																y*VictVsPerp*rsess2_ec1*sexBinE y*VictVsPerp*rsess2_ec2*sexBinE 
																y*VictVsPerp*rsess2_ec1*pSoc_L y*VictVsPerp*rsess2_ec2*pSoc_L 
																y*VictVsPerp*sexBinE*pSoc_L 
																y*rsess2_ec1*sexBinE*pSoc_L y*rsess2_ec2*sexBinE*pSoc_L
																y*VictVsPerp*rsess2_ec1*age_c y*VictVsPerp*rsess2_ec2*age_c 
																y*VictVsPerp*rsess2_ec1*rel_c y*VictVsPerp*rsess2_ec2*rel_c 
																y*VictVsPerp*rsess2_ec1*sexOrBin_E y*VictVsPerp*rsess2_ec2*sexOrBin_E
																y*VictVsPerp*sexBinE*age_c y*VictVsPerp*sexBinE*rel_c y*VictVsPerp*sexBinE*sexOrBin_E
																y*VictVsPerp*pSoc_L*age_c y*VictVsPerp*pSoc_L*rel_c y*VictVsPerp*pSoc_L*sexOrBin_E
																y*rsess2_ec1*sexBinE*age_c y*rsess2_ec2*sexBinE*age_c 
																y*rsess2_ec1*sexBinE*rel_c y*rsess2_ec2*sexBinE*rel_c 
																y*rsess2_ec1*sexBinE*sexOrBin_E y*rsess2_ec2*sexBinE*sexOrBin_E
																y*rsess2_ec1*pSoc_L*age_c y*rsess2_ec2*pSoc_L*age_c 	
																y*rsess2_ec1*pSoc_L*rel_c y*rsess2_ec2*pSoc_L*rel_c 		
																y*rsess2_ec1*pSoc_L*sexOrBin_E y*rsess2_ec2*pSoc_L*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;


* Model 14h

  - Perpetrator/Victim = 0/1 (PerpVsVict)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for perpetrator for moderates, averaged across everything else;

* This is the same as Model 13d but for liberals;

proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*rsess2_ec1 m*rsess2_ec2 m*SexBinE m*pSoc_L					m*rsess2_ec1*SexBinE m*rsess2_ec2*SexBinE								m*age_c m*rel_c m*sexOrBin_E
																m*rsess2_ec1*pSoc_L   m*rsess2_ec2*pSoc_L								m*rsess2_ec1*age_c m*rsess2_ec1*rel_c m*rsess2_ec1*sexOrBin_E 
																m*SexBinE*pSoc_L														m*rsess2_ec2*age_c m*rsess2_ec2*rel_c m*rsess2_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*pSoc_L*age_c m*pSoc_L*rel_c m*pSoc_L*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*PerpVsVict y*rsess2_ec1 y*rsess2_ec2 y*SexBinE y*pSoc_L		y*PerpVsVict*rsess2_ec1 y*PerpVsVict*rsess2_ec2							y*age_c y*rel_c y*sexOrBin_E
																y*PerpVsVict*SexBinE y*PerpVsVict*pSoc_L                       			y*PerpVsVict*age_c y*PerpVsVict*rel_c y*PerpVsVict*sexOrBin_E
																y*rsess2_ec1*SexBinE y*rsess2_ec2*SexBinE   							y*rsess2_ec1*age_c y*rsess2_ec1*rel_c y*rsess2_ec1*sexOrBin_E
																y*rsess2_ec1*pSoc_L  y*rsess2_ec2*pSoc_L    							y*rsess2_ec2*age_c y*rsess2_ec2*rel_c y*rsess2_ec2*sexOrBin_E
																y*SexBinE*pSoc_L								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*pSoc_L*age_c y*pSoc_L*rel_c y*pSoc_L*sexOrBin_E

																y*PerpVsVict*rsess2_ec1*sexBinE y*PerpVsVict*rsess2_ec2*sexBinE 
																y*PerpVsVict*rsess2_ec1*pSoc_L y*PerpVsVict*rsess2_ec2*pSoc_L 
																y*PerpVsVict*sexBinE*pSoc_L 
																y*rsess2_ec1*sexBinE*pSoc_L y*rsess2_ec2*sexBinE*pSoc_L
																y*PerpVsVict*rsess2_ec1*age_c y*PerpVsVict*rsess2_ec2*age_c 
																y*PerpVsVict*rsess2_ec1*rel_c y*PerpVsVict*rsess2_ec2*rel_c 
																y*PerpVsVict*rsess2_ec1*sexOrBin_E y*PerpVsVict*rsess2_ec2*sexOrBin_E
																y*PerpVsVict*sexBinE*age_c y*PerpVsVict*sexBinE*rel_c y*PerpVsVict*sexBinE*sexOrBin_E
																y*PerpVsVict*pSoc_L*age_c y*PerpVsVict*pSoc_L*rel_c y*PerpVsVict*pSoc_L*sexOrBin_E
																y*rsess2_ec1*sexBinE*age_c y*rsess2_ec2*sexBinE*age_c 
																y*rsess2_ec1*sexBinE*rel_c y*rsess2_ec2*sexBinE*rel_c 
																y*rsess2_ec1*sexBinE*sexOrBin_E y*rsess2_ec2*sexBinE*sexOrBin_E
																y*rsess2_ec1*pSoc_L*age_c y*rsess2_ec2*pSoc_L*age_c 	
																y*rsess2_ec1*pSoc_L*rel_c y*rsess2_ec2*pSoc_L*rel_c 		
																y*rsess2_ec1*pSoc_L*sexOrBin_E y*rsess2_ec2*pSoc_L*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*PerpVsVict*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;


**** Recoded for conservatives ****

* Model 14i

 */VictVsPerp 0 = Vict, 1 = Perp;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */SexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for victims for conservatives, averaged across everything else;
 
* Same as 13a, but for conservatives;

proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*sess_ec1 m*sess_ec2 m*SexBinE m*pSoc_H						m*sess_ec1*SexBinE m*sess_ec2*SexBinE									m*age_c m*rel_c m*sexOrBin_E
																m*sess_ec1*pSoc_H  m*sess_ec2*pSoc_H									m*sess_ec1*age_c m*sess_ec1*rel_c m*sess_ec1*sexOrBin_E 
																m*SexBinE*pSoc_H														m*sess_ec2*age_c m*sess_ec2*rel_c m*sess_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*pSoc_H*age_c m*pSoc_H*rel_c m*pSoc_H*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*VictVsPerp y*sess_ec1 y*sess_ec2 y*SexBinE y*pSoc_H			y*VictVsPerp*sess_ec1 y*VictVsPerp*sess_ec2								y*age_c y*rel_c y*sexOrBin_E
																y*VictVsPerp*SexBinE y*VictVsPerp*pSoc_H                       			y*VictVsPerp*age_c y*VictVsPerp*rel_c y*VictVsPerp*sexOrBin_E
																y*sess_ec1*SexBinE y*sess_ec2*SexBinE   								y*sess_ec1*age_c y*sess_ec1*rel_c y*sess_ec1*sexOrBin_E
																y*sess_ec1*pSoc_H y*sess_ec2*pSoc_H    									y*sess_ec2*age_c y*sess_ec2*rel_c y*sess_ec2*sexOrBin_E
																y*SexBinE*pSoc_H								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*pSoc_H*age_c y*pSoc_H*rel_c y*pSoc_H*sexOrBin_E

																y*VictVsPerp*sess_ec1*sexBinE y*VictVsPerp*sess_ec2*sexBinE 
																y*VictVsPerp*sess_ec1*pSoc_H y*VictVsPerp*sess_ec2*pSoc_H 
																y*VictVsPerp*sexBinE*pSoc_H 
																y*sess_ec1*sexBinE*pSoc_H y*sess_ec2*sexBinE*pSoc_H
																y*VictVsPerp*sess_ec1*age_c y*VictVsPerp*sess_ec2*age_c 
																y*VictVsPerp*sess_ec1*rel_c y*VictVsPerp*sess_ec2*rel_c 
																y*VictVsPerp*sess_ec1*sexOrBin_E y*VictVsPerp*sess_ec2*sexOrBin_E
																y*VictVsPerp*sexBinE*age_c y*VictVsPerp*sexBinE*rel_c y*VictVsPerp*sexBinE*sexOrBin_E
																y*VictVsPerp*pSoc_H*age_c y*VictVsPerp*pSoc_H*rel_c y*VictVsPerp*pSoc_H*sexOrBin_E
																y*sess_ec1*sexBinE*age_c y*sess_ec2*sexBinE*age_c 
																y*sess_ec1*sexBinE*rel_c y*sess_ec2*sexBinE*rel_c 
																y*sess_ec1*sexBinE*sexOrBin_E y*sess_ec2*sexBinE*sexOrBin_E
																y*sess_ec1*pSoc_H*age_c y*sess_ec2*pSoc_H*age_c 	
																y*sess_ec1*pSoc_H*rel_c y*sess_ec2*pSoc_H*rel_c 		
																y*sess_ec1*pSoc_H*sexOrBin_E y*sess_ec2*pSoc_H*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;


* Model 14j

 */VictVsPerp 0 = Perp, 1 = Vict;
 */sess_ec1 = -.333 Session 1, .666 Session 2 (compares 1 to 2);
 */sess_ec2 = -.333 Session 1, .666 Session 3 (compares 1 to 3);
 */SexBinE -.5 Female, .5 Male;
 */sexOrBin_E = -.5 Straight, .5 Everyone else;
 
* Impact of Session 2/3 (versus 1) on blame for perpetrators for conservatives, averaged across everything else;

* Same as 13b, but for conservatives;
 
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*sess_ec1 m*sess_ec2 m*SexBinE m*pSoc_H						m*sess_ec1*SexBinE m*sess_ec2*SexBinE									m*age_c m*rel_c m*sexOrBin_E
																m*sess_ec1*pSoc_H  m*sess_ec2*pSoc_H									m*sess_ec1*age_c m*sess_ec1*rel_c m*sess_ec1*sexOrBin_E 
																m*SexBinE*pSoc_H														m*sess_ec2*age_c m*sess_ec2*rel_c m*sess_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*pSoc_H*age_c m*pSoc_H*rel_c m*pSoc_H*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*PerpVsVict y*sess_ec1 y*sess_ec2 y*SexBinE y*pSoc_H			y*PerpVsVict*sess_ec1 y*PerpVsVict*sess_ec2								y*age_c y*rel_c y*sexOrBin_E
																y*PerpVsVict*SexBinE y*PerpVsVict*pSoc_H                       			y*PerpVsVict*age_c y*PerpVsVict*rel_c y*PerpVsVict*sexOrBin_E
																y*sess_ec1*SexBinE y*sess_ec2*SexBinE   								y*sess_ec1*age_c y*sess_ec1*rel_c y*sess_ec1*sexOrBin_E
																y*sess_ec1*pSoc_H y*sess_ec2*pSoc_H    									y*sess_ec2*age_c y*sess_ec2*rel_c y*sess_ec2*sexOrBin_E
																y*SexBinE*pSoc_H								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*pSoc_H*age_c y*pSoc_H*rel_c y*pSoc_H*sexOrBin_E

																y*PerpVsVict*sess_ec1*sexBinE y*PerpVsVict*sess_ec2*sexBinE 
																y*PerpVsVict*sess_ec1*pSoc_H y*PerpVsVict*sess_ec2*pSoc_H 
																y*PerpVsVict*sexBinE*pSoc_H 
																y*sess_ec1*sexBinE*pSoc_H y*sess_ec2*sexBinE*pSoc_H
																y*PerpVsVict*sess_ec1*age_c y*PerpVsVict*sess_ec2*age_c 
																y*PerpVsVict*sess_ec1*rel_c y*PerpVsVict*sess_ec2*rel_c 
																y*PerpVsVict*sess_ec1*sexOrBin_E y*PerpVsVict*sess_ec2*sexOrBin_E
																y*PerpVsVict*sexBinE*age_c y*PerpVsVict*sexBinE*rel_c y*PerpVsVict*sexBinE*sexOrBin_E
																y*PerpVsVict*pSoc_H*age_c y*PerpVsVict*pSoc_H*rel_c y*PerpVsVict*pSoc_H*sexOrBin_E
																y*sess_ec1*sexBinE*age_c y*sess_ec2*sexBinE*age_c 
																y*sess_ec1*sexBinE*rel_c y*sess_ec2*sexBinE*rel_c 
																y*sess_ec1*sexBinE*sexOrBin_E y*sess_ec2*sexBinE*sexOrBin_E
																y*sess_ec1*pSoc_H*age_c y*sess_ec2*pSoc_H*age_c 	
																y*sess_ec1*pSoc_H*rel_c y*sess_ec2*pSoc_H*rel_c 		
																y*sess_ec1*pSoc_H*sexOrBin_E y*sess_ec2*pSoc_H*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*PerpVsVict*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;


* Model 14k 

  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for victims for conservatives, averaged across everything else;

* Same as 13c, but for conservatives;
 
proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*rsess2_ec1 m*rsess2_ec2 m*SexBinE m*pSoc_H					m*rsess2_ec1*SexBinE m*rsess2_ec2*SexBinE								m*age_c m*rel_c m*sexOrBin_E
																m*rsess2_ec1*pSoc_H   m*rsess2_ec2*pSoc_H								m*rsess2_ec1*age_c m*rsess2_ec1*rel_c m*rsess2_ec1*sexOrBin_E 
																m*SexBinE*pSoc_H														m*rsess2_ec2*age_c m*rsess2_ec2*rel_c m*rsess2_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*pSoc_H*age_c m*pSoc_H*rel_c m*pSoc_H*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*VictVsPerp y*rsess2_ec1 y*rsess2_ec2 y*SexBinE y*pSoc_H		y*VictVsPerp*rsess2_ec1 y*VictVsPerp*rsess2_ec2							y*age_c y*rel_c y*sexOrBin_E
																y*VictVsPerp*SexBinE y*VictVsPerp*pSoc_H                       			y*VictVsPerp*age_c y*VictVsPerp*rel_c y*VictVsPerp*sexOrBin_E
																y*rsess2_ec1*SexBinE y*rsess2_ec2*SexBinE   							y*rsess2_ec1*age_c y*rsess2_ec1*rel_c y*rsess2_ec1*sexOrBin_E
																y*rsess2_ec1*pSoc_H  y*rsess2_ec2*pSoc_H    							y*rsess2_ec2*age_c y*rsess2_ec2*rel_c y*rsess2_ec2*sexOrBin_E
																y*SexBinE*pSoc_H								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*pSoc_H*age_c y*pSoc_H*rel_c y*pSoc_H*sexOrBin_E

																y*VictVsPerp*rsess2_ec1*sexBinE y*VictVsPerp*rsess2_ec2*sexBinE 
																y*VictVsPerp*rsess2_ec1*pSoc_H y*VictVsPerp*rsess2_ec2*pSoc_H 
																y*VictVsPerp*sexBinE*pSoc_H 
																y*rsess2_ec1*sexBinE*pSoc_H y*rsess2_ec2*sexBinE*pSoc_H
																y*VictVsPerp*rsess2_ec1*age_c y*VictVsPerp*rsess2_ec2*age_c 
																y*VictVsPerp*rsess2_ec1*rel_c y*VictVsPerp*rsess2_ec2*rel_c 
																y*VictVsPerp*rsess2_ec1*sexOrBin_E y*VictVsPerp*rsess2_ec2*sexOrBin_E
																y*VictVsPerp*sexBinE*age_c y*VictVsPerp*sexBinE*rel_c y*VictVsPerp*sexBinE*sexOrBin_E
																y*VictVsPerp*pSoc_H*age_c y*VictVsPerp*pSoc_H*rel_c y*VictVsPerp*pSoc_H*sexOrBin_E
																y*rsess2_ec1*sexBinE*age_c y*rsess2_ec2*sexBinE*age_c 
																y*rsess2_ec1*sexBinE*rel_c y*rsess2_ec2*sexBinE*rel_c 
																y*rsess2_ec1*sexBinE*sexOrBin_E y*rsess2_ec2*sexBinE*sexOrBin_E
																y*rsess2_ec1*pSoc_H*age_c y*rsess2_ec2*pSoc_H*age_c 	
																y*rsess2_ec1*pSoc_H*rel_c y*rsess2_ec2*pSoc_H*rel_c 		
																y*rsess2_ec1*pSoc_H*sexOrBin_E y*rsess2_ec2*pSoc_H*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*VictVsPerp*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;


* Model 14l

  - Perpetrator/Victim = 0/1 (PerpVsVict)
  - Session 1/3 = -.666/.333 (rsess2_ec1)
  - Session 2/3 = -.666/.333 (rsess2_ec2)
  - Female/Male = -.5/.5 (SexBinE)

* Impact of Session 1/2 (versus 3) on blame for perpetrator for moderates, averaged across everything else;

* This is the same as Model 9d but for conservatives;

proc mixed noclprint covtest asycov maxiter=100 method=reml DATA=stacked convf=1e-4 convg=1e-4 convh=1e-4; 
class  respondentid dv2;
model  outcome =
/*a path - fear-threat part*/									/*Moderation part*/														/*Covariates*/
m m*rsess2_ec1 m*rsess2_ec2 m*SexBinE m*pSoc_H					m*rsess2_ec1*SexBinE m*rsess2_ec2*SexBinE								m*age_c m*rel_c m*sexOrBin_E
																m*rsess2_ec1*pSoc_H   m*rsess2_ec2*pSoc_H								m*rsess2_ec1*age_c m*rsess2_ec1*rel_c m*rsess2_ec1*sexOrBin_E 
																m*SexBinE*pSoc_H														m*rsess2_ec2*age_c m*rsess2_ec2*rel_c m*rsess2_ec2*sexOrBin_E 
        																 									                            m*SexBinE*age_c m*SexBinE*rel_c m*SexBinE*sexOrBin_E 
																																		m*pSoc_H*age_c m*pSoc_H*rel_c m*pSoc_H*sexOrBin_E 
        																																		 


/*c path - blame part*/
y y*PerpVsVict y*rsess2_ec1 y*rsess2_ec2 y*SexBinE y*pSoc_H		y*PerpVsVict*rsess2_ec1 y*PerpVsVict*rsess2_ec2							y*age_c y*rel_c y*sexOrBin_E
																y*PerpVsVict*SexBinE y*PerpVsVict*pSoc_H                       			y*PerpVsVict*age_c y*PerpVsVict*rel_c y*PerpVsVict*sexOrBin_E
																y*rsess2_ec1*SexBinE y*rsess2_ec2*SexBinE   							y*rsess2_ec1*age_c y*rsess2_ec1*rel_c y*rsess2_ec1*sexOrBin_E
																y*rsess2_ec1*pSoc_H  y*rsess2_ec2*pSoc_H    							y*rsess2_ec2*age_c y*rsess2_ec2*rel_c y*rsess2_ec2*sexOrBin_E
																y*SexBinE*pSoc_H								                       	y*SexBinE*age_c y*SexBinE*rel_c y*SexBinE*sexOrBin_E
															 									                   						y*pSoc_H*age_c y*pSoc_H*rel_c y*pSoc_H*sexOrBin_E

																y*PerpVsVict*rsess2_ec1*sexBinE y*PerpVsVict*rsess2_ec2*sexBinE 
																y*PerpVsVict*rsess2_ec1*pSoc_H y*PerpVsVict*rsess2_ec2*pSoc_H 
																y*PerpVsVict*sexBinE*pSoc_H 
																y*rsess2_ec1*sexBinE*pSoc_H y*rsess2_ec2*sexBinE*pSoc_H
																y*PerpVsVict*rsess2_ec1*age_c y*PerpVsVict*rsess2_ec2*age_c 
																y*PerpVsVict*rsess2_ec1*rel_c y*PerpVsVict*rsess2_ec2*rel_c 
																y*PerpVsVict*rsess2_ec1*sexOrBin_E y*PerpVsVict*rsess2_ec2*sexOrBin_E
																y*PerpVsVict*sexBinE*age_c y*PerpVsVict*sexBinE*rel_c y*PerpVsVict*sexBinE*sexOrBin_E
																y*PerpVsVict*pSoc_H*age_c y*PerpVsVict*pSoc_H*rel_c y*PerpVsVict*pSoc_H*sexOrBin_E
																y*rsess2_ec1*sexBinE*age_c y*rsess2_ec2*sexBinE*age_c 
																y*rsess2_ec1*sexBinE*rel_c y*rsess2_ec2*sexBinE*rel_c 
																y*rsess2_ec1*sexBinE*sexOrBin_E y*rsess2_ec2*sexBinE*sexOrBin_E
																y*rsess2_ec1*pSoc_H*age_c y*rsess2_ec2*pSoc_H*age_c 	
																y*rsess2_ec1*pSoc_H*rel_c y*rsess2_ec2*pSoc_H*rel_c 		
																y*rsess2_ec1*pSoc_H*sexOrBin_E y*rsess2_ec2*pSoc_H*sexOrBin_E																																														
																																														
/*b path - blame part*/
y*fear_c y*PerpVsVict*fear_c 
/ noint covb ddfm=kr s;
repeated / group=dv2 subject=respondentid type=un;
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand convergencestatus=converge solutionr=estind;
run;

*********************************** INDIRECT EFFECT CONFIDENCE INTERVALS ***********************************************************;

* Now go to R to estimate the CIs for the indirect effects;


