%% Intro 
clear 
close all
clc
%set(0, 'DefaultFigureWindowStyle', 'docked')

%% three meshes
% #1 fine
% #2 medium
% #3 coarse

%% number of elements
N1 = 193431;
N2 = 85025;
N3 = 37510;


%% avg cell size
h1 = 1/sqrt(N1);
h2 = 1/sqrt(N2);
h3 = 1/sqrt(N3);


%% refinement ratio
r21 = h2/h1;
r32 = h3/h2;
r31 = h3/h1;
r   = mean([r21 r32]); %(verificare che r21=r32)

%% read data
tic
data1 = readtable('FINE_INC/history.csv');
data2 = readtable('MEDIUM_INC/history.csv');
data3 = readtable('COARSE_INC/history.csv');

figure('Name', 'Iter vc CL-CD')
subplot(2,1,1)
hold on, grid on
plot(data1.Inner_Iter, data1.CL)
plot(data2.Inner_Iter, data2.CL)
plot(data3.Inner_Iter, data3.CL)
subplot(2,1,2)
hold on, grid on
plot(data1.Inner_Iter, data1.CD)
plot(data2.Inner_Iter, data2.CD)
plot(data3.Inner_Iter, data3.CD)

figure('Name', 'CL-h CD-h')
subplot(1,2,1)
hold on, grid on
scatter(h1,data1.CL(end))
scatter(h2,data2.CL(end))
scatter(h3,data3.CL(end))
subplot(1,2,2)
hold on,grid on
scatter(h1,data1.CD(end))
scatter(h2,data2.CD(end))
scatter(h3,data3.CD(end))
toc

%% variable under analysis
% phi1 = data1.CD(end);
% phi2 = data2.CD(end);
% phi3 = data3.CD(end);
%  
phi1 = data1.CL(end);
phi2 = data2.CL(end);
phi3 = data3.CL(end);

eps21 = phi2 - phi1;
eps32 = phi3 - phi2;

%% compute the apparent order of convergence
p1 = (abs(log(abs(eps32/eps21))))/log(r);

% Richardsopn extrapolation
phi_ext = phi1 + (phi1-phi2)/(r.^p1-1);

% relative errors between different grids
err_21 = abs((phi1-phi2)/phi1);
err_32 = abs((phi2-phi3)/phi2);

% extrapolated relative errors
err_ext = abs((phi_ext-phi1)/phi_ext);

% grid convergence index
Fs     = 1.25;
GCI_21 = Fs*abs((err_21)/(r21^p1-1));
GCI_32 = Fs*abs((err_32)/(r32^p1-1));

K1 = GCI_32/(r^p1*GCI_21);

%% fixed-point model
s = sign(eps32 - eps21);

p0 = p1;
q0 = 1;
x0 = [q0,p0];

x  = fsolve(@(x)conv_order(x,s,r21,r32,eps21,eps32),x0);
q  = x(1);
p2 = x(2);

phi21_ext   = (r21^p2*phi1 - phi2)/(r21^p2 - 1);
e_rel21     = abs((phi1 - phi2)/phi1);
e_rel32     = abs((phi2 - phi3)/phi2);
e_rel21_ext = abs((phi21_ext - phi1)/phi21_ext);

gci_21 = Fs*(abs(e_rel21/(r21^p2 - 1)));
gci_32 = Fs*(abs(e_rel32/(r32^p2 - 1)));

K2 = gci_32/(r^p2*gci_21);

%%
% check that trhe sol is in the symptotic range of convergence
% by checking that (GCI_coarse/(r^p*GCI_fine)) is close to 1 (??)

%% plot results
coeff       = [phi1 phi2 phi3];
coeff_ext   = [phi_ext phi1];
err         = [err_ext err_21, err_32];
N           = [N1 N2 N3];
h           = [h1 h2 h3];
h_ext       = [0, h1];

figure(3)
plot(h, coeff, 'r-o', h_ext, coeff_ext, 'b--o', 'linew', 1.5)
grid on
%xlabel('h'), ylabel('CL')
xlabel('h'), ylabel('CD')

figure(4)
plot([0 h1 h2], err, 'r-*','linew',1.5)
grid on
xlabel('h'), ylabel('err')

figure(5)
plot(data1.Inner_Iter, data1.CL, data2.Inner_Iter, data2.CL, data3.Inner_Iter, data3.CL)
grid on
figure(6), 
plot(data1.Inner_Iter, data1.CD, data2.Inner_Iter, data2.CD, data3.Inner_Iter, data3.CD)
grid on

%% function
function y = conv_order(x,s,r21,r32,eps21,eps32)
    y(1) = x(1) - log((r21.^x(2) - s)/(r32.^x(2) - s));
    y(2) = x(2) - (abs(log(abs(eps32/eps21)) + x(1)))/log(r21);
end