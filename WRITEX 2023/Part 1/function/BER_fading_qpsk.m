%% Copyright AICOMS WRITEXS 2023
function [BER]=BER_fading_qpsk(EbNo)
gamma = 10.^(EbNo/10); 
for i=1:length(gamma)
    BER(i)=0.5*(1-(1/(sqrt(1+(2/(gamma(i)))))));
end
