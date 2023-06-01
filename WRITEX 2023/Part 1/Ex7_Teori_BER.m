%% Copyright AICOMS WRITEXS 2023
addpath(genpath('function'));
clc;
clear all;
EbNo = -10:2:26; %dB
[BER]=BER_awgn_bpsk(EbNo);
[BER2]=BER_awgn_qpsk(EbNo);
[BER3]=BER_fading_bpsk(EbNo);
[BER4]=BER_fading_qpsk(EbNo);

semilogy(EbNo,BER,'-k','linewidth',1,'DisplayName','AWGN BPSK Theory');
hold on
semilogy(EbNo,BER2,'-r','linewidth',1,'DisplayName','AWGN qpsk Theory');
semilogy(EbNo,BER3,'--k','linewidth',1,'DisplayName','Fading BPSK Theory');
semilogy(EbNo,BER4,'--r','linewidth',1,'DisplayName','Fading BPSK Theory');
xlabel('Average EbNo (dB)');
ylabel('Average BER');
legend 
axis([-10 26 10e-5 1 ])
grid on;

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