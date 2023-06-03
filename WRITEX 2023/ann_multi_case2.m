function ann_multi_case2
clear all
[inmod,outawgn,bitin]=siskom_dasar;
x1=outawgn;
% x2=[1 0 1 0];
% datasetI=[x1x1'.*x2' x1'+x2'    ];
% datasetI=[x1.'  x1.'.^2  ];
datasetI=[ x1'   ];
% datasetI=[x1'.*x2' x1'+x2'];
% datasetO=[or(x1',x2') and(x1',x2') x1' x2' xor(x1',x2') (x1+x2)' ];
datasetO=bitin';
% xor(x1',x2')
lamda=0.001;
epoch=1000;
Ni=size(datasetI,2);
No=size(datasetO,2);

w=ones(No,Ni);%w=[w11 w21;w12 w22]
b=zeros(No,1);
p=datasetI.';
y=datasetO.';

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

if size(datasetI,2)==1 && size(datasetO,2)==1
%SISO
figure(1),clf
plot(real(E),'b-','linewidth',2),hold on,grid on
plot(squeeze(real(W)),'m-','linewidth',2)
plot(squeeze(real(B)),'g-','linewidth',2)
xlabel('Epoch')
ylabel('Value')
legend('Loss','w','b')
elseif size(datasetI,2)>1 && size(datasetO,2)==1
%MISO
figure(1),clf
plot(abs(E),'b-','linewidth',2),hold on,grid on
plot(abs(squeeze(W(:,1,:))),'m-','linewidth',2)
plot(abs(squeeze(W(:,2,:))),'r-','linewidth',2)
plot(abs(squeeze(B)),'g-','linewidth',2)
xlabel('Epoch')
ylabel('Value')
legend('Loss','w_1','w_2','b')
elseif size(datasetI,2)==1 && size(datasetO,2)>1
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
