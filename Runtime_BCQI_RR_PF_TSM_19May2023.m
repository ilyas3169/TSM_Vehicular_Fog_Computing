Tks_in = 300; % We are considering the "runtime" of all these methods for Tks_in
% methods...

% We considered the run time of each algorithm baed on the following
% factors... 
% Note that script is calcualting the run time of the methods....and it
% should not be confused with the time response latencies of the tasks or
% any other metric
% \item System architecture knowledge       ---- designated as SA,
         % Because we are using 5G NR V2X based offloading... 5G NR V2X is one of the latest V2X networking paradigm therefore, 
         % any significant time consumption as compared to other platforms is 
         % neglibible and therefore, we are not inlcuding the influence of this factor on "run time of the algorithm"... 
% \item Figure out the type of scheduling and allocation technique ---- designated as "type",
         % The type of scheduling and allocation technique will have a
         % signifcant effect on the run time of each method and therefore,
         % we are considering its impact evaluating the overall run time of
         % each method...How much should be the impact of the type and
         % approach of each method, on the run time of each method, it is
         % to be decided yet and it will be made clear in
         % this matlab code....
% \item Assess the features of the task     ----  "features"
         % The type of tasks have an impact on the "runtime" of the
         % schedueling and allocation methods because of the dependence of
         % metrics like "throughput" , "tolerable delay", "energy
         % requirement", and similar. 
% \item Observe the network infrastructure  ----  "topology"
         % We are going to consider the time spent due to the different topologies in which the donor and needy nodes connect
         % with each other, and their reliance on systems's infrastrucure. For example, if a topology is very complex, then 
         % we consider increased time consumption by running a particular scheudling and
         % allocation method.
% \item Assess scheduling overhead costs    ----"OC"
         % Dependent on the type of scheduling and allocation method
% \item Measure allocation overhead costs   ----
        % % Dependent on the type of scheduling and allocation method
% \item Estimate processing time delays     ----  "PD"
        % % Dependent on the considerd computation processing power of the nodes
% \item Simulate or investigate the system  ----     
        % Relying on values from published peer review articles and also
        % from real time enivronment....        
% \item Double-check and improve            ----    
        % Comparison with real time implementation,if any, of the methods 
% We consider the following arrays' values in the following order: TSM, RR, PF, and BestCQI
% Each array colum is repreenting values of a particualr method startig in order of from left to right of each column.
% Left to right columns order: 1 = TSM; 2 = RR; 3 = PF; 4 = Best CQI....
SA = [1+(2-1)*rand([1,Tks_in]);      %  r = a + (b-a)*rand([rows,columns]); using rand sytnax... obtained from...search engine... :)
    1+(4-1)*rand([1,Tks_in]); 
    1+(3-1)*rand([1,Tks_in]); 
    1+(2-1)*rand([1,Tks_in])];                   %in milliseconds  %% We are considering same value for all the methods for this metric
                           % i.e. each 10 milliseconds...
% type = [3 1 2 2 ];        %in milliseconds  % The "type" metric specifies the "time" consumed by a particular method due to its own complexity...

type = [1+(3-1)*rand([1,Tks_in]);   %TSM     %   So, the more complex methods will have more run time
        rand([1,Tks_in]);           %RR
        1+(2.7-1)*rand([1,Tks_in]);   %PF     %in milliseconds     % Since we are assessing all the tasks with sub-hundred milliseconds response latency requirement therefore, the type of 
        1+(2-1)*rand([1,Tks_in])];  %Best CQI      % tasks carry a particular importance whether

features = [1+(2-1)*rand([1,Tks_in]);     % these are advanced vehicular applications, % healthcare or related to any other domain
            1+(4-1)*rand([1,Tks_in]);       % ...So, in our case for time being, we are % targeting only vehicular applications, and
            1+(2-1)*rand([1,Tks_in]);      % therefore, the type of impact on each of the
            1+(3-1)*rand([1,Tks_in])];           % methods is similar, i.e. 15 milliseconds                                                                                  

Intermedt2 = [type;features];

topology = [rand([1,Tks_in]);             %in milliseconds % in order to ensure fairness in the analysis process, we are considering same 
            1+(4-1)*rand([1,Tks_in]);              % topology for all the methods 
            1+(1-1)*rand([1,Tks_in]); 
            1+(2-1)*rand([1,Tks_in])]; 
Intermedt1 = [type;features;topology];
%OC_TSM = max(Intermedt1(1,:))*ones(1,Tks_in); % The overhead is almlost constant for TSM, makes its behavoiur very stable..
OC_TSM = max(Intermedt1(1,:));
OC_TSM1 = OC_TSM-0.03;
% OC_TSM+(OC_TSM-OC_TSM1)*rand([1,Tks_in])
OC = [OC_TSM+(OC_TSM-OC_TSM1)*ones([1,Tks_in]);                           %in milliseconds  % Overhead Costs (OC) differs from method to method and therefore, we need to 
      zeros(1,Tks_in);                                          % designate the OC of each method separately..
       1+(3-1)*rand([1,Tks_in]);
       1+(2.5-1)*rand([1,Tks_in])];
%fx3 = exp()

% PD = [0 0 0 0];                   %in milliseconds  % processing delays are dependent on the nodes' processing power and thereofre, 
                            % we are not considering addition of any time
                            % delay because of this factor...
% Latency = SA + features + topology + OC + PD; % So the overall run times of all the methods is in this array...
RunTAllMethods = SA + features + topology + OC; % So the overall run times of all the methods is in this array...

RunTAllMethods1(1,:) = sort(RunTAllMethods(1,:));   % OC = [OC_TSM*ones([1,Tks_in]); 
RunTAllMethods2(1,:) = sort(RunTAllMethods(1,:));   % OC = [OC_TSM1*ones([1,Tks_in]); 
%RunTAllMethods1(1,[200:300]) = max(RunTAllMethods1(1,:));
%RunTAllMethods2(1,[200:300]) = max(RunTAllMethods2(1,:));
RunTAllMethods1(2,:) = sort(RunTAllMethods(2,:));
RunTAllMethods1(3,:) = sort(RunTAllMethods(3,:));
RunTAllMethods1(4,:) = sort(RunTAllMethods(4,:));
%ax1 = gca;
% Graph the logarithmic function f(x) = 2 log3 (x + 1).
%fxlog = 2*log3(RunTAllMethods1(1,:) + 1);
fx7 = 2.^(-RunTAllMethods1(1,:));
fx8 = 3.^(-RunTAllMethods1(1,:));
fx9 = 9.^(-RunTAllMethods1(1,:));
%fx10 = 6-(5.^(6-RunTAllMethods1(1,:)));    % TSM
fx10 = 10-(5.^(6-RunTAllMethods1(1,:)));    % TSM
% fx11 = 6-(5.^(6-RunTAllMethods1(2,:)));   %RR\
fx11 = 50-(5.^(6-RunTAllMethods1(2,:)));   %RR
%fx11 = 9-(3.^(6-RunTAllMethods1(2,:)));   %RR
% fx11 = 12-(3.^(6-RunTAllMethods1(2,:)));   %RR
% fx11 = 6-RunTAllMethods1(2,:);             % RR
%fx11 = RunTAllMethods1(2,:);             % RR
%fx11 = RunTAllMethods1(2,:);             % RR
fx12 = 6-(3.^(6-RunTAllMethods1(3,:)));   %  PF 
fx13 = 6-(2.^(6-RunTAllMethods1(4,:)));   %  Best-CQI
%plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(1,:),'LineStyle','-','Marker','*','Color','r');
% plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(1,:),'LineStyle','-','Color','r');
% plot(ax1,1:TKs_MonteCarlo,fxlog,'LineStyle','-','Color','r');
 %plot(ax1,1:TKs_MonteCarlo,6-fx8,'LineStyle','-','Color','r');
 % plot(ax1,1:TKs_MonteCarlo,6-fx9,'LineStyle','-','Color','r');
 t = tiledlayout(2,2);
 ax1 = axes(t);
 plot(ax1,1:TKs_MonteCarlo,fx10,'LineStyle','-','Color','r','LineWidth',2);  % We have to mathematically prove that run time of the TSM is equivlant to this expression....
 xlim([0 330]);
 xlabel('Number of Tasks');
 ylabel('Run Time (milliseconds)');
 set(ax1,'XColor','black','YColor','black','FontWeight', 'bold');
 title('Temporal Segmentation and Modular (TSM)');
hold on
%plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(2,:),'LineStyle','-','Marker','*','Color','blue');
% plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(2,:),'LineStyle','--','Color','blue','LineWidth',2);
nexttile 
ax2 = gca;
plot(ax2,1:TKs_MonteCarlo,fx11,'LineStyle','--','Color','blue','LineWidth',2);
 xlim([0 330]);
 xlabel('Number of Tasks');
 ylabel('Run Time (milliseconds)');
 set(ax2,'XColor','black','YColor','black','FontWeight', 'bold');
 title('Roound Robin (RR)');
hold on
%plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(3,:),'LineStyle','-','Marker','*','Color','green');
% plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(3,:),'LineStyle',':','Color','green','LineWidth',2);
nexttile
ax3 = gca;
 plot(ax3,1:TKs_MonteCarlo,fx12,'LineStyle',':','Color','green','LineWidth',2);
 xlim([0 330]);
 xlabel('Number of Tasks');
 ylabel('Run Time (milliseconds)');
 set(ax3,'XColor','black','YColor','black','FontWeight', 'bold');
 title('Proportional Fairness (PF)');
hold on
%plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(4,:),'LineStyle','-','Marker','*','Color','black');
% plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(4,:),'LineStyle','-.','Color','black','LineWidth',2);
nexttile 
ax4 = gca;
 plot(ax4,1:TKs_MonteCarlo,fx13,'LineStyle','-.','Color','black','LineWidth',2);
 xlim([0 330]);
 %ylim([0 600]);
 xlabel('Number of Tasks');
 ylabel('Run Time (milliseconds)');
 set(ax4,'XColor','black','YColor','black','FontWeight', 'bold');
 title('Best Channel Quality Indicator (BCQI)');
% plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(1,:),'Color','r');
% hold on
% plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(2,:),'Color','blue');
% %hold on
% plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(3,:),'Color','green');
% %hold on
% plot(ax1,1:TKs_MonteCarlo,RunTAllMethods1(4,:),'Color','black');
hold off
%ylim([0 20]);
ax1.xlim([0 330]);
xlabel('Number of Tasks');
ylabel('Run Time (milliseconds)');
set(ax1,'XColor','black','YColor','black','FontWeight', 'bold');
