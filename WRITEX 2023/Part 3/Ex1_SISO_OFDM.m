%% Copyright AICOMS WRITEXS 2023
clc;clear all;addpath(genpath('function'));
%% MODULASI BPSK
m = 2; M = log2(m);R=1;             %index modulation %length bits per symbol %Channel coding rate
FFTSize = 64;                       %FFTSize
N = FFTSize*M;                      %Length of bits in a block 64 item sizes OFDM
K = R*N;                            %Length of bits in each frame
cp = ceil(4.69/66.67*FFTSize);      %length of cyclic prefix based on Numerology 0
SNR = 0:5:50;                       %[dB] SNR
snr = 10.^(SNR/10);                 %SNR in numeric
ebn0 = snr*1/(M*R)*((N+cp)/N);      %Calculate ebn0
F = dftmtx(FFTSize)/sqrt(FFTSize);  %FFT Matrix
F_h = F';                           %IFFT Matrix
Kk = floor(K);                      %Panjang bit
frame = 1000;                        %Frame Iteration
prow = FFTSize+cp*2;                %row length matriks Toeplitz
pcol = cp+FFTSize;                  %col length matriks Toeplitz
S = 0.1;                            %Threshold S for Softdemapper copyright Lia Suci
for ii=1:length(SNR)
    fprintf('SNR: %d\n', SNR(ii));
    ber = 0;fer = 0;
    sigma = sqrt(1/(snr(ii)));
    BER_bpsk_fading(ii)=0.5*(1-(1/(sqrt(1+(1/(ebn0(ii))))))); %Theory inputnya ebno
    for j=1:frame
        %% Generate bit
        u = randi([0,1],1,N); 
        %% Mapper
        [out_simbol, code_bit, code_simbol] = func_mapper(u,'c-bpsk');
        s = out_simbol;     %output symbols of modulation
        %% OFDM Mod
        out_ifft_x1 = ifft(s,FFTSize)*sqrt(FFTSize);  %implementation of IFFT symbol
        out_ifft_x1_cp = [out_ifft_x1(end-cp+1:end), out_ifft_x1];  %add cyclic prefix   
        %% Symbol separated by time
        x_all   = out_ifft_x1_cp;  % tx signal
        %% Channel
        %h = ones(2); %awgn h=[h11 h12;h21 h22] %Model for AWGN channel
        h11 = (randn(1,1)+sqrt(-1)*randn(1,1))/sqrt(2);
        h12 = (randn(1,1)+sqrt(-1)*randn(1,1))/sqrt(2);
        h13 = (randn(1,1)+sqrt(-1)*randn(1,1))/sqrt(2);%only single path
        H = [h11 h12 h13];  
        H_Toeplitz = zeros(prow-1,pcol); %prow = FFTSize+cp*2; pcol = cp+FFTSize;
        for k = 1:pcol
            for l = 1:length(H)
                H_Toeplitz(l+k-1,k) = H(l);  %assign matrix Toeplitz (validate with imagesc(abs(H_Toep))
            end
        end
        %% Received Signal
        y_t1 = H_Toeplitz*x_all.';  %transmitted through channel
        %y_t1 = conv(H,x_all);
        n = sigma/sqrt(2)*(randn(size(y_t1))+sqrt(-1)*randn(size(y_t1))); %
        y_t1_n_cp = y_t1+n;         %received signal and plus noise
        %% remove CP and OFDM Demod
        y_all = [y_t1_n_cp(cp+1:end-cp+1,1)].'; %remove CP
        y = [(fft(y_all(1,:),FFTSize))/sqrt(FFTSize)]; %Implementation of FFT in signal using toeplitz
%        y_all = [y_t1_n_cp(1,cp+1:end-1)]; %remove CP
%        y = [(fft(y_all(1,:),FFTSize))/sqrt(FFTSize)]; %Implementation of FFT in signal using conv
        %% get H Circular
        H_c = func_circulant([H zeros(1,FFTSize - length(H))]); % Circulant Matrix (KHO)
        Xi = F*H_c*F_h;
        Xi = diag(Xi); % get matrix diagonal channel from matrix circulant (H_x)
        %% Equalizer
        %eq_mmse = conj(Xi)./((conj(Xi).*Xi)+(sigma^2)); %MMSE
        %sHat = eq_mmse.*y.';           %MMSE
        eq_zf = 1./Xi;                  %ZF
        sHat = eq_zf.*y.';              %Symbol hat
        [Lci, isi_0, isi_1,Z,Y] = func_Soft_Demapper_S(sHat, code_bit, code_simbol,sigma, S, M);
        %Lci = sHat.*(2/sigma^2);
        %% Demapper BPSK
        for k=1:length(sHat)
            if Lci(k) > 0 
                bit_de(k)=0;
            else
                bit_de(k)=1;
            end
        end
        %% BER & FER Calculations
          compare_bit = sum(bit_de~=u);
          ber = ber+compare_bit;
    end
    %% Get average of BER
    BER(ii) = ber/(frame*K);
end
%% Setting Figure
fprintf('BER: %d\n', BER);
figure(1);
Figure1 = figure(1);
semilogy(SNR,BER_bpsk_fading,'-k*','linewidth',1)
hold on
semilogy(SNR, BER, '--ro', 'linewidth', 1);
xlabel('Average SNR (dB)');
ylabel('Average BER');
legend('BPSK Theory', 'SISO OFDM')
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

   