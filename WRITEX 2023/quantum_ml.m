% function quantum_ml
clear all
pos0=[];pos1=[];
for i=1:1000
y(i,1)=2*rand(1,1)-1+j*(2*rand(1,1)-1);
    P=coba_qml(y(i,1));
    b=(P>=0.5)*0+(P<0.5)*1;
        if b==0
            pos0=[pos0 y(i,1)];
        else
            pos1=[pos1 y(i,1)];
        end
end
figure(1),clf
plot(pos0,'ro'),hold on, grid on
plot(pos1,'bx')
xlabel('Real Part'),ylabel('Imaginary Part')
legend('Bit "0"','Bit "1"')



function P40=coba_qml(y)
k0=kronisasi('0');
k1=kronisasi('1');

x0=1/sqrt(2)*(-1+j);
x1=1/sqrt(2)*(1-j);

k0000=kronisasi('0000');
k0010=kronisasi('0010');
k0101=kronisasi('0101');
k0111=kronisasi('0111');
k1000=kronisasi('1000');
k1010=kronisasi('1010');
k1101=kronisasi('1101');
k1111=kronisasi('1111');

X0=real(x0)*k0000+imag(x0)*k0010+real(x1)*k0101+imag(x1)*k0111+...
real(y)*k1000+imag(y)*k1010+real(y)*k1101+imag(y)*k1111;%<-- Step 2
I=eye(2);
H=hadamard(2);
HIII=kron(kron(kron(H,I),I),I);
X1=HIII*X0; %<-- Step 3
M0=k0*k0';
M1=k1*k1';
M0III=kron(kron(kron(M0,I),I),I);
IIIM0=kron(kron(kron(I,I),I),M0);
c0=M0III*X1; %<--step 4

P10=X1.'*M0III*X1;
X20=M0III*X1/sqrt(P10);

M40=IIIM0;
P40=X20.'*M40*X20;
end

% k0001=kronisasi('0001');
% k0011=kronisasi('0011');
% k0100=kronisasi('0100');
% k0110=kronisasi('0110');
% k1001=kronisasi('1001');
% k1011=kronisasi('1011');
% k1100=kronisasi('1100');
% k1110=kronisasi('1110');
% M1III=kron(kron(kron(M1,I),I),I);
% IIIM1=kron(kron(kron(I,I),I),M1);
% IIM0I=kron(kron(kron(I,I),M0),I);
% IIM1I=kron(kron(kron(I,I),M1),I);
% M30=IIM0I;
% M31=IIM1I;
% P11=X1.'*M1III*X1;
% X21=M1III*X1/sqrt(P11);
% P30=X20.'*M30*X20;
% P31=X21.'*M31*X21;
% M41=IIIM1;
% P41=X21.'*M41*X21;
% b1=IIIM1*X1
% tot=[X0,X1,c0,b0];







