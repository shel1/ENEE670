%KPP4.m

% xx = linspace(0,(pi/2),1000);
% theta in radians
xx = -pi/2:pi/500:pi/2;
% for the sinc plot
xxxx = -10*pi/2:pi/500:10*pi/2;
% qq = linspace(100,2000,100);
% range values
qq = 10:10:2000;
% matlab barfs if you don't declare them first
z = [];
Lm = [];
ebno = [];

for i = 1:501
    for j = 1:200
    [z(i,j),Lm(i,j),ebno(i,j)] = LinkBudget(xx(i),qq(j));
%     [z(i),Lm(i),ebno(i)] = LinkBudget(xx(i),500);

    end
%     plot(qq,Lm);
%     hold all;
end
    
figure;
semilogy(rad2deg(xx),Lm(:,1));
hold all;
semilogy(rad2deg(xx),Lm(:,10));
semilogy(rad2deg(xx),Lm(:,100));
semilogy(rad2deg(xx),Lm(:,200));
grid on;
xl=xlabel('$$\theta_{El}$$');
xl.Interpreter = 'latex';
yl=ylabel('$$\textrm{Link Margin (dB)}$$');
yl.Interpreter = 'latex';
t1=title('$$\textrm{Link Margin Overview}$$');
t1.Interpreter = 'latex';
ylim([27 85]);
legend('10m','100m','1km','2km');


figure;
% semilogy(rad2deg(xx),Lm(:,1));
hold all;
% semilogy(rad2deg(xx),Lm(:,10));
% semilogy(rad2deg(xx),Lm(:,100));
semilogy(rad2deg(xx),Lm(:,200));
hold all;
grid on;
xl=xlabel('$$\theta_{El}$$');
xl.Interpreter = 'latex';
yl=ylabel('$$\textrm{Link Margin (dB)}$$');
yl.Interpreter = 'latex';
xlim([-10 10]);
% ylim([27 80]);
ylim([27 34]);
t1=title('$$\textrm{Link Margin Detail}$$');
t1.Interpreter = 'latex';
legend('10m','100m','1km','2km');

mLm = Lm(:,100)-max(Lm(:,100));
figure;
% semilogy(rad2deg(xx),Lm(:,1));
hold all;
% semilogy(rad2deg(xx),Lm(:,10));
% semilogy(rad2deg(xx),Lm(:,100));
% plot(rad2deg(xx),Lm(:,200));
semilogy(rad2deg(xx),mLm);

grid on;
figure;
%sinc plot
yyy=20*log10(sin(xxxx)./xxxx);
plot(xxxx,yyy);
hold;
grid on;
