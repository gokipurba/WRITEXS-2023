%% Copyright AICOMS WRITEXS 2023
h1 = [1 0.7 0.5 0.3 0.1];
h2 = [1 0.1];
%signal = [-14 -0.2 -0.1 0 -0.1 -0.2 -14]

f1 = fft([h1 zeros(1,199-length(h1))]);
F1 = f1/max(abs(f1));

f2 = fft([h2 zeros(1,199-length(h2))]);
F2 = f2/max(abs(f2));

plot(20*log10([abs(F1(101:end)) abs(F1(1:100))]));
hold on;
plot(20*log10([abs(F2(101:end)) abs(F2(1:100))]));
%plot([50, 50, 60 , 100, 140, 150, 150],signal)
xlabel('Frequency Hz')
ylabel('PSD')
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