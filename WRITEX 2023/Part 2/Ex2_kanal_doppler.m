%% Copyright AICOMS WRITEXS 2023
addpath(genpath('function'));
f = 900e6;
N = 1024;
x = 1;
v = 500;
[csi_max, f_dopp_max, fd_ts_max] = doppler_fdTs(N,x, f,v);
[csi_max1, f_dopp_max1, fd_ts_max1] = doppler_fdTs(N,x, f,v);
[csi_max2, f_dopp_max2, fd_ts_max2] = doppler_fdTs(N,x, f,v);
plot(csi_max);
hold on
plot(csi_max1);
plot(csi_max2);
figure(1);
Figure1 = figure(1);
FigW = 6;
FigH = 5.6;
set(Figure1,'defaulttextinterpreter','tex',...
    'PaperUnits','inches','Papersize',[FigW,FigH],...
    'Paperposition',[0,0,FigW,FigH],'Units','Inches',...
    'Position',[0,0,FigW,FigH])
set(gca,...
    'FontSize',10,...
    'FontName','Arial');
hold on;