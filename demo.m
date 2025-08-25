clc; clear all;

addpath quality_assess\

%% Load HSI data
isSimulation = true;
use_preset_datasets = true;
preset_datasets = 'WDC-case6'; % Select from WDC-case6, PAVIA-case6, Indian, Urban
if use_preset_datasets == true
    load(strcat('data\',preset_datasets));
    switch preset_datasets
        case 'WDC-case6' 
            dataset = 'wdc'; % Select from wdc, pavia, indian, urban
            gaussSigma = 0.1;          
            hasImpulse = true;           
            hasStripeDeadline = true; 
        case 'PAVIA-case6'
            dataset = 'pavia'; % Select from wdc, pavia, indian, urban
            gaussSigma = 0.1;          
            hasImpulse = true;           
            hasStripeDeadline = true; 
        case 'Indian'
            dataset = 'indian'; 
            gaussSigma = 0;          
            hasImpulse = true;           
            hasStripeDeadline = true; 
        case 'Urban'
            dataset = 'urban'; 
            gaussSigma = 0;          
            hasImpulse = true;           
            hasStripeDeadline = true; 
            Noisy_Img = Noise_Urban;
    end
    mode = 'extrap'; % Select from extrap, clip. If the value of gaussSigma is not in the range [0.1,0.3], try mode = 'extrap' and mode = 'clip' to get the best result.
else
    load('data\WDC-case6');
    dataset = 'wdc'; % Select from wdc, pavia, indian, urban
    gaussSigma = 0.1;          
    hasImpulse = true;           
    hasStripeDeadline = true;    
    mode = 'extrap'; % Select from extrap, clip. If the value of gaussSigma is not in the range [0.1,0.3], try mode = 'extrap' and mode = 'clip' to get the best result.
end

nonconvex_surrogate = 'nff'; % Select from nff, lp


%% Parameter setting
opts = opts_set(dataset, gaussSigma, hasImpulse, hasStripeDeadline, nonconvex_surrogate, mode);


%% GNRSR
disp('=============== GNRSR ===============')
fprintf('=== a = %f; lambda = %f; ga = %f; blocksize = %d; stepsize = %d ====\n',opts.a,opts.lambda,opts.gamma, opts.blocksize, opts.stepsize);

C=1;
tic
[output_image] = GNRSR(Noisy_Img,opts);
toc

output_image(output_image>1)=1;
output_image(output_image<0)=0;


%% quality assess
if isSimulation == true
    [q_psnr_mean,q_psnr] = MPSNR(Img,output_image);
    [q_ssim_mean,q_ssim] = MSSIM(Img,output_image);
    [q_fsim_mean,q_fsim] = MFSIM(Img,output_image);
    q_ergas = ErrRelGlobAdimSyn(255*Img,255*output_image);
    fprintf('psnr = %.4f , ssim = %.4f, fsim = %.4f , ergas = %.4f \n',q_psnr_mean,q_ssim_mean,q_fsim_mean,mean(q_ergas));
    if use_preset_datasets == true
        switch preset_datasets
            case 'WDC-case6' 
                final_Img = cat(3, Img(:,:,69), Img(:,:,106), Img(:,:,151));
                final_output_image = cat(3, output_image(:,:,69), output_image(:,:,106), output_image(:,:,151));
            case 'PAVIA-case6'
                final_Img = cat(3, Img(:,:,55), Img(:,:,35), Img(:,:,15));
                final_output_image = cat(3, output_image(:,:,55), output_image(:,:,35), output_image(:,:,15));
        end
        figure;
        subplot(1,2,1); imshow(final_Img); title('Clean Img');
        subplot(1,2,2); imshow(final_output_image); title('Output Img');
    end
else
    if use_preset_datasets == true
        switch preset_datasets
            case 'Indian'
                final_Noisy_Img = cat(3, Noisy_Img(:,:,142), Noisy_Img(:,:,22), Noisy_Img(:,:,1));
                final_output_image = cat(3, output_image(:,:,142), output_image(:,:,22), output_image(:,:,1));
            case 'Urban'
                final_Noisy_Img = cat(3, Noisy_Img(:,:,71), Noisy_Img(:,:,107), Noisy_Img(:,:,207));
                final_output_image = cat(3, output_image(:,:,71), output_image(:,:,107), output_image(:,:,207));
        end 
        figure;
        subplot(1,2,1); imshow(final_Noisy_Img); title('Noisy Img');
        subplot(1,2,2); imshow(final_output_image); title('Output Img');
    end
end




