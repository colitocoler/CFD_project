%% Intro
clear
close all
clc

l_main= 0.3; %30cm

% Coordinate profilo
main= importdata('profilogiusto.txt')';

%%
% Dati
s  = 0.8;         % traslazione lungo x
t  = 0.08;        % traslazione lungo y 
a1 = 30;          % rotazione flap
a2 = 1.5;         % rotazione mainplane
r = 0.8;          % fattore di scala tra main e flap 


%main(73) leading edge
%main(1) trailing edge

% Rotazione
matrix1 = rotz(a1);
matrix2 = rotz(a2);

flap = matrix1(1:2,1:2)*main*r;
main = matrix2(1:2,1:2)*main;

flap(1,:) = flap(1,:) + s;
flap(2,:) = flap(2,:) + t;

ref_len= sqrt((main(1,73)-flap(1,1))^2 + (main(2,73)-flap(2,1))^2);
main = main*l_main;
flap = flap*l_main;

% Plot 
plot(main(1,:), main(2,:))
hold on
plot(flap(1,:), flap(2,:))
axis equal
grid on

plot([main(1,73),flap(1,1)],[main(2,73),flap(2,1)])

LEN_REN=  l_main*ref_len;

%% MAIN
dim_fan=0.01; %dimensione al fan
dim_mid=0.1; %dimensione in mezzo
dim_nose=0.01; %dimensione sul naso

N_points=15; %numero di punti infittimento sopra e sotto
N_points2=19; %numero di punti infittimento naso
N_points3=22;    %numero di punti sfittimento naso
N_points4=13;

prog=(dim_mid/dim_fan)^(1/(N_points-1));
prog2=(dim_mid/dim_nose)^(1/(N_points2-1));
prog3=(dim_nose/dim_mid)^(1/(N_points3-1));
prog4=(dim_mid/dim_fan)^(1/(N_points4-1));

disp('MAIN')

for ii=1:length(main)
    
    if ii<=15 %fine sotto

        dim=dim_fan*prog^(ii-1); 
        num = num2str(ii);
        dim = num2str(dim);
        x_coord = num2str(main(1,ii));
        y_coord = num2str(main(2,ii));
        str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*m};');
        disp(str);

    else

        if ii>55 && ii<75  %infittimento naso

                dim=dim_mid/prog2^(ii-56); %metti uno in piu di dove inizia
                num = num2str(ii);
                dim = num2str(dim);
                x_coord = num2str(main(1,ii));
                y_coord = num2str(main(2,ii));
                str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*m};');
                disp(str);
        else

                
                if ii>74 && ii<97%sfittimento

                    dim=dim_nose/prog3^(ii-75); %metti uno in piu di dove inizia
                    num = num2str(ii);
                    dim = num2str(dim);
                    x_coord = num2str(main(1,ii));
                    y_coord = num2str(main(2,ii));
                    str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*m};');
                    disp(str);            

                else

                    if ii>120 && ii<134 %infittimento sopra

                        dim=dim_mid/prog4^(ii-121); %metti uno in piu di dove inizia
                        num = num2str(ii);
                        dim = num2str(dim);
                        x_coord = num2str(main(1,ii));
                        y_coord = num2str(main(2,ii));
                        str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*m};');
                        disp(str);            

                    else

                        if ii>133 %costante sopra nella zona dove c'è il flap

                            dim=dim_fan;%mid/prog^(ii-126); %metti uno in piu di dove inizia
                            num = num2str(ii);
                            dim = num2str(dim);
                            x_coord = num2str(main(1,ii));
                            y_coord = num2str(main(2,ii));
                            str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*m};');
                            disp(str);

                        else

                            num = num2str(ii);
                            x_coord = num2str(main(1,ii));
                            y_coord = num2str(main(2,ii));
                            str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,h};');
                            disp(str)
                            
                        
                    end
                end
            end
        end
    end
end

%% FLAP
dim_fan=0.01; %dimensione al fan
dim_mid=0.1; %dimensione in mezzo
dim_mid_sotto=0.1; %dimensione in mezzo sotto
dim_nose=0.01; %dimensione sul naso

N_points=15; %numero di punti infittimento sopra e sotto
N_points2=15; 
N_points3=28;    %numero di punti sfittimento naso
N_points4=14; 

prog=(dim_mid/dim_fan)^(1/(N_points-1));
prog2=(dim_mid_sotto/dim_fan)^(1/(N_points2-1));
prog3=(dim_fan/dim_nose)^(1/(N_points3-1));
prog4=(dim_nose/dim_mid)^(1/(N_points4-1));

disp('FLAP')

for ii=1:length(main)
    
    
    if ii<=15 %sfittimento per racordarsi col fan, sotto

        dim=dim_fan*prog^(ii-1); 
        num = num2str(ii+length(flap));
        dim = num2str(dim);
        x_coord = num2str(flap(1,ii));
        y_coord = num2str(flap(2,ii));
        str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*mf};');
        disp(str);

    else

        if ii>15 && ii<35 %costante sotto

                dim=dim_mid_sotto;
                num = num2str(ii+length(flap));
                dim = num2str(dim);
                x_coord = num2str(flap(1,ii));
                y_coord = num2str(flap(2,ii));
                str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,hf};');
                disp(str);
        else

            if ii>34 && ii<50 %infittimento sotto per arrivare con elementi grossi giusti in prossimità del main

                    dim=dim_mid_sotto/prog2^(ii-35); %metti uno in piu di dove inizia
                    num = num2str(ii+length(flap));
                    dim = num2str(dim);
                    x_coord = num2str(flap(1,ii));
                    y_coord = num2str(flap(2,ii));
                    str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*mf};');
                    disp(str);
            else

                if ii>49 && ii<78 %infittimento naso

                    dim=dim_fan/prog3^(ii-50); %metti uno in piu di dove inizia
                    num = num2str(ii+length(flap));
                    dim = num2str(dim);
                    x_coord = num2str(flap(1,ii));
                    y_coord = num2str(flap(2,ii));
                    str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*mf};');
                    disp(str);            

                else

                    if ii>77 && ii<92 %sfittimento naso

                        dim=dim_nose/prog4^(ii-78); %metti uno in piu di dove inizia
                        num = num2str(ii+length(flap));
                        dim = num2str(dim);
                        x_coord = num2str(flap(1,ii));
                        y_coord = num2str(flap(2,ii));
                        str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*mf};');
                        disp(str);            

                    else

                        if ii>125 %infittimento sopra per raccordarsi col fan, sopra

                            dim=dim_mid/prog^(ii-126); %metti uno in piu di dove inizia
                            num = num2str(ii+length(flap));
                            dim = num2str(dim);
                            x_coord = num2str(flap(1,ii));
                            y_coord = num2str(flap(2,ii));
                            str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,',dim,'*mf};');
                            disp(str);

                        else

                            num = num2str(ii+length(flap));
                            x_coord = num2str(flap(1,ii));
                            y_coord = num2str(flap(2,ii));
                            str = strcat('Point(',num,') = {' , x_coord , ',' , y_coord, ',0,hf};');
                            disp(str)
                            
                        end
                    end
                end
            end
        end
    end
end