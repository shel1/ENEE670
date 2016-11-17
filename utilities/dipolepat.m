clear all;
close all;

theta = linspace(0,2*pi,100);
phi  = linspace(0,2*pi,100);

[theta,phi]  = meshgrid(theta,phi);

r = sin(theta).^1;
x = r.*sin(theta).*cos(phi);
y = r.*sin(theta).*sin(phi);
z = r.*cos(theta);

mesh(x,y,z);
axis equal;


freq = 978e6;
c = 299792458;

lam=c/freq;
k=2*pi/lam;
L=(lam/2)*1; %L=length of monopole.
t=0:0.01:2*pi;

    
    num=cos(k*L)-cos(k*L*cos(t));
        den=sin(t);
%         e=20*log10(abs(num./den));
        e=(abs(num./den));
        e = e-max(e);
        deg=t*180/pi;
        
        
    figure;
    subplot(1,2,1);
    polar(t,e);
    subplot(1,2,2);
    plot(deg,e);