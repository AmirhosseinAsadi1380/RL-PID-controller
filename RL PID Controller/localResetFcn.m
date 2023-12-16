function in = localResetFcn(in)

% Randomize reference signal

%blk = sprintf('R_test/teta(desired)2');
blk = sprintf('RL_R_flexible_mode1/Desired \nWater Level');

h = 0.1*randn + 0.5 ;
while h <= 0.45 || h >= 0.6
    h = 0.1*randn + 0.5  ;
end
in = setBlockParameter(in,blk,'Value',num2str(h));

end
