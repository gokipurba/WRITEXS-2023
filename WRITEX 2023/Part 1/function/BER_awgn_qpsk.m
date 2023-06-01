%% Copyright AICOMS WRITEXS 2023
function [BER]=BER_awgn_qpsk(EbNo)
gamma = 10.^(EbNo/10); 
for i=1:length(gamma)
    BER(i)=0.5*erfc(sqrt(gamma(i)/2));
end
