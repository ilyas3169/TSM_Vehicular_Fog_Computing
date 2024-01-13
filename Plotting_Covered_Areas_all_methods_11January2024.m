 t = tiledlayout(2,2);
 ax1 = axes(t);
 XCoordUnderTSM = XCoordUnder;  % Updated on 11 January 2024...This is TSM related random sample under the curve of TSM ....
                                % Needed 'mat' data file is by the name 'TSMScheduler31May2023'
                                % [TimeRsMonteCarlo;nan;nan;nan];   % Ammended on 11 january 2024 for making suitable for reproducing without my supervision...
 XCoordUnderTSMAmmended = XCoordUnderAmmended;  % Ammended on 11 January 2024 to get coincidence with 'TSM' curve
                                
 YCoordUnderTSM = YCoordUnder;    % Updated on 11 January 2024...This is TSM related random sample under the curve of TSM ....
                                  % Needed 'mat' data file is by the name 'TSMScheduler31May2023'                             
 YCoordUnderTSMAmmended = YCoordUnderAmmended;  % Ammended on 11 January 2024 to get coincidence with 'TSM' curve
 
 XCoordAboveTSM = XCoordAbove;
 
 YCoordAboveTSM = YCoordAbove;
 
 fill(XCoordUnderTSM, YCoordUnderTSM, 'yellow');
 xlim([0 max(XCoordUnderTSM)]);
 % ylim([0 max(YCoordUnderTSM)]);
 % ylim([0 max(YCoordUnderTSM)]);
 %fill(XCoordUnderTSMAmmended, YCoordUnderTSMAmmended, 'yellow');
 hold on;
 grayColor = [.7 .7 .7];
 fill(XCoordAboveTSM ,YCoordAboveTSM,grayColor);
 text(6,243,'Gray Color: Region above curve','FontWeight','bold');
 text(6,227,'Yellow Color: Area below curve','FontWeight','bold');
 %ylim([0 250]);
 % ylim([0 max(YCoordAboveTSM)]);
 xlabel('Number of Tasks');
 ylabel('Response Time (milliseconds)');
 set(ax1,'XColor','black','YColor','black','FontWeight', 'bold');
 box(ax1,"off");
 title('Temporal Segmentation and Modular (TSM)');
  hold on;

  nexttile 
  ax2 = gca;
  c2 = [0.3010 0.7450 0.9330]; % bluesh
fill(XCoordUnderRR, YCoordUnderRR, 'yellow');
hold on;
grayColor = [.7 .7 .7];
fill(XCoordAboveRR,YCoordAboveRR,grayColor);
 text(20,1490,'Gray Color: Region above curve','FontWeight','bold');
 text(20,1410,'Yellow Color: Area below curve','FontWeight','bold');
 %ylim([0 250]);
 xlabel('Number of Tasks');
 ylabel('Response Time (milliseconds)');
 %ylim([0 1560]);
  set(ax2,'XColor','black','YColor','black','FontWeight', 'bold');
  box(ax2,"off");
  title('Roound Robin (RR)');
   hold on;

nexttile
ax3 = gca;
c = [0 0.4470 0.7410];
%fill(XCoordUnder, YCoordUnder, c);
fill(XCoordUnderPF, YCoordUnderPF, 'yellow');
hold on;
%c = [0.4940 0.1840 0.5560];
c = [0.4660 0.6740 0.1880];
%fill(XCoordAbove,YCoordAbove,c);
fill(XCoordAbovePF,YCoordAbovePF,grayColor);
text(5,570,'Gray Color: Region above curve','FontWeight','bold');
text(5,540,'Yellow Color: Area below curve','FontWeight','bold');
 %ylim([0 250]);
 xlabel('Number of Tasks');
 ylabel('Response Time (milliseconds)');
 set(ax3,'XColor','black','YColor','black','FontWeight', 'bold');
 box(ax3,"off");
 title('Proportional Fairness (PF)');
 xlim([0 size(XCoordAbovePF,1)]);
 %ylim([0 size(YCoordAbovePF,1)]);
   hold on;

nexttile 
ax4 = gca;
fill(XCoordUnderBCQI, YCoordUnderBCQI, 'yellow');
hold on;
%c = [0.4940 0.1840 0.5560];
c = [0.4660 0.6740 0.1880];
%fill(XCoordAbove,YCoordAbove,'red');
fill(XCoordAboveBCQI,YCoordAboveBCQI,grayColor);
  text(5,760,'Gray Color: Region above curve','FontWeight','bold');
  text(5,720,'Yellow Color: Area below curve','FontWeight','bold');
 %ylim([0 250]);
 xlabel('Number of Tasks');
 ylabel('Response Time (milliseconds)');
 % ylim([0,820]);
 % ylim([0 600]);
 %ylim([0 700]);
 xlim([0 size(XCoordAboveBCQI,1)]);
 % ylim([0 650]);
 set(ax4,'XColor','black','YColor','black','FontWeight', 'bold');
 box(ax4,"off");
  title('Best Channel Quality Indicator (BCQI)');