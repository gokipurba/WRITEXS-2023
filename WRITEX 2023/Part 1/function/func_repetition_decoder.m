%% Copyright AICOMS WRITEXS 2023
function u = func_repetition_decoder(c,R)
    n = length(c)/R;
    u = zeros(1,n);
    for i=1:n
        startIndex = (i-1)*R+1;
        endIndex =  i*R;
        u(i) = mode(c(startIndex:endIndex));
    end
end
