function [X,S] = GNRSR_IALM(Y,opts)
[m,n] = size(Y);

a = opts.a;
lambda = opts.lambda;
rate = opts.rate;
max_itr = opts.max_itr;
tol =opts.tol;

S = zeros(m,n);  
P = zeros(m,n);      
Q = zeros(m,n);
W = zeros(m,n);

gamma = opts.gamma/(min(m,n))^(1/2);
mu = opts.mu/(norm(Y))^2;
norm_X = norm(Y,'fro');

for iter = 1:max_itr
    
    % step 1: Update X_{k+1}
    tmp_X = (Y - S + P/mu + mirt_idctn( W + Q/mu ))/2;%
    [X, ~] = X_solver(tmp_X, 2 * mu, a, opts.nonconvex_surrogate);
    
    % step 2: Update S_{k+1}
    tmp_S = Y-X+P/mu;
    S = softthre(tmp_S, lambda/mu);

    % step 3: Update W_{k+1}
    transform_X= mirt_dctn(X);
    tmp_W = transform_X - Q/mu;
    W = softthre(tmp_W, gamma/mu);
    
    % step 4: Update Lagrange multipliers
    P = P + mu * (Y - X - S);  
    Q = Q + mu * (W - transform_X);
    
    % step 5: Update \mu
    mu = mu * rate; 
    
    % step 6: Check stopping criterion
    Rel_Err = norm (Y - X - S ,'fro')/norm_X; % convergence condition
    if Rel_Err < tol
        break;
    end   
end

end


