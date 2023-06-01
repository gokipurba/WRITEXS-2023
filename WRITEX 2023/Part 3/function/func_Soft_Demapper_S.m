function [Lci, isi_0, isi_1,Z,Y]=func_Soft_Demapper_S(y, code_bit, code_simbol,sigma,S,M)

for i=1:length(y)
    for j=1:M
          bit_1=find(code_bit(:,j)==1); 
          bit_0=find(code_bit(:,j)==0); 
          sum0=0;
          sum1=0;
          for k=1:length(bit_1)
            %% BIT 1
            if sigma<S
                sigma=S;  
            end
            xm_1=code_simbol(bit_1(k));
            Z=(abs(y(i)-xm_1)^2);
            isi_1=Z/(2*sigma^2);        
			if isi_1> 709
                isi_1= 709;
            elseif isi_1<-709
                isi_1 = -709;
            end
            sum1= sum1+exp(-isi_1);
            
            %% BIT 0
            xm_0=code_simbol(bit_0(k));
            Y=(abs(y(i)-xm_0)^2); 
            isi_0=Y/(2*sigma^2);
			
			if isi_0>709
                isi_0= 709;        
            elseif isi_0 <-709
                isi_0=-709;                    
            end            
            sum0=sum0+exp(-isi_0);
            
            isi_log(j,i)=sum0/sum1;
          end     
          LLR(j,i)=log(isi_log(j,i));      
    end
end

Lci=reshape(LLR,1,[]);