function fade=jakes_fading(fDTs,S)
% created by Dr. Khoirul Anwar
% 2 June 2010
% Information Theory and Signal Processing 
% JAIST
% Success on 3 June 2010
S=S-1;
No=8; % following Jakes
%lambda=3e8/frek;
%fD=v*1000/(60*60*lambda); % in km/h
fDTs = fDTs/S;
wm=2*pi*fDTs;
alpha=pi/4;
Xc=zeros(1,S+1);
Xs=zeros(1,S+1);
t=0:1:S;
N=2*(2*No+1);
for n=1:No
w=wm*cos(2*pi*n/N);
beta=pi*n/No;
%xc=2*cos(beta).*cos(w*t);
%xs=2*sin(beta).*cos(w*t);
xc=2*cos(beta).*cos(w*t+(1-2*rand)*pi);
xs=2*sin(beta).*cos(w*t+(1-2*rand)*pi);
Xc=Xc+xc;
Xs=Xs+xs;
end
Xc=Xc+sqrt(2).*cos(alpha).*cos(wm*t+(1-2*rand)*pi);
Xs=Xs+sqrt(2).*sin(alpha).*cos(wm*t+(1-2*rand)*pi);
fade=(Xc+sqrt(-1)*Xs)*2/sqrt(2*N);
