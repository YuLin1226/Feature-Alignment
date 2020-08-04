function f = obj(pose)
 %% Init
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


%%
x = pose(1);
y = pose(2);
yaw = pose(3);

c = cos(yaw);
s = sin(yaw);

T = [x;y];
R = [c,-s;
     s, c];

scan = inv(R)*(scan2 - T);

f = 100;
for i = 1:length(scan)
    x = floor(scan(1,i));
    y = floor(scan(2,i));
    f = f + map(x,y);
end
end