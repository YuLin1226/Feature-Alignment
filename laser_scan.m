clear;
close all;
clc;
%% Create Scan Points

case_num = 1;
x = []; y = [];
noise_mag = 2;
switch case_num
    
    case 1
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
        
    case 2
        % Create horizontal line
        for i = 1:50
            new_x = 50 + noise_mag*(rand - 0.5);
            new_y = i + noise_mag*(rand - 0.5);
            x = [x, new_x];
            y = [y, new_y];
        end

        % Create vertical line
        for i = 1:50
            new_x = x(end) - 1 + noise_mag*(rand - 0.5);
            new_y = y(end) + noise_mag*(rand - 0.5);
            x = [x, new_x];
            y = [y, new_y];
        end

        % Create circle
        for i = 1:50
            new_x = x(end) + noise_mag*(rand - 0.5);
            new_y = y(end) -1 + noise_mag*(rand - 0.5);
            x = [x, new_x];
            y = [y, new_y];
        end
        
    case 3
        % Create horizontal line
        for i = 1:50
            new_x = i + noise_mag*(rand - 0.5);
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
end
%% Plot Original Scan Points
% plot(x,y,'b.'); hold on;
% axis([-10,130,-10,70]);

%% Test
% subplot(212);
% dx = diff(x)/0.044; dy = diff(y)/0.044;
% ddx = diff(dx)/0.044; ddy = diff(dy)/0.044;
% dx = dx(2:end); dy = dy(2:end);
% k = (dx.*ddy - ddx.*dy)./(dx.^2 + dy.^2).^1.5;
% plot((1:length(k))*1, k);
%% Segmentation
% ---
% If d_threshold is :
% 1) too small, then a line will be segmented into several pieces.
% 2) too large, corners will be included in lines.
% ---
d_threshold = 5;
% left_seg = {};
% right_seg = {};
seg = {};
for i = 1 : length(x)
%     % Given Point
%     x_left  = x(1 : i);
%     y_left  = y(1 : i);
%     x_right = x(i : end);
%     y_right = y(i : end);
%     
%     d_sum = 0;
%     for L = 1 : length(x_left) - 1
%         
%         d = cal_dist( x_left(end - L) , y_left(end - L) , x_left(end) , y_left(end) );
%         d_sum  = d_sum + cal_dist( x_left(end - L) , y_left(end - L) , x_left(end - L + 1) , y_left(end - L + 1) );
%         
%         if (d_sum - d) > d_threshold || L == length(x_left) - 1
%             
%             data_cell = { x_left(end - L +1 : end) , y_left(end - L +1 : end) };
%             left_seg = cat(1, left_seg, data_cell);
%             
%             break;
%         end
%     end
% 
%     
%     d_sum = 0;
%     for R = 1 : length(x_right) - 1
%         
%         d = cal_dist( x_right(1) , y_right(1) , x_right(R+1) , y_right(R+1) );
%         d_sum  = d_sum + cal_dist( x_right(R) , y_right(R) , x_right(R+1) , y_right(R+1) );
%         
%         if (d_sum - d) > d_threshold
% 
%             data_cell = { x_right(1 : R) , y_right(1 : R) };
%             right_seg = cat(1, right_seg, data_cell);
% 
%             break;
%         end
%     end

    d_sum = 0;
    for L = 1 : length(x) - 1
        
        d = cal_dist( x(L+1) , y(L+1) , x(1) , y(1) );
        d_sum  = d_sum + cal_dist( x(L) , y(L) , x(L + 1) , y(L + 1) );
        
        if (d_sum - d) > d_threshold || L == length(x) - 1
            
            data_cell = { x(1:L) , y(1:L) ,{}};
            seg = cat(1, seg, data_cell);
            x = x(L:end);
            y = y(L:end);

            break;
        end
    end

    if length(x) <= 2
        seg{end,1} = [ seg{end,1} , x(end)];
        seg{end,2} = [ seg{end,2} , y(end)];
        break;
    end
end

%% Plot Segments
subplot(211);
for i = 1 : size(seg,1)
    x = seg{i,1};
    y = seg{i,2};

    plot(x,y,'.');
    hold on;
end
axis([-10,130,-10,70]);

%% Mark Types of Segments
% ---
% If shape_thres is :
% 1) too small, then a line will be identified as a circle.
% 2) too large, then a part of cirlce maybe seen as a line.
% ---
shape_thres = 0.07;
for i = 1 : size(seg,1)
    x = seg{i,1};
    y = seg{i,2};

    x1 = x(1); 
    y1 = y(1);
    
    xn = x(end);
    yn = y(end);
    
    xm = mean(x);
    ym = mean(y);
    
    v1m = [xm - x1, ym - y1];
    vmn = [xn - xm, yn - ym];
    v1n = [xn - x1, yn - y1];
    
    arc1 = cal_arccos(v1m, vmn);
    arc2 = cal_arccos(v1m, v1n);
    arc3 = cal_arccos(vmn, v1n);
    
    if mean([arc1, arc2, arc3]) < shape_thres
        seg{i,3} = "line";
        text(xm,ym,"line")
    else
        seg{i,3} = "circle";
        text(xm,ym,"circle")
    end
        
end

%%  Corner Detection and Merger Operation
k = 0;
i = 0;
circle_thres = (pi/180) * 60;
corner_thres = 0.7;
for j = 1 : length(seg) - 1 
%     i = j;
    i = i + 1 + k;
    k = 0;
    
    
    x1 = seg{i,1};   y1 = seg{i,2};
    x1m = mean(x1);  y1m = mean(y1);
    x2 = seg{i+1,1}; y2 = seg{i+1,2};
    x2m = mean(x2);  y2m = mean(y2);

%     val = cal_arccos([x1(end) - x1m, y1(end) - y1m], [x2m - x2(1), y2m - y2(1)]);
    val = cal_arccos([x1(end) - x1(1), y1(end) - y1(1)], [x2(end) - x2(1), y2(end) - y2(1)]);
    
    if seg{i,3} == "circle"
            
        % circle , circle
        if seg{i,3} == seg{i+1,3}   
                % 合併Operation
                seg{i,1} = [ seg{i,1} , seg{i+1,1} ];
                seg{i,2} = [ seg{i,2} , seg{i+1,2} ];
                seg(i+1,:) = [];
                k = -1;
%             % 合併circle
%             if val < circle_thres   
%                 k = -1;
%                 text(x1(end), y1(end), "\leftarrow Circle Merge",'Color','blue');
%                 
%                 % 合併Operation
%                 seg{i,1} = [ seg{i,1} , seg{i+1,1} ];
%                 seg{i,2} = [ seg{i,2} , seg{i+1,2} ];
%                 seg(i+1,:) = [];
%                 
%                 
%                 
%             else
%                 text(x1(end), y1(end), "\leftarrow undefined",'Color','red');
%             end
            
        % circle , line   
        else                        
   
            % 判斷轉角
            if val > corner_thres  
                k = 0;
                text(x1(end), y1(end), "\leftarrow Corner Here",'Color','blue');
            % 合併circle
            else
                k = -1;
                text(x1(end), y1(end), "\leftarrow Circle Merge",'Color','blue');
                
                % 合併Operation
                seg{i,1} = [ seg{i,1} , seg{i+1,1} ];
                seg{i,2} = [ seg{i,2} , seg{i+1,2} ];
                seg(i+1,:) = [];
            end
            
        end
        
    % seg{i,3} == "line"    
    else 
        
        % line , line
        if seg{i,3} == seg{i+1,3}   
            
            
            % 判斷轉角
            if val > corner_thres  
                k = 0;
                text(x1(end), y1(end), "\leftarrow Corner Here",'Color','blue');
                
            % 合併line
            else
                k = -1;
                text(x1(end), y1(end), "\leftarrow Line Merge",'Color','blue');
                
                % 合併Operation
                seg{i,1} = [ seg{i,1} , seg{i+1,1} ];
                seg{i,2} = [ seg{i,2} , seg{i+1,2} ];
                seg(i+1,:) = [];
            end
            
        % line , circle
        else                        
            
            
            % 判斷轉角
            if val > corner_thres  
                k = 0;
                text(x1(end), y1(end), "\leftarrow Corner Here",'Color','blue');
                
%             % 合併line
            else
                text(x1(end), y1(end), "\leftarrow Line Merge",'Color','green');
                k = -1;
                % 合併Operation
                seg{i,1} = [ seg{i,1} , seg{i+1,1} ];
                seg{i,2} = [ seg{i,2} , seg{i+1,2} ];
                seg(i+1,:) = [];
                
            end
            
            
        end
        
    end
end

subplot(212)
for i = 1 : size(seg,1)
    x = seg{i,1};
    y = seg{i,2};

    plot(x,y,'.');
    hold on;
end
axis([-10,130,-10,70]);

%% Landmark Output
circle_num = 0;
for i = 1 : size(seg,1)
    if seg{i,3} == "circle"
        circle_num = circle_num + 1;
    end
end
seg
landmark = {"line",{ size(seg,1) - 1 } ; "circle",{ circle_num }};






