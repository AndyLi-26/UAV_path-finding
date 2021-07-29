%: configer
clc; close all;clear all;
%% get all obs
[M, obs]=t3d_obs_gen('obss/');
M=M(3);obs=obs(3);
%% set up global vars
global uav wp
wp = [200, -1800];
uav = struct("pos",[0,0],"h", 173,"v",23,"z",120,"yaw",20);
%% set options
prt=true;
saveVid=false;
pplot=true;

%% run main with time
tic;
main;
toc