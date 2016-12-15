%% KPP4.m
%%%%%%%%%%%%%%%%%%%%%%%%
% Matt and Francis 
% Date: 12/12/2016
% Documentation updates 
%%%%%%%%%%%%%%%%%%%%%%%%
close all;
%%
% theta in radians
h = pi/500;
xx = h:h:pi-h;
%%
% range values
qq = 10:10:2000;
%%
% matlab barfs if you don't declare them first
z = [];
Lm = [];
ebno = [];

for i = 1:499
    for j = 1:200
    [z(i,j),Lm(i,j),ebno(i,j)] = LinkBudget(xx(i),qq(j));
    end
end
figure;
lm50 = Lm(:,50);
% lm50 = lm50 - max(lm50);
lm100 = Lm(:,100);
lm200 = Lm(:,200);
% lm50 = lm50 - max(lm50);
% lm100 = lm100 - max(lm100);
% lm200 = lm200 - max(lm200);
semilogy(rad2deg(xx),lm50);
grid on;

hold all;
semilogy(rad2deg(xx),lm100);
semilogy(rad2deg(xx),lm200);
% 
% figure;
% plot(rad2deg(xx),lm100);
% grid on;
% legend('1km');
% figure;
% plot(rad2deg(xx),lm200);
% grid on;
% legend('2km');
xl=xlabel('$$\theta_{El}$$');
xl.Interpreter = 'latex';
yl=ylabel('$$\textrm{Link Margin (dB)}$$');
yl.Interpreter = 'latex';
t1=title('$$\textrm{Link Margin Overview}$$');
t1.Interpreter = 'latex';
legend('500m','1km','2km');
ylim([4 32]);
