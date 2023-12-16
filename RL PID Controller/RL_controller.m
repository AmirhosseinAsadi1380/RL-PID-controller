clc ; clear ; 
%% Environment 
%observation
observationInfo = rlNumericSpec([7 1],'LowerLimit',-inf*ones(7,1),'UpperLimit',inf*ones(7,1));
observationInfo.Name = 'observations';
%action 
actionInfo = rlNumericSpec([3 1],'LowerLimit',[0;0;0],'UpperLimit',[100;100;100]);
actionInfo.Name = 'accel;steer';

env = rlSimulinkEnv('RL_controller','RL_controller/RL Agent',...
   observationInfo,actionInfo);
% reset the initial conditions
%env.ResetFcn = @(in)localResetFcn(in);  
Ts = 0.05 ;
Tf = 10;
rng(0)

%% Agent 

statePath = [
    featureInputLayer(7,'Normalization','none','Name','State')
    fullyConnectedLayer(64,'Name','CriticStateFC1')
    reluLayer('Name','CriticRelu1')
    fullyConnectedLayer(32,'Name','CriticStateFC2')];
actionPath = [
    featureInputLayer(3,'Normalization','none','Name','Action')
    fullyConnectedLayer(32,'Name','CriticActionFC1')];
commonPath = [
    additionLayer(2,'Name','add')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(1,'Name','CriticOutput')];

criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');

criticOpts = rlRepresentationOptions('LearnRate',1e-03,'GradientThreshold',1);

critic = rlQValueRepresentation(criticNetwork,observationInfo,actionInfo,'Observation',{'State'},'Action',{'Action'},criticOpts);

actorNetwork = [
    featureInputLayer(7,'Normalization','none','Name','State')
    fullyConnectedLayer(3, 'Name','actorFC')
    tanhLayer('Name','actorTanh')
    fullyConnectedLayer(3,'Name','Action')
    ];

actorOptions = rlRepresentationOptions('LearnRate',1e-04,'GradientThreshold',1);

actor = rlDeterministicActorRepresentation(actorNetwork,observationInfo,actionInfo,'Observation',{'State'},'Action',{'Action'},actorOptions);

agentOpts = rlDDPGAgentOptions(...
    'SampleTime',Ts,...
    'TargetSmoothFactor',1e-3,...
    'DiscountFactor',1.0, ...
    'MiniBatchSize',64, ...
    'ExperienceBufferLength',1e6); 
agentOpts.NoiseOptions.Variance = 0.3;
agentOpts.NoiseOptions.VarianceDecayRate = 1e-5;

agent = rlDDPGAgent(actor,critic,agentOpts) ; 



%% Train 

maxepisodes = 4000;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes, ...
    'MaxStepsPerEpisode',maxsteps, ...
    'ScoreAveragingWindowLength',10, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',1e9);

% trainOpts.SaveAgentCriteria = "AverageReward";
% trainOpts.SaveAgentValue = 2300 ;
% trainOpts.SaveAgentDirectory = pwd + "\run1\Agents" ; 

doTraining = true ;

if doTraining
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
else
    % Load the pretrained agent for the example.
    load('Agent1564.mat','agent')
end

simOpts = rlSimulationOptions('MaxSteps',maxsteps,'StopOnError','on');
experiences = sim(env,agent,simOpts);


