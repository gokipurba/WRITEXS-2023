function A=kronisasi(S)
ket0=[1;0];
ket1=[0;1];
eval(['A=ket',S(1),';']) %--> inisialisasi
for i=1:length(S)-1
    eval(['A=kron(A,ket',S(i+1),');'])
end
