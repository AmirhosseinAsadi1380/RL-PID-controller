This GitHub project uses reinforcement learning to optimize the parameters of a PID controller for control of a flexible manipulator. The goal is to improve the manipulator's performance by dynamically adjusting the PID controller to counteract system flexibility and uncertainties.

The project consists of three parts:
 - RL_controller.m: It defines the environment, agent, and train properties for the learning process. Also, this code is coupled with the Simulink file as well.
 - localResetFcn.m: To reset the initial conditions for the learning process.
 - RL_controller.slx: The Simulink file contains the dynamic model of the flexible manipulator as the plant, the PID controller, and the agent.
 - 
![Screenshot 2023-12-16 210336](https://github.com/AmirhosseinAsadi1380/RL-PID-controller/assets/153992265/3ad25000-50ea-45e7-b5be-f0953b540730)
