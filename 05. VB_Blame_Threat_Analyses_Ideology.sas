* Victim Blame Primary Analyses:
  1. Victim and perpetrator blame across sessions among liberal, moderate, and conservative males and females. (c path)
  2. Threat within and across sessions among liberal, moderate, and conservative males and females (a path)
  3. Mediation of blame by threat across sessions among liberal, moderate, and conservative males and females (multi-level moderated mediation, see R script for indirect effect estimates)

* Written by the fifth, second, and third authors in 2024-26
* Data files: 
  VB S1-3 STACKED.xlsx
  VB S1-3 WIDE.xlsx
* Last edited 2026.10.28.

********************************************** PREPARE DATA ***********************************************;

* Start by taking care of all data preparation for all analyses;

************************* PREPARE BLAME DATA *******************************;

* Import file;
libname long xlsx "/home/u63541235/sasuser.v94/Victim Blame Files/1. Blame + Threat + Mediation/Victim Blame S1-3 LONG 2026.11.11.xlsx";

* Make sure data sets are accessible in the working library;
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

* All effects-coded variables also need to be recognized as numeric;
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

* Check the frequencies to make sure all categorical variables are coded right;
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
libname wide xlsx "/home/u63541235/sasuser.v94/Victim Blame Files/1. Blame + Threat + Mediation/Victim Blame S1-3 WIDE 2026.11.11.xlsx";

* Make sure data sets are accessible in the working library;
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

* All effects-coded variables also need to be recognized as numeric;
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


* Check the frequencies to make sure all categorical variables are coded correctly;
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

* Check the frequencies to make sure all categorical variables are coded right;
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
 */note that, depending on the system, one might need to switch 0.00 to 0 in the class statement; 
 */note that lsmeans gets mad if covariates are treated as class, so effects coded sexOrBin_E instead;
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
lsmeans VictVsPerp VictVsPerp*Session*sexBin*polGen 
/ at (age_c rel_c sexOrBin_E)= (0 0 0) tdiff pdiff;
ods output lsmeans=blamegroupmeans diffs = diffs Tests3 = Tests3;
RUN;
  
**

*Model 2;

* Same as above, drop 4-way interactions because all are non-significant;
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
ods output lsmeans=blamegroupmeans diffs = diffs;
RUN;
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data= blamegroupmeans noobs;
  format DF 12.6 ProbF pvalue8.4;
RUN;

proc print data= diffs noobs;
  format DF 12.6 ProbF pvalue8.4;
RUN;


* Model 3;

* Drop 3-way interactions because all are nonsignificant;
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
VictVsPerp*session VictVsPerp*sexBin VictVsPerp*polgen session*sexBin 
session*polgen sexBin*polgen /*6 2-ways*/ 
/ at (age_c rel_c sexOrBin_E)= (0 0 0) tdiff pdiff;
repeated / subject=respondentid type=un;
ods output lsmeans=blamegroupmeans diffs = diffs;
RUN;
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data= blamegroupmeans noobs;
  format DF 12.6 ProbF pvalue8.4;
RUN;

proc print data= diffs noobs;
  format DF 12.6 ProbF pvalue8.4;
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
 
* Impact of Session 2/3 (versus 1) on blame for victim, averaged across everything else;
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
ods output SolutionF = SolutionF;
RUN;
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data=SolutionF noobs;
  format DF 12.6 ProbF pvalue8.4;
RUN;


* Additional models for total effect in mediation 

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
ods output SolutionF = SolutionF;
RUN;
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data=SolutionF noobs;
  format DF 12.6 ProbF pvalue8.4;
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
ods output SolutionF = SolutionF;
RUN;
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data=SolutionF noobs;
  format DF 12.6 ProbF pvalue8.4;
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
ods output SolutionF = SolutionF;
RUN;
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data=SolutionF noobs;
  format DF 12.6 ProbF pvalue8.4;
RUN;


********** Difference score robustness check (c path) **********

Model 4a;
* Dummy-coded version for marginal means (diff score);
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
* Since not an MLM, no adjusted df


* Model 4b;
* Regression output for Appendix (diff score);

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
ods output SolutionF=SolutionF;
RUN;
* Since not an MLM, no adjusted df


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
* Since not an MLM, no adjusted df

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
* Since not an MLM, no adjusted df

* Model 6;

* Drop all 3-way interactions because none are significant;
* Final a path model to obtain marginal means;
* /Note that the regression version is identical to the mediation output below, so we don't need to estimate it here;

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
* Since not an MLM, no adjusted df

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
ods output covb=acovfix asycov=acovrand solutionf=estfix covparms=estrand 
convergencestatus=converge solutionr=estind Tests3 = Tests3;
RUN;

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

* Final model to be included in the Appendix, where everything except RM is effects-coded with 
  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/2 = -.333/.666 (sess_ec1)
  - Session 1/3 = -.333/.666 (sess_ec1)
  - Female/Male = -.5/.5 (SexBinE)
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
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data=estfix noobs;
  format DF 12.6 ProbF pvalue8.4;
RUN;

************* GENDER, SESSION 2 & 3 (VS. 1), AND MODERATE & CONSERVATIVE (VS. LIBERAL) ON PERPETRATOR BLAME *********;

*Now need to change reference groups to estimate remaining indirect effects;

* Model 8b;
* Impact of Session 2/3 (versus 1) on blame through threat, for perpetrators (b & c paths), averaged across everything else;
* Impact of being a man (versus woman) on blame through threat, for perpetrators (b & c paths), averaged across everything else;
* Impact of being moderate/conservative (versus liberal) on blame through threat, for perpetrators (b & c), averaged across everything else;
  */This is the same as Model 8a except switch VictVsPerp to PerpVsVict;
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
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data=estfix noobs;
  format DF 12.6 ProbF pvalue8.4;
RUN;

********************** GENDER, SESSION 1 & 2 (VS. 3), AND LIBERAL & MODERATIVE (VS. CONSERVATIVE) ON VICTIM BLAME *********************;

* Model 8c;

* Coded with 
  - Victim/Perpetrator = 0/1 (VictVsPerp)
  - Session 1/3 = -.666/.333 (rsess3_ec1)
  - Session 2/3 = -.666/.333 (rsess3_ec2)
  - Female/Male = -.5/.5 (SexBinE)
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
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data=estfix noobs;
  format DF 12.6 ProbF pvalue8.4;
RUN;

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
* Make sure seeing full dfs (round to full numbers if do not specify);
proc print data=estfix noobs;
  format DF 12.6 ProbF pvalue8.4;
RUN;

*********************************** INDIRECT EFFECT CONFIDENCE INTERVALS ***********************************************************;

* Now go to R to estimate the CIs for the indirect effects;



