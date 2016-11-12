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
d1 = LoganData(1).velD(2100:2309);
d2 = LoganData(5).velD;
[C lags] = xcorr(d1,d2);
[z,I] = max(abs(C));
tDiff = lags(I);
    subplot(311); plot(d1); title('s1');
    subplot(312); plot(d2); title('s2');
    subplot(313); plot(lags,C);
    title('Cross-correlation between s1 and s2')
    figure;
    plot(d2(abs(tDiff):end));
    hold;
    plot(d1,'r');
    hold;
%%
d2 = LoganData(4).velD(100:end);
[C lags] = xcorr(d1,d2);
[z,I] = max(abs(C));
tDiff = lags(I); 
plot(d2,'b');
hold;
d2 = LoganData(5).velD(100:end);
[C lags] = xcorr(d1,d2);
[z,I] = max(abs(C));
tDiff = lags(I); 
plot(d2,'g');