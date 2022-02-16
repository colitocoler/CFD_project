clear
clc
close all

data = readtable('base_surface.csv');
data_adj = readtable('adj_surface.csv');


%% base case
data(266:end+1,:) = data(265:end,:);
data(14,:) = data(1,:);
data(265,:) = data(1,:);
data(end+1,:) = data(8,:);
data(end+1,:) = data(266,:);

x=data.Points_0;
y=data.Points_1;
cp=data.Pressure_Coefficient;
taux = data.Skin_Friction_Coefficient_0;
tauy = data.Skin_Friction_Coefficient_1;

%% adj

data_adj(266:end+1,:) = data_adj(265:end,:);
data_adj(14,:) = data_adj(1,:);
data_adj(265,:) = data_adj(1,:);
data_adj(end+1,:) = data_adj(8,:);
data_adj(end+1,:) = data_adj(266,:);

x_adj=data_adj.Points_0;
y_adj=data_adj.Points_1;
cp_adj=data_adj.Pressure_Coefficient;
taux_adj = data_adj.Skin_Friction_Coefficient_0;
tauy_adj = data_adj.Skin_Friction_Coefficient_1;

%% extract the relevant points

inizio = 14;

x=x(inizio:end,1);
y=y(inizio:end,1);
cp=cp(inizio:end,1);
taux=taux(inizio:end,1);
tauy=tauy(inizio:end,1);

x_adj=x_adj(inizio:end,1);
y_adj=y_adj(inizio:end,1);
cp_adj=cp_adj(inizio:end,1);
taux_adj=taux_adj(inizio:end,1);
tauy_adj=tauy_adj(inizio:end,1);



%% split main and flap

tol=0.1;

for ii =1:length(x)
    a = x(ii+1) - x(ii);
    if a > tol
        x_main = x(1:ii);
        x_flap = x(ii+1:end);
        y_main = y(1:ii);
        y_flap = y(ii+1:end);
        cp_main = cp(1:ii);
        cp_flap = cp(ii+1:end);
        taux_main = taux(1:ii);
        taux_flap = taux(ii+1:end);
        tauy_main = tauy(1:ii);
        tauy_flap = tauy(ii+1:end);
        break
    end
end

for ii =1:length(x_adj)
    a = x_adj(ii+1) - x_adj(ii);
    if a > tol
        x_main_adj = x_adj(1:ii);
        x_flap_adj = x_adj(ii+1:end);
        y_main_adj = y_adj(1:ii);
        y_flap_adj = y_adj(ii+1:end);
        cp_main_adj = cp_adj(1:ii);
        cp_flap_adj = cp_adj(ii+1:end);
        taux_main_adj = taux_adj(1:ii);
        taux_flap_adj = taux_adj(ii+1:end);
        tauy_main_adj = tauy_adj(1:ii);
        tauy_flap_adj = tauy_adj(ii+1:end);
        break
    end
end

figure(1)
plot(x_flap,y_flap);hold on;
plot(x_main,y_main)
figure(2)
plot(x_main_adj,cp_main_adj,x_flap_adj,cp_flap_adj,'r','LineWidth',1.5);hold on;
plot(x_main,cp_main,x_flap,cp_flap,'--b','LineWidth',1.5)
tl = legend('main c$_p$ optimized configuration','flap c$_p$ optimized configuration','c$_p$ original configuration','Interpreter','latex','location','se');
tx = xlabel('x','Interpreter','latex','fontsize',15);
ty = ylabel('c$_p$','Interpreter','latex','fontsize',15);
set(gca,'TickLabelInterpreter','latex','fontsize',12);
grid on;

figure(3)
plot(x_flap_adj,taux_flap_adj,'r');hold on;
plot(x_flap,taux_flap,'b')

for ii =1:length(x_flap_adj)
    if ii == length(x_flap_adj)
        h(ii) = (y_flap_adj(ii) - y_flap_adj(1))/sqrt((x_flap_adj(ii) - x_flap_adj(1))^2+(y_flap_adj(ii) - y_flap_adj(1))^2);
        break
    end
        
    h(ii) = (y_flap_adj(ii+1) - y_flap_adj(ii))/sqrt((x_flap_adj(ii+1) - x_flap_adj(ii))^2+(y_flap_adj(ii+1) - y_flap_adj(ii))^2);
end

for ii =1:length(x_flap)
    if ii == length(x_flap)
        p(ii) = (y_flap(ii) - y_flap(1))/sqrt((x_flap(ii) - x_flap(1))^2+(y_flap(ii) - y_flap(1))^2);
        break
    end
        
    p(ii) = (y_flap(ii+1) - y_flap(ii))/sqrt((x_flap(ii+1) - x_flap(ii))^2+(y_flap(ii+1) - y_flap(ii))^2);
end

figure(4)
plot(x_flap_adj,cp_flap_adj.*h','r');hold on;
plot(x_flap,cp_flap.*p','b')
