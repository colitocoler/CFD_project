%% Intro 
clear 
close all
clc

data = readtable('medium_aperto.csv');

x = data.Points_0(15:end);
cp= data.Pressure_Coefficient(15:end);
jj=1;


for ii = 1:length(x)
    
    if (x(ii+1)-x(ii)) > 0.1
                
        x1 = x(1:ii);
        cp1 = cp(1:ii);
        
        x2 = x(ii+1:end);
        cp2 = cp(ii+1:end);
        
        break
        
        
    end
end

plot([x1 ;x1(1)],[cp1 ;cp1(1)],'r',[x2;x2(1)],[cp2 ; cp2(1)],'b')
tl = legend('c$_p$ main','c$_p$ flap','Interpreter','latex','location','se');
tx = xlabel('x','Interpreter','latex');
ty = ylabel('c$_p$','Interpreter','latex');
tz = title('c$_p$ plot','Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','fontsize',12);

