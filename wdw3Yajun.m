%Sits at one spot (rotations; delays) for one day and looks for the cross-correlation.
%Now also plots aligned 4-s windows.  As of July 2012.
format short e
clear all
set(0,'DefaultFigureVisible','on');
   
% days=[2005 255;
%       2005 256;
%       2005 260];
days=[2004 196;
      2004 197;
      2004 198;
      2004 199;
      2004 200];
  
STAs=['PGC '
      'SSIB'
      'SILB'];
%     'LZB '
%     'KLNB'
%     'TWKB'
%     'MGCB'];
% 002
STArots=[0 90 32 00;  %PGC , Yajun's "0" changed to 90.
         6 85 33 86;  %SSIB from Yajun
         0 90 39 20];  %SILB
%        0 90 54 00;  %LZB
%        0 90  7 -5;  %KLNB
%        4 70 48 -4;  %MGCB
%        4 75 38 -27]; %TWKB
STArots(:,2:3)=pi*STArots(:,2:3)/180.;
nsta=size(STAs,1);

mshift=24; %29; %16 %11 %14 %12_for_+085+020 %15_for_+059-073  %19 for 128-s?
hi=6.;
lo=1.5;
% hi=1.5;
% lo=0.5;
% hi=12.;
% lo=4.5;
npo=2;
npa=1;
loopoffmax=1.5; %1.5 for standard 1.5-6Hz; 4 for 0.5-1.5Hz
xcmaxAVEnmin=0.4; %0.42; %0.45; %0.36 for 4s 1-12 Hz; %0.4 for 4s 1.5-6 Hz and 6s 0.5-1.5Hz; 0.36 for 4s2-8 Hz ; 0.38 for 4s0.75-6 Hz; 0.094 for 128s 2-8Hz;  0.1 for 128s 1.5-6Hz; 0.44 for 3-s window?
winlen=4*40; %4 for 1.5-6Hz; 8 for 0.5-1.5Hz
winoff=1*40; %1 for 4s; 2 for 8 s; 3 for 12 s; 8 for 128s

for nd=1:size(days,1)
close all
t=cputime; tt=cputime;

year=days(nd,1);
YEAR=int2str(year);
jday=days(nd,2);
if jday <= 9
    JDAY=['00',int2str(jday)];
elseif jday<= 99
    JDAY=['0',int2str(jday)];
else
    JDAY=int2str(jday);
end
MO=day2month(jday,year)
SSIBsoff=STArots(2,4); %These 2 lines hokey
SILBsoff=STArots(3,4); %These 2 lines hokey
IDENTIF=[YEAR,'.',JDAY,'.',int2str(STArots(2,4)),'.',int2str(STArots(3,4)), ...
    '.loff',num2str(loopoffmax),'.ccmin',num2str(xcmaxAVEnmin),'.nponpa',int2str(npo),int2str(npa)]

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
         m1=m1+1;
         Detects2_8(m1)=detects2_8(n);
     end
end

%This needed here to find glitches prior to filtering
timwin=86400/2; %(86400*40)
winbig=2*(86400*40/2-120);
timbig=winbig/(2*40);
igstart=floor(86400*40/2-winbig/2)+1;
nwin=floor((winbig-winlen)/winoff);

%Get data:
direc=[YEAR,'/',MO,'/'];
prename=[direc,YEAR,'.',JDAY,'.00.00.00.0000.CN'];
for ista=1:nsta
    if strcmp(STAs(ista,end),' ')
        sps=40;
        STAEdat=[prename,'.',STAs(ista,1:3),'..BHE.D.SAC']; %BHE for permstas.
        STANdat=[prename,'.',STAs(ista,1:3),'..BHN.D.SAC'];
        spsfactor=1; %for glitches
    else
        sps=100;
        STAEdat=[prename,'.',STAs(ista,:),'..HHE.D.SAC']; %BHE for permstas.
        STANdat=[prename,'.',STAs(ista,:),'..HHN.D.SAC'];
        spsfactor=2.5; %for glitches
    end
    %%%%%%%%%%%%%%%%
    %Read data:
    [STAE,HdrDataSTA,tnuSTA,pobjSTA,timsSTA]=readsac(STAEdat,0,'l');
    [STAN,~,~,~,~]=readsac(STANdat,0,'l');
    tracelen=length(STAE)
    if ista==1
        tracelenPGC=tracelen;
        timsPGC=timsSTA;
    end
    %%%%%%%%%%%%%%%%
    %Find glitches prior to filtering...
    nzerosE=glitches2(STAE,nwin,winlen,winoff,igstart,spsfactor); 
    nzerosN=glitches2(STAN,nwin,winlen,winoff,igstart,spsfactor);
    nzeros(ista,:)=max(nzerosE,nzerosN);
    %%%%%%%%%%%%%%%%
    %cosine taper before filtering:
    x=(0:pi/(2*sps):pi/2-pi/(2*sps))';   
    if strcmp(STAs(ista,end),' ') %This seems to be necessary at the start of each day for PGCE:
        STAE(1:80)=0.;
        STAE(81:120)=sin(x).*STAE(81:120); %Only at start of day!
    else
        STAE(1:sps)=sin(x).*STAE(1:sps);
    end
    STAN(1:sps)=sin(x).*STAN(1:sps);
    x=flipud(x);
    STAE(tracelen-(sps-1):tracelen)=sin(x).*STAE(tracelen-(sps-1):tracelen);
    STAN(tracelen-(sps-1):tracelen)=sin(x).*STAN(tracelen-(sps-1):tracelen);
    %%%%%%%%%%%%%%%%
    %Filter data:
    if strcmp(STAs(ista,end),' ') 
        [STAEf]=1.6e-4*bandpass(STAE,sps,lo,hi,npo,npa,'butter');
        [STANf]=1.6e-4*bandpass(STAN,sps,lo,hi,npo,npa,'butter');
    else
        if year==2003 && jday<213
            [STAEf]=20.0e-3*bandpass(STAE,sps,lo,hi,npo,npa,'butter'); %times 5 until Aug 2003 5.0*
            [STANf]=20.0e-3*bandpass(STAN,sps,lo,hi,npo,npa,'butter'); %times 5 until Aug 2003 5.0*
        else
            [STAEf]=4.0e-3*bandpass(STAE,sps,lo,hi,npo,npa,'butter'); 
            [STANf]=4.0e-3*bandpass(STAN,sps,lo,hi,npo,npa,'butter'); 
        end
        STAEf=resample(STAEf,2,5);
        STANf=resample(STANf,2,5);
        tracelen=length(STAEf)
    end
    %%%%%%%%%%%%%%%%
    %Split-correct:
    STA=STAEf+1i*STANf;
    STAfastslow=STA*exp(-1i*STArots(ista,2));
    STAslow=real(STAfastslow);
    STAfast=imag(STAfastslow);
    len=length(STA);
    STAslow(10:tracelen-10)=STAslow(10+STArots(ista,1):tracelen-10+STArots(ista,1));
    STAsplitcorrected=(STAslow+1i*STAfast)*exp(1i*STArots(ista,2));
    STAsplitcorrectedrot=STAsplitcorrected*exp(-1i*STArots(ista,3));
    STAscrot=STAsplitcorrectedrot;
    %%%%%%%%%%%%%%%%
    %Center on desired region:
    STAsoff=STArots(ista,4);
    if STAsoff > -1
        STAscrot(1:tracelen-STAsoff)=STAscrot(STAsoff+1:tracelen);
        STAscrot(tracelen-STAsoff+1:tracelen)=0;
    else
        STAscrot(-STAsoff+1:tracelen)=STAscrot(1:tracelen+STAsoff);
        STAscrot(1:-STAsoff)=0;
    end
    STAopt(ista,:)=real(STAscrot);
    STAort(ista,:)=imag(STAscrot);
end
%%%%%%%%%%%%
%WATCH SEQUENCE OD STATIONS; this could be done more carefully:
realPGC=STAopt(1,:);
realSSIB=STAopt(2,:);
realSILB=STAopt(3,:);
% realPGC=imag(PGCrot); %A quick/dirty way to try the same on the orthogonal components
% realSSIB=imag(SSIBrot);
% realSILB=imag(SILBrot);
nzerosPGC=nzeros(1,:);
nzerosSSIB=nzeros(2,:);
nzerosSILB=nzeros(3,:);

plotstart=1; 
plotend=tracelenPGC; 
ltmax=max([realPGC(plotstart:plotend)'; ...
          realSSIB(plotstart:plotend)'; ...
          realSILB(plotstart:plotend)']);
ltmax=min(ltmax,0.75);
ltmin=min([realPGC(plotstart:plotend)'; ...
          realSSIB(plotstart:plotend)'; ...
          realSILB(plotstart:plotend)']);
ltmin=max(ltmin,-0.75);

figure %Superposed traces, 150s window:
subplot(4,1,1); 
hold on
plot(timsPGC,realPGC,'r');
plot(timsPGC,realSSIB,'b');
plot(timsPGC,realSILB,'k');
axis([0 timwin/2 ltmin ltmax]);
subplot(4,1,2); 
hold on
plot(timsPGC,realPGC,'r');
plot(timsPGC,realSSIB,'b');
plot(timsPGC,realSILB,'k');
axis([timwin/2 timwin ltmin ltmax]);
subplot(4,1,3); 
hold on
plot(timsPGC,realPGC,'r');
plot(timsPGC,realSSIB,'b');
plot(timsPGC,realSILB,'k');
axis([timwin 3*timwin/2 ltmin ltmax]);
subplot(4,1,4); 
hold on
plot(timsPGC,realPGC,'r');
plot(timsPGC,realSSIB,'b');
plot(timsPGC,realSILB,'k');
axis([3*timwin/2 2*timwin ltmin ltmax]);
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
% winbig=2*(tracelenPGC/2-120);
% timbig=winbig/(2*40);
% igstart=floor(tracelenPGC/2-winbig/2)+1;
% nwin=floor((winbig-winlen)/winoff);
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
%An attempt to bypass glitches in data.  Min value of good data typically ~10^{-2}
glitches=1.e-7;
sumsPGC2=max(sumsPGC2,glitches);
sumsSSIB2=max(sumsSSIB2,glitches);
sumsSILB2=max(sumsSILB2,glitches);
%
denomPGSSn=realsqrt(sumsPGC2.*sumsSSIB2);
denomPGSIn=realsqrt(sumsPGC2.*sumsSILB2);
denomSISSn=realsqrt(sumsSILB2b.*sumsSSIB2);
%
% denomPGSSn=max(denomPGSSn,eps);
% denomPGSIn=max(denomPGSIn,eps);
% denomSISSn=max(denomSISSn,eps);
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
xcnshifts=cputime-t
t=cputime;

ampmax=max([ampPGSS; ampPGSI; ampSISS]);

medxcmaxAVEn=median(xcmaxAVEn)
xmaxPGSSntmp=xmaxPGSSn;
xmaxPGSIntmp=xmaxPGSIn;
xmaxSISSntmp=xmaxSISSn;
%loopoff=xmaxPGSIn-xmaxPGSSn+xmaxSISSn; 
iup=4;
nin=0;
zerosallowed=20*winlen/160;
for n=1:nwin
    if xcmaxAVEn(n)<xcmaxAVEnmin || abs(xmaxPGSIn(n)-xmaxPGSSn(n)+xmaxSISSn(n))>loopoffmax ...
            || isequal(abs(imaxPGSS(n)),mshift) || isequal(abs(imaxPGSI(n)),mshift) || isequal(abs(imaxSISS(n)),mshift) ...
            || nzerosPGC(n)>zerosallowed || nzerosSSIB(n)>zerosallowed || nzerosSILB(n)>zerosallowed
        xmaxPGSSntmp(n)=20; xmaxPGSIntmp(n)=20; xmaxSISSntmp(n)=20; 
    else
        interpPGSSn=interp(sumsPGSSn(n,:),iup,3);
        interpPGSIn=interp(sumsPGSIn(n,:),iup,3);
        interpSISSn=interp(sumsSISSn(n,:),iup,3);
        leninterp=length(interpPGSSn);
        [xcmaxinterpPGSSn,imaxinterpPGSS]=max(interpPGSSn(1:leninterp-(iup-1)));
        [xcmaxinterpPGSIn,imaxinterpPGSI]=max(interpPGSIn(1:leninterp-(iup-1)));
        [xcmaxinterpSISSn,imaxinterpSISS]=max(interpSISSn(1:leninterp-(iup-1)));
        if abs((imaxinterpPGSS-mshift*iup-1)/iup-imaxPGSS(n))>0.5 || ...
           abs((imaxinterpPGSI-mshift*iup-1)/iup-imaxPGSI(n))>0.5 || ...
           abs((imaxinterpSISS-mshift*iup-1)/iup-imaxSISS(n))>0.5
                [n (imaxinterpPGSS-mshift*iup-1)/iup imaxPGSS(n) ...
                   (imaxinterpPGSI-mshift*iup-1)/iup imaxPGSI(n) ... 
                   (imaxinterpSISS-mshift*iup-1)/iup imaxSISS(n)]
        end
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
            imaxPGSSwr=round(xmaxPGSSntmp(n));
            imaxPGSIwr=round(xmaxPGSIntmp(n));

            istart=igstart+(n-1)*winoff+mshift; %a better way might exist?  %ADDED mshift 10/20/12
            iend=istart+winlen-1;
            imid=round((istart+iend)/2);
            %Check power spectrum
            [PGCxx fp] = pwelch(realPGC(istart:iend),[],[],[],40); %40 is sps
            PGCxx=PGCxx/max(PGCxx);
            [SSIBxx fp] = pwelch(realSSIB(istart-imaxPGSSwr:iend-imaxPGSSwr),[],[],[],40);
            SSIBxx=SSIBxx/max(SSIBxx);
            [SILBxx fp] = pwelch(realSILB(istart-imaxPGSIwr:iend-imaxPGSIwr),[],[],[],40);
            SILBxx=SILBxx/max(SILBxx);
            flo=find(fp > lo,1)-1;
            fhi=find(fp > hi,1)+1; %extra 1 for good measure
            belowcut=median([PGCxx(2:flo); SSIBxx(2:flo); SILBxx(2:flo)]);
            ppeaksPGC=findpeaks(PGCxx(flo+1:fhi));
            if length(ppeaksPGC)>=1
                maxppeakPGC=max(ppeaksPGC);
            else
                maxppeakPGC=0.;
            end
            ppeaksSSIB=findpeaks(SSIBxx(flo+1:fhi));
            if length(ppeaksSSIB)>=1
                maxppeakSSIB=max(ppeaksSSIB);
            else
                maxppeakSSIB=0.;
            end
            ppeaksSILB=findpeaks(SILBxx(flo+1:fhi));
            if length(ppeaksSILB)>=1
                maxppeakSILB=max(ppeaksSILB);
            else
                maxppeakSILB=0.;
            end
            abovecut=median([maxppeakPGC maxppeakSSIB maxppeakSILB]);
            if abovecut > 0.9*belowcut %-1
                PGSStr=realPGC(istart:iend).*realSSIB(istart-imaxPGSSwr:iend-imaxPGSSwr);
                PGSItr=realPGC(istart:iend).*realSILB(istart-imaxPGSIwr:iend-imaxPGSIwr);
                SISStr=realSILB(istart-imaxPGSIwr:iend-imaxPGSIwr).*realSSIB(istart-imaxPGSSwr:iend-imaxPGSSwr);
                cumsumtr=cumsum(PGSStr)+cumsum(PGSItr)+cumsum(SISStr);
                [cumsumtrdiff idiff]=max(cumsumtr(41:winlen)-cumsumtr(1:winlen-40));

                PGCfile(nin*winlen+1:(nin+1)*winlen,1:2)=[timsPGC(istart:iend)' realPGC(istart:iend)'];
                SSIBfile(nin*winlen+1:(nin+1)*winlen,1:2)=[timsPGC(istart:iend)' realSSIB(istart-imaxPGSSwr:iend-imaxPGSSwr)'];
                SILBfile(nin*winlen+1:(nin+1)*winlen,1:2)=[timsPGC(istart:iend)' realSILB(istart-imaxPGSIwr:iend-imaxPGSIwr)'];
                PGSSfile(nin+1,1:2)=[imaxPGSSwr xcmaxPGSSn(n)];
                PGSIfile(nin+1,1:2)=[imaxPGSIwr xcmaxPGSIn(n)];
                SISSfile(nin+1,1:3)=[cumsumtrdiff/cumsumtr(winlen) xcmaxSISSn(n) idiff];

                nin=nin+1;
                aPGSSkeep(nin,:)=[timswin(n) aPGSS(n)];
                aPGSIkeep(nin,:)=[timswin(n) aPGSI(n)];
                aSISSkeep(nin,:)=[timswin(n) aSISS(n)];
                loopoffkeep(nin,:)=[timswin(n) loopoff(n)];
                mapfile(nin,:)=[timswin(n) xmaxPGSIntmp(n) xmaxPGSSntmp(n) ...
                    xcmaxAVEn(n) loopoff(n) AmpComp(n) cumsumtrdiff timswin(n)-(winlen/40)/2+idiff/40. cumsumtrdiff/cumsumtr(winlen)];
            else
                xmaxPGSSntmp(n)=20; xmaxPGSIntmp(n)=20; xmaxSISSntmp(n)=20;
           end
        else
            xmaxPGSSntmp(n)=50; xmaxPGSIntmp(n)=50; xmaxSISSntmp(n)=50; 
        end
    end
end
fid = fopen(['YMAP/map',IDENTIF,'_',num2str(lo),'-',num2str(hi),'-','ms',int2str(mshift),'-',int2str(winlen/40),'s'],'w');
fprintf(fid,'%9.1f %9.5f %9.5f %9.4f %9.2f %9.3f %10.4f %10.4f %8.3f\n',mapfile(1:nin,:)');
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
title([IDENTIF,'_{',num2str(lo),'-',num2str(hi),'}'])
orient landscape
print('-depsc',['YMAP/FIGS/',IDENTIF,'-',int2str(winlen/40),'s_',num2str(lo),'-',num2str(hi),'b.eps'])
fid = fopen(['HILBERTS/xcmax',IDENTIF,'_',num2str(lo),'-',num2str(hi),'-','ms',int2str(mshift),'-',int2str(winlen/40),'s'],'w');
fprintf(fid,'%9.3f %9.5f\n',[timswin xcmaxAVEn]');
fclose(fid);

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
plot(timsPGC,min(0,realPGC),'r');
plot(timsPGC,min(0,realSSIB),'b');
plot(timsPGC,min(0,realSILB),'k');
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
plot(timsPGC,min(0,realPGC),'r');
plot(timsPGC,min(0,realSSIB),'b');
plot(timsPGC,min(0,realSILB),'k');
axis([timbig/2 timbig -1 1]);
box on
title([IDENTIF,'_{',num2str(lo),'-',num2str(hi),'}'])
orient landscape
print('-depsc',['YMAP/FIGS/',IDENTIF,'-',int2str(winlen/40),'s_',num2str(lo),'-',num2str(hi),'c.eps'])

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
plot(timsPGC,min(0,realPGC),'r');
plot(timsPGC,min(0,realSSIB),'b');
plot(timsPGC,min(0,realSILB),'k');
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
plot(timsPGC,min(0,realPGC),'r');
plot(timsPGC,min(0,realSSIB),'b');
plot(timsPGC,min(0,realSILB),'k');
axis([3*timbig/2 2*timbig -1 1]);
box on
title([IDENTIF,'_{',num2str(lo),'-',num2str(hi),'}'])
orient landscape
print('-depsc',['YMAP/FIGS/',IDENTIF,'-',int2str(winlen/40),'s_',num2str(lo),'-',num2str(hi),'d.eps'])

figure
colormap(jet)
scatter(xmaxPGSIn-xmaxPGSSn+xmaxSISSn,xcmaxAVEn,3,AmpComp)
hold on 
plot(-50:50,xcmaxAVEnmin+zeros(101,1),'k:');
axis([min(-5,-2.5*loopoffmax) max(5,2.5*loopoffmax) -0.2 1.0])
hrf = plotreflinesr(gca,-loopoffmax,'x','k');colorbar
hrf = plotreflinesr(gca,loopoffmax,'x','k');colorbar
box on
title([IDENTIF,'_{',num2str(lo),'-',num2str(hi),'}'])
print('-depsc',['YMAP/FIGS/',IDENTIF,'-',int2str(winlen/40),'s_',num2str(lo),'-',num2str(hi),'e.eps'])

if winlen<=500
scrsz=get(0,'ScreenSize');
nt=0;
nrow=4;
mcol=6;
for ifig=1:floor(nin/(nrow*mcol))+1
    figure('Position',[scrsz(3)/10 scrsz(4)/10 4*scrsz(3)/5 9*scrsz(4)/10]);
    for n = 1:nrow
        for m = 1:mcol
            nt=nt+1;
            if nt <= nin
                 %if PGSSfile(nt,1) >= 10 && PGSSfile(nt,1) <= 16 && PGSIfile(nt,1) >= 2 && PGSIfile(nt,1) <= 8
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
                    xvect=[is is+2*(yma-ymi)*(winlen/160.)]; %amplitude bar originally scaled for 4-s window
                    yma=2.4*max(yma,-ymi);
                    yvect=[-0.9*yma -0.9*yma];
                    plot(xvect,yvect,'r','linewidth',3)
                    plot([is+1/hi is+1/lo],[-0.8*yma -0.8*yma],'k','linewidth',3)
                    text(is+0.2, 0.66*yma, int2str(PGSIfile(nt,1)),'fontsize',6);
                    text(ien-0.6, 0.66*yma, int2str(PGSSfile(nt,1)),'fontsize',6);
                    box on
                    axis([is ien -yma yma])
                    set(gca,'XTick',[is (is+ien)/2],'fontsize',6);
                    if n==1 && m==2
                        title([IDENTIF,'_{',num2str(lo),'-',num2str(hi),'}'])
                    end

                    subplot(3*nrow,mcol,3*(n-1)*mcol+mcol+m,'align');
% The following for spectra
%                     [PGCxx f] = pwelch(PGCfile(winlen*(nt-1)+1:winlen*nt,2)-mean(PGCfile(winlen*(nt-1)+1:winlen*nt,2)),[],[],[],40);
%                     [SSIBxx f] = pwelch(SSIBfile(winlen*(nt-1)+1:winlen*nt,2)-mean(SSIBfile(winlen*(nt-1)+1:winlen*nt,2)),[],[],[],40);
%                     [SILBxx f] = pwelch(SILBfile(winlen*(nt-1)+1:winlen*nt,2)-mean(SILBfile(winlen*(nt-1)+1:winlen*nt,2)),[],[],[],40);
% %                     [PGCxx f] = pwelch(PGCfile(winlen*(nt-1)+1:winlen*nt,2),[],[],[],40);
% %                     [SSIBxx f] = pwelch(SSIBfile(winlen*(nt-1)+1:winlen*nt,2),[],[],[],40);
% %                     [SILBxx f] = pwelch(SILBfile(winlen*(nt-1)+1:winlen*nt,2),[],[],[],40);
% %                     [Cpgss,f] = mscohere(PGCfile(winlen*(nt-1)+1:winlen*nt,2),SSIBfile(winlen*(nt-1)+1:winlen*nt,2), ...
% %                         [],[],[],40);
% %                     [Cpgsi,f] = mscohere(PGCfile(winlen*(nt-1)+1:winlen*nt,2),SILBfile(winlen*(nt-1)+1:winlen*nt,2), ...
% %                         [],[],[],40);
% %                     [Csiss,f] = mscohere(SILBfile(winlen*(nt-1)+1:winlen*nt,2),SSIBfile(winlen*(nt-1)+1:winlen*nt,2), ...
% %                         [],[],[],40);
% %                     plot(f,Cpgss,'b')
% %                     hold on
% %                     plot(f,Cpgsi,'r')
% %                     plot(f,Csiss,'k')
%                     plot(f,PGCxx/max(PGCxx),'r+')
%                     hold on
%                     plot(f,SSIBxx/max(SSIBxx),'b+')
%                     plot(f,SILBxx/max(SILBxx),'k+')
%                     xlim([0 hi+2])
%                     %xlim([0.1 hi+1])
%                     %ylim([0.01 1])
%                     set(gca,'XTick',(1:10),'fontsize',6);
% The above for spectra
                    PGSStr=PGCfile(winlen*(nt-1)+1:winlen*nt,2).*SSIBfile(winlen*(nt-1)+1:winlen*nt,2);            
                    PGSItr=PGCfile(winlen*(nt-1)+1:winlen*nt,2).*SILBfile(winlen*(nt-1)+1:winlen*nt,2);
                    SISStr=SSIBfile(winlen*(nt-1)+1:winlen*nt,2).*SILBfile(winlen*(nt-1)+1:winlen*nt,2);
                    % find the peaks etc.
                    avedots=(PGSStr+PGSItr+SISStr)/3.;
                    [peaks, locs]=findpeaks(avedots,'minpeakdistance',3);
                    npeaks=length(peaks);
                    [maxpk, imaxpk]=max(peaks);
                    pks=zeros(npeaks,2);
                    pks(:,2)=peaks;
                    pks(:,1)=PGCfile(winlen*(nt-1)+locs);
                    pksort=sortrows(pks,2);
                    rat14=maxpk/pksort(npeaks-4,2); %ratio of max to 4th largest anywhere in window
                    if imaxpk==1 
                        maxpkp=peaks(2);
                        maxpkm=-9e9;
                        pkwid=2*(pks(2,1)-pks(1,1));
                        pksid12=maxpk/maxpkp;
                        pksid13=maxpk/peaks(3);
                    elseif imaxpk==npeaks
                        maxpkp=-9e9;
                        maxpkm=peaks(npeaks-1);
                        pkwid=2*(pks(npeaks,1)-pks(npeaks-1,1));
                        pksid12=maxpk/maxpkm;
                        pksid13=maxpk/peaks(npeaks-2);
                    else
                        maxpkp=peaks(imaxpk+1);
                        maxpkm=peaks(imaxpk-1);
                        pkwid=pks(imaxpk+1,1)-pks(imaxpk-1,1);
                        pksid12=maxpk/max(maxpkp,maxpkm);
                        pksid13=maxpk/min(maxpkp,maxpkm);
                    end
                    cumsumPGSStr=cumsum(PGSStr);
                    cumsumPGSItr=cumsum(PGSItr);
                    cumsumSISStr=cumsum(SISStr);
                     yma=1.1; %yma=max(avedots);
                     ymi=-0.1; %ymi=min(avedots);
                    %hold on
%                     plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),PGSStr,'b')
%                     plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),PGSItr,'r')
%                     plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),SISStr,'k')
%                     plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),avedots,'c') %,'linewidth',2)
%                     plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),zeros(winlen,1),'k')
%                     plot(pks(:,1),pks(:,2),'r+')
% The following for running-sum dot product
                    plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),cumsumPGSStr,'b')
                    hold on
                    plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),cumsumPGSItr,'r')
                    plot(PGCfile(winlen*(nt-1)+1:winlen*nt,1),cumsumSISStr,'k')
                    yma=max(max([cumsumPGSStr cumsumPGSItr cumsumSISStr]));
                    ymi=min(min([cumsumPGSStr cumsumPGSItr cumsumSISStr]));
                    axis([is ien ymi yma])
                    set(gca,'XTick',(0:20),'fontsize',6);
% The above for running-sum dot product
                    box on
                    text(is+0.1, ymi+0.82*(yma-ymi), num2str(PGSIfile(nt,2),3),'fontsize',6);
                    text(is+0.1, ymi+0.64*(yma-ymi), num2str(PGSSfile(nt,2),3),'fontsize',6);
                    text(is+0.1, ymi+0.46*(yma-ymi), num2str(SISSfile(nt,2),3),'fontsize',6);
                    text(ien-0.8, ymi+0.1*(yma-ymi), num2str(SISSfile(nt,1),3),'fontsize',6);
                    %axis([lo-1 hi+1 ymi yma])
                    %axis tight
                    %set(gca,'XTick',[is is+2],'fontsize',6);
                    pkfile(nt,:)=[PGCfile(winlen*(nt-1)+1+(winlen/2)) pks(imaxpk,1) maxpk pksid12 pksid13 pkwid rat14];

                    PGCauto=PGCfile(winlen*(nt-1)+1:winlen*nt,2).*PGCfile(winlen*(nt-1)+1:winlen*nt,2);
                    PGC2=cumsum(PGCauto);
                    SSIBauto=SSIBfile(winlen*(nt-1)+1:winlen*nt,2).*SSIBfile(winlen*(nt-1)+1:winlen*nt,2);
                    SSIB2=cumsum(SSIBauto);
                    SILBauto=SILBfile(winlen*(nt-1)+1:winlen*nt,2).*SILBfile(winlen*(nt-1)+1:winlen*nt,2);
                    SILB2=cumsum(SILBauto);
                    PGSSnum=cumsumPGSStr(21:winlen)-cumsumPGSStr(1:winlen-20);
                    PGSInum=cumsumPGSItr(21:winlen)-cumsumPGSItr(1:winlen-20);
                    SISSnum=cumsumSISStr(21:winlen)-cumsumSISStr(1:winlen-20);
                    PGCden=PGC2(21:winlen)-PGC2(1:winlen-20);
                    SSIBden=SSIB2(21:winlen)-SSIB2(1:winlen-20);
                    SILBden=SILB2(21:winlen)-SILB2(1:winlen-20);
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
                    set(gca,'XTick',(0:2),'fontsize',6);
                 %end
            end
        end
    end
    orient landscape
    if ifig <= 9
        print('-depsc',['YMAP/WIGS/',IDENTIF,'-',num2str(lo),'-',num2str(hi),'.',int2str(0),int2str(0),int2str(ifig),'.eps'])
    elseif ifig <= 99
        print('-depsc',['YMAP/WIGS/',IDENTIF,'-',num2str(lo),'-',num2str(hi),'.',int2str(0),int2str(ifig),'.eps'])
    else
        print('-depsc',['YMAP/WIGS/',IDENTIF,'-',num2str(lo),'-',num2str(hi),'.',int2str(ifig),'.eps'])
    end

end
fid = fopen(['YMAP/pks',IDENTIF,'_',num2str(lo),'-',num2str(hi),'-','ms',int2str(mshift),'-',int2str(winlen/40),'s'],'w');
fprintf(fid,'%9.1f %9.3f %10.6f %9.3f %9.3f %9.3f %9.3f \n',pkfile(1:nin,:)');
fclose(fid);
end

medlok=median(abs(loopoffkeep))
medaPGSS=median(aPGSSkeep)
medaPGSI=median(aPGSIkeep)
medaSISS=median(aSISSkeep)

tot=cputime-tt
end
