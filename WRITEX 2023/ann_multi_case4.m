% function ann_multi_case4
clear all
% [inmod,outawgn,bitin,outbin]=siskom_acc;

load datadian
in=x(:,2:end);
out=x(:,1);
outbin=de2bi(out/10,4,'left-msb').';

% in=in.';
out=outbin(:,:);

x1=in(:,:);
% x1=outbin;
% x2=[1 0 1 0];
% datasetI=[x1x1'.*x2' x1'+x2'    ];
% datasetI=[x1.'  x1.'.^2  ];
datasetI=[ x1   ];
% datasetI=[x1'.*x2' x1'+x2'];
% datasetO=[or(x1',x2') and(x1',x2') x1' x2' xor(x1',x2') (x1+x2)' ];
datasetO=out;
% datasetO=outbin';

% datasetO=reshape(datasetO,2,2);
% datasetI=reshape(datasetI,2,2);


% xor(x1',x2')
lamda=0.00005;
epoch=1000;

p=datasetI';
y=datasetO;
Ni=size(p,1);
No=size(y,1);
T=size(p,2);
w=zeros(No,Ni);%w=[w11 w21;w12 w22]
b=zeros(No,T);


for k=1:epoch
    yt=w*p+b;%y1t dan y2t untuk semua dataset lengkap
    e=(yt-y);
    for i=1:No
        w(i,:)=w(i,:)-lamda*mean(e(i,:).*p(:,:)*2,2).';
    end
    b=b-lamda*mean(2*e,2);
    E(k)=mean(mean(e.^2));
    W(:,:,k)=w;
    B(:,:,k)=b';
    Y(:,:,k)=yt;
    continue
end

if size(datasetI,1)==1 && size(datasetO,1)==1
%SISO
figure(1),clf
plot(abs(E),'b-','linewidth',2),hold on,grid on
plot(squeeze(abs(W)),'m-','linewidth',2)
plot(squeeze(abs(B)),'g-','linewidth',2)
xlabel('Epoch')
ylabel('Value')
legend('Loss','w','b')
elseif size(datasetI,1)>1 && size(datasetO,1)==1
%MISO
figure(1),clf
plot(abs(E),'b-','linewidth',2),hold on,grid on
plot(abs(squeeze(W(:,1,:))),'m-','linewidth',2)
plot(abs(squeeze(W(:,2,:))),'r-','linewidth',2)
plot(abs(squeeze(B)),'g-','linewidth',2)
xlabel('Epoch')
ylabel('Value')
legend('Loss','w_1','w_2','b')
elseif size(datasetI,1)==1 && size(datasetO,1)>1
%SIMO
figure(1),clf
plot(abs(E),'b-','linewidth',2),hold on,grid on
plot(squeeze(abs(W(1,:,:))),'m-','linewidth',2)
plot(squeeze(abs(W(2,:,:))),'r-','linewidth',2)
plot(squeeze(B(:,1,:)),'g-','linewidth',2)
plot(squeeze(B(:,2,:)),'k-','linewidth',2)
xlabel('Epoch')
ylabel('Value')
legend('Loss','w_1','w_2','b_1','b_2')
else
% MIMO
figure(1),clf

plot(abs(E),'b-','linewidth',2),hold on,grid on
plot(squeeze(abs(W(1,1,:))),'m:','linewidth',2)
plot(squeeze(abs(W(2,1,:))),'r:','linewidth',2)
plot(squeeze(abs(W(3,1,:))),'g:','linewidth',2)
plot(squeeze(abs(W(1,2,:))),'m-','linewidth',2)
plot(squeeze(abs(W(2,2,:))),'r-','linewidth',2)
plot(squeeze(abs(W(3,2,:))),'g-','linewidth',2)
plot(squeeze(abs(B(:,1,:))),'m--','linewidth',2)
plot(squeeze(abs(B(:,2,:))),'r--','linewidth',2)
plot(squeeze(abs(B(:,3,:))),'g--','linewidth',2)
xlabel('Epoch')
ylabel('Value')
legend('Loss','w_{11}','w_{12}','w_{13}','w_{21}','w_{22}','w_{23}','b_1','b_2','b_3')
end
