function  [ output_image] = GNRSR(oriData3_noise,opts)
[m,n,p] = size(oriData3_noise);
clear_image=zeros(m,n,p);

stepszie = opts.stepsize;
M = opts.blocksize;

Weight = zeros(m,n,p);      
patch_block = zeros(M^2,p);  
R         =   m-M+1; 
C         =   n-M+1; 
rr        =   [1:stepszie:R];
rr        =   [rr rr(end)+1:R];
cc        =   [1:stepszie:C];
cc        =   [cc cc(end)+1:C];
row       =   length(rr);
column    =   length(cc);

% Algorithm 1
for   rownumber =1:row
    for columnnumber = 1:column
         i = rr(rownumber);
         j = cc(columnnumber); 
         for  k=1:1:p
         patch_reference = oriData3_noise(i:i+M-1,j:j+M-1,k); 
         patch_block(:,k) =  patch_reference(:);
         Weight(i:1:i+M-1,j:1:j+M-1,k) = Weight(i:1:i+M-1,j:1:j+M-1,k)+1;   
         end
        
        % Algorithm 2
        [clear_patch_block, ~] = GNRSR_IALM(patch_block,opts);
        
        for m2=1:1:p
          clear_image(i:1:i+M-1,j:1:j+M-1,m2) = reshape(clear_patch_block(:,m2),M,M)+clear_image(i:1:i+M-1,j:1:j+M-1,m2);
        end 
     end            
end  

Weight_last = 1./Weight;
output_image = Weight_last.*clear_image;
end
