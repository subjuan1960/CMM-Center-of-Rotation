clear all; close all; clc

%% Circular fit
filename = './data/micro_test.csv';
% filename = './data/3point_method.csv';
% filename = './equidistant2.csv';
% filename = './J6_measurements.csv';

M = readtable(filename);
P = M{:,:};

r_init = 10; % initial guess of radius
G_init = [P(1,:)+1 r_init]'; % initial guess vector [x y z r]

[Q_opt, P_opt, K, r] = rotCenter(20, P, G_init);

Px = P_opt(:,1);
Py = P_opt(:,2);
Pz = P_opt(:,3);
xrange = min(Px)-10:max(Px)+10;
yrange = min(Py)-10:max(Py)+10;

a = K(1);
b = K(2);
c = K(3);
[x y] = meshgrid(xrange, yrange);
z = a.*x + b.*y + c;

figure()
surf(x,y,z,'FaceAlpha',0.2);
hold on
plot3(Px, Py, Pz,'r*')
plot3(Q_opt(1), Q_opt(2), Q_opt(3),'g*')
grid on
hold on
axis equal

%% finding axis of rot from center of base to tip
% tip_file = './data/3point_method.csv'; % should really be the same file
% M_tip = readtable(tip_file);
% P_tip = M_tip{end,1:3};

rot_axis = P_tip - Q_opt;
quiver3(Q_opt(1),Q_opt(2),Q_opt(3),1*rot_axis(1),1*rot_axis(2),1*rot_axis(3))
grid on 
hold on
axis equal