function [inmod,outawgn,bit,outbin]=siskom_acc
% clear all
v=30;SNR=100;
n=1;N=100;
Marray=2^n;ind=1;
for snr=SNR
    bit=randi([0 1],1,N);
%     bit=[1 0 1 1];
%     bitin=reshape(bit,2,N/2)';
    bita = func_accumulator(bit);            % codewords
% bita=bit;
    for i=1:length(bit)/n
        inmod(1,i)=bi2de(bita(1,n*i+1-n:n*i),'left-msb');
    end
    outmod=pskmod(inmod,Marray);
    h=raygen(length(outmod),v);
    outfad=h.*outmod;
%     outfad=outmod;
    outawgn0=awgn(outfad,snr,'measured');
    outawgn=outawgn0./(h);
    outdemod=pskdemod(outawgn,Marray);
    outbin=zeros(1,length(outdemod)*n);
    for i=1:length(outdemod)
        outbin(1,n*i+1-n:n*i)=de2bi(outdemod(1,i),n,'left-msb');
    end
     outaccd = func_de_accumulator(outbin);
    [p,ber(1,ind)]=symerr(outaccd,bit);
    ind=ind+1;
end
% figure(1),clf,semilogy(SNR,ber)
% xlabel('SNR (dB)'),ylabel('BER')
ber
return
