%% Copyright AICOMS WRITEXS 2023
clc; clear all;
M=log2(64);size = 1024*M;
c=randi([0,1],1,size); 
addpath(genpath('function'));
[x, code_bit, code_simbol] = func_mapper(c,'64qam');
plot(x,'ob','MarkerFaceColor','b'); axis([-1 1 -1 1]);
grid on;
xlabel('In-phase');
ylabel('Quadrature');
line([0 0], ylim,'lineWidth', 1, 'Color', 'k');
line(xlim, [0 0],'lineWidth', 1, 'Color', 'k');
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