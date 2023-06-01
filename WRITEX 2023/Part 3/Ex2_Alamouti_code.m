%% Copyright AICOMS WRITEXS 2023
clc;clear all;addpath(genpath('function'));
%% MODULASI BPSK
m = 2;                  %index modulation
M = log2(m);            %length bits per symbol
FFTSize = 1024;           %FFTSize
N = FFTSize*M;          %Length of bits in a block
R=1;                    %Channel coding rate
K = floor(R*N);         %Length of bits in each frame
SNR = 0:5:50;
snr = 10.^(SNR/10);
cp_len = 0;             %Cylic prefix
ebn0 = snr*1/(M*R)*((N+cp_len)/N);
frame = 1000;
S = 0.1;
for i=1:length(SNR)
    fprintf('SNR: %d\n', SNR(i));
    ber = 0;
    fer = 0;
    sigma = sqrt(1/(snr(i)));    
    for j=1:frame
        %% Generate bit
        u = randi([0,1],1,N); 
        %% Mapper
        [out_simbol, code_bit, code_simbol] = func_mapper(u,'c-bpsk');
        s = out_simbol; 
        %% Alamouti Code
        for k =1:2:length(s)    
            x1(k) = s(k);           %insert symbol time 1 from out_simbol to antenna1 (x1) 
            x2(k) = s(k+1);         %insert symbol time 1 from out_simbol to antenna2 (x2) 
        end
        for k =2:2:length(s)
            x1(k) = -conj(s(k));    %insert symbol time 2 from out_simbol to antenna1 (x1) 
            x2(k) = conj(s(k-1));   %insert symbol time 2 from out_simbol to antenna2 (x2) 
        end   
        x_all   = [x1;x2];          % concatenate all symbol matrix [antenna1; antenna2];
        %% Symbol separated by time
        x_t1 = x_all(:,1:2:end);    %symbols from antennas in time 1
        x_t2 = x_all(:,2:2:end);    %symbols from antennas in time 2
        %% Channel Fading
        %h = ones(2); %awgn h=[h11 h12;h21 h22]
        h11=((randn(1,1)+sqrt(-1)*randn(1,1))/sqrt(2)); %skalar
        h12=((randn(1,1)+sqrt(-1)*randn(1,1))/sqrt(2));
        h21=((randn(1,1)+sqrt(-1)*randn(1,1))/sqrt(2));
        h22=((randn(1,1)+sqrt(-1)*randn(1,1))/sqrt(2));
        h = [h11 h12;h21 h22];
        %% Received Signal
        y1 = h*x_t1;     %y1=[h11 h12;h21 h22][s0;s1]
        y2 = h*x_t2;     %y2=[h11 h12;h21 h22][-s1*;s0*]
        n1 = sigma/sqrt(2)*(randn(size(x_t1))+sqrt(-1)*randn(size(x_t2)));
        n2 = sigma/sqrt(2)*(randn(size(x_t1))+sqrt(-1)*randn(size(x_t2))); %[n1;n2]
        yn1 = y1+n1;      %received symbols from 2 antennas in time 1 and plus noise
        yn2 = y2+n2;      %reveived symbols from 2 antennas in time 2 and plus noise
        r0 = yn1(1,:);   %received signal from antenna 1 at time 1
        r1 = yn2(1,:);   %received signal from antenna 1 at time 2
        r2 = yn1(2,:);   %received signal from antenna 2 at time 1
        r3 = yn2(2,:);   %received signal from antenna 2 at time 2
        %% STBC Decoder
        total_branch_energy = norm(h(1,1))+norm(h(1,2))+norm(h(2,1))+norm(h(2,2)); %total branch energy channels
        sHat0 = (conj(h(1,1))*r0 + h(1,2)*conj(r1) + conj(h(2,1))*r2 + h(2,2)*conj(r3)); %1x32 decode symbol 0
        sHat1 = (conj(h(1,2))*r0 - h(1,1)*conj(r1) + conj(h(2,2))*r2 - h(2,1)*conj(r3)); %1x32 decode symbol 1
        sHat = zeros(1,FFTSize);
        sHat(:,1:2:end) = sHat0;
        sHat(:,2:2:end) = sHat1;%1x64
        %% Demapper
        for k=1:length(sHat)
            if sHat(k)>0
                bit_de(k)=0;
            else
                bit_de(k)=1;
            end
        end
        %% BER & FER Calculations
        compare_bit = symerr(bit_de,u);
        ber = ber+compare_bit;
    end
    %% Get average of BER
    BER(i) = ber/(frame*K);
end
%% Setting Figure
fprintf('BER: %d\n', BER);
figure(1);
Figure1 = figure(1);
semilogy(SNR, BER, '--bo', 'linewidth', 1);
xlabel('Average SNR (dB)');
ylabel('Average BER');
legend('MIMO')
axis([0 50 10e-6 10e-1 ])
grid on;
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