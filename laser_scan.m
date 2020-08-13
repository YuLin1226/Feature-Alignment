clear;
clc;
%% Case 1
x = [];
y = [];

noise_mag = 0.5;
% Create horizontal line
for i = 1:50
    new_x = 5 + noise_mag*(rand - 0.5);
    new_y = i + noise_mag*(rand - 0.5);
    x = [x, new_x];
    y = [y, new_y];
end

% Create vertical line
for i = 1:50
    new_x = x(end) + 1 + noise_mag*(rand - 0.5);
    new_y = y(end) + noise_mag*(rand - 0.5);
    x = [x, new_x];
    y = [y, new_y];
end

% Create circle
r = 20;
x_c = x(end) + r * cos(pi/3);
y_c = y(end) - r * sin(pi/3);
for i = 1:90
    new_x = x_c + r*cos(pi/180*i*2 + 2*pi/3) + noise_mag*(rand - 0.5);
    new_y = y_c + r*sin(pi/180*i*2 + 2*pi/3) + noise_mag*(rand - 0.5);
    x = [x, new_x];
    y = [y, new_y];
end

plot(x,y,'b.'); hold on;
axis([-10,90,-10,90]);

%% Algorithm
d_threshold = 1;
left_seg = {};
right_seg = {};
for i = 1 : length(x)
    % Given Point
    x_left  = x(1 : i);
    y_left  = y(1 : i);
    x_right = x(i : end);
    y_right = y(i : end);
    
    d_sum = 0;
    for L = 1 : length(x_left) - 1
        
        d = cal_dist( x_left(end - L) , y_left(end - L) , x_left(end) , y_left(end) );
        d_sum  = d_sum + cal_dist( x_left(end - L) , y_left(end - L) , x_left(end - L + 1) , y_left(end - L + 1) );
        
        if (d_sum - d) > d_threshold
            
            data_cell = { x_left(end - L +1 : end) , y_left(end - L +1 : end) };
            left_seg = cat(1, left_seg, data_cell);
            
            break;
        end
    end

    
    d_sum = 0;
    for R = 1 : length(x_right) - 1
        
        d = cal_dist( x_right(1) , y_right(1) , x_right(R+1) , y_right(R+1) );
        d_sum  = d_sum + cal_dist( x_right(R) , y_right(R) , x_right(R+1) , y_right(R+1) );
        
        if (d_sum - d) > d_threshold

            data_cell = { x_right(1 : R) , y_right(1 : R) };
            right_seg = cat(1, right_seg, data_cell);

            break;
        end
    end
    
end

x = left_seg{1,1};
y = left_seg{1,2};

plot(x,y,'r.');









