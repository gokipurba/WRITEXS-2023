%% Copyright AICOMS WRITEXS 2023
clc; clear all;
c=[0:1]; M=log2(2);
for i=1:length(c)
x(i) = (1/sqrt(2))*((1-2*c(i))+sqrt(-1)*(1-2*c(i))); %mapping
end
plot(x,'ob','MarkerFaceColor','b'); axis([-1 1 -1 1]);
for i = 1:length(c)
text ((real(x(i))-0.03),(imag(x(i))+0.2),...
mat2str(c(i)),'FontSize', 11); %memposisikan bit string
end
grid on;
xlabel('In-phase');
ylabel('Quadrature');
line([0 0], ylim,'lineWidth', 1, 'Color', 'r');
line(xlim, [0 0],'lineWidth', 1, 'Color', 'r');
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
