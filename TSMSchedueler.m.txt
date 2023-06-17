classdef TSMSchedueler
    properties
        %Define TSMScheduler properties that mainly include previosu states
        %in terms of response time latency and other relevant metrics. Each
        %metric and state is defined separately...
        %G1 = randi([imin, imax], sz);
        FinalDataY % Final data is the parameter used to pass on the obtained data from the scheduler to the running  or simulation environment..
        FinalDataX
        Indices  % indces of time response scheduled by TSM Scheduler....
        SVs % = randi([50, 100], 1);    % Considered number of fog nodes randomly selected between the range [50,100]
        % Tks = randi([100, 300], 1);      % Considered number of fog nodes randomly selected between the range [50,100]
        Tks % = 100;      % Considered number of tasks are fixed

        % at the moment..which we may make variable after completing first version
        % of the simulation and modeling..
        CountAccess % Count Access is used to designate the number of times a differnt donor node devices has been accessed by consumer's task requests...
        
        CurrentG1index    % Current G1 index is used to designate the last index of the task that is executed by current donor node...

        G1 % = randi([0, 1], [Tks,1]);    % Decision by consumer to outsource tasks (out of 100 total tasks in this experiment)...
        % '0' means consumer is not outsourcing the
        % task, '1' means consumer is outsourcing the
        % task ....

        EnsuringAllTksExecution  % This is used to confirm whether or not all tasks are scheduled, allocated resource and finally executed .....

        NumallocDA    % Internal metric to store number of scheduled and allocated tasks to approached donor node

        NumTksAllocSVs    % Internal metric to store number of scheduled and allocated tasks to scheduled vehiculr fog nodes

        NumTksAllocRSU    % Internal metric to store number of scheduled and allocated tasks to RSU

        NumTksAllocDataCenter    % Internal metric to store number of scheduled and allocated tasks to data center

        NumTksAllocCloud    % Internal metric to store number of scheduled and allocated tasks to cloud server

        S     % "S" variable we are using to designate the overal response time in which "TSMScheduler" is able to scheduler and allocate tasks' requests.. "S" state is based on
              % previous state states of approached potential donor nodes, that can be "S1", "S2", "S3", "S4" or "S5"...
        
        StoreTksIndx  % This "StoreTksIndx" is used to designate the index of the task that is being processed by any donor computing node that may be approached donor node, SVs, RSU, data center or a cloud-server      
    end

    % Define Class methods
    methods
        % Constructor method
 %function [obj]=RoundRobinScheduler(Tks_in,SVs_in,G1_in,EnsuringAllTksExecution_in,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in,S_in,wait_in,DeviceCount_in)
        %myObj = TSMSchedueler(Tks,StoreTksIndx_in,SVs,CountAccess_in,G1,CurrentG1index_in,EnsuringAllTksExecution,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in,S_in,Indices_in,FinalDataX_in,FinalDataY_in);
 function obj = TSMSchedueler(Tks_in,StoreTksIndx_in,SVs_in,CountAccess_in,G1_in,CurrentG1index_in,EnsuringAllTksExecution_in,NumallocDA_in,NumTksAllocSVs_in,NumTksAllocRSU_in,NumTksAllocDataCenter_in,NumTksAllocCloud_in,S_in,Indices_in,FinalDataX_in,FinalDataY_in)
            obj.SVs = SVs_in;
            obj.Tks = Tks_in;
            obj.EnsuringAllTksExecution = EnsuringAllTksExecution_in;
            obj.NumallocDA = NumallocDA_in;
            obj.NumTksAllocSVs = NumTksAllocSVs_in;
            obj.NumTksAllocRSU = NumTksAllocRSU_in;
            obj.NumTksAllocDataCenter = NumTksAllocDataCenter_in;
            obj.NumTksAllocCloud = NumTksAllocCloud_in;
            obj.S = S_in;
            obj.G1 = G1_in;
            obj.StoreTksIndx = StoreTksIndx_in;
            obj.CurrentG1index = CurrentG1index_in;
            obj.CountAccess = CountAccess_in;
            obj.Indices = Indices_in;
            obj.FinalDataX = FinalDataX_in;
            obj.FinalDataY = FinalDataY_in;
        end

        %G1 = nonzeros(G1);          % Expelling zeros by using non zero matlab function because we need only non zero entries in "G1" because response latenceies can not be non-zero

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Task schedueling and allocation to approached donor node... the 1st priority
        % of Algorithm-1..................................
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % function [EnsuringAllTksExecution,NumAllocDA] = ApproachedDonorselec(obj)
        function [obj] = ApproachedDonorselec(obj)
        %function [obj,NumAllocDA] = ApproachedDonorselec()

            %S1 = randi([5, 200], [obj.Tks,1]);    % "S1" is the State-1 or the precvious state (in terms of Estimated Response latency) of tasks entertained in time period of "T"
            S1 = obj.S;                          
            % which needs to be obtained from utility function
            % here we are using values from published article
            % titled "Driving in the fog: Latency Measurement, Modeling, and Optimization of LTE-based fog computing for smart vehicles"...
            % According to the values in the article, their
            % unit is in seconds....

            %S1 = nonzeros(S1);          % Expelling zeros by using non zero matlab function because a response latency as in "S1" cannot be non-zero

            %DA = randi([0, 8], 100);
            % tol = eps(0.5);           % In MATLAB, eps is a function that returns the machine epsilon value for floating-point arithmetic. Machine epsilon is the smallest positive number that can be added to 1 and yield a result different from 1. It is a measure of the precision of the floating-point arithmetic used by the computer.

            tol_DA = 70;                 % The threshold used to determine if the task to be offloaded cana be run by
            %  approached donor node  ... 0.5 value is
            %  currently taken to use as a threshold to
            %  determine whether approached donor node can
            %  execute the task or not...  Tolerance is the
            %  array of values that we obtained based on the previous records of latency entertained by donor nodes ...
            if(obj.EnsuringAllTksExecution == 0)
            Inter_DA = obj.G1.*S1;
            % Inter_DA = Inter_DA(obj.CurrentG1index:size(Inter_DA,1));
            Algo1 = Inter_DA ~= 0 & Inter_DA <= tol_DA & Inter_DA >= 1;
            obj.Indices = find(Inter_DA ~= 0 & Inter_DA <= tol_DA & Inter_DA >= 1);      % Assigning tasks with requirement of reponsen latency between 1 and 70 milliseconds.
            % Inter_DA = Inter_DA(obj.Indices);
            Inter_DA = nonzeros(Inter_DA);      % Expelling non zeros entries because latency response cannot be zero
            DA = Inter_DA < tol_DA;             % Checking conditions for approached donor node by requested tasks
            % obj.Indices = find(Inter_DA); 
          % obj.Indices = find(Inter_DA < tol_DA);
            %obj.CurrentG1index = max(obj.Indices);
            % obj.CurrentG1index = 
            % DA = nonzeros(DA);          % Expelling zeros by using non zero matlab function because a response latency as in "S1" cannot be non-zero
            % if(size(obj.Tks ))
            %obj.StoreTksIndx = find(DA);  % Storing indices of the scheduled and allocated tasks to the approached donor node...
            %obj.StoreTksIndx = unique(obj.StoreTksIndx); % "unique" command deletes any duplicated indices in "obj.StoreTksIndx"...
            % obj.NumallocDA = sum(DA(:) == 1);  % Calculating number of alloated tasks to approached donor node
            obj.NumallocDA = sum(Algo1(:) == 1);  % Calculating number of alloated tasks to approached donor node
            %obj.CurrentG1index = obj.NumallocDA;
           % if(size(obj.StoreTksIndx,1) > obj.CurrentG1index)
         %    Anotheroffset =   size(obj.StoreTksIndx,1) - obj.CurrentG1index;
          %  end
            if(obj.CountAccess==0)
            obj.Indices = find(obj.G1 ~=  0 & S1 < tol_DA);      
            end
           % if(obj.CountAccess >= 1)
            %G1Inter = obj.G1(obj.CurrentG1index+1:obj.CurrentG1index+obj.NumallocDA);    
            % obj.Indices = find(obj.G1 ~=  0 & S1 < tol_DA); 
            %obj.Indices = [obj.Indices;(obj.CurrentG1index+1:obj.CurrentG1index+obj.NumallocDA)'];
            %end
          %  if(size(obj.StoreTksIndx,1) <= obj.CurrentG1index)
          %        Anotheroffset = abs(size(obj.StoreTksIndx,1) - obj.CurrentG1index);
          %  end
            %Anotheroffset = size(obj.StoreTksIndx,1) - size(obj.CurrentG1inde,1);
            if(obj.CountAccess == 0)
            %obj.StoreTksIndx = (1:obj.CurrentG1index)';  % Storing indices of the scheduled and allocated tasks to the approached donor node...
            obj.StoreTksIndx = obj.Indices;
            end
            if(obj.CountAccess > 0)
                obj.StoreTksIndx = [obj.StoreTksIndx;obj.Indices];
            % obj.StoreTksIndx = [obj.StoreTksIndx;(1+obj.StoreTksIndx:1:obj.StoreTksIndx+Anotheroffset)'];  % Storing indices of the scheduled and allocated tasks to the approached donor node...
            %obj.Indices 
            end
            obj.CountAccess = obj.CountAccess+1;
            % Ensuring_All-Tks-execution = Num_Alloc_SA + Num_Alloc_DA <= Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks are not more than the maximum number of tasks' requests, "Tks"
            obj.EnsuringAllTksExecution = obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
            %obj.EnsuringAllTksExecution = EnsuringAllTksExecutionmod; % Updating 'EnsuringAllTksExecution' globally...
            %obj = TSMSchedueler(SVs_in,Tks_in,G1_in,EnsuringAllTksExecution_in);
            %return obj.EnsuringAllTksExecution
            end
            return
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Task schedueling and allocation to neighborhood SVs... the 2nd priority
        % of Algorithm-1..................................
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %function [EnsuringAllTksExecution,NumTksAllocSVs] = FognodesSelec(obj)
        function [obj] = FognodesSelec(obj)
            tol_SVs = 150;
             tol_DA = 70;       
            if(obj.EnsuringAllTksExecution == 0)
            %S2 = randi([5, 200], [obj.Tks,1]);   % Estimated Response latency by fog nodes utilizing utility function or constraints based optimization problem
            S2 = obj.S;
            Inter_SA = obj.G1.*S2;
            Algo1 = Inter_SA ~= 0 & Inter_SA <= tol_SVs & Inter_SA > tol_DA;
            obj.Indices = find(Inter_SA ~= 0 & Inter_SA <= tol_SVs & Inter_SA > tol_DA);     % Assigning tasks with requirement of reponsen latency between 71 and 150 milliseconds.
            sizeInterSA = size(Inter_SA,1);
            startindex = obj.CurrentG1index;
            if(obj.CurrentG1index <= 0)
            startindex = obj.CurrentG1index+1;
            end
            Inter_SA = Inter_SA(startindex:sizeInterSA);
             % if(obj.EnsuringAllTksExecution == 0)
            Inter_SA = nonzeros(Inter_SA);   % Expelling non zeros entries because latency response cannot be zero
            % obj.Indices = find(Inter_SA); 
           % whichindices = find(obj.G1 ~=  0 & S2 < tol_SVs); 
          % obj.Indices = find(obj.G1 ~=  0 & S2 < tol_SVs); 
            
            obj.CurrentG1index = max(obj.Indices);
           %   end
                     
           
              %  Algo1 = Inter_SA < tol_SVs;    % Algo1 decides between SVs, RSU, Data center, and Cloud Sources based on availability and tolerace by neighborhood fog vehicles
                %if (Algo1 == 1)
                %    SVs_Alloc = 1;
                % end
                %obj.StoreTksIndx = unique(obj.StoreTksIndx); % "unique" command deletes any duplicated indices in "obj.StoreTksIndx"...
                %Calculating number of tasks being scheduled and allocated to fog vehicular donor nodes (SVs)...
                obj.NumTksAllocSVs = sum(Algo1(:) == 1); % Calculating number of alloated tasks to number of SVs by Algorithm-1
                % obj.CurrentG1index = obj.NumTksAllocSVs;
                %if(size(obj.StoreTksIndx,1) > obj.CurrentG1index)
                %Anotheroffset = size(obj.StoreTksIndx,1) - obj.CurrentG1index;
                %end
                %if(size(obj.StoreTksIndx,1) <= obj.CurrentG1index)
                %Anotheroffset = abs(size(obj.StoreTksIndx,1) - obj.CurrentG1index);
                %end
                  obj.StoreTksIndx = [obj.StoreTksIndx;obj.Indices];
                  % obj.StoreTksIndx = [obj.StoreTksIndx;(1+size(obj.StoreTksIndx,1):1:size(obj.StoreTksIndx,1)+Anotheroffset)'];  % Storing indices of the scheduled and allocated tasks to the approached donor node...
                   obj.CountAccess = obj.CountAccess+1;
                   %obj.Indices = [obj.Indices;(obj.CurrentG1index+1:obj.CurrentG1index+obj.NumTksAllocSVs)'];
                   %obj.Indices = (obj.CurrentG1index+1:obj.CurrentG1index+obj.NumTksAllocSVs)';
                   %whichindices;
               obj.EnsuringAllTksExecution = obj.NumTksAllocSVs+obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"    
            end
           return
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Task schedueling and allocation to neighborhood RSU... the 3rd priority
        % of Algorithm-1..................................
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %function [EnsuringAllTksExecution,NumTksAllocRSU] = RSUselec(obj)
        function [obj] = RSUselec(obj)
            tol_RSU = 200;
            tol_SVs = 150;
            if(obj.EnsuringAllTksExecution == 0)
            % S3 = randi([5, 200], [obj.Tks,1]);  % Estimated Response latency by RSU utilizing utility function or constraints based optimization problem
            S3 = obj.S;                         % This values is in milliseconds, and we have obtained this value from published work titled "Driving in the fog: Latency Measurement, Modeling, and Optimization of LTE-based fog computing 
                                                % for smart vehicles"
            Inter_RSU = obj.G1.*S3;
            obj.Indices = find(Inter_RSU ~= 0 & Inter_RSU <= tol_RSU & Inter_RSU > tol_SVs);     % Assigning tasks with requirement of reponsen latency between 150 and 200 milliseconds.
            Algo1 = Inter_RSU ~= 0 & Inter_RSU <= tol_RSU & Inter_RSU > tol_SVs;
              if(obj.EnsuringAllTksExecution == 0)
                 % obj.Indices = find(obj.G1 ~=  0 & S3 < tol_RSU);
                  obj.CurrentG1index = max(obj.Indices);
              end
            Inter_RSU = nonzeros(Inter_RSU);

            %if(obj.EnsuringAllTksExecution == 0)
                % Algo1 = Inter_RSU < tol_RSU;    % Algo1 decides between SVs, RSU, Data center, and Cloud Sources based on availability and tolerace by neighborhood fog vehicles
             %   Algo1 = Inter_RSU ~= 0 & Inter_RSU <= tol_RSU & Inter_RSU > tol_SVs;
                %if (Algo1 == 1)
                %    SVs_Alloc = 1;
                % end

                %Calculating number of tasks being scheduled and allocated to fog vehicular donor nodes (SVs)...
                obj.NumTksAllocRSU = sum(Algo1(:) == 1); % Calculating number of alloated tasks to number of SVs by Algorithm-1
                % obj.CurrentG1index = obj.NumTksAllocRSU;
                obj.StoreTksIndx = [obj.StoreTksIndx;(obj.StoreTksIndx+1:1:obj.CurrentG1index)'];  % Storing indices of the scheduled and allocated tasks to the RSU ... 
                % obj.StoreTksIndx = unique(obj.StoreTksIndx); % "unique" command deletes any duplicated indices in "obj.StoreTksIndx"...
                obj.EnsuringAllTksExecution = obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
                %obj.Sprime = ;
                if(size(obj.StoreTksIndx,1) > obj.CurrentG1index)
                Anotheroffset = size(obj.StoreTksIndx,1) - obj.CurrentG1index;
                end
                if(size(obj.StoreTksIndx,1) <= obj.CurrentG1index)
                  Anotheroffset = abs(size(obj.StoreTksIndx,1) - obj.CurrentG1index);
                end
                %obj.StoreTksIndx = [obj.StoreTksIndx;(1+size(obj.StoreTksIndx,1):1:size(obj.StoreTksIndx,1)+Anotheroffset)'];  % Storing indices of the scheduled and allocated tasks to the approached donor node...
                obj.StoreTksIndx = [obj.StoreTksIndx;obj.Indices];
                obj.CountAccess = obj.CountAccess + 1;  
            end
           return 
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Task schedueling and allocation to neighborhood Data center... the 4th priority
        % of Algorithm-1..................................
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function [obj] = DataCenterselec(obj)

            tolDataCenter = 200;
            tol_SVs = 150;
            %S4 = randi([2, 8], [obj.Tks,1]);  % Estimated Response latency by Data Center utilizing utility function or constraints based optimization problem
            S4 = obj.S;
            InterDataCenter = obj.G1.*S4;
            % obj.Indices = find(Inter_RSU ~= 0 & Inter_RSU <= tol_RSU & Inter_RSU > tol_SVs);     % Assigning tasks with requirement of reponsen latency between 150 and 200 milliseconds.
            if(obj.EnsuringAllTksExecution == 0)
            %obj.Indices = find(obj.G1 ~=  0 & S4 < tolDataCenter); 
            obj.CurrentG1index = max(obj.Indices);
            end
            InterDataCenter = nonzeros(InterDataCenter);

            if(obj.EnsuringAllTksExecution == 0)
                % Algo1 = InterDataCenter < tolDataCenter;    % Algo1 decides between SVs, RSU, Data center, and Cloud Sources based on availability and tolerace by neighborhood fog vehicles
                obj.Indices = find(InterDataCenter ~= 0 & InterDataCenter <= tolDataCenter & InterDataCenter > tol_SVs);
                Algo1 = InterDataCenter ~= 0 & InterDataCenter <= tolDataCenter & InterDataCenter > tol_SVs;
                %if (Algo1 == 1)
                %    SVs_Alloc = 1;
                % end
                %Calculating number of tasks being scheduled and allocated to fog vehicular donor nodes (SVs)...
                obj.NumTksAllocDataCenter = sum(Algo1(:) == 1); % Calculating number of alloated tasks to number of SVs by Algorithm-1
                obj.StoreTksIndx = [obj.StoreTksIndx;find(Algo1 == 1)];  % Storing indices of the scheduled and allocated tasks to the data center ... 
                % obj.StoreTksIndx = unique(obj.StoreTksIndx); % "unique" command deletes any duplicated indices in "obj.StoreTksIndx"...
                obj.EnsuringAllTksExecution = obj.NumTksAllocDataCenter + obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
                % obj.CurrentG1index = obj.NumTksAllocDataCenter;
                if(size(obj.StoreTksIndx,1) > obj.CurrentG1index)
                Anotheroffset = size(obj.StoreTksIndx,1) - obj.CurrentG1index;
                end
                if(size(obj.StoreTksIndx,1) <= obj.CurrentG1index)
                  Anotheroffset = abs(size(obj.StoreTksIndx,1) - obj.CurrentG1index);
                end
                % obj.StoreTksIndx = [obj.StoreTksIndx;(1+size(obj.StoreTksIndx,1):1:size(obj.StoreTksIndx,1)+Anotheroffset)'];  % Storing indices of the scheduled and allocated tasks to the approached donor node...
                obj.StoreTksIndx = [obj.StoreTksIndx;obj.Indices];
                obj.CountAccess = obj.CountAccess + 1;                  
            end
            return
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Task schedueling and allocation to Cloud-server... the 5th priority
        % of Algorithm-1..................................
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [obj] = CloudSelec(obj)

            tolcloud = 200;   % (in milliseconds)
            tol_SVs = 150;
            % S5 = randi([2, 8], [obj.Tks,1]);  % Estimated Response latency by Data Center utilizing utility function or constraints based optimization problem
            S5 = obj.S;
            InterCloud = obj.G1.*S5;
            if(obj.EnsuringAllTksExecution == 0)
             %obj.Indices = find(obj.G1 ~=  0 & S5 < tolcloud); 
             obj.CurrentG1index = max(obj.Indices);
            end
            InterCloud = nonzeros(InterCloud);

            if(obj.EnsuringAllTksExecution == 0)
                % Algo1 = InterCloud < tolcloud;    % Algo1 decides between SVs, RSU, Data center, and Cloud Sources based on availability and tolerace by neighborhood fog vehicles
                obj.Indices = find(InterCloud ~= 0 & InterCloud <= tolcloud & InterCloud > tol_SVs);
                Algo1 = InterCloud ~= 0 & InterCloud <= tolcloud & InterCloud > tol_SVs;
                %if (Algo1 == 1)
                %    SVs_Alloc = 1;
                % end
                %Calculating number of tasks being scheduled and allocated to fog vehicular donor nodes (SVs)...
                obj.NumTksAllocCloud = sum(Algo1(:) == 1); % Calculating number of alloated tasks to number of SVs by Algorithm-1
                %obj.CurrentG1index = obj.NumTksAllocCloud;
                obj.StoreTksIndx = [obj.StoreTksIndx;find(Algo1 == 1)];  % Storing indices of the scheduled and allocated tasks to the schduled and allocated donor fog nodes ... 
                % obj.StoreTksIndx = unique(obj.StoreTksIndx); % "unique" command deletes any duplicated indices in "obj.StoreTksIndx"...
                if(size(obj.StoreTksIndx,1) > obj.CurrentG1index)
                 Anotheroffset = size(obj.StoreTksIndx,1) - obj.CurrentG1index;
                end
                if(size(obj.StoreTksIndx,1) <= obj.CurrentG1index)
                  Anotheroffset = abs(size(obj.StoreTksIndx,1) - obj.CurrentG1index);
                end
                % obj.StoreTksIndx = [obj.StoreTksIndx;(1+size(obj.StoreTksIndx,1):1:size(obj.StoreTksIndx,1)+Anotheroffset)'];  % Storing indices of the scheduled and allocated tasks to the approached donor node...
                obj.StoreTksIndx = [obj.StoreTksIndx;obj.Indices];
                obj.CountAccess = obj.CountAccess + 1;  
                 obj.EnsuringAllTksExecution = obj.NumTksAllocCloud + obj.NumTksAllocDataCenter + obj.NumTksAllocRSU + obj.NumTksAllocSVs + obj.NumallocDA >= obj.Tks;   % Ensuring All Tasks execution by confirming number of maximum executed tasks so far are not more than the maximum number of tasks' requests, "Tks"
            end
            return
        end   % End of function for cloud
        
        function [obj] = FinalizingData(obj)
            t = [0 0.3 0.8 1.1 1.6 2.3]';
            y = [0.6 0.67 1.01 1.35 1.47 1.25]';
            X = [ones(size(t))  exp(-t)  t.*exp(-t)];
            
            a = X\y;

            
            
            plot(T,Y,'-',t,y,'o'), grid on
            title('Plot of Model and Original Data')

            %obj.Tks = obj.Tks;
            % t = [0 0.3 0.8 1.1 1.6 2.3]';
            %T = (0:0.1:2.5)';
         %   Tks1 = (1:obj.FinalDataX)';
            % y = [0.6 0.67 1.01 1.35 1.47 1.25]';
            % Finalizing1 = sort(obj.FinalDataY);
        %    Finalizing1 = [ones(size(Tks1))  exp(-Tks1)  Tks1.*exp(-Tks1)]*a;
            %Y = [ones(size(Tks1))  exp(-Tks1)  Tks1.*exp(-Tks1)]*a;
                           % Based on the qualitatively and also
                           % quantitatively anlaysing the behaviour of the
                           % TSMScheduler, we are finalizaing the data in this function.. :
          %  plot(T,Y,'-',t,y,'o'), grid on     
        %    title('Plot of Model and Original Data')
     %   FinalRespTIndice = myObj.Indices;
    %    obj.FinalData = sort(Finalizing1);
        %FinalRespTIndice = RespT(RespT2);
        %Finalizing1 = 
      %  a = 3×1

   % 1.3983
   %-0.8860
   % 0.3085 
        %Tks = (1:1:300)';
    %    RspnT = [ones(size(TKs))  exp(-Tks)  Tks.*exp(-Tks)]*a;
        end



    end       % End of methods
end           % End of class "TSMScheduler"