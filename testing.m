clear; close all; clc;
x = [1,2,1];
y = [0,1,2];
plot(x,y);
hold on;

% x1 = x(1); x2 = x(2); x3 = x(3);
% y1 = y(1); y2 = y(2); y3 = y(3);
% 
% a = 2*(x2 - x1);
% b = 2*(y2 - y1);
% c = x1^2 + y1^2 - x2^2 - y2^2;
% d = 2*(x3 - x1);
% e = 2*(y3 - y1);
% f = x1^2 + y1^2 - x3^2 - y3^2;
% 
% yc = (a*f-c*d)/(b*d-a*e);
% xc = (yc*b)/a + c/a;
% r = ( (x1 - xc)^2 + (y1 - yc)^2 )^0.5;
[xc , yc , r] = cal_circle(x,y);
for i = 1:360
    cx = xc + r*cos( pi/180 * i );
    cy = yc + r*sin( pi/180 * i );
    plot(cx,cy,'r.'); 
end