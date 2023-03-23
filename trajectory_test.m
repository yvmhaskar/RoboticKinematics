%% trajectory_test script
clear
close all
% Written by Xiaoran Zha for MAE204 Final Project
% Code for visualizing trajectory created from TrajectoryGenerator

% User Parameters:
scale = 40; % The size of x, y, z axes of e-e frame shown on graph
arrowWidth = 2; % Linewidth of x, y, z axes
plotSample = 20; % Plot for every # state of .csv file
T = readtable('trajectoryOutput.csv'); % .csv output of TrajectoryGenerator
% 3D plot axes limits
xmin = 0;
xmax = 600;
ymin = -400;
ymax = 200;
zmin = 0;
zmax = 400;
% Camera rotation (degrees)
camera_xyrotation = 120;
camera_elevation = 30;




traj = table2array(T);
traj_len = size(traj,1);

% Initialize animation output
obj = VideoWriter('trajectory');
obj.Quality = 100;
obj.FrameRate = 10;
open(obj)

figure(1)
i = 1;
% Extract SE(3) components from .csv
r11 = traj(i,1); r12 = traj(i,2); r13 = traj(i,3);
r21 = traj(i,4); r22 = traj(i,5); r23 = traj(i,6);
r31 = traj(i,7); r32 = traj(i,8); r33 = traj(i,9);
px = traj(i,10); py = traj(i,11); pz = traj(i,12);

% Create x, y, z axes for e-e frame
quiver3(px,py,pz,r11,r21,r31,scale,'r','LineWidth',arrowWidth)
hold on
rotate3d on
quiver3(px,py,pz,r12,r22,r32,scale,'b','LineWidth',arrowWidth)
quiver3(px,py,pz,r13,r23,r33,scale,'g','LineWidth',arrowWidth)

timestep = 0.01*plotSample;
xlim ([xmin, xmax]);
ylim ([ymin, ymax]);
zlim ([zmin, zmax]);
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
title('End-effector Trajectory')

f = getframe(gcf);
% Rotate camera view
view(camera_xyrotation,camera_elevation)
writeVideo(obj,f);


% Iterate for every plotSample'th line of .csv
for j = 1:round(traj_len/plotSample)
    i = j*plotSample;
    % Extract SE(3) components from .csv
    r11 = traj(i,1); r12 = traj(i,2); r13 = traj(i,3);
    r21 = traj(i,4); r22 = traj(i,5); r23 = traj(i,6);
    r31 = traj(i,7); r32 = traj(i,8); r33 = traj(i,9);
    px = traj(i,10); py = traj(i,11); pz = traj(i,12);

    % Create x, y, z axs for e-e frame
    quiver3(px,py,pz,r11,r21,r31,scale,'r','LineWidth',arrowWidth)
    quiver3(px,py,pz,r12,r22,r32,scale,'b','LineWidth',arrowWidth)
    quiver3(px,py,pz,r13,r23,r33,scale,'g','LineWidth',arrowWidth)
    f = getframe(gcf);
    writeVideo(obj,f);

    pause(timestep)
    
    
end
hold off
fprintf("Plot ended, generating video \n")
obj.close()