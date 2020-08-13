function value = cal_arccos(v1, v2)
    d1 = sum(v1.^2)^0.5;
    d2 = sum(v2.^2)^0.5;
    
    value = acos(sum(v1.*v2)/(d1*d2));
end