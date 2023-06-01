%% Copyright AICOMS WRITEXS 2023
function codeword = func_repetition_encode(u, R)
    for i=1:length(u)
        for jj = 1:R
        codeword(R*i+1-jj)=u(i);
        end
    end
end