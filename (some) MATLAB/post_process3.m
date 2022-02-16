clear
clc

adj = importdata('adj.csv')';
base = importdata('base.csv')';

inizio_adj = 28;
inizio_base = 28;
fine_adj = 961;
fine_base = 946;

y_adj = base.data(inizio_adj:fine_adj,29);
y_base = base.data(inizio_base:fine_base,29);

mom_adj = adj.data(inizio_adj:fine_adj,7);
mom_base = base.data(inizio_base:fine_base,7);

plot(mom_adj,y_adj,mom_base,y_base,'LineWidth',1.5)
tl = legend('x-momentum optimized flap','x-momentum original flap','c$_p$ original configuration','Interpreter','latex','location','best');
tx = xlabel('x-momentum','Interpreter','latex','fontsize',15);
ty = ylabel('y','Interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex','fontsize',12);
grid on;



M_adj = trapz(y_adj,mom_adj);
M_base= trapz(y_base,mom_base);


% adj = importdata('massa_adj.csv')';
% base = importdata('massa_base.csv')';
% 
% inizio_adj = 408;
% inizio_base = 435;
% fine = 9842;
% 
% y_adj = base.data(inizio_adj:fine,29);
% y_base = base.data(inizio_base:fine,29);
% 
% mom_adj = adj.data(inizio_adj:fine,7);
% mom_base = base.data(inizio_base:fine,7);
% 
% plot(mom_adj,y_adj,'r',mom_base,y_base,'b')
% 
% 
% 
% M_adj = trapz(flip(y_adj),flip(mom_adj));
% M_base= trapz(flip(y_base),flip(mom_base));
