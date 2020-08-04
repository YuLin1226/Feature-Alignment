clear; 
clc;
%%
scan1 = [25,11;
         25,12;
         25,13;
         25,14;
         25,15;
         25,16;
         25,17;
         25,18;
         25,19;
         25,20]';

s = sin(pi/4);
c = cos(pi/4);
T = [5,5];
scan2 = [c,-s;s,c] * scan1 + T';

%% Create Grid Map
map = zeros(100,100);
for i = 1:length(scan1)
    x = scan1(1,i);
    y = scan1(2,i);
    map(x,y) = -1;
end

map2 = zeros(100,100);
for i = 1:length(scan2)
    x = floor(scan2(1,i));
    y = floor(scan2(2,i));
    map2(x,y) = -1;
end

%% plot map
for i = 1 : 100
    for j = 1: 100
        if map(i,j) == -1
            rectangle('position',[i j 1 1], 'FaceColor', 'k'); hold on;
        end
    end
end
rectangle('position',[0, 0, 100, 100]*0.5);

for i = 1 : 100
    for j = 1: 100
        if map2(i,j) == -1
            rectangle('position',[i j 1 1], 'FaceColor', 'r'); hold on;
        end
    end
end

%%
% pose = [5,5,pi/4]
% x = pose(1);
% y = pose(2);
% yaw = pose(3);
% 
% c = cos(yaw);
% s = sin(yaw);
% 
% T = [x;y];
% R = [c,-s;
%      s, c];
% 
% scan = inv(R)*(scan2 - T);
% 
% f = 100;
% for i = 1:length(scan)
%     x = floor(scan(1,i));
%     y = floor(scan(2,i));
%     f = f + map(x,y);
% end
% f


%% Optimization
A = [];
B = [];
Aeq = [];
Beq = [];
lb = [-50,-50,-pi];
ub = [50,50,pi];
nonlcon = [];
pose = [1,1,pi/6];
% [Con , ConEq] = NonlinearConstraints(r);T
% nonlcon = [Con , ConEq]

options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
[pose_min, fval] = fmincon('obj', pose, A, B, Aeq, Beq, lb, ub, nonlcon, options)

