 t = tiledlayout(2,2);
 ax1 = axes(t);
 fill(XCoordUnderTSM, YCoordUnderTSM, 'yellow');
 hold on;
 grayColor = [.7 .7 .7];
 fill(XCoordAboveTSM ,YCoordAboveTSM,grayColor);
 text(5,243,'Gray Color: Region above curve','FontWeight','bold');
 text(5,227,'Yellow Color: Area below curve','FontWeight','bold');
 %ylim([0 250]);
 xlabel('Number of Tasks');
 ylabel('Response Time (milliseconds)');
 set(ax1,'XColor','black','YColor','black','FontWeight', 'bold');
 title('Temporal Segmentation and Modular (TSM)');
  hold on;

  nexttile 
  ax2 = gca;
  c2 = [0.3010 0.7450 0.9330]; % bluesh
fill(XCoordUnderRR, YCoordUnderRR, 'yellow');
hold on;
grayColor = [.7 .7 .7];
fill(XCoordAboveRR,YCoordAboveRR,grayColor);
 text(20,1510,'Gray Color: Region above curve','FontWeight','bold');
 text(20,1428,'Yellow Color: Area below curve','FontWeight','bold');
 %ylim([0 250]);
 xlabel('Number of Tasks');
 ylabel('Response Time (milliseconds)');
 ylim([0 1560]);
  set(ax2,'XColor','black','YColor','black','FontWeight', 'bold');
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
text(5,680,'Gray Color: Region above curve','FontWeight','bold');
text(5,635,'Yellow Color: Area below curve','FontWeight','bold');
 %ylim([0 250]);
 xlabel('Number of Tasks');
 ylabel('Response Time (milliseconds)');
 set(ax3,'XColor','black','YColor','black','FontWeight', 'bold');
 title('Proportional Fairness (PF)');
   hold on;

nexttile 
ax4 = gca;
fill(XCoordUnderBCQI, YCoordUnderBCQI, 'yellow');
hold on;
%c = [0.4940 0.1840 0.5560];
c = [0.4660 0.6740 0.1880];
%fill(XCoordAbove,YCoordAbove,'red');
fill(XCoordAboveBCQI,YCoordAboveBCQI,grayColor);
  text(5,635,'Gray Color: Region above curve','FontWeight','bold');
  text(5,595,'Yellow Color: Area below curve','FontWeight','bold');
 %ylim([0 250]);
 xlabel('Number of Tasks');
 ylabel('Response Time (milliseconds)');
 % ylim([0,820]);
 % ylim([0 600]);
 %ylim([0 700]);
 ylim([0 650]);
 set(ax4,'XColor','black','YColor','black','FontWeight', 'bold');
  title('Best Channel Quality Indicator (BCQI)');
