function [a_val, lambda_val, ga_val] = Hyperparameter_settings(noise, ...
     a_trip, lambda_trip, ga_trip, n1, n2, n3, mode)



    a1=a_trip(1); a2=a_trip(2); a3=a_trip(3);
    l1=lambda_trip(1); l2=lambda_trip(2); l3=lambda_trip(3);
    g1=ga_trip(1); g2=ga_trip(2); g3=ga_trip(3);
    
    if (noise >= n1) && (noise < n2)
        t = (noise - n1) / (n2 - n1);
        a_val      = a1 + t.*(a2 - a1);
        lambda_val = l1 + t.*(l2 - l1);
        ga_val     = g1 + t.*(g2 - g1);
    elseif (noise >= n2) && (noise < n3)
        t = (noise - n2) / (n3 - n2);
        a_val      = a2 + t.*(a3 - a2);
        lambda_val = l2 + t.*(l3 - l2);
        ga_val     = g2 + t.*(g3 - g2);
    elseif noise == n3
        a_val      = a3;
        lambda_val = l3;
        ga_val     = g3; 
    end
    
    mask23 = (noise >= n2) & (noise < n3);
    if mask23 == true
        t = (noise(mask23) - n2) / (n3 - n2);
        a_val(mask23)      = a2 + t.*(a3 - a2);
        lambda_val(mask23) = l2 + t.*(l3 - l2);
        ga_val(mask23)     = g2 + t.*(g3 - g2);
    end
    
    low  = noise < n1;
    high = noise > n3;
    
    if strcmpi(mode,'clip')
        if low == true
            a_val(low)      = a1;
            lambda_val(low) = l1;
            ga_val(low)     = g1;
        end
        if high == true
            a_val(high)      = a3;
            lambda_val(high) = l3;
            ga_val(high)     = g3;
        end
    elseif strcmpi(mode,'extrap')
        if low == true
            t = (noise(low) - n1) / (n2 - n1);
            a_val(low)      = a1 + t.*(a2 - a1);
            lambda_val(low) = l1 + t.*(l2 - l1);
            ga_val(low)     = g1 + t.*(g2 - g1);
        end
        if high == true
            t = (noise(high) - n2) / (n3 - n2);
            a_val(high)      = a2 + t.*(a3 - a2);
            lambda_val(high) = l2 + t.*(l3 - l2);
            ga_val(high)     = g2 + t.*(g3 - g2);
        end
    end
end