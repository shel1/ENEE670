close all;

if (0)
    
    x = 0:pi/100:3*pi
    S1 = sin(x)
    S2 = cos(x)
    noise = rand(1,400)
    pl = abs(length(S1)-length(noise))
    pre = round(pl/2)
    post = pl-pre
    S1t=padarray(S1,[0 post],'post');
    S1t2=padarray(S1t,[0 pre],'pre');
    S1t3 = noise+S1t2;
    plot(S1t3)
    noise2 = rand(1,400)
    pl = abs(length(S1)-length(noise))
    pre = round(pl/2)
    post = pl-pre
    S2t=padarray(S2,[0 post],'post');
    S2t2=padarray(S2t,[0 pre],'pre');
    S2t3 = noise+S2t2;
    figure;plot(S2t3)
end
%%
% d1 = LoganData(1).jump.velD(2100:2309);
% l1 = LoganData(1).jump.velD(2815:3000);
load('exitSig.mat');
ju=32;
x1 = LoganData(ju).jump.velD;
figure;
plot(x1);


[C lags] = xcorr(exVelD,x1);
[z,I] = max(abs(C));
tDiff = lags(I);
[C2 lags2] = xcorr(landVelD,x1);
[z2,I2] = max(abs(C2));
tDiffL = lags(I2);
[ex1,ld1,ex2,ld2] = getExit(LoganData(ju),1);

figure;
    subplot(311); plot(d1); title('s1');
%     subplot(312); plot(d2); title('s2');
%     subplot(313); plot(lags,C);
%     title('Cross-correlation between s1 and s2')
%     figure;
%     plot(d2(abs(tDiff):end));
%     hold all;
%     plot(d1,'r');
%     figure;
%     plot(d2(1:abs(tDiffL)+200));
%     hold all;
%     plot(l1,'r');
    
    
%%
d2 = LoganData(4).jump.velD(100:end);
[C lags] = xcorr(d1,d2);
[z,I] = max(abs(C));
tDiff = lags(I); 
plot(d2(abs(tDiff):end),'b');

d2 = LoganData(5).jump.velD(100:end);
[C lags] = xcorr(d1,d2);
[z,I] = max(abs(C));
tDiff = lags(I); 
plot(d2,'g');