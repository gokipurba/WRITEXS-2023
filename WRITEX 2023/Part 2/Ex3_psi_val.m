%% Copyright AICOMS WRITEXS 2023
clc;clear all;
%pdp=[1 0.011686918	0.077624712	0.000246207	4.93515E-06]; %Broadband  
pdp=[1]; %narrowband
path_len=length(pdp);              %jumlah/panjang path
for m=1:path_len
    h(m)=sqrt(pdp(m))*(randn+sqrt(-1)*randn)/sqrt(2); %arriving power of m-path
end
m = 2;M = log2(m); R = 1; %order modulasi yang digunakan %jumlah bit %coding rate
FFTSize = 64; %ukuran FFT
K = FFTSize*M; %jumlah bit
N = R*K; %panjang blok
Q = ceil((1.17/16.67)*FFTSize); B=5e6; %panjang CP dengan Numerology 4
EBN = 0:5:50 ; %nilai Eb/N0 dalam dB
ebn = 10.^(EBN/10) ; %nilai Eb/N0 dalam numerik
snr = ebn*M*R*(FFTSize/(FFTSize+Q)); %nilai SNR pada kanal Broadband
F = dftmtx(FFTSize)/sqrt(FFTSize); %matriks FFT
Fh = F'; %matriks IFFT
Heq =circulant([h zeros(1,FFTSize-length(h))]);  %[64x64] Circulant Matrix (c) Khoirul Anwar
psi = F*Heq*Fh; %[64x64] 
psi_vall = diag(psi)
 for ii = 1:length(ebn)
     for jj = 1:length(psi_vall)
        c(jj) = log2(1+(abs(psi_vall(jj)))^2*ebn(ii)*M*R); %kapasitas kanal Broadband
     end
    average_capacity(ii) = sum(c)/length(psi_vall);
 end
capacity = mean(B.*average_capacity)
