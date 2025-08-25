function opts = opts_set(dataset, gaussSigma, hasImpulse, hasStripeDeadline, nonconvex_surrogate, mode)
    opts = struct();

    base = 0;
    if hasStripeDeadline == true
        base = 0.1;
    end
    
    n1=0.1; n2=0.2; n3=0.3;
    
    switch dataset
        case 'wdc' 
            switch nonconvex_surrogate
                case 'nff'
                    a_trip      = [0.5 0.95 1.4];
                    lambda_trip = [0.0095 0.0091 0.0087];
                    ga_trip     = [0.03 0.055 0.07];
    
                    [a_v, l_v, g_v] = Hyperparameter_settings(gaussSigma+base, a_trip, lambda_trip, ga_trip, n1, n2, n3, mode);
    
                    opts.a = a_v;
                    opts.lambda = l_v;
                    opts.gamma = g_v;
    
                    opts.blocksize = 25;
                    opts.stepsize = 10;
    
                    rate_pair = [1.7 1.4];
    
                    opts.rate = rate_setting(gaussSigma+base, rate_pair, n2, n3);
                case 'lp'
                    a_trip      = [0.16 0.185 0.21];
                    lambda_trip = [0.0096 0.0092 0.0088];
                    ga_trip     = [0.035 0.055 0.07];
    
                    [a_v, l_v, g_v] = Hyperparameter_settings(gaussSigma+base, a_trip, lambda_trip, ga_trip, n1, n2, n3, mode);
    
                    opts.a = a_v;
                    opts.lambda = l_v;
                    opts.gamma = g_v;
    
                    opts.blocksize = 20;
                    opts.stepsize = 8;
    
                    rate_pair = [1.6 1.3];
    
                    opts.rate = rate_setting(gaussSigma+base, rate_pair, n2, n3);
            end
            opts.mu = 25;
        case 'pavia'
             switch nonconvex_surrogate
                case 'nff'
                    a_trip      = [0.4 0.5 0.6];
                    lambda_trip = [0.0115 0.008 0.01];
                    ga_trip     = [0.04 0.05 0.06];
    
                    if hasStripeDeadline == false
                        [a_v, l_v, g_v] = Hyperparameter_settings(gaussSigma, a_trip, lambda_trip, ga_trip, n1, n2, n3, mode);
                    else
                        a_v = 0.5;
                        l_v = 0.01;
                        g_v = 0.05;
                    end
    
                    opts.a = a_v;
                    opts.lambda = l_v;
                    opts.gamma = g_v;
    
                    opts.blocksize = 25;
                    opts.stepsize = 10;
    
                    rate_pair = [1.6 1.4];
    
                    opts.rate = rate_setting(gaussSigma, rate_pair, n2, n3);
                case 'lp'
                    a_trip      = [0.11 0.12 0.14];
                    lambda_trip = [0.0115 0.0115 0.0115];
                    ga_trip     = [0.055 0.10 0.12];
    
                    if hasStripeDeadline == false
                        [a_v, l_v, g_v] = Hyperparameter_settings(gaussSigma, a_trip, lambda_trip, ga_trip, n1, n2, n3, 'extrap');
                    else
                        a_v = 0.15;
                        l_v = 0.009;
                        g_v = 0.04;
                    end
    
                    opts.a = a_v;
                    opts.lambda = l_v;
                    opts.gamma = g_v;
    
                    opts.blocksize = 20;
                    opts.stepsize = 8;
    
                    rate_pair = [1.6 1.4];
    
                    opts.rate = rate_setting(gaussSigma, rate_pair, n1, n3);
            end
            opts.mu = 4;
        case 'indian'
            switch nonconvex_surrogate
                case 'nff'
                    opts.a = 0.5;
                    opts.lambda = 0.0095;
                    opts.gamma = 0.03;
    
                    opts.blocksize = 25;
                    opts.stepsize = 10;
    
                    opts.rate = 1.7;
                    
                case 'lp'              
                    opts.a = 0.16;
                    opts.lambda = 0.0096;
                    opts.gamma = 0.035;

                    opts.blocksize = 20;
                    opts.stepsize = 8;
    
                    opts.rate = 1.6;
            end
            opts.mu = 200;
        case 'urban'
            switch nonconvex_surrogate
                case 'nff'
                    opts.a = 7;
                    opts.lambda = 0.0037;
                    opts.gamma = 0.26;
    
                    opts.blocksize = 25;
                    opts.stepsize = 10;
    
                    opts.rate = 1.6;
                    
                case 'lp'              
                    opts.a = 0.3;
                    opts.lambda = 0.0037;
                    opts.gamma = 0.26;

                    opts.blocksize = 20;
                    opts.stepsize = 8;
    
                    opts.rate = 1.6;
            end
            opts.mu = 30;
    end
    
    opts.nonconvex_surrogate = nonconvex_surrogate;

    opts.max_itr = 500;
    opts.tol = 1e-4; 
end