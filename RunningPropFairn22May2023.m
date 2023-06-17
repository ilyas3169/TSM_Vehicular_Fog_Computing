% Consmrs =
NMax = 100;    % Keeping number of iterations for Probability Density Function (PDF) (guassian Normal Distribution).....
Tks_array = zeros(NMax,1);          % Storing Number of tasks (random variable) for each iteration 
MOntCarlR_array = zeros(NMax,1);   % Storing MontCarl ration  (random variable) for each iteration
for N = 1:NMax 
Tks_in = randi([100, 300], 1);    % We assume that there are "Tks" number of tasks from the same number of consumers acoss a considered netowrkingn infrastructure...
%Tks_in = 300;
SVs = randi([50, 100], 1);        % We also assume that there "Tks" requests are reciecved in some porportion by potential donor nodes that are "SVs" in total number 
                                 %  that can be vehiculr fog nodes andn also it may be an RSU.At the moment we consider a a random share of these tasks requests by 
                               %  these potentnial donor nodes but these can be more optimized.. 
G1 = randi([0, 1], [Tks_in,1]);   
EnsuringAllTksExecution = 0;
NumallocDA_in = 0;
NumTksAllocSVs_in = 0;
NumTksAllocRSU_in = 0;
NumTksAllocDataCenter_in = 0;
NumTksAllocCloud_in = 0;
%S_in = randi([1, 8], [Tks,1]);            % "S1" is the State-1 or the precvious state (in terms of Estimated Response latency) 
                                           %  of tasks entertained in time period of "T"
S_in = sort(randi([5,200],[Tks_in,1]));     % This values is in milliseconds, and we have obtained this value from published work titled "Driving in the fog: Latency Measurement, Modeling, and Optimization of LTE-based fog computing 
                                          % for smart vehicles"
StoreTksIndx_in = 1;          % "StoreTksIndx_in" is used to designate the index of the task that is being processed by any donor computing node that may be approached donor node, SVs, RSU, data center or a cloud-server      
CurrentG1index_in = 1;        % "CurrentG1index_in" is used to designate the last index of the task that is executed by current donor node...  
CountAccess_in = 0;            % Count Access is used to designate the number of times a differnt donor node devices has been accessed by consumer's task requests...
Indices_in = 0;
FinalDataX_in = 0; 
FinalDataY_in = 0; 
wait_in = randi([50 400],[Tks_in,1]);       % based on qualitative anlaysis after reading several published articles data...wait is in milliseconds
DeviceCount_in = 0;
Inter_DA_in = 0;
Inter_SA_in = 0;
InterDataCenter_in = 0;
InterCloud_in = 0;
myObj = ProportionalFairnessScheduling(Tks_in,StoreTksIndx_in,SVs,CountAccess_in,G1,CurrentG1index_in,EnsuringAllTksExecution,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in,S_in,Indices_in,FinalDataX_in,FinalDataY_in,wait_in,DeviceCount_in,Inter_DA_in,Inter_SA_in,InterDataCenter_in,InterCloud_in);
count = 0; % To observe number of iterations...that is the number of donor nodes which worked as scheduler and allocators...
while (myObj.EnsuringAllTksExecution == 0)   % At the end of each time-peroid "T", a becaon message is broadcasted which ensures
                                             % that the potentuial donor nodes
                                             % that have least entertained any
                                             % tasks' requests execute any
                                             % remaining unscheduled or
                                             % unallocated tasks out of total
                                             % "Tks" tasks' requests.
%So, once recieved by potential neighborhood donor node, it first
%recalculates the remaining tasks to be scheduled and allocated
% if it can execute the tasks
%if(count > 0)
%    myObj.Tks = myObj.Tks - (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud);
%Tks = myObj.Tks;
% myObj.SVs = round(myObj.SVs/2);
% myObj.G1 = randi([0,1],[myObj.Tks,1]);
%SVs = abs(myObj.SVs/2);
%G1 = randi([0,1],[Tks,1]);
%EnsuringAllTksExecution = (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud) == myObj.Tks;
%NumallocDA_in = myObj.NumallocDA;
%NumTksAllocSVs_in = myObj.NumTksAllocSVs;
%NumTksAllocRSU_in = myObj.NumTksAllocRSU;
%NumTksAllocDataCenter_in = myObj.NumTksAllocDataCenter;
%NumTksAllocCloud_in = myObj.NumTksAllocCloud;

%myObj = TSMSchedueler(Tks,SVs,G1,EnsuringAllTksExecution,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in);
%end
%myObj.EnsuringAllTksExecution = (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud) == myObj.Tks;
% myObj = TSMSchedueler(Tks,SVs,G1,EnsuringAllTksExecution,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in);

if(myObj.EnsuringAllTksExecution == 0)
    % Define the estimated percentage of ones
    p = 0.1;
    % Generate a random array of [Tks,1] values between 0 and 1
    A1 = rand(Tks_in,1);
    % Convert the values to binary based on the threshold
    %A11 = A1 < p;
    myObj.G1  = A1 < p;
    if(size(myObj.G1,1) < Tks_in)
     AppendG1 = Tks_in - size(myObj.G1,1);
     myObj.G1 = [myObj.G1;zeros(AppendG1)];
    end
        % use the "myObj.G1" in round robin scheduler when it calls the donor
    % nodes to scheudler and allocate incoming tasks' requests...
    if (count ~= 0)
     myObj.wait = randi([50 400],[Tks_in,1]);       % based on qualitative anlaysis after reading several published articles data...wait is in milliseconds due 
                                                      % to "cons" of  "proportional fairness" like complexity, trade-off between fairness and efficiency, delay
                                                      % and latency, sensitivity to imperfect channel estimation...
    end
    [myObj] = myObj.ApproachedDonorselec();
%if(myObj.CountAccess == 0)
%myObj.wait = randi([150 200],1);       % based on qualitative anlaysis after reading several published articles data...wait is in milliseconds
%IndicesRtTSchdldDR = myObj.Indices; 
IndicesRtTSchdldDR = myObj.Inter_DA(myObj.Inter_DA ~= 0);
%end
%if(myObj.CountAccess == 1)
%IndicesRtTSchdldDR = myObj.Indices(1:myObj.NumallocDA);
%end

%if(myObj.CountAccess > 1)
%IndicesRtTSchdldDR = myObj.Indices(myObj.NumallocDA+1:myObj.NumallocDA+myObj.CurrentG1index);
%end
%RespT = myObj.StoreTksIndx;
%end
if(count == 0)   % This is local count....
RespT1 = IndicesRtTSchdldDR; % RespT1 contains response time obtained as a result of scheduling by TSM scheduler at any node... 
end
if(count >= 1)   % This is local count....
RespT1 = [RespT1;IndicesRtTSchdldDR]; % RespT1 contains response time obtained as a result of scheduling by TSM scheduler at any node... 
end

if(size(RespT1,1) >= myObj.Tks)
myObj.EnsuringAllTksExecution = 1;
RespT4 = RespT1(1:myObj.Tks);
%Offset1 = size(RespT1,1)-myObj.Tks;
% for i = myObj.Tks+1:Offset1
 %    RespT4(i,1) = [];
 %end

%DeleteIndexend = size(RespT1,1)-Tks;    % End index calculation for "RespT1"
%RespT2 = RespT1(Tks+1:Tks+DeleteIndexend,1)
%RespT2 = RespT1(1:Tks_in);
end

end
if(myObj.EnsuringAllTksExecution == 0)
% Define the estimated percentage of ones
p = 0.2;           % more number of yes decisions because more number of fog nodes exist in the neighborhood as compared to single controller node...
% Generate a random array of [Tks,1] values between 0 and 1
A2 = rand(Tks_in,1);
% Convert the values to binary based on the threshold
A2 = A2(A1 ~= 1); 
myObj.G1 = A2 < p;                                            % G1 has to be updated each time for every potential donor node...
    if(size(myObj.G1,1) < Tks_in)
     AppendG1 = Tks_in - size(myObj.G1,1);
     myObj.G1 = [myObj.G1;zeros(AppendG1)];
    end
myObj.wait = randi([50 400],[Tks_in,1]);       % based on qualitative anlaysis after reading several published articles data...wait is in milliseconds
[myObj] = myObj.FognodesSelec();
%if(myObj.
%IndicesRtTSchdldSVs = myObj.Indices;
IndicesRtTSchdldSVs = myObj.Inter_SA(myObj.Inter_SA ~= 0);
%if(count > 1)   % This is local count....
RespT1 = [RespT1;IndicesRtTSchdldSVs]; % RespT1 contains response time obtained as a result of scheduling by TSM scheduler at any node... 
if(size(RespT1,1) >= myObj.Tks)
myObj.EnsuringAllTksExecution = 1;
RespT4 = RespT1(1:myObj.Tks);
% Offset1 = size(RespT1,1)-myObj.Tks;
% for i = myObj.Tks+1:Offset1
 %    RespT4(i,1) = [];
% end
%DeleteIndexend = size(RespT1,1)-Tks;    % End index calculation for "RespT1"
%RespT2 = RespT1(Tks+1:Tks+DeleteIndexend,1)
% RespT2 = RespT1(1:Tks_in);
end
%end
%myObj.Tks = myObj.Tks - (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud);
%Tks = myObj.myObj.Tks;
%SVs = abs(myObj.SVs\2);
%G1 = randi([0,1],[Tks,1]);
%EnsuringAllTksExecution = (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud) == myObj.Tks;
%NumallocDA_in = myObj.NumallocaDA;
%NumTksAllocSVs_in = myObj.NumTksAllocSVs;
%NumTksAllocRSU_in = myObj.NumTksAllocRSU;
%NumTksAllocDataCenter_in = myObj.NumTksAllocDataCenter;
%NumTksAllocCloud_in = myObj.NumTksAllocCloud;

%myObj = TSMSchedueler(Tks,SVs,G1,EnsuringAllTksExecution,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in);
end

% if(myObj.EnsuringAllTksExecution == 0)   % In round robin, since the scheduling and allocation is centralized , that is, already been handled in the first function 
%                                          % titled
%                                          % "ApproachedDonorselec"...So,
%                                          % commenting this portion to
%                                          % exclude the duplication by
%                                          % involving RSU again......
% [myObj] = myObj.RSUselec();
% IndicesRtTSchdldRSU = myObj.Indices;
% RespT1 = [RespT1;IndicesRtTSchdldRSU]; % RespT1 contains response time obtained as a result of scheduling by TSM scheduler at any node... 
% if(size(RespT1,1) >= Tks)
% myObj.EnsuringAllTksExecution = 1;
% %DeleteIndexend = size(RespT1,1)-Tks;    % End index calculation for "RespT1"
% %RespT2 = RespT1(Tks+1:Tks+DeleteIndexend,1)
% RespT2 = RespT1(1:Tks);
% end
% %myObj.Tks = myObj.Tks - (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud);
%Tks = myObj.myObj.Tks;
%SVs = abs(myObj.SVs\2);
%G1 = randi([0,1],[Tks,1]);
%EnsuringAllTksExecution = (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud) == myObj.Tks;
%NumallocDA_in = myObj.NumallocaDA;
%NumTksAllocSVs_in = myObj.NumTksAllocSVs;
%NumTksAllocRSU_in = myObj.NumTksAllocRSU;
%NumTksAllocDataCenter_in = myObj.NumTksAllocDataCenter;
%NumTksAllocCloud_in = myObj.NumTksAllocCloud;

%myObj = TSMSchedueler(Tks,SVs,G1,EnsuringAllTksExecution,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in);
% end

if(myObj.EnsuringAllTksExecution == 0 && myObj.Tks > 0)
% Define the estimated percentage of ones
p = 0.05;           % Less number of yes decisions because less number of data centers exist in the neighborhood as compared to single controller node...
% Generate a random array of [Tks,1] values between 0 and 1... Also data
% centers feasiblity as a extenal resouce is not very encouraging...
A3 = rand(myObj.Tks,1);
A3 = A3(A1 ~= 1 & A2 ~= 1); 
% Convert the values to binary based on the threshold
myObj.G1 = A3 < p;                                            % G1 has to be updated each time for every potential donor node...
    if(size(myObj.G1,1) < Tks_in)
     AppendG1 = Tks_in - size(myObj.G1,1);
     myObj.G1 = [myObj.G1;zeros(AppendG1)];
    end
% wait_in = randi([110 150],[myObj.Tks,1]);       % based on qualitative anlaysis after reading several published articles data...wait is in milliseconds
myObj.wait = randi([50 400],[Tks_in,1]);       % based on qualitative anlaysis after reading several published articles data...wait is in milliseconds
[myObj] = myObj.DataCenterselec();
% IndicesRtTSchdldDC = myObj.Indices;
IndicesRtTSchdldDC = myObj.InterDataCenter(myObj.InterDataCenter ~= 0);
RespT1 = [RespT1;IndicesRtTSchdldDC]; % RespT1 contains response time obtained as a result of scheduling by TSM scheduler at any node... 
if(size(RespT1,1) >= myObj.Tks)
myObj.EnsuringAllTksExecution = 1;
RespT4 = RespT1(1:myObj.Tks);
%Offset1 = size(RespT1,1)-myObj.Tks;
 %for i = myObj.Tks+1:Offset1
 %    RespT4(i,1) = [];
 %end
%DeleteIndexend = size(RespT1,1)-Tks;    % End index calculation for "RespT1"
%RespT2 = RespT1(Tks+1:Tks+DeleteIndexend,1)
%RespT2 = RespT1(1:Tks_in);
end
%myObj.Tks = myObj.Tks - (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud);
%Tks = myObj.myObj.Tks;
%SVs = abs(myObj.SVs\2);
%G1 = randi([0,1],[Tks,1]);
%EnsuringAllTksExecution = (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud) == myObj.Tks;
%NumallocDA_in = myObj.NumallocaDA;
%NumTksAllocSVs_in = myObj.NumTksAllocSVs;
%NumTksAllocRSU_in = myObj.NumTksAllocRSU;
%NumTksAllocDataCenter_in = myObj.NumTksAllocDataCenter;
%NumTksAllocCloud_in = myObj.NumTksAllocCloud;

%myObj = TSMSchedueler(Tks,SVs,G1,EnsuringAllTksExecution,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in);
end

if(myObj.EnsuringAllTksExecution == 0)
    % Define the estimated percentage of ones
p = 0.01;           % Least number of yes decisions because less number of Cloud servers exist in the neighborhood as compared to single controller node...
% Generate a random array of [Tks,1] values between 0 and 1... Also cloud servers' feasiblity as a extenal resouce is not very encouraging...
A4 = rand(myObj.Tks,1);
A4 = A4(A1 ~= 1 & A2 ~= 1 & A3 ~= 1); 
% Convert the values to binary based on the threshold
myObj.G1 = A4 < p;   
% wait_in = randi([150 200],[myObj.Tks,1]);       % based on qualitative anlaysis after reading several published articles data...wait is in milliseconds
myObj.wait = randi([50 400],[Tks_in,1]);       % based on qualitative anlaysis after reading several published articles data...wait is in milliseconds
    if(size(myObj.G1,1) < Tks_in)
     AppendG1 = Tks_in - size(myObj.G1,1);
     myObj.G1 = [myObj.G1;zeros(AppendG1)];
    end
[myObj] = myObj.CloudSelec();
% IndicesRtTSchdldCS = myObj.Indices;
IndicesRtTSchdldCS = myObj.InterCloud(myObj.InterCloud ~= 0);
RespT1 = [RespT1;IndicesRtTSchdldCS]; % RespT1 contains response time obtained as a result of scheduling by TSM scheduler at any node... 
if(size(RespT1,1) >= myObj.Tks)
myObj.EnsuringAllTksExecution = 1;
RespT4 = RespT1(1:myObj.Tks);
% Offset1 = size(RespT1,1)-myObj.Tks;
%  for i = myObj.Tks+1:Offset1
%      RespT4(i,1) = [];
%  end
% indexoffset = size(RespT1,1) - myObj.Tks;
%DeleteIndexend = size(RespT1,1)-Tks;    % End index calculation for "RespT1"
%RespT2 = RespT1(Tks+1:Tks+DeleteIndexend,1)
% RespT2 = RespT1(1:Tks_in);
end
%myObj.Tks = myObj.Tks - (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud);
%Tks = myObj.myObj.Tks;
%SVs = abs(myObj.SVs\2);
%G1 = randi([0,1],[Tks,1]);
%EnsuringAllTksExecution = (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud) == myObj.Tks;
%NumallocDA_in = myObj.NumallocaDA;
%NumTksAllocSVs_in = myObj.NumTksAllocSVs;
%NumTksAllocRSU_in = myObj.NumTksAllocRSU;
%NumTksAllocDataCenter_in = myObj.NumTksAllocDataCenter;
%NumTksAllocCloud_in = myObj.NumTksAllocCloud;

%myObj = TSMSchedueler(Tks,SVs,G1,EnsuringAllTksExecution,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in);
end
%if(count > 0)
   % myObj.Tks = myObj.Tks - (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud);
%end
%[myObj] = myObj.ApproachedDonorselec();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Storing values of x-axis and y-axis for monte carlo graphs for "TSMScheduler"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if(count == 0)
%    TKs_MonteCarlo = myObj.Tks;
%    RespT = myObj.S;
 %   TimeRsMonteCarlo = RespT(myObj.StoreTksIndx);
    % TimeRsMonteCarlo = myObj.S;
%end
%if(count == 0)
%RespT1 = [IndicesRtTSchdldDR;IndicesRtTSchdldSVs;IndicesRtTSchdldRSU;IndicesRtTSchdldDC;IndicesRtTSchdldCS];
%end
count = count+1;
end
%if(count == 0)
    % TKs_MonteCarlo = myObj.Tks;
    % TKs_MonteCarlo = myObj.Tks;
    % RespT2 = RespT1;
    RespT2 = RespT1;
    if(size(RespT1,1) >= myObj.Tks)
    RespT2 = RespT4;
    end
    %RespT5 = myObj.S(RespT4);
    %TimeRsMonteCarlo = RespT5;
    TimeRsMonteCarlo = RespT2;
    TKs_MonteCarlo = Tks_in;
    RespT = myObj.S;
    %TimeRsMonteCarlo = RespT(RespT2);
    IndicesTSMTimeresponse = find(myObj.S); 
    %TimeRsMonteCarlo = RespT(IndicesTSMTimeresponse);
    % TimeRsMonteCarlo = RespT(RespT2);
    % TimeRsMonteCarlo = RespT(RespT1);
    myObj.FinalDataY = TimeRsMonteCarlo;
    % myObj.FinalDataX = myObj.Tks;
    myObj.FinalDataX = Tks_in;
    myObj.Indices = RespT2;

    % TimeRsMonteCarlo = myObj.S;
%end
%ax1 = axes(t);
% ax1 = gca;
% %if(myObj.EnsuringAllTksExecution == 1)             % Generating monte carlo graphs for "TSMScheduler"
%   % plot(ax1,1:TKs_MonteCarlo,TimeRsMonteCarlo,'LineStyle','-','Marker','*','Color','r');
%   plot(ax1,1:TKs_MonteCarlo,TimeRsMonteCarlo,'LineStyle','-','Marker','*','Color','r');
%   % ylim([0 250]);
%   % ylim([0 400]);
%   % ylim([0 1250]);
%   ylim([0 700]);
%   xlabel('Number of Tasks');
%   ylabel('Response Time (milliseconds)');
%   set(ax1,'XColor','black','YColor','black','FontWeight', 'bold');
%   % ax1.XColor = 'r';
%   % ax1.YColor = 'r';
% %end
% hold on;
% Generate "TKs_MonteCarlo" number of random sample points (response time)
%myObj.StoreTksIndx
%randSamplePoints = (200-1).*rand(TKs_MonteCarlo,1) + 1;
%randSamplePoints = (240-1).*rand(TKs_MonteCarlo,1) + 1;
randSamplePoints = (1230-130).*rand(TKs_MonteCarlo,1) + 130;
% Place the above random opints based on response time "TimeRsMonteCarlo" taken from TSMScheduler
% response time......
% above_or_below = randSamplePoints > TimeRsMonteCarlo;

%plot(1:TKs_MonteCarlo, randSamplePoints, 'ms-'); % Plot randome sample points
% plot(1:TKs_MonteCarlo, randSamplePoints, 'b.', 'LineWidth', 2, 'MarkerSize', 10);
UnderFlags = randSamplePoints < TimeRsMonteCarlo;
AboveFlags = randSamplePoints > TimeRsMonteCarlo;
Under = find(randSamplePoints < TimeRsMonteCarlo);
Above = find(randSamplePoints > TimeRsMonteCarlo);
UnderY = randSamplePoints(Under);
AboveY = randSamplePoints(Above);
% UnderX = TKs_MonteCarlo(UnderFlags == 1);
% UnderX = 1:TKs_MonteCarlo;
%UnderX = UnderX(Under);
UnderX = Under;
AboveX = Above;
%Under(Under == 1);
Area = max(TKs_MonteCarlo)*max(TimeRsMonteCarlo);
MonteCarloRatio = size(Under,1)/TKs_MonteCarlo*Area;
Tks_array(N,1) = Tks_in; 
MOntCarlR_array(N,1) = MonteCarloRatio;
end

%area(UnderX, UnderY, 'FaceColor', 'Yellow');

% Use of multiple axis following page helps...
%https://www.mathworks.com/help/matlab/creating_plots/graph-with-multiple-x-axes-and-y-axes.html
% Filling upper portion using "fill" or "area" command..
%XCoord = [1 150 150 180 180 215 215 300 300 0 1];
%XCoord = [1 150 145 180 180 215 215 300 300 0 1];
%XCoord = [0 150 145 180 180 215 215 300 300 0 0];
%YCoord = [5 199 75 80 70 80 5 120 250 250 5];
%YCoord = [5 199 75 80 70 80 5 110 250 250 5];
%YCoord = [0 199 75 80 70 80 5 110 250 250 0];
%fill(XCoord ,YCoord,'g');
% Filling Lower or Under portion using "fill" or "area" command..
%XCoordUnder = [0 145 150 180 180 215 215 300 300 0];
%YCoordUnder = [0 199 75 80 70 80 5 110 0 0];
%XCoordUnder = [0 145 150 180 180 215 215 300 300 0];
% XCoordAbove = [2 27 29 67 180 70 77 81 82 107 108 155 156 162 164 167 197 198 254 256 263 263 0 2];
XCoordAbove = [(1:TKs_MonteCarlo)';300;0;1];
XCoordAbovePF = [(1:TKs_MonteCarlo)';300;0;1];
%YCoordUnder = [0 199 75 80 70 80 5 110 0 0];
% YCoordAbove = [10 200 12 185 6 192 15 197 12 197 42 165 170 10 195 15 196 14.61 137 220 220 10];
YCoordAbove = [TimeRsMonteCarlo;700;700;324];
YCoordAbovePF = [TimeRsMonteCarlo;700;700;324];
%XCoordUnder = [2 27 29 67 180 70 77 81 82 107 108 155 156 162 164 167 197 198 254 256 263 263 0 2];
XCoordUnder = [(1:TKs_MonteCarlo)';300;0;1];
XCoordUnderPF = [(1:TKs_MonteCarlo)';300;0;1];
%YCoordUnder = [0 199 75 80 70 80 5 110 0 0];
% YCoordUnder = [10 200 12 185 6 192 15 197 12 197 42 165 170 10 195 15 196 14.61 137 0 0 10];
YCoordUnder = [TimeRsMonteCarlo;0;0;324];
YCoordUnderPF = [TimeRsMonteCarlo;0;0;324];


%ax2 = axes(t);
c = [0 0.4470 0.7410];
%fill(XCoordUnder, YCoordUnder, c);
fill(XCoordUnderPF, YCoordUnderPF, c);
%c = [0.4940 0.1840 0.5560];
hold on;
c = [0.4660 0.6740 0.1880];
%fill(XCoordAbove,YCoordAbove,c);
fill(XCoordAbovePF,YCoordAbovePF,c);
  text(152,670,'Green Color: Region above curve','FontWeight','bold');
  text(152,635,'Blue Color: Area below curve','FontWeight','bold');
view(0,-90);
ax2.XAxisLocation = 'top';
%ax2.YAxisLocation = 'right';
ax2.Color = 'none';
%ax1.Box = 'off';
%ax2.Box = 'off';
%if(myObj.EnsuringAllTksExecution == 0)
%myObj.Tks = myObj.Tks - (myObj.NumallocDA + myObj.NumTksAllocSVs + myObj.NumTksAllocRSU + myObj.NumTksAllocDataCenter + myObj.NumTksAllocCloud);
%[myObj] = myObj.FognodesSelec();
%end
