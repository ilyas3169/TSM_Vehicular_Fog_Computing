classdef RoundRobinScheduler < TSMSchedueler
properties
    wait               % we are using "wait" as time positive offset added to state (S1) in terms of resopnse time. 
                       %  The state "S1" decides the overall response time of the
                       %  scheduler while scheduling and allocating tasks... Since
                       %  RoundRobin scheudler is event triggerd scheudler that only
                       %  gets prompted when upon a consumer provocation...And it does
                       %  not use any temporal segmentation or any other proactive
                       %  measures to deal with scheduling and allocation process.
                       %  Therefore, using values for "wait" from different published sources like
                       %  one "Mobile vehicles as fog nodes for latency optimization in
                       %  smart cities", we are analysing the round robin performance
                       %  and are comparing it with our and other considered benchmark
                       %  approaches...
   DeviceCount        % DeviceCount is another metric used for approached devices by consumers' tasks' requests..    
   InterCloud         % Response time generated as a result of Cloud transfer function .....
   Inter_DA           % Response time generated as a result of Approached donor node (controller in case of round robin scheduler) transfer function .....
   Inter_SA           % Response time generated as a result of fog Vehicles (SVs) transfer function .....       
   InterDataCenter    % Response time generated as a result of fog Vehicles (SVs) transfer function .....       
end
methods
           %function obj = TSMSchedueler(Tks_in,StoreTksIndx_in,SVs_in,CountAccess_in,G1_in,CurrentG1index_in,EnsuringAllTksExecution_in,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in,S_in,Indices_in,FinalDataX_in,FinalDataY_in)
           function [obj] = RoundRobinScheduler(Tks_in,StoreTksIndx_in,SVs_in,CountAccess_in,G1_in,CurrentG1index_in,EnsuringAllTksExecution_in,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in,S_in,Indices_in,FinalDataX_in,FinalDataY_in,wait_in,DeviceCount_in,Inter_DA_in,Inter_SA_in,InterDataCenter_in,InterCloud_in)
         %obj = obj@TSMSchedueler(wait_in,DeviceCount_in);
   %function obj = TSMSchedueler(Tks_in,StoreTksIndx_in,SVs_in,CountAccess_in,G1_in,CurrentG1index_in,EnsuringAllTksExecution_in,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in,S_in,Indices_in,FinalDataX_in,FinalDataY_in)
         obj = obj@TSMSchedueler(Tks_in,StoreTksIndx_in,SVs_in,CountAccess_in,G1_in,CurrentG1index_in,EnsuringAllTksExecution_in,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in,S_in,Indices_in,FinalDataX_in,FinalDataY_in);
   % myObj = RoundRobinScheduler(Tks_in,StoreTksIndx,SVs_in,G1_in,EnsuringAllTksExecution_in,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in,S_in,wait_in,DeviceCount_in);
         obj.Tks = Tks_in;
         obj.SVs = SVs_in;
         obj.G1 = G1_in;
         obj.EnsuringAllTksExecution = EnsuringAllTksExecution_in;
         obj.NumallocDA = NumallocDA_in;
         obj.NumTksAllocSVs = NumTksAllocSVs_in;
         obj.NumTksAllocRSU = NumTksAllocRSU_in;
         obj.NumTksAllocDataCenter = NumTksAllocDataCenter_in;
         obj.NumTksAllocCloud = NumTksAllocCloud_in;
         obj.S = S_in;
         obj.wait = wait_in;
         obj.DeviceCount = DeviceCount_in;
         obj.StoreTksIndx = StoreTksIndx_in;
         obj.CurrentG1index = CurrentG1index_in;
         obj.CountAccess = CountAccess_in;
         obj.Indices = Indices_in;
         obj.FinalDataX = FinalDataX_in;
         obj.FinalDataY = FinalDataY_in;
         obj.Inter_DA = Inter_DA_in;
         obj.Inter_SA = Inter_SA_in;
         obj.InterDataCenter = InterDataCenter_in;
         obj.InterCloud = InterCloud_in;
    end    
    function [obj] = ApproachedDonorselec(obj)
        %S1 = randi([1, 8], [obj.Tks,1]); 
        %if(obj.DeviceCount > 0)
        %S1 = randi([1, 8+obj.wait], [obj.Tks,1]); 
        %obj.S
        %end
        S1 = obj.S + obj.wait;
        
       % tol_DA = randi([1,obj.wait],1);                 % The threshold used to determine if the task to be offloaded can be run by
            %  approached donor node  ... 0.5 value is
            %  currently taken to use as a threshold to
            %  determine whether approached donor node can
            %  execute the task or not...  Tolerance is the
            %  array of values that we obtained based on the previous records of latency entertained by donor nodes ... 
         obj.Inter_DA = obj.G1.*S1;
         % Algo1 = Inter_DA ~= 0 & Inter_DA <= tol_DA & Inter_DA >= 1;
         Algo1 = obj.Inter_DA ~= 0;
         %obj.Indices = find(Inter_DA ~= 0 & Inter_DA <= tol_DA & Inter_DA >= 1);      % Assigning tasks with requirement of reponsen latency .
         obj.Indices = find(obj.Inter_DA ~= 0);      % Assigning tasks without requirement of reponsen latency.
         % Inter_DA = nonzeros(Inter_DA);   % Expelling non zeros entries because latency response cannot be zero

        % DA = Inter_DA < tol_DA;     % Checking conditions for approached donor node by requested tasks
            % DA = nonzeros(DA);          % Expelling zeros by using non zero matlab function because a response latency as in "S1" cannot be non-zero
         if(obj.EnsuringAllTksExecution == 0)   
         obj.NumallocDA = sum(Algo1(:) == 1);  % Calculating number of alloated tasks to approached donor node
         end
         % Ensuring_All-Tks-execution = Num_Alloc_SA + Num_Alloc_DA <= Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks are not more than the maximum number of tasks' requests, "Tks"
         % obj.EnsuringAllTksExecution = obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
         obj.EnsuringAllTksExecution = obj.NumTksAllocCloud + obj.NumTksAllocDataCenter + obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
            %obj.EnsuringAllTksExecution = EnsuringAllTksExecutionmod; % Updating 'EnsuringAllTksExecution' globally...
            %obj = TSMSchedueler(SVs_in,Tks_in,G1_in,EnsuringAllTksExecution_in);
            %return obj.EnsuringAllTksExecution
         return
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Task schedueling and allocation to neighborhood SVs... in case Round robin schedueling finds SVs to be scheduled and allocated....................................
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %function [EnsuringAllTksExecution,NumTksAllocSVs] = FognodesSelec(obj)
        function [obj] = FognodesSelec(obj)
            %tol_SVs = 8;

            %S2 = randi([1, 8+obj.wait], [obj.Tks,1]);   % Estimated Response latency by fog nodes utilizing utility function or constraints based optimization problem
            S2 = obj.S + obj.wait;
            obj.Inter_SA = obj.G1.*S2;
            % Inter_SA = obj.G1.*S1;
         % Algo1 = Inter_DA ~= 0 & Inter_DA <= tol_DA & Inter_DA >= 1;
           obj.Indices = find(obj.Inter_SA ~= 0);      % Assigning tasks without requirement of reponsen latency.
           Algo1 = obj.Inter_SA ~= 0;
            %Inter_SA = nonzeros(Inter_SA);   % Expelling non zeros entries because latency response cannot be zero

            if(obj.EnsuringAllTksExecution == 0)
                %Algo1 = Inter_SA < tol_SVs;    % Algo1 decides between SVs, RSU, Data center, and Cloud Sources based on availability and tolerace by neighborhood fog vehicles
                %if (Algo1 == 1)
                %    SVs_Alloc = 1;
                % end
                %Calculating number of tasks being scheduled and allocated to fog vehicular donor nodes (SVs)...
                obj.NumTksAllocSVs = sum(Algo1(:) == 1); % Calculating number of alloated tasks to number of SVs by Algorithm-1
            end

            % obj.EnsuringAllTksExecution = obj.NumTksAllocSVs+obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
            obj.EnsuringAllTksExecution = obj.NumTksAllocCloud + obj.NumTksAllocDataCenter + obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
            return
        end



     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Task schedueling and allocation to neighborhood RSU... in case Round robin schedueling finds RSU to be scheduled and allocated.........................
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %function [EnsuringAllTksExecution,NumTksAllocRSU] = RSUselec(obj)
        function [obj] = RSUselec(obj)
            % tol_RSU = 6;

            %S3 = randi([2, 8+obj.wait], [obj.Tks,1]);  % Estimated Response latency by RSU utilizing utility function or constraints based optimization problem
            S3 = obj.S + obj.wait;

            Inter_RSU = obj.G1.*S3;
            
           obj.Indices = find(Inter_RSU ~= 0);         % Assigning tasks without requirement of reponse latency.
           Algo1 = Inter_RSU ~= 0; 
            %Inter_RSU = nonzeros(Inter_RSU);

            if(obj.EnsuringAllTksExecution == 0)
             %   Algo1 = Inter_RSU < tol_RSU;    % Algo1 decides between SVs, RSU, Data center, and Cloud Sources based on availability and tolerace by neighborhood fog vehicles
                %if (Algo1 == 1)
                %    SVs_Alloc = 1;
                % end

                %Calculating number of tasks being scheduled and allocated to fog vehicular donor nodes (SVs)...
                obj.NumTksAllocRSU = sum(Algo1(:) == 1); % Calculating number of alloated tasks to number of SVs by Algorithm-1

                % obj.EnsuringAllTksExecution = obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
                obj.EnsuringAllTksExecution = obj.NumTksAllocCloud + obj.NumTksAllocDataCenter + obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
                return
            end
        end 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Task schedueling and allocation to neighborhood Data center... in case Round robin schedueling finds Data center to be scheduled and allocated...................
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function [obj] = DataCenterselec(obj)

            % tolDataCenter = 1;

           % S4 = randi([2, 8+obj.wait], [obj.Tks,1]);  % Estimated Response latency by Data Center utilizing utility function or constraints based optimization problem
            S4 = obj.S + obj.wait;

            obj.InterDataCenter = obj.G1.*S4;

           obj.Indices = find(obj.InterDataCenter ~= 0);         % Assigning tasks without requirement of reponse latency.
           Algo1 = obj.InterDataCenter ~= 0; 
          %  InterDataCenter = nonzeros(InterDataCenter);

            if(obj.EnsuringAllTksExecution == 0)
               % Algo1 = InterDataCenter < tolDataCenter;    % Algo1 decides between SVs, RSU, Data center, and Cloud Sources based on availability and tolerace by neighborhood fog vehicles
                %if (Algo1 == 1)
                %    SVs_Alloc = 1;
                % end
                %Calculating number of tasks being scheduled and allocated to fog vehicular donor nodes (SVs)...
                obj.NumTksAllocDataCenter = sum(Algo1(:) == 1); % Calculating number of alloated tasks to number of SVs by Algorithm-1

                % obj.EnsuringAllTksExecution = obj.NumTksAllocDataCenter + obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
                obj.EnsuringAllTksExecution = obj.NumTksAllocCloud + obj.NumTksAllocDataCenter + obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"

                return
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Task schedueling and allocation to Cloud-server... in case Round robin schedueling finds Cloud server to be scheduled and allocated...................
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [obj] = CloudSelec(obj)

            % tolcloud = 0.5;

            % S5 = randi([2, 8+obj.wait], [obj.Tks,1]);  % Estimated Response latency by Data Center utilizing utility function or constraints based optimization problem
            S5 = obj.S + obj.wait;

            obj.InterCloud = obj.G1.*S5;
            
           obj.Indices = find(obj.InterCloud  ~= 0);         % Assigning tasks without requirement of reponse latency.
           Algo1 = obj.InterCloud  ~= 0;

           % InterCloud = nonzeros(InterCloud);

            if(obj.EnsuringAllTksExecution == 0)
              %  Algo1 = InterCloud < tolcloud;    % Algo1 decides between SVs, RSU, Data center, and Cloud Sources based on availability and tolerace by neighborhood fog vehicles
                %if (Algo1 == 1)
                %    SVs_Alloc = 1;
                % end
                %Calculating number of tasks being scheduled and allocated to fog vehicular donor nodes (SVs)...
                obj.NumTksAllocCloud = sum(Algo1(:) == 1); % Calculating number of alloated tasks to number of SVs by Algorithm-1
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            obj.EnsuringAllTksExecution = obj.NumTksAllocCloud + obj.NumTksAllocDataCenter + obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"

            %if(EnsuringAllTksExecution == 1)
            %if(EnsuringAllTksExecution
        end        
end
end