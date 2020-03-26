
clear;
close all;
clc

% load Full_FORCE\g_10_N_1000\rightArmRaise_g_10_N_1000.mat
% load Full_FORCE\g_10_N_1000\rightArmScaption_g_10_N_1000.mat
% load Full_FORCE\g_18_N_1000\rightLegRaise_g_18_N_1000.mat
% load Full_FORCE/g_18_N_1000/deepSquat_g_18_N_1000.mat
% load Full_FORCE/g_18_N_1000/hurdelStep_g_18_N_1000.mat

% load RFORCE\g_18_N_1000\rightArmRaise_g_18_N_1000.mat
% load RFORCE\g_15_N_1000\deepSquat_g_15_N_1000.mat
% load RFORCE\g_18_N_1000\rightLegRaise_g_18_N_1000.mat
% load RFORCE/g_18_N_1000/hurdleStep_g_18_N_1000.mat
% load RFORCE/g_18_N_1000/hurdleStep_g_18_N_1000.mat
load matlab.mat

J = [4, 6, 5, 3, 2, 4, 7, 8, 9, 4, 11,  12, 13, 1,  15, 16, 17, 1,  19, 20, 21;
    3, 5, 3, 2, 1, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22];

% %% Simplified
% J = [4, 4, 3, 2, 4, 12, 4, 7, 1, 1;
%      6, 3, 2, 1, 12, 14, 7, 10, 20, 16];


% 1 Waist (absolute)
% 2 Spine
% 3 Chest
% 4 Neck
% 5 Head
% 6 Head tip
% 7 Left collar
% 8 Left upper arm
% 9 Left forearm
% 10 Left hand
% 11 Right collar
% 12 Right upper arm
% 13 Right forearm
% 14 Right hand
% 15 Left upper leg
% 16 Left lower leg
% 17 Left foot
% 18 Left leg toes
% 19 Right upper leg
% 20 Right lower leg
% 21 Right foot
% 22 Right leg toes


minz = min(min(skel(:,1,:)));
maxz = max(max(skel(:,1,:)));
miny = min(min(skel(:,2,:)));
maxy = max(max(skel(:,2,:)));
minx = min(min(skel(:,3,:)));
maxx = max(max(skel(:,3,:)));

% visualize the skeletons
[m,n,p,q] = size(Simulation_skel);

Simulation_skel_single = reshape(Simulation_skel(1,:,:,:),n,p,q);
num_frames = size(Simulation_skel,4);

%%
%
% temp1 = reshape(Testing_error(7,:,:),3,22)
% for i =1 :22
%     for j = 1:3
%         temp2 = reshape(Simulation_skel_single(i,j,:),1,14235);
%         temp3 = reshape(period_data(i,j,:),1,949);
%         temp3 = interp(temp3,1 / dt);
%
%         norm(temp3 - temp2)
%         % load bodyMovementTrainingDataAugmented.mat
%         figure(3*i-3+j)
%         hold on
%         plot(temp2)
%         plot(temp3)
%         pause(0.01)
%     end
% end


%
% Simulation_skel_single = Simulation_skel;
% num_frames = size(Simulation_skel,3);
filename = 'testAnimated.gif';
axis tight manual
f1 = figure(1);
for i = 1:1:num_frame*2
    
    % Plotting ground truth
    subplot (2,2,[1 3])
    joint_gt = skel(:,:,i);
    
    h = plot3(joint_gt(:,3), joint_gt(:,1), joint_gt(:,2), 'b.', 'MarkerSize', 50);
    h.LineWidth = 20;
    xlabel('X'); ylabel('Z'); zlabel('Y');
    
    set(gca,'DataAspectRatio',[1 1 1])
    
    for j = 1:size(J,2)
        point1 = joint_gt(J(1,j),:);
        point2 = joint_gt(J(2,j),:);
        l1 = line([point1(3),point2(3)], [point1(1),point2(1)], [point1(2),point2(2)],'LineWidth',10);
        l1.LineStyle = '--';
    end
    axis([minx maxx minz maxz miny maxy]);
    grid;
    title("Ground Truth");
    axis off
    grid off
    set(gcf,'nextplot','replacechildren','Position', [100, 100, 400, 300]);
    view(40,20)
    if i==num_frames
        close all
        hold off
    end
    
    % Plotting prediction
    subplot (2,2,[2 4])
    joint = Simulation_skel_single(:,:,i*15);
    
    h = plot3(joint(:,3), joint(:,1), joint(:,2), 'g.', 'MarkerSize', 50);
    hold on
    h.LineWidth = 20;
    xlabel('X'); ylabel('Z'); zlabel('Y');
    
    set(gca,'DataAspectRatio',[1 1 1]);
    
    for j = 1:size(J,2)
        point1 = joint(J(1,j),:);
        point2 = joint(J(2,j),:);
        line([point1(3),point2(3)], [point1(1),point2(1)], [point1(2),point2(2)], 'LineWidth',10);
    end
    hold off
    axis([minx maxx minz maxz miny maxy]);
    grid;
    title("Prediction");
    axis off
    grid off
    set(gcf,'nextplot','replacechildren','Position', [100, 100, 400, 300]);
    view(40,20)

    pause(0.001)
    
    
    drawnow
    % capture the plot as an image
    frame = getframe(f1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if i == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
    
end

% num_joint = (1:1:22);
% figure(1)
% scatter(num_joint, Training_error(:,1),'filled','SizeData',80)
% hold on
% scatter(num_joint, Training_error(:,2),'filled','SizeData',80)
% scatter(num_joint, Training_error(:,3),'filled','SizeData',80)
% title(["Training error when r, g, N = ", [num2str(1 / dt),', ', num2str(g),',',num2str(N)]])
%
%
% figure(2)
% scatter(num_joint, Testing_error(:,1),'filled','SizeData',80)
% hold on
% scatter(num_joint, Testing_error(:,2),'filled','SizeData',80)
% scatter(num_joint, Testing_error(:,3),'filled','SizeData',80)
% title(["Testing error when r, g, N = ", [num2str(1 / dt),', ', num2str(g),',',num2str(N)]])

% figure(3)
% scatter(num_joint, Training_time(:,1))
% hold on
% scatter(num_joint, Training_time(:,2))
% scatter(num_joint, Training_time(:,3))
% title(["Training time when r, g, N = ", [num2str(1 / dt),', ', num2str(g),',',num2str(N)]])
%
%
% figure(4)
% scatter(num_joint, Testing_time(:,1))
% hold on
% scatter(num_joint, Testing_time(:,2))
% scatter(num_joint, Testing_time(:,3))
% title(["Testing time when r, g, N = ", [num2str(1 / dt),', ', num2str(g),',',num2str(N)]])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Functions

function [ R ] = eulers_2_rot_matrix(x)
%EULER_2_ROT_MATRIX transforms a set of euler angles into a rotation  matrix
% input vector of euler angles
% [gamma_x, beta_y, alpha_z]  are ZYX Eulers angles in radians
gamma_x=x(1);beta_y=x(2);alpha_z=x(3);
R = rotz(alpha_z) * roty(beta_y) * rotx(gamma_x);
end

function r = rotx(t)
% ROTX Rotation about X axis
ct = cos(t);
st = sin(t);
r =    [1	0	0
    0	ct	-st
    0	st	ct];
end

function r = roty(t)
% ROTY Rotation about Y axis
ct = cos(t);
st = sin(t);
r =    [ct	0	st
    0	1	0
    -st	0	ct];
end

function r = rotz(t)
%ROTZ Rotation about Z axis
ct = cos(t);
st = sin(t);
r =    [ct	-st	0
    st	ct	0
    0	0	1];
end