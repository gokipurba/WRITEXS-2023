function ann_multi_case1
clear all

x1=[1 0];
% x2=[1 0 1 0];
% datasetI=[x1'.*x2' x1'+x2'    ];
datasetI=[x1'    ];
% datasetI=[x1'.*x2' x1'+x2'];
% datasetO=[or(x1',x2') and(x1',x2') x1' x2' xor(x1',x2') (x1+x2)' ];
datasetO=[~x1'];
% xor(x1',x2')
lamda=0.2;
epoch=200;
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
%     b=b-lamda*mean(2*e,2);
    E(k)=mean(mean(e.^2));
    W(:,:,k)=w;
    B(:,:,k)=b';
    Y(:,:,k)=yt;
    continue
end
% %SISO
% figure(1),clf
% plot(E,'b-','linewidth',2),hold on,grid on
% plot(squeeze(W),'m-','linewidth',2)
% plot(squeeze(B),'g-','linewidth',2)
% xlabel('Epoch')
% ylabel('Value')
% legend('Loss','w','b')

% %MISO
% figure(1),clf
% plot(E,'b-','linewidth',2),hold on,grid on
% plot(squeeze(W(:,1,:)),'m-','linewidth',2)
% plot(squeeze(W(:,2,:)),'r-','linewidth',2)
% plot(squeeze(B),'g-','linewidth',2)
% xlabel('Epoch')
% ylabel('Value')
% legend('Loss','w_1','w_2','b')

% %SIMO
% figure(1),clf
% plot(E,'b-','linewidth',2),hold on,grid on
% plot(squeeze(W(1,:,:)),'m-','linewidth',2)
% plot(squeeze(W(2,:,:)),'r-','linewidth',2)
% plot(squeeze(B(:,1,:)),'g-','linewidth',2)
% plot(squeeze(B(:,2,:)),'k-','linewidth',2)
% xlabel('Epoch')
% ylabel('Value')
% legend('Loss','w_1','w_2','b_1','b_2')

%MIMO
% figure(1),clf
% 
% plot(E,'b-','linewidth',2),hold on,grid on
% plot(squeeze(W(1,1,:)),'m:','linewidth',2)
% plot(squeeze(W(2,1,:)),'r:','linewidth',2)
% plot(squeeze(W(3,1,:)),'g:','linewidth',2)
% plot(squeeze(W(1,2,:)),'m-','linewidth',2)
% plot(squeeze(W(2,2,:)),'r-','linewidth',2)
% plot(squeeze(W(3,2,:)),'g-','linewidth',2)
% plot(squeeze(B(:,1,:)),'m--','linewidth',2)
% plot(squeeze(B(:,2,:)),'r--','linewidth',2)
% plot(squeeze(B(:,3,:)),'g--','linewidth',2)
% xlabel('Epoch')
% ylabel('Value')
% legend('Loss','w_{11}','w_{12}','w_{13}','w_{21}','w_{22}','w_{23}','b_1','b_2','b_3')


return
x1=[0 0 1 1];
x2=[0 1 0 1];
datasetI=[x1' ~x1'.*x2' x2'  ];
datasetO=[or(x1',x2') and(x1',x2') xor(x1',x2') ];
% dataset=dataset*2-1;
% dataset(:,1:2)=dataset(:,1:2).^4;
% dataset=[x1' x2' ~x1' ~x2' ];

% x1=[0 1];
% x2=[1 0];
% dataset=[x1' x2'];

lamda=0.1;
epoch=500;
Ni=size(datasetI,2);;
No=size(datasetO,2);

w=ones(No,Ni);%w=[w11 w21;w12 w22]
b=zeros(No,1);
% w=zeros(Ni,No);%w=[w11 w21;w12 w22]

% w=[1 2;3 4];
% w=rand(2,2);
p=datasetI.';
y=datasetO.';

% p=dataset(:,1:3).'
% y=dataset(:,4:6).'

% y=dataset(:,3).'

% p=dataset(:,1).';
% y=dataset(:,2).';


for k=1:epoch
    % yt(1,:)=w*p(1,:).'+b;%y1t dan y2t = p1*w1j+p2w2j+bj
    % yt(2,:)=w*p(2,:).'+b
    % yt(3,:)=w*p(3,:).'+b
    % yt(4,:)=w*p(4,:).'+b
    yt=w*p+b;%y1t dan y2t untuk semua dataset lengkap
    % yt=max(0,yt);
    % yt=tanh(yt);
    % yt=extractdata(sigmoid(dlarray(yt)));
    % yt=max(0.1*yt,yt);
    e=(yt-y);
    
    % sse=sum(e,2);
    
    % w1(1,1)=w(1,1)+lamda*sum(e(1,:).*p(1,:)*2);%w11
    % w1(1,2)=w(1,2)+lamda*sum(e(1,:).*p(2,:)*2);%w21
    % w1(2,1)=w(2,1)+lamda*sum(e(2,:).*p(1,:)*2);%w12
    % w1(2,2)=w(2,2)+lamda*sum(e(2,:).*p(2,:)*2);%w22
    for i=1:No
        w(i,:)=w(i,:)-lamda*mean(e(i,:).*p(:,:)*2,2).';
    end
    % wt(1,:)=w(1,:)+lamda*sum(e(1,:).*p(:,:)*2,2).';%w11 dan w21
    % wt(2,:)=w(2,:)+lamda*sum(e(2,:).*p(:,:)*2,2).';%w12 dan w22
    
    % yt=w*p+b;%y1t dan y2t untuk semua dataset lengkap
    % e=(yt-y);
    
    b=b-lamda*mean(2*e,2);
    
    W(k,:)=w;
    B(k)=b;
    E(k)=mean(mean(e.^2));
    
    % w1(k)=w(1,1);
    % w2(k)=w(1,2);
    % b1(k)=b(1,1);
    
    continue
end
figure(1),clf
plot(E,'b-'),hold on,grid on
plot(W,'r-')
plot(B,'g-')
xlabel('Epoch')
ylabel('Value')
legend('Loss','w','b')
% subplot(222),plot(w1)
% subplot(223),plot(w2)
% subplot(224),plot(b1)


% w
% p
% yt


% yt(1,1)=p(1,:)*w(:,1)+b(1)
% yt(1,2)=p(1,:)*w(:,1)+b(1)









