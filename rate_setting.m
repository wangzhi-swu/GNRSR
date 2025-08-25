function val = rate_setting(noise, rate_pair, n1, n2)
    
    r1=rate_pair(1); r2=rate_pair(2); 
    
    if noise <= n1
        val = r1;
    elseif noise < n2 
        t   = (noise - n1) / (n2 - n1);
        val = r1 + t.*(r2 - r1);
    else 
        val = r2;
    end
    
end