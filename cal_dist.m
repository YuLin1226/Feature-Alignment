function dist = cal_dist(xi, yi, xf, yf)
    x = xi - xf;
    y = yi - yf;
    dist = (x^2 + y^2)^0.5;
end