%Sits at one spot (rotations; delays) for one day and looks for the cross-correlation.
%Now also plots aligned 4-s windows.  As of July 2012.
clear all
t=cputime; tt=cputime;
close all
format short e
%Rotations & offsets:
   timoffrot=[2005 257 07 42 12 +080 +053  75  50  50];
%timoffrot=[213 14 11 48 -015 +058 110 125 380];
   %timoffrot=[227 14 18 28 +058 -074  90 85 50]; %Quiet day
%timoffrot=[227 20 08 20 +028 +004 100 380 150];
   %timoffrot=[243 17 48 04 -008 -128 100 400 265]; %Eq at  48.3795  122.4010 !
   %timoffrot=[239 22 59 48 +017 -050  85 380 340]; %an Armb detection
   %timoffrot=[239 00 61 00 +060 -085  85  65  45]; %Aug 27 no Armb detection
   %timoffrot=[240 00 61 00 +060 -085  85  65  45]; %Aug 28 no Armb detection
   %timoffrot=[241 00 61 00 +060 -085  85  65  45]; %Aug 29 no Armb detection
   %timoffrot=[242 00 61 00 +060 -085  85  65  45]; %Aug 30 no Armb detection
   %timoffrot=[243 00 61 00 +060 -085  85  65  45]; %Aug 31 no Armb detection.  A bust
   %timoffrot=[244 23 42 12 +058 -085  95  65  45]; %day0
   %timoffrot=[245 23 42 12 +058 -085  95  65  45]; %day1
%timoffrot=[246 00 61 00 +060 -085  85  65  45];  %Near beginning; isolated; 100%
%timoffrot=[246 04 21 16 +062 -084  90  70  45];
%timoffrot=[246 04 21 56 +061 -084  90  60  50]; %Also quite isolated
%timoffrot=[246 04 22 20 +060 -085  85  60  40];
   %timoffrot=[2005 246 04 25 16 +060 -085  90  60  45]; %agu
%timoffrot=[246 04 26 52 +059 -085  90  60  45];
%timoffrot=[246 09 45 56 +061 -083  95  65  50];
%timoffrot=[246 11 08 52 +064 -083  90  60  50];
%timoffrot=[246 12 53 24 +062 -083  95  60  50];
%timoffrot=[246 09 47 40 +060 -084  90  60  50];
%timoffrot=[246 09 56 12 +062 -085  95  55  50]; %Also small
%timoffrot=[246 10 06 36 +061 -085  85  60  45]; %36415-36420, e.g.
%timoffrot=[246 11 11 16 +063 -084  90  60  50];
%timoffrot=[246 12 56 12 +062 -085  90  55  50];
%timoffrot=[246 17 17 48 +062 -087  80  60  40];
%timoffrot=[247 04 59 24 +033 -100  85 370  80];/
%timoffrot=[247 10 15 24 +051 -078  85  60  55 ];
%timoffrot=[247 11 14 36 +056 -077  90  55  65];
   %timoffrot=[247 14 18 28 +058 -074  90 85 50]; %(the original; catalog has 85  75  55)
   %timoffrot=[247 14 18 28 +058 -074  85 75 50]; %(the original; catalog has 85  75  55)
   %timoffrot=[247  9 53 32   57  -78 100  65  60]; %From the 2-8Hz catalog
   %timoffrot=[248 15 37 00 +058 -074  85 70 50];
%timoffrot=[247 14 42 28 +059 -073  85  65  65];  %Small signal!
%timoffrot=[250 05 09 24 +065 -068  80  75  45]; %Near start of a small migration.  V. messy.
%timoffrot=[250 05 23 56 +060 -072  85  65  50];
   %timoffrot=[250 05 44 44 +056 -075  85  70  55]; %Possible EGFs here. FIRST LOOK!
%timoffrot=[250 09 13 40 +105 -031  85  50  80];
   %timoffrot=[250 11 20 36 +105 -030  90  50  80]; %Big; good for looking for "missed" energy
%timoffrot=[250 11 25 00 +093 -035  85  70  90];
%timoffrot=[250 11 28 36 +090 -037  80  75  65];
%timoffrot=[250 11 30 44 +090 -036  75  60  70]; %early in a migration episode
   %timoffrot=[250 11 34 20 +086 -032  80 105  65]; %migration
   %timoffrot=[250 11 27 40 +091 -037  80  70  75]; %(originally 80 75 75)
%timoffrot=[250 11 34 20 +086 -032 +024  80 105  65  80];
%timoffrot=[250 11 47 00 +080 -042  75  70  65];
   %timoffrot=[250 15 17 24 +104 -031  90  55  80]; %Big!
   %timoffrot=[250 16 40 52 -017 +056 100 120 130]; %Up north
%timoffrot=[250 06 21 00 +100 -036  85  50  70]; %Also big, not quite as.
%timoffrot=[253 01 50 20 +093 -024  85  75  85];
%timoffrot=[254 06 47 08 +086 +019  80 105  55]; %Dominated by last half of last panel
%timoffrot=[254 07 40 52 +086 +019  80 110  55]; %Consistent with lxtwmg %(whole 2nd panel, e.g.)
   %timoffrot=[254 09 57 08 +086 +019  80 115  50]; %2nd panel quite impressive, again.
%timoffrot=[254 13 48 28 +086 +019  80 115  50];
%timoffrot=[254 13 50 04 +086 +019  80 115  50]; %BIG SPIKE, panel 2.  Coherence starts slightly earlier?
%timoffrot=[254 15 11 56 +086 +019  80 120  55]; %Messy; dominated by panel 2
%timoffrot=[254 20 29 00 +086 +019  85 115  55]; %Messy; mix of in-phase/out-of-phase end of panel 2
%timoffrot=[254 22 17 56 +086 +019  75 105  45];
   %timoffrot=[254 14 32 52 +040 -006  65 370  50]; %Alternate Brown location
   %timoffrot=[265 14 32 52 +040 -006  65 370  50]; %Alternate Brown location, Brown day
   %timoffrot=[256 01 31 48 +033 +024  95 155  45]; %quasi-Brown location; a bust?
   %timoffrot=[265 01 31 48 +033 +024  95 155  45]; %quasi-Brown location, Brown day; pretty much a bust
   
   %timoffrot=[2005 246 04 25 16 +060 -085  90  60  45]; %agu
   %timoffrot=[253 05 19 48 +085 +020  80 115  55]; 
%    timoffrot=[253 05 19 48 +085 +020  80 115  55]; 
    %timoffrot=[2005 254 04 05 00 +087 +018  85 110  45];
    %timoffrot=[2005 255 04 05 00 +087 +018  85 110  45];
    %timoffrot=[2005 254 07 42 12 +086 +016  80 110  60];
    %timoffrot=[2005 257 05 19 48 +085 +020  80 115  55];   
    %timoffrot=[2005 254 05 19 48 +085 +020  80 115  55]; %Started yesterday.  
    %timoffrot=[2005 255 01 27 56 +086 +027  75 125  45]; %Started yesterday 
    %timoffrot=[254 03 29 56 +096 +011  85 110  75]; %a different spot but not too far, active just before.  Not much.
    %timoffrot=[255 09 40 12 +091 +032  80  75  45]; %nearby, on this day starts w/ a fast migration
    %timoffrot=[254 09 40 12 +091 +032  80  75  45]; %nearby, the day before. Nada.
    %timoffrot=[255 05 19 48 +085 +020  80 115  55]; %bingo.  Starts w/ a fast migration
%    timoffrot=[255 09 42 04 +089 +031  80 105  50]; %nearby
    %timoffrot=[2005 257 05 19 48 +085 +020  80 115  55]; %v. little
    %timoffrot=[257 05 19 48 +085 +020  80 115  55]; %one small but cohrenet burst
%    timoffrot=[258 05 19 48 +085 +020  80 115  55]; % Sept. 15.  Nothing at this spot.
    %timoffrot=[2005 260 05 19 48 +085 +020  80 115  55]; % Sept. 18.  Nothing at this spot.
   %timoffrot=[259 12 28 44 +044 +071  70 350 375];
   %timoffrot=[259 13 29 24 +036 +075  75 370 390];
   %timoffrot=[2005 259 12 58 36 +036 +075  80 365 385]; %New spot
   %timoffrot=[2005 260 12 58 36 +036 +075  80 365 385]; %New spot
%    timoffrot=[2005 259 03 50 44 +045 +072  65 355 370]; %New spot
%    timoffrot=[2005 258 03 50 44 +045 +072  65 355 370]; %New spot
   %timoffrot=[2005 260 03 50 44 +045 +072  65 355 370]; %New spot
   %timoffrot=[2004 193 06 52 36 +105 -031  80  45  80]; %Earlier spot 2004
   %timoffrot=[2004 199 14 15 32 +085 +020  80 115  55];
   %timoffrot=[2004 196 14 15 32 +086 +013  80 115  55];
   %timoffrot=[2005 254 14 15 32 +086 +013  80 115  55];
   %timoffrot=[2004 196 14 15 32 +085 +020  80 110  55];
   %timoffrot=[2004 197 14 15 32 +086 +027  75 120  45]; %downstream
   %timoffrot=[2004 198 14 15 32 +086 +027  75 120  45]; %downstream
   %timoffrot=[2004 198 14 15 32 +085 +020  80 115  55];
   %timoffrot=[2004 196  9 45 48   87   14  75 115  50]; %focus on early, 2004, 2-8Hz catalog
     %timoffrot=[2003 063 14 15 32 +085 +020  80 115  55]; %spot, 2003
   %timoffrot=[2003 062 14 15 32 +085 +020  80 115  55]; %spot, 2003
   %timoffrot=[2003 063 14 15 32 +086 +027  75 125  45]; %downstream, 2003
   %timoffrot=[2003 062 14 15 32 +086 +013  80 110  55]; %upstream, 2003
   %timoffrot=[2003 061 14 15 32 +085 +020  80 115  55]; %faked %COULD BE 80 120 50/55, 2-8Hz
   %timoffrot=[2003 069 14 15 32 +085 +020  80 115  55]; %spot, 2003.  NADA Anywhere! on 065
%    timoffrot=[2005 250 05 19 48 +092 -037  80 70  75];   
    %timoffrot=[2005 247 05 19 48 +059 -073  85 65  55];   
    %timoffrot=[2006 121 05 19 48 +059 -073  95 90  50];   %FOR HIGHER FREQUENCY
    %timoffrot=[2005 245 05 19 48 +059 -073  95 90  50];   %FOR HIGHER FREQUENCY  
    %timoffrot=[2005 078 05 19 48 +059 -073  95 90  50];   %FOR HIGHER FREQUENCY  
    %timoffrot=[2004 195 05 19 48 +059 -073  95 90  50];   %FOR HIGHER FREQUENCY
    %timoffrot=[2004 118 05 19 48 +059 -073  95 90  50];   %FOR HIGHER FREQUENCY
    %timoffrot=[2004 364 05 19 48 +059 -073  95 90  50];   %FOR HIGHER FREQUENCY
    %timoffrot=[2003 061 05 19 48 +059 -073  95 90  50];   %FOR HIGHER FREQUENCY
    %timoffrot=[2003 272 05 19 48 +059 -073  95 90  50];   %FOR HIGHER FREQUENCY
   %timoffrot=[2003 062  9 45 48   87   14  75 115  50]; %focus on early, 2003, 2-8Hz catalog
    %timoffrot=[2005 257 05 19 48 +085 +043  75 80  45];   
mshift=12; %16 %11 %14_for_+085+020
hi=6.;
lo=1.5;
% hi=8.;
% lo=2.;
% hi=6.;
% lo=0.75;
year=timoffrot(1);
YEAR=int2str(year);
jday=timoffrot(2);
if jday <= 9
    JDAY=['00',int2str(jday)];
elseif jday<= 99
    JDAY=['0',int2str(jday)];
else
    JDAY=int2str(jday)
end
timlook=3600*timoffrot(3)+60*timoffrot(4)+timoffrot(5)
rotPGC=pi*(timoffrot(8)-90)/180;
rotSSIB=pi*(timoffrot(9)-90)/180;
rotSILB=pi*(timoffrot(10)-90)/180;
SSIBsoff=timoffrot(6);
SILBsoff=timoffrot(7);
SSIBtoff=SSIBsoff/40;
SILBtoff=SILBsoff/40;
IDENTIF=[YEAR,'.',JDAY,'.',int2str(timoffrot(6)),'.',int2str(timoffrot(7)), ...
    '.',int2str(timoffrot(8)),'.',int2str(timoffrot(9)),'.',int2str(timoffrot(10))]

%Read Armbruster's detections:
ArmCat=load(['/data2/arubin/CNDC/',YEAR,'/list.',YEAR,'.pgsssiMAJ']);
%ArmCat=load(['/data2/arubin/CNDC/',YEAR,'/list.',YEAR,'.pgsssiMIN']);
detects=86400*(ArmCat(:,1)-jday)+3600*ArmCat(:,2)+60*ArmCat(:,3)+ArmCat(:,4);
vectoff=[ArmCat(:,5)-SSIBsoff ArmCat(:,6)-SILBsoff (ArmCat(:,6)-SILBsoff)-(ArmCat(:,5)-SSIBsoff)];
distoff=vectoff.*vectoff;
distoff2=sum(distoff,2);
gridoff=max(abs(vectoff),[],2); %Try this instead.  Should change w/mshift (defined later, though)
m0=0;
Detects=0;
for n=1:length(detects)
    %if distoff2(n)<=9
    if gridoff(n)<=mshift-1
%      if isequal(ArmCat(n,5:6),[SSIBsoff SILBsoff]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff-1 SILBsoff]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff+1 SILBsoff]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff SILBsoff-1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff SILBsoff+1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff-1 SILBsoff-1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff-1 SILBsoff+1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff+1 SILBsoff-1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff+1 SILBsoff+1]) 
         %ArmCat(n,5:6)
         m0=m0+1;
         Detects(m0)=detects(n);
     end
end
%abs(xmaxPGSIn(n)-xmaxPGSSn(n)+xmaxSISSn(n))>loopoffma
ArmCat=load(['/data2/arubin/CNDC/',YEAR,'/list.',YEAR,'.pgsssiMAJ_new']);
detects2_8=86400*(ArmCat(:,1)-jday)+3600*ArmCat(:,2)+60*ArmCat(:,3)+ArmCat(:,4);
vectoff=[ArmCat(:,5)-SSIBsoff ArmCat(:,6)-SILBsoff];
distoff=vectoff.*vectoff;
distoff2=sum(distoff,2);
gridoff=max(abs(vectoff),[],2); %Try this instead.  Should change w/mshift (defined later, though)
m1=0;
Detects2_8=0;
for n=1:length(detects2_8)
    %if distoff2(n)<=9
    if gridoff(n)<=mshift-1
%      if isequal(ArmCat(n,5:6),[SSIBsoff SILBsoff]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff-1 SILBsoff]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff+1 SILBsoff]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff SILBsoff-1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff SILBsoff+1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff-1 SILBsoff-1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff-1 SILBsoff+1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff+1 SILBsoff-1]) ||...
%         isequal(ArmCat(n,5:6),[SSIBsoff+1 SILBsoff+1]) 
         m1=m1+1;
         Detects2_8(m1)=detects2_8(n);
     end
end

%Read data:
direc=[YEAR,'/SEPT/'];
prename=[direc,YEAR,'.',JDAY,'.00.00.00.0000.CN'];
PGCEdat=[prename,'.PGC..BHE.D.SAC'];
PGCNdat=[prename,'.PGC..BHN.D.SAC'];
%PGCZdat=[prename,'.PGC..BHZ.D.SAC'];
SSIBEdat=[prename,'.SSIB..HHE.D.SAC'];
SSIBNdat=[prename,'.SSIB..HHN.D.SAC'];
SILBEdat=[prename,'.SILB..HHE.D.SAC'];
SILBNdat=[prename,'.SILB..HHN.D.SAC'];

[PGCE,HdrDataPGC,tnuPGC,pobjPGC,timsPGC]=readsac(PGCEdat,0,'l');
[PGCN,~,~,~,~]=readsac(PGCNdat,0,'l');
%[PGCZ,~,~,~,~]=readsac(PGCZdat,0,'l');
[SSIBE,HdrDataSSIB,tnuSSIB,pobjSSIB,timsSSIB]=readsac(SSIBEdat,0,'l');
[SSIBN,~,~,~,~]=readsac(SSIBNdat,0,'l');
[SILBE,HdrDataSILB,tnuSILB,pobjSILB,timsSILB]=readsac(SILBEdat,0,'l');
[SILBN,~,~,~,~]=readsac(SILBNdat,0,'l');
% timsPGC(1)
% timsSSIB(1)
% timsSILB(1)
%
rdsac=cputime-t
t=cputime;
%     % Truncate for quicker calculation.  100sps stations are longer for
%     % later interpolation
%     timwin=4*60+1;
%     timstart=max(0, timlook-timwin); timend=min(86400, timlook+timwin);
%     PGCE=PGCE(timstart*40+1:timend*40)-mean(PGCE(timstart*40+1:timend*40));
%     PGCN=PGCN(timstart*40+1:timend*40)-mean(PGCN(timstart*40+1:timend*40)); 
%     %PGCZ=PGCZ(timstart*40+1:timend*40);
%     SSIBE=SSIBE(timstart*100:timend*100+1)-mean(SSIBE(timstart*100:timend*100+1));
%     SSIBN=SSIBN(timstart*100:timend*100+1)-mean(SSIBN(timstart*100:timend*100+1));
%     SILBE=SILBE(timstart*100:timend*100+1)-mean(SILBE(timstart*100:timend*100+1));
%     SILBN=SILBN(timstart*100:timend*100+1)-mean(SILBN(timstart*100:timend*100+1));
%     timsPGC=timsPGC(timstart*40+1:timend*40);
%     timsSSIB=timsSSIB(timstart*100:timend*100+1);
%     timsSILB=timsSILB(timstart*100:timend*100+1);
% %shrten=cputime-t
% %t=cputime;
% %
tracelenPGC=length(PGCE);
tracelenSSIB=length(SSIBE);
tracelenSILB=length(SILBE);
    timPGCfirst=timsPGC(1);
    timSSIBfirst=timsSSIB(1); %0.01s earlier than PGC
    timSILBfirst=timsSILB(1); %0.01s earlier than PGC
    timPGClast=timsPGC(tracelenPGC);
    timSSIBlast=timsSSIB(tracelenSSIB);
    timSILBlast=timsSILB(tracelenSILB);
    timstart=timPGCfirst; timend=timPGClast; 
    timwin=(timPGClast-timPGCfirst)/2;
    startdiff=timPGCfirst-timSSIBfirst
    enddiff=timSSIBlast-timPGClast

%cosine taper before filtering:
x=(0:pi/80:pi/2-pi/80)';
% %Seems to be necessary at the start of each day for PGCE:
    PGCE(1:80)=0.;
    PGCE(81:120)=sin(x).*PGCE(81:120); %Only at start of day!
%PGCE(1:40)=sin(x).*PGCE(1:40);
PGCN(1:40)=sin(x).*PGCN(1:40);
x=flipud(x);
PGCE(tracelenPGC-39:tracelenPGC)=sin(x).*PGCE(tracelenPGC-39:tracelenPGC);
PGCN(tracelenPGC-39:tracelenPGC)=sin(x).*PGCN(tracelenPGC-39:tracelenPGC);
x=(0:pi/200:pi/2-pi/200)';
SSIBE(1:100)=sin(x).*SSIBE(1:100);
SSIBN(1:100)=sin(x).*SSIBN(1:100);
SILBE(1:100)=sin(x).*SILBE(1:100);
SILBN(1:100)=sin(x).*SILBN(1:100);
x=flipud(x);
SSIBE(tracelenSSIB-99:tracelenSSIB)=sin(x).*SSIBE(tracelenSSIB-99:tracelenSSIB);
SSIBN(tracelenSSIB-99:tracelenSSIB)=sin(x).*SSIBN(tracelenSSIB-99:tracelenSSIB);
SILBE(tracelenSILB-99:tracelenSSIB)=sin(x).*SILBE(tracelenSILB-99:tracelenSILB);
SILBN(tracelenSILB-99:tracelenSSIB)=sin(x).*SILBN(tracelenSILB-99:tracelenSILB);

% if(rem(tracelen,2)==0)
%     SeisData(tracelen)=[];
%     tims(tracelen)=[];
%     tracelen=tracelen-1;
% end
%Looks like filtering the 40-Hz data followed by interpolation introduces 
%less high-frequency stuff that does not appear in the original filtered
%40-Hz data:
%PGCE=spline(tims,SeisData,timsx);
%[PGCE]=bandpass(PGCE,100,1.0,5.0,2,1,'butter');

%Filter data:
npo=2;
npa=1;
[PGCEf]=1.6e-4*bandpass(PGCE,40,lo,hi,npo,npa,'butter');
[PGCNf]=1.6e-4*bandpass(PGCN,40,lo,hi,npo,npa,'butter');
%[PGCZf]=1.6e-4*bandpass(PGCZ,40,lo,hi,npo,npa,'butter');
[SSIBEf]=4.0e-3*bandpass(SSIBE,100,lo,hi,npo,npa,'butter'); %times 5 until Aug 2003
[SSIBNf]=4.0e-3*bandpass(SSIBN,100,lo,hi,npo,npa,'butter'); %times 5 until Aug 2003
[SILBEf]=4.0e-3*bandpass(SILBE,100,lo,hi,npo,npa,'butter'); %times 5 until Aug 2003
[SILBNf]=4.0e-3*bandpass(SILBN,100,lo,hi,npo,npa,'butter'); %times 5 until Aug 2003
fltr=cputime-t
t=cputime;

%Decimate the 100 sps data:
% SSIBEfd = interp1(timsSSIB,SSIBEf,timsPGC,'linear')';
% SSIBNfd = interp1(timsSSIB,SSIBNf,timsPGC,'linear')';
% SILBEfd = interp1(timsSILB,SILBEf,timsPGC,'linear')';
% SILBNfd = interp1(timsSILB,SILBNf,timsPGC,'linear')';
% dmate=cputime-t
% t=cputime;
SSIBEfd = resample(SSIBEf,2,5);
SSIBNfd = resample(SSIBNf,2,5);
SILBEfd = resample(SILBEf,2,5);
SILBNfd = resample(SILBNf,2,5);
dmate=cputime-t
t=cputime;

PGC=PGCEf+1i*PGCNf;
SSIB=SSIBEfd+1i*SSIBNfd;
SILB=SILBEfd+1i*SILBNfd;
PGCrot=PGC*exp(1i*rotPGC);
SSIBrot=SSIB*exp(1i*rotSSIB);
SILBrot=SILB*exp(1i*rotSILB);
    %rtate=cputime-t
    %t=cputime;

if SSIBtoff > 0
    SSIBrot(1:tracelenPGC-SSIBsoff)=SSIBrot(SSIBsoff+1:tracelenPGC);
    SSIBrot(tracelenPGC-SSIBsoff+1:tracelenPGC)=0;
else
    SSIBrot(-SSIBsoff+1:tracelenPGC)=SSIBrot(1:tracelenPGC+SSIBsoff);
    SSIBrot(1:-SSIBsoff)=0;
end
if SILBtoff > 0
    SILBrot(1:tracelenPGC-SILBsoff)=SILBrot(SILBsoff+1:tracelenPGC);
    SILBrot(tracelenPGC-SILBsoff+1:tracelenPGC)=0;
else
    SILBrot(-SILBsoff+1:tracelenPGC)=SILBrot(1:tracelenPGC+SILBsoff);
    SILBrot(1:-SILBsoff)=0;
end
    %tracesht=cputime-t
    %t=cputime;

realPGC=real(PGCrot);
realSSIB=real(SSIBrot);
realSILB=real(SILBrot);
% realPGC=imag(PGCrot); %A quick/dirty way to try the same on the orthogonal components
% realSSIB=imag(SSIBrot);
% realSILB=imag(SILBrot);

plotstart=1; %(timlook-timstart)*40
plotend=tracelenPGC; %(timlook-timstart)*40
ltmax=max([real(PGCrot(plotstart:plotend)); ...
          real(SSIBrot(plotstart:plotend)); ...
          real(SILBrot(plotstart:plotend))]);
ltmax=min(ltmax,0.75);
ltmin=min([real(PGCrot(plotstart:plotend)); ...
          real(SSIBrot(plotstart:plotend)); ...
          real(SILBrot(plotstart:plotend))]);
ltmin=max(ltmin,-0.75);

figure %Superposed traces, 150s window:
subplot(4,1,1); 
hold on
plot(timsPGC,real(PGCrot),'r');
plot(timsPGC,real(SSIBrot),'b');
plot(timsPGC,real(SILBrot),'k');
axis([0 timwin/2 ltmin ltmax]);
%xlim([timlook-75 timlook-37.5]);
subplot(4,1,2); 
hold on
plot(timsPGC,real(PGCrot),'r');
plot(timsPGC,real(SSIBrot),'b');
plot(timsPGC,real(SILBrot),'k');
axis([timwin/2 timwin ltmin ltmax]);
%xlim([timlook-37.5 timlook]);
subplot(4,1,3); 
hold on
plot(timsPGC,real(PGCrot),'r');
plot(timsPGC,real(SSIBrot),'b');
plot(timsPGC,real(SILBrot),'k');
axis([timwin 3*timwin/2 ltmin ltmax]);
%xlim([timlook timlook+37.5]);
subplot(4,1,4); 
hold on
plot(timsPGC,real(PGCrot),'r');
plot(timsPGC,real(SSIBrot),'b');
plot(timsPGC,real(SILBrot),'k');
axis([3*timwin/2 2*timwin ltmin ltmax]);
%xlim([timlook+37.5 timlook+75]);
traceplt=cputime-t
t=cputime;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Autocorrelation of stations.  Those that end in "2" are the running
%   cumulative sum, to be used later by differncing the window edpoints.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PGCauto=realPGC.*realPGC;
PGC2=cumsum(PGCauto);
SSIBauto=realSSIB.*realSSIB;
SSIB2=cumsum(SSIBauto);
SILBauto=realSILB.*realSILB;
SILB2=cumsum(SILBauto);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Cross-correlation between stations, with small offsets up to +/- mshift.
%  First index is pointwise multiplication of traces; second is shifting offset.
%  lenx is shorter than tracelenPGC by mshift at each end (see notebook sketch)
%  For PGSS and PGSI, SSI and SIL are shifted relative to PGC, by 1 each time through loop.
%  For SISS, SSI is shifted relative to SILB.
%  cumsumPGSS etc. are the running cumulative sum of the x-correlation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mshift=16;
lenx=tracelenPGC-2*mshift;
PGSSx=zeros(lenx, 2*mshift+1);
PGSIx=zeros(lenx, 2*mshift+1);
SISSx=zeros(lenx, 2*mshift+1);
for n=-mshift:mshift;
    PGSSx(:,n+mshift+1)=realPGC(1+mshift:tracelenPGC-mshift).* ...
        realSSIB(1+mshift-n:tracelenPGC-mshift-n);
    PGSIx(:,n+mshift+1)=realPGC(1+mshift:tracelenPGC-mshift).* ...
        realSILB(1+mshift-n:tracelenPGC-mshift-n);
    SISSx(:,n+mshift+1)=realSILB(1+mshift:tracelenPGC-mshift).* ...
        realSSIB(1+mshift-n:tracelenPGC-mshift-n);
end
cumsumPGSS=cumsum(PGSSx);
cumsumPGSI=cumsum(PGSIx);
cumsumSISS=cumsum(SISSx);
xcshifts=cputime-t
t=cputime;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  "winbig" is now the whole day, minus 3 sec at each end (apparently).
%  "timbig" is the time of half that.
%  igstart is the index of the starting sample.
%  winlen and winoff refer to the small windows.
%  timswin refers to the central times of those small windows.
%  sumsPGSS (etc.) is the cross-correlation sum over the window.  The first
%    index refers to the window number and the second the shift over +/-mshift.
%  Normalized x-correlation:
%    For PGSS and PGSI, for a given window PGC does not shift but SSI and 
%    SIL do.  So can compute sumsPGC2 (from the running cum. sum PGC2) just
%    once for each window.  Same for sumsSILB2b.  But for the stations that
%    shift, SSI and SIL (for PGC) and SSI (for SIL), must compute sumsSSIB2 
%    and sumsSILB2 upon each shift (actually, this is is easy book-keeping
%    but not efficient).  Again, the first index refers to the window
%    number and the second the shift over +/-mshift.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
winbig=2*(tracelenPGC/2-120);
timbig=winbig/(2*40);
igstart=floor(tracelenPGC/2-winbig/2)+1;
winlen=4*40;
%winlen=128*40;
winoff=40/1;
%winoff=40*8;
nwin=floor((winbig-winlen)/winoff);
timswin=zeros(nwin,1);
sumsPGSS=zeros(nwin,2*mshift+1);
sumsPGSI=zeros(nwin,2*mshift+1);
sumsSISS=zeros(nwin,2*mshift+1);
sumsPGC2=zeros(nwin,2*mshift+1);
sumsSSIB2=zeros(nwin,2*mshift+1);
sumsSILB2=zeros(nwin,2*mshift+1);
sumsSILB2b=zeros(nwin,2*mshift+1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  sumsPGSS is shorter than sumsPGC2 by 2*mshift.  This is why sumsPGC2 etc
%  is shifted by +mshift.  cumsumPGSS(1,:)=cumsum(PGSSx)(1,:) starts mshift
%  to the right of the first data sample.  igstart is how many to the right
%  of that.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n=1:nwin;
    istart=igstart+(n-1)*winoff;
    iend=istart+winlen;
    timswin(n)=timsPGC(istart+winlen/2); 
    sumsPGSS(n,:)=cumsumPGSS(iend,:)-cumsumPGSS(istart-1,:); 
    sumsPGSI(n,:)=cumsumPGSI(iend,:)-cumsumPGSI(istart-1,:);
    sumsSISS(n,:)=cumsumSISS(iend,:)-cumsumSISS(istart-1,:);
    sumsPGC2(n,:)=PGC2(iend+mshift)-PGC2(istart+mshift-1);  %PGC2 is cumsummed. Yes, +mshift.
    sumsSILB2b(n,:)=SILB2(iend+mshift)-SILB2(istart+mshift-1); %Similar, for the SILB-SSIB connection.
    for m=-mshift:mshift;
        sumsSSIB2(n,m+mshift+1)=SSIB2(iend+mshift-m)-SSIB2(istart+mshift-1-m); %+m??? (yes).
        sumsSILB2(n,m+mshift+1)=SILB2(iend+mshift-m)-SILB2(istart+mshift-1-m);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Denominator for the normalization.  A 2D array, nwin by 2*mshift+1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
denomPGSSn=realsqrt(sumsPGC2.*sumsSSIB2);
denomPGSIn=realsqrt(sumsPGC2.*sumsSILB2);
denomSISSn=realsqrt(sumsSILB2b.*sumsSSIB2);
%
denomPGSSn=max(denomPGSSn,eps);
denomPGSIn=max(denomPGSIn,eps);
denomSISSn=max(denomSISSn,eps);
%
sumsPGSSn=sumsPGSS./denomPGSSn;
sumsPGSIn=sumsPGSI./denomPGSIn;
sumsSISSn=sumsSISS./denomSISSn;
[xcmaxPGSSn,imaxPGSS]=max(sumsPGSSn,[],2); %Integer-offset max cross-correlation
[xcmaxPGSIn,imaxPGSI]=max(sumsPGSIn,[],2);
[xcmaxSISSn,imaxSISS]=max(sumsSISSn,[],2);
%Parabolic fit:
% [xmaxPGSSn,ymaxPGSSn,xloPGSSn,xhiPGSSn]=parabol(nwin,mshift,sumsPGSSn,imaxPGSS); %These return some poor measure of "confidence".
% [xmaxPGSIn,ymaxPGSIn,xloPGSIn,xhiPGSIn]=parabol(nwin,mshift,sumsPGSIn,imaxPGSI);
% [xmaxSISSn,ymaxSISSn,xloSISSn,xhiSISSn]=parabol(nwin,mshift,sumsSISSn,imaxSISS);
[xmaxPGSSn,ymaxPGSSn,aPGSS]=parabol(nwin,mshift,sumsPGSSn,imaxPGSS); %Interpolated max cross-correlation
[xmaxPGSIn,ymaxPGSIn,aPGSI]=parabol(nwin,mshift,sumsPGSIn,imaxPGSI);
[xmaxSISSn,ymaxSISSn,aSISS]=parabol(nwin,mshift,sumsSISSn,imaxSISS);

ix=sub2ind(size(denomPGSSn),(1:nwin)',imaxPGSS);
ampPGSS=sqrt(denomPGSSn(ix)); %This makes amplitude linear rather than quadratic with counts.
ampPGC2=sumsPGC2(ix); %by construction PGC2 is the same for all shifts
ampSSIB2=sumsSSIB2(ix);
ix=sub2ind(size(denomPGSIn),(1:nwin)',imaxPGSI);
ampPGSI=sqrt(denomPGSIn(ix));
ampSILB2=sumsSILB2(ix);
ix=sub2ind(size(denomSISSn),(1:nwin)',imaxSISS);
ampSISS=sqrt(denomSISSn(ix));
AmpComp(1:4)=0;
AmpComp(5:nwin)=((ampPGC2(5:nwin)+ampSSIB2(5:nwin)+ampSILB2(5:nwin))- ...
                (ampPGC2(1:nwin-4)+ampSSIB2(1:nwin-4)+ampSILB2(1:nwin-4)))./ ...
                ((ampPGC2(5:nwin)+ampSSIB2(5:nwin)+ampSILB2(5:nwin))+ ...
                (ampPGC2(1:nwin-4)+ampSSIB2(1:nwin-4)+ampSILB2(1:nwin-4))) ;
%Center them
imaxPGSS=imaxPGSS-mshift-1;
imaxPGSI=imaxPGSI-mshift-1;
imaxSISS=imaxSISS-mshift-1;
iloopoff=imaxPGSI-imaxPGSS+imaxSISS; %How well does the integer loop close?
xmaxPGSSn=xmaxPGSSn-mshift-1;
xmaxPGSIn=xmaxPGSIn-mshift-1;
xmaxSISSn=xmaxSISSn-mshift-1;
loopoff=xmaxPGSIn-xmaxPGSSn+xmaxSISSn; %How well does the interpolated loop close?
xcmaxAVEn=(xcmaxPGSSn+xcmaxPGSIn+xcmaxSISSn)/3;
loopoffmax=1.5
xcmaxAVEnmin=0.4 %0.4 for 4s 1.5-6 Hz; 0.36 for 4s2-8 Hz ;  0.094 for 128s 2-8Hz;  0.1 for 128s 1.5-6Hz
xcnshifts=cputime-t
t=cputime;

ampmax=max([ampPGSS; ampPGSI; ampSISS]);
figure 
subplot(4,1,1,'align'); 
hold on
plot(timswin,zeros(nwin,1),'k:');
%plot(timswin,3.5+zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn*mshift,'g');
plot(timswin,xmaxPGSSn,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIn,'ro','MarkerSize',2);
plot(timswin,(xmaxPGSIn-xmaxPGSSn+xmaxSISSn),'k*','MarkerSize',2);
%plot(timswin,xmaxSISSn,'k*','MarkerSize',2);
axis([0 timbig/2 -mshift mshift]);
ylabel('samples')
box on
subplot(4,1,2,'align'); 
hold on
plot(timswin,zeros(nwin,1),'k:');
%plot(timswin,3.5+zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn*mshift,'g');
plot(timswin,xmaxPGSSn,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIn,'ro','MarkerSize',2);
plot(timswin,(xmaxPGSIn-xmaxPGSSn+xmaxSISSn),'k*','MarkerSize',2);
%plot(timswin,xmaxSISSn,'k*','MarkerSize',2);
axis([timbig/2 timbig -mshift mshift]);
ylabel('samples')
box on
subplot(4,1,3,'align'); 
hold on
plot(timswin,zeros(nwin,1),'k:');
%plot(timswin,3.5+zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn*mshift,'g');
plot(timswin,xmaxPGSSn,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIn,'ro','MarkerSize',2);
plot(timswin,(xmaxPGSIn-xmaxPGSSn+xmaxSISSn),'k*','MarkerSize',2);
%plot(timswin,xmaxSISSn,'k*','MarkerSize',2);
axis([timbig 3*timbig/2 -mshift mshift]);
ylabel('samples')
box on
subplot(4,1,4,'align'); 
hold on
plot(timswin,zeros(nwin,1),'k:');
%plot(timswin,3.5+zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn*mshift,'g');
plot(timswin,xmaxPGSSn,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIn,'ro','MarkerSize',2);
plot(timswin,(xmaxPGSIn-xmaxPGSSn+xmaxSISSn),'k*','MarkerSize',2);
%plot(timswin,xmaxSISSn,'k*','MarkerSize',2);
axis([3*timbig/2 2*timbig -mshift mshift]);
xlabel('sec')
ylabel('samples')
box on
title([IDENTIF,'_{',int2str(lo),'-',int2str(hi),'}'])
orient landscape
print('-depsc',['FIGS/',IDENTIF,'-',int2str(winlen/40),'s_',int2str(lo),'-',int2str(hi),'a.eps'])

medxcmaxAVEn=median(xcmaxAVEn)
xmaxPGSSntmp=xmaxPGSSn;
xmaxPGSIntmp=xmaxPGSIn;
xmaxSISSntmp=xmaxSISSn;
%loopoff=xmaxPGSIn-xmaxPGSSn+xmaxSISSn; 
iup=4;
nin=0;
for n=1:nwin
    if xcmaxAVEn(n)<xcmaxAVEnmin || abs(xmaxPGSIn(n)-xmaxPGSSn(n)+xmaxSISSn(n))>loopoffmax ...
            || isequal(abs(imaxPGSS(n)),mshift) || isequal(abs(imaxPGSI(n)),mshift) || isequal(abs(imaxSISS(n)),mshift)
        xmaxPGSSntmp(n)=20; xmaxPGSIntmp(n)=20; xmaxSISSntmp(n)=20; 
    else
        interpPGSSn=interp(sumsPGSSn(n,:),iup,3);
        interpPGSIn=interp(sumsPGSIn(n,:),iup,3);
        interpSISSn=interp(sumsSISSn(n,:),iup,3);
        [xcmaxinterpPGSSn,imaxinterpPGSS]=max(interpPGSSn);
        [xcmaxinterpPGSIn,imaxinterpPGSI]=max(interpPGSIn);
        [xcmaxinterpSISSn,imaxinterpSISS]=max(interpSISSn);
        xcmaxconprev=-99999.;  %used to be 0; not good with glitches
        for iPGSS=max(1,imaxinterpPGSS-3*iup):min(imaxinterpPGSS+3*iup,iup*(2*mshift+1)-(iup-1)) %3 samples from peak; 
                                                                                 %intentionally wider than acceptable;
                                                                                 %iup-1 are extrapolated points
            for iPGSI=max(1,imaxinterpPGSI-3*iup):min(imaxinterpPGSI+3*iup,iup*(2*mshift+1)-(iup-1))
                ibangon = (iup*mshift+1)-iPGSI+iPGSS;
                if ibangon >= 1 && ibangon<=iup*(2*mshift+1)
                    xcmaxcon=interpPGSSn(iPGSS)+interpPGSIn(iPGSI)+interpSISSn(ibangon);
                    if xcmaxcon > xcmaxconprev
                        xcmaxconprev=xcmaxcon;
                        iPGSSbang=iPGSS;
                        iPGSIbang=iPGSI;
                    end
                end
            end
        end
        iSISSbang=(iup*mshift+1)-iPGSIbang+iPGSSbang;
        if abs(iPGSSbang-imaxinterpPGSS) <= loopoffmax*iup && ...
           abs(iPGSIbang-imaxinterpPGSI) <= loopoffmax*iup && ...
           abs(iSISSbang-imaxinterpSISS) <= loopoffmax*iup && ...
           interpPGSSn(iPGSSbang)+interpPGSIn(iPGSIbang)+interpSISSn(iSISSbang) >= 3*xcmaxAVEnmin
            xmaxPGSSntmp(n)=(iPGSSbang-(iup*mshift+1))/iup;
            xmaxPGSIntmp(n)=(iPGSIbang-(iup*mshift+1))/iup;
            xmaxSISSntmp(n)=(iSISSbang-(iup*mshift+1))/iup;
            
            %for plotting traces
            istart=igstart+(n-1)*winoff; %a better way might exist?
            iend=istart+winlen-1;
            imaxPGSSwr=round(xmaxPGSSntmp(n));
            imaxPGSIwr=round(xmaxPGSIntmp(n));

            PGSStr=realPGC(istart:iend).*realSSIB(istart-imaxPGSSwr:iend-imaxPGSSwr);
            PGSItr=realPGC(istart:iend).*realSILB(istart-imaxPGSIwr:iend-imaxPGSIwr);
            SISStr=realSILB(istart-imaxPGSIwr:iend-imaxPGSIwr).*realSSIB(istart-imaxPGSSwr:iend-imaxPGSSwr);
            cumsumtr=cumsum(PGSStr)+cumsum(PGSItr)+cumsum(SISStr);
            [cumsumtrdiff idiff]=max(cumsumtr(41:winlen)-cumsumtr(1:winlen-40));

            PGCfile(nin*winlen+1:(nin+1)*winlen,1:2)=[timsPGC(istart:iend)' realPGC(istart:iend)];
            SSIBfile(nin*winlen+1:(nin+1)*winlen,1:2)=[timsPGC(istart:iend)' realSSIB(istart-imaxPGSSwr:iend-imaxPGSSwr)];
            SILBfile(nin*winlen+1:(nin+1)*winlen,1:2)=[timsPGC(istart:iend)' realSILB(istart-imaxPGSIwr:iend-imaxPGSIwr)];
            PGSSfile(nin+1,1:2)=[imaxPGSSwr xcmaxPGSSn(n)];
            PGSIfile(nin+1,1:2)=[imaxPGSIwr xcmaxPGSIn(n)];
            SISSfile(nin+1,1:3)=[cumsumtrdiff/cumsumtr(winlen) xcmaxSISSn(n) idiff];
            
            nin=nin+1;
            aPGSSkeep(nin,:)=[timswin(n) aPGSS(n)];
            aPGSIkeep(nin,:)=[timswin(n) aPGSI(n)];
            aSISSkeep(nin,:)=[timswin(n) aSISS(n)];
            loopoffkeep(nin,:)=[timswin(n) loopoff(n)];
            mapfile(nin,:)=[round(timswin(n)) xmaxPGSIntmp(n) xmaxPGSSntmp(n) ...
                xcmaxAVEn(n) loopoff(n) AmpComp(n) cumsumtrdiff timswin(n)-2+idiff/40. cumsumtrdiff/cumsumtr(winlen)];
        else
            xmaxPGSSntmp(n)=20; xmaxPGSIntmp(n)=20; xmaxSISSntmp(n)=20; 
        end
    end
end
fid = fopen(['map',IDENTIF,'_',int2str(lo),'-',int2str(hi),'-',int2str(winlen/40),'s'],'w');
fprintf(fid,'%i %9.5f %9.5f %9.4f %9.2f %9.3f %10.4f %10.4f %8.3f\n',mapfile');
fclose(fid);
figure 
subplot(4,1,1,'align'); 
hold on
plot(timswin,xcmaxAVEnmin*mshift+zeros(nwin,1),'k:');
plot(timsPGC(winlen:2*winlen),7+zeros(winlen+1,1),'k','linewidth',2);
plot(timswin,zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn*mshift,'g');
plot(timswin,xmaxPGSSntmp,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIntmp,'ro','MarkerSize',2);
plot(timswin,xmaxSISSntmp,'k*','MarkerSize',2);
axis([0 timbig/2 -mshift mshift]);
ylabel('samples')
box on
subplot(4,1,2,'align'); 
hold on
plot(timswin,xcmaxAVEnmin*mshift+zeros(nwin,1),'k:');
plot(timswin,zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn*mshift,'g');
plot(timswin,xmaxPGSSntmp,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIntmp,'ro','MarkerSize',2);
plot(timswin,xmaxSISSntmp,'k*','MarkerSize',2);
axis([timbig/2 timbig -mshift mshift]);
ylabel('samples')
box on
subplot(4,1,3,'align'); 
hold on
plot(timswin,xcmaxAVEnmin*mshift+zeros(nwin,1),'k:');
plot(timswin,zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn*mshift,'g');
plot(timswin,xmaxPGSSntmp,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIntmp,'ro','MarkerSize',2);
plot(timswin,xmaxSISSntmp,'k*','MarkerSize',2);
axis([timbig 3*timbig/2 -mshift mshift]);
ylabel('samples')
box on
subplot(4,1,4,'align'); 
hold on
plot(timswin,xcmaxAVEnmin*mshift+zeros(nwin,1),'k:');
plot(timswin,zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn*mshift,'g');
plot(timswin,xmaxPGSSntmp,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIntmp,'ro','MarkerSize',2);
plot(timswin,xmaxSISSntmp,'k*','MarkerSize',2);
axis([3*timbig/2 2*timbig -mshift mshift]);
xlabel('sec')
ylabel('samples')
box on
title([IDENTIF,'_{',int2str(lo),'-',int2str(hi),'}'])
orient landscape
print('-depsc',['FIGS/',IDENTIF,'-',int2str(winlen/40),'s_',int2str(lo),'-',int2str(hi),'b.eps'])

for n=1:nwin;
    if abs(loopoff(n))>2.0
        loopoff(n)=30; 
    end
end
figure 
subplot(4,1,1,'align'); 
hold on
plot(timswin,zeros(nwin,1),'k:');
plot(timswin,xmaxPGSSntmp,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIntmp,'ro','MarkerSize',2);
plot(timswin,xmaxSISSntmp,'k*','MarkerSize',2);
plot(timsPGC(winlen:2*winlen),7+zeros(winlen+1,1),'k','linewidth',2);
axis([0 timbig/2 -mshift mshift]);
title('blue = PGSS ;   red = PGSI ;  black = SISS')
box on
subplot(4,1,2,'align'); 
hold on
hrf = plotreflinesr(gca,detects,'x','k'); 
hrf = plotreflinesr(gca,Detects,'x','r'); 
hrf = plotreflinesr(gca,detects2_8,'x','g'); 
hrf = plotreflinesr(gca,Detects2_8,'x','b'); 
plot(timswin,xcmaxAVEnmin+zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn,'k');
plot(timswin,-1+0.1*abs(loopoff),'g.','MarkerSize',1);
plot(timsPGC,min(0,real(PGCrot)),'r');
plot(timsPGC,min(0,real(SSIBrot)),'b');
plot(timsPGC,min(0,real(SILBrot)),'k');
axis([0 timbig/2 -1 1]);
box on
subplot(4,1,3,'align'); 
hold on
plot(timswin,zeros(nwin,1),'k:');
plot(timswin,xmaxPGSSntmp,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIntmp,'ro','MarkerSize',2);
plot(timswin,xmaxSISSntmp,'k*','MarkerSize',2);
axis([timbig/2 timbig -mshift mshift]);
box on
subplot(4,1,4,'align'); 
hold on
hrf = plotreflinesr(gca,detects,'x','k'); 
hrf = plotreflinesr(gca,Detects,'x','r'); 
hrf = plotreflinesr(gca,detects2_8,'x','g'); 
hrf = plotreflinesr(gca,Detects2_8,'x','b'); 
plot(timswin,xcmaxAVEnmin+zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn,'k');
plot(timswin,-1+0.1*abs(loopoff),'g.','MarkerSize',1);
plot(timsPGC,min(0,real(PGCrot)),'r');
plot(timsPGC,min(0,real(SSIBrot)),'b');
plot(timsPGC,min(0,real(SILBrot)),'k');
axis([timbig/2 timbig -1 1]);
box on
title([IDENTIF,'_{',int2str(lo),'-',int2str(hi),'}'])
orient landscape
print('-depsc',['FIGS/',IDENTIF,'-',int2str(winlen/40),'s_',int2str(lo),'-',int2str(hi),'c.eps'])

figure
subplot(4,1,1,'align'); 
hold on
plot(timswin,zeros(nwin,1),'k:');
plot(timswin,xmaxPGSSntmp,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIntmp,'ro','MarkerSize',2);
plot(timswin,xmaxSISSntmp,'k*','MarkerSize',2);
plot(timsPGC(tracelenPGC/2+winlen:tracelenPGC/2+2*winlen),7+zeros(winlen+1,1),'k','linewidth',2);
axis([timbig 3*timbig/2 -mshift mshift]);
box on
subplot(4,1,2,'align'); 
hold on
hrf = plotreflinesr(gca,detects,'x','k'); 
hrf = plotreflinesr(gca,Detects,'x','r'); 
hrf = plotreflinesr(gca,detects2_8,'x','g'); 
hrf = plotreflinesr(gca,Detects2_8,'x','b'); 
plot(timswin,xcmaxAVEnmin+zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn,'k');
plot(timswin,-1+0.1*abs(loopoff),'g.','MarkerSize',1);
plot(timsPGC,min(0,real(PGCrot)),'r');
plot(timsPGC,min(0,real(SSIBrot)),'b');
plot(timsPGC,min(0,real(SILBrot)),'k');
axis([timbig 3*timbig/2 -1 1]);
box on
subplot(4,1,3,'align'); 
hold on
plot(timswin,zeros(nwin,1),'k:');
plot(timswin,xmaxPGSSntmp,'bs','MarkerSize',2);
plot(timswin,xmaxPGSIntmp,'ro','MarkerSize',2);
plot(timswin,xmaxSISSntmp,'k*','MarkerSize',2);
axis([3*timbig/2 2*timbig -mshift mshift]);
box on
subplot(4,1,4,'align'); 
hold on
hrf = plotreflinesr(gca,detects,'x','k'); 
hrf = plotreflinesr(gca,Detects,'x','r'); 
hrf = plotreflinesr(gca,detects2_8,'x','g'); 
hrf = plotreflinesr(gca,Detects2_8,'x','b'); 
plot(timswin,xcmaxAVEnmin+zeros(nwin,1),'k:');
plot(timswin,xcmaxAVEn,'k');
plot(timswin,-1+0.1*abs(loopoff),'g.','MarkerSize',1);
plot(timsPGC,min(0,real(PGCrot)),'r');
plot(timsPGC,min(0,real(SSIBrot)),'b');
plot(timsPGC,min(0,real(SILBrot)),'k');
axis([3*timbig/2 2*timbig -1 1]);
box on
title([IDENTIF,'_{',int2str(lo),'-',int2str(hi),'}'])
orient landscape
print('-depsc',['FIGS/',IDENTIF,'-',int2str(winlen/40),'s_',int2str(lo),'-',int2str(hi),'d.eps'])

figure
colormap(jet)
scatter(xmaxPGSIn-xmaxPGSSn+xmaxSISSn,xcmaxAVEn,3,AmpComp)
hold on 
plot(-5:5,xcmaxAVEnmin+zeros(11,1),'k:');
axis([-5 5 -0.2 1.0])
hrf = plotreflinesr(gca,-1.5,'x','k');colorbar
hrf = plotreflinesr(gca,1.5,'x','k');colorbar
box on
title([IDENTIF,'_{',int2str(lo),'-',int2str(hi),'}'])
print('-depsc',['FIGS/',IDENTIF,'-',int2str(winlen/40),'s_',int2str(lo),'-',int2str(hi),'e.eps'])

scrsz=get(0,'ScreenSize');
nt=0;
nrow=4;
mcol=6;
for ifig=1:floor(nin/(nrow*mcol))+1
    figure('Position',[scrsz(3)/10 scrsz(4)/10 4*scrsz(3)/5 9*scrsz(4)/10]);
    for n = 1:nrow
        for m = 1:mcol
            nt=nt+1;
            if nt < nin
    %             if PGSSfile(nt,1) <= 0 && PGSSfile(nt,1) >= -2 && abs(PGSIfile(nt,1))<=2
                    subplot(3*nrow,mcol,3*(n-1)*mcol+m,'align');
                    plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),PGCfile(winlen*(nt-1)+1:winlen*nt,2),'r')
                    hold on
                    plot(SSIBfile(winlen*(nt-1)+1:winlen*nt,1),SSIBfile(winlen*(nt-1)+1:winlen*nt,2),'b')
                    plot(SILBfile(winlen*(nt-1)+1:winlen*nt,1),SILBfile(winlen*(nt-1)+1:winlen*nt,2),'k')
                    is = PGCfile(winlen*(nt-1)+1,1);
                    ien= PGCfile(winlen*nt,1);
                    %yma=0.4;
                    yma=max(max([PGCfile(winlen*(nt-1)+1:winlen*nt,2) SSIBfile(winlen*(nt-1)+1:winlen*nt,2) ...
                        SILBfile(winlen*(nt-1)+1:winlen*nt,2)]));
                    ymi=min(min([PGCfile(winlen*(nt-1)+1:winlen*nt,2) SSIBfile(winlen*(nt-1)+1:winlen*nt,2) ...
                        SILBfile(winlen*(nt-1)+1:winlen*nt,2)]));
                    xvect=[is is+2*(yma-ymi)];
                    yma=2.4*max(yma,-ymi);
                    yvect=[-0.9*yma -0.9*yma];
                    plot(xvect,yvect,'r','linewidth',3)
                    plot([is is+1/lo],[-0.8*yma -0.8*yma],'k','linewidth',3)
                    text(is+0.2, 0.66*yma, int2str(PGSIfile(nt,1)),'fontsize',6);
                    text(ien-0.6, 0.66*yma, int2str(PGSSfile(nt,1)),'fontsize',6);
                    box on
                    axis([is ien -yma yma])
                    set(gca,'XTick',[is is+2],'fontsize',6);

                    subplot(3*nrow,mcol,3*(n-1)*mcol+mcol+m,'align');
                    PGSStr=PGCfile(winlen*(nt-1)+1:winlen*nt,2).*SSIBfile(winlen*(nt-1)+1:winlen*nt,2);            
                    hold on
                    PGSItr=PGCfile(winlen*(nt-1)+1:winlen*nt,2).*SILBfile(winlen*(nt-1)+1:winlen*nt,2);
                    SISStr=SSIBfile(winlen*(nt-1)+1:winlen*nt,2).*SILBfile(winlen*(nt-1)+1:winlen*nt,2);
                    cumsumPGSStr=cumsum(PGSStr);
                    cumsumPGSItr=cumsum(PGSItr);
                    cumsumSISStr=cumsum(SISStr);
                    yma=max(max([cumsumPGSStr cumsumPGSItr cumsumSISStr]));
                    ymi=min(min([cumsumPGSStr cumsumPGSItr cumsumSISStr]));
                    plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),cumsumPGSStr,'b')
                    plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),cumsumPGSItr,'r')
                    plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),cumsumSISStr,'k')
                    box on
                    text(is+0.1, ymi+0.82*(yma-ymi), num2str(PGSIfile(nt,2),3),'fontsize',6);
                    text(is+0.1, ymi+0.64*(yma-ymi), num2str(PGSSfile(nt,2),3),'fontsize',6);
                    text(is+0.1, ymi+0.46*(yma-ymi), num2str(SISSfile(nt,2),3),'fontsize',6);
                    text(ien-0.8, ymi+0.04*(yma-ymi), num2str(SISSfile(nt,1),3),'fontsize',6);
                    axis([is ien ymi yma])
                    %axis tight
                    set(gca,'XTick',[is is+2],'fontsize',6);

                    PGCautob=PGCfile(winlen*(nt-1)+1:winlen*nt,2).*PGCfile(winlen*(nt-1)+1:winlen*nt,2);
                    PGC2b=cumsum(PGCautob);
                    SSIBautob=SSIBfile(winlen*(nt-1)+1:winlen*nt,2).*SSIBfile(winlen*(nt-1)+1:winlen*nt,2);
                    SSIB2b=cumsum(SSIBautob);
                    SILBautob=SILBfile(winlen*(nt-1)+1:winlen*nt,2).*SILBfile(winlen*(nt-1)+1:winlen*nt,2);
                    SILB2b=cumsum(SILBautob);
                    PGSSnum=cumsumPGSStr(21:winlen)-cumsumPGSStr(1:winlen-20);
                    PGSInum=cumsumPGSItr(21:winlen)-cumsumPGSItr(1:winlen-20);
                    SISSnum=cumsumSISStr(21:winlen)-cumsumSISStr(1:winlen-20);
                    PGCden=PGC2b(21:winlen)-PGC2b(1:winlen-20);
                    SSIBden=SSIB2b(21:winlen)-SSIB2b(1:winlen-20);
                    SILBden=SILB2b(21:winlen)-SILB2b(1:winlen-20);
                    subplot(3*nrow,mcol,3*(n-1)*mcol+2*mcol+m,'align');
                    PGSSn=PGSSnum./realsqrt(PGCden.*SSIBden);
                    PGSIn=PGSInum./realsqrt(PGCden.*SILBden);
                    SISSn=SISSnum./realsqrt(SSIBden.*SILBden);
                    alln=(PGSSn+PGSIn+SISSn)/3;
                    idiff=SISSfile(nt,3);
                    maxxc=max(alln(idiff:idiff+20)); %endpoints of alln window should be endpoints of 1 sec cumsum interval
                    plot(PGCfile(winlen*(nt-1)+11:winlen*nt-10,1),alln,'c','linewidth',3)
                    hold on
                    plot(PGCfile(winlen*(nt-1)+11:winlen*nt-10,1),PGSSn,'b')
                    plot(PGCfile(winlen*(nt-1)+11:winlen*nt-10,1),PGSIn,'r')
                    plot(PGCfile(winlen*(nt-1)+11:winlen*nt-10,1),SISSn,'k')
                    plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),0.75*maxxc*ones(winlen,1),'k:');
                    plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),0.65*maxxc*ones(winlen,1),'k:');
                    axis([is ien -0.5 1])
                    set(gca,'XTick',[is is+2],'fontsize',6);
    %             end
            end
        end
    end
    orient landscape
    if ifig <= 9
        print('-depsc',['WIGS/',IDENTIF,'-',int2str(lo),'-',int2str(hi),'.',int2str(0),int2str(0),int2str(ifig),'.eps'])
    elseif ifig <= 99
        print('-depsc',['WIGS/',IDENTIF,'-',int2str(lo),'-',int2str(hi),'.',int2str(0),int2str(ifig),'.eps'])
    else
        print('-depsc',['WIGS/',IDENTIF,'-',int2str(lo),'-',int2str(hi),'.',int2str(ifig),'.eps'])
    end

end

medlok=median(abs(loopoffkeep))
medaPGSS=median(aPGSSkeep)
medaPGSI=median(aPGSIkeep)
medaSISS=median(aSISSkeep)


%cputime-t;
tot=cputime-tt
