%  MATLAB Source Codes for the book "Cooperative Decision and Planning for
%  Connected and Automated Vehicles" published by Mechanical Industry Press
%  in 2020.
% ��������������Эͬ������滮�������鼮���״���
%  Copyright (C) 2020 Bai Li
%  2020.02.14
% ==============================================================================
%  ������ 4.2��.���ڶ�̬�滮�Ľṹ����·��һ�����켣���߷���
% ==============================================================================
% ��ע��
% 1. ������ת��ʱ���ܻ���΢��ײ�ϰ���ⲻ��Bug,��Frenet����ϵ�н�������Ϊ����ײ��
% �������ڵѿ�������ϵ�г��ֶ�̬���ʱ���ῴ��ȥ����ײ��������ײԣ�Ȼ��������⡣
% ==============================================================================
clear all; close all; clc
% % ��������
global vehicle_geometrics_ % �����������γߴ�
vehicle_geometrics_.vehicle_wheelbase = 2.8;
vehicle_geometrics_.vehicle_front_hang = 0.96;
vehicle_geometrics_.vehicle_rear_hang = 0.929;
vehicle_geometrics_.vehicle_width = 1.942;
vehicle_geometrics_.vehicle_length = vehicle_geometrics_.vehicle_wheelbase + vehicle_geometrics_.vehicle_front_hang + vehicle_geometrics_.vehicle_rear_hang;
global vehicle_kinematics_ % �����˶���������
vehicle_kinematics_.vehicle_v_max = 20.0;
global dp_ % �����ռ����
dp_.num_t_grids = 5;
dp_.num_s_grids = 7;
dp_.num_l_grids = 8;
dp_.unit_time = 2.0;
dp_.max_unit_s = dp_.unit_time * vehicle_kinematics_.vehicle_v_max;
dp_.min_unit_s = 0;
dp_.ds = linspace(dp_.min_unit_s, dp_.max_unit_s, dp_.num_s_grids);
dp_.dl = linspace(0, 1, dp_.num_l_grids);

global obstacles_ Nobs precise_timeline precise_timeline_index % �ϰ����������
Nobs = 10;
delta_t_precise = 0.05;
precise_timeline = [0 : delta_t_precise : (dp_.unit_time * dp_.num_t_grids)];
precise_timeline_index = cell(1,dp_.num_t_grids);
ind = round(linspace(1, length(precise_timeline), dp_.num_t_grids + 1));
for ii = 1 : dp_.num_t_grids
    elem.ind1 = ind(ii); elem.ind2 = ind(ii+1);
    precise_timeline_index{1,ii} = elem;
end
obstacles_ = GenerateObstacles(vehicle_kinematics_.vehicle_v_max);
global BV_ % ��ֵ
BV_.s0 = 0;
BV_.l0 = 0.78;
BV_.theta0 = 0;

% % DP�����еĲ�������
dp_.Ncollision = 10000;
dp_.w_relative = 1.0;
dp_.w1 = 1.0;
dp_.w2 = 1.0;
dp_.w3 = 10.0;
% % ���߹켣
tic; [x, y, theta] = SearchDecisionTrajectoryViaDp(); toc
% % ��̬��ʾ���߹켣
Dynamics(x, y, theta);