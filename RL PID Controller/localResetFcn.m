function in = localResetFcn(in)

% Randomize reference signal

%blk = sprintf('R_test/teta(desired)2');
blk = sprintf('RL_R_flexible_mode1/Desired \nWater Level');

h = 0.1*randn + 0.5 ;
while h <= 0.45 || h >= 0.6
    h = 0.1*randn + 0.5  ;
end
in = setBlockParameter(in,blk,'Value',num2str(h));

% % Randomize initial teta
% h = 0.5*randn ;
% while h <= 0 || h >= 2
%     h = 0.5*randn ;
% end
% % blk = 'R_test/plant2/Integrator1';
% blk = 'RL_R_flexible_mode1/Water-Tank System1/Integrator1';
% in = setBlockParameter(in,blk,'InitialCondition',num2str(h));

end