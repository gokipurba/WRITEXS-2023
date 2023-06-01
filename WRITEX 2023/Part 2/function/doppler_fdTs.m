%% Copyrigt AICOMS WRITEXS 2023
function [csi_max,f_dopp_max,fd_ts_max]= doppler_FRMCS(k, x, frek, v1)
data=k; %k=FFTSize=blocklength
bw=x;%MHz
v_max=v1;%km/h
% v_mid=v2;%km/h
% v_min=v3;%km/h
% v_low=v4;
f_tech=frek; %MHz
c=3*(10^8);
sb = 15e3;
ts= 1/sb; %second
lambda=c/f_tech;
f_dopp_max=(v_max*1000)/(60*60*lambda);
% f_dopp_mid=(v_mid*1000)/(60*60*lambda);
% f_dopp_min=(v_min*1000)/(60*60*lambda);
% f_dopp_low=(v_low*1000)/(60*60*lambda);

fd_ts_max=f_dopp_max*ts;
% fd_ts_mid=f_dopp_mid*ts;
% fd_ts_min=f_dopp_min*ts;
% fd_ts_low=f_dopp_low*ts;

csi_max=jakes_fading(fd_ts_max,k);
% csi_min=jakes_fading(fd_ts_min,k);
% csi_low=jakes_fading(fd_ts_low,k);

% plot(real(csi_max),'r-')
% hold on;
% plot(real(csi_min),'k-');
% plot(real(csi_low),'b-');