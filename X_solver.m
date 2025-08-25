function [X, S1] = X_solver(D, rho, a, nonconvex_surrogate)
    [U, S, V] = svd(D,'econ');
    switch nonconvex_surrogate
        case 'nff'
            [X, S1] = NFF(S,rho,a,U,V);
        case 'lp'
            [X, S1] = lp(S,rho,a,U,V);
    end
end

function [X, S1] = NFF(S,rho,a,U,V)
    lambda = 1/rho;
    S0 = diag(S);
    m = length(S0);
    S1 = zeros(m,1);
    if lambda <= 1/(2*a^2)
        t = (lambda*a);
    else
        t = max(sqrt(2*lambda)-1/(2*a),0);
    end
    for i=1:m
        if S0(i) > t 
            S1(i) = prox(lambda,a,S0(i));
        else
            S1(i) = 0;
        end
    end
    X = U *diag(S1) *V';
end

function [s1] = prox(lambda,a,gamma)
    p1 = (1+a*abs(gamma))/3;
    f = phi(lambda,a,gamma);
    p2 = 1+2*cos(f/3 - pi/3);
    s1 = sign(gamma)*((p1*p2 - 1)/a);
end

function [f] = phi(lambda,a,gamma)
    num = 27 * lambda * (a^2);
    den = 2 * (1 + a*abs(gamma))^3;
    f = acos(num/den - 1);
end
   

function [X, S1] = lp(S,rho,a,U,V)
    p = a;
    lambda = 1/rho;
    v = (lambda*p*(1-p))^(1/(2-p))+eps;
    v1 = v+lambda*p*(abs(v)^(p-1));
    S0 = diag(S);
    m = length(S0);
    S1 = zeros(m,1);
    for j=1:m
        alpha = S0(j);
        if alpha>v1  
            x = alpha;             
            for i = 1:10
                gx = x - alpha + lambda*p*(abs(x)^(p-1))*sign(x);   
                ggx = 1 - lambda*p*(1-p)*(x^(p-2));                  
                x = x - gx/ggx;
            end
        else
            x=0;
        end
         S1(j) = x;
    end
    X = U *diag(S1) *V';
end


