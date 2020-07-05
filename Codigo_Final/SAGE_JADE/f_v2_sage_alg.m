%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Algoritmo SAGE (Space Alternating Generalized Expectation-maximization) para
% localizaci�n 3D 
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Llamada: [sage_aoa,sage_eoa,sage_toa,sage_amp] = f_v2_sage_alg(Medidas,L,iters,polar,Canal,toa_max)
% 
% Par�metros:
%   -Medidas: nombre del fichero de medida de la c�mara ('nombre_fichero')
%   -L: n�mero de MPC a estimar. 
%   -iters: n�mero de repeticiones del proceso de b�squeda
%   (recomendado [1-3])
%   -polar: seleccionamos la posici�n del vector de polarizaci�n deseada.
%   Se puede dejar en blanco y se tomar� el valor central sin polarizaci�n.
%   -Canal: seleccionamos la direcci�n del canal que queremos medir
%   correspondiente a uno de los par�metros S
%           -'S21': par�metro S21
%           -'S12': par�metro S12
%   -toa_max: valor m�ximo del rango de b�squeda de MPCs (ns)
%
% Salida:
%   -sage_aoa: �ngulo azimutal phi de llegada para cada MPC estimado (grados)
%   -sage_eoa: �ngulo de elevaci�n theta de llegada para cada MPC estimado (grados)
%   -sage_toa: tiempo de llegada para cada MPC estimado (s)
%   -sage_amp: amplitud de llegada para cada MPC estimado (dB)
%--------------------------------------------------------------------------

function [sage_aoa,sage_eoa,sage_toa,sage_amp] = f_v2_sage_alg(Medidas,L,iters,polar,Canal,toa_max)

%--------PARA REALIZACI�N DE PRUEBAS --------------------------------------
% Comentar la l�nea function y end.
% Descomentar las l�neas a continuaci�n
% clc; clear all;
% Medidas = 'Medidas/<nombrefichero>';
% L = ;
% iters = ;
% polar = ;
% SNR = ;
% Canal = ;
% toa_max = ;
%--------------------------------------------------------------------------

load(Medidas);
switch(Canal)
    case 'S12' %Par�metro S12
        Param_S = 1;
    case 'S21' %Par�metro S21
        Param_S = 2;
    otherwise
        Param_S = 1;
end
freq_n = linspace(freqInicial,freqFinal,puntosFreq)*1e9;
lambda = 3e8/mean(freq_n);

%Dimensiones de la matriz de medida
K = length(freq_n);
M = length(Xs)*length(Zs);   

%Obtenemos el array de posici�n de cada uno de los elementos del array de
%antenas en 3D en el receptor
array_pos_rx = [];
for i = 1:length(Xs)
    for j = 1:length(Zs)
        aux = [Xs(i),0,Zs(j)]*1e-2;
        array_pos_rx = [array_pos_rx; aux];
    end 
end

%Hacemos lo mismo para un array de transmisi�n
%*************************FUTURA AMPLIACI�N********************************
%M�s adelante podremos hacer lo mismo si tenemos un RPA en el emisor por
%ahora se queda as�
array_pos_tx = [0 0 0];
%**************************************************************************


%Para el estudio de las medidas se usar� un doble bucle que obtendr� los
%MPCs para valores de  
% -Orientaci�n/�ngulo del Transmisor (Ys)
% -Ruido que a�adiremos por software (SNR)
%**************POSIBLE MEJORA**********************************************
% -Distintos Valores de Polarizaci�n (Es) -> Est� fijada a 0� de desv�o
%**************************************************************************

for y=1:length(Ys)
    %Tomamos la se�al a utilizar
    signal_X = reshape(S(:,:,y,polar,:,Param_S),M,K); 
%     signal_X = awgn(signal_X,SNR);
    
    %Inicializamos a cero los valores a estimar
    toa = zeros(1,L); 
    OmegaR = zeros(2,L); %Estos par�metros contienen a su vez los �ngulos phi y
    OmegaT = zeros(2,L); %theta azimutal y de elevacion respectivamente
    ampl = zeros(1,L);
    
    for iteracion = 1:iters
        fprintf("\nIteracion: %i/%i\n",iteracion,iters);
        if iteracion == 1   %Inicializaci�n del algoritmo
            for IC = 1:L
                %Cancelaci�n de componentes usando t�cnica SIC
                x_i = intercancelacion(signal_X,toa,OmegaR,OmegaT,ampl,IC,freq_n,array_pos_rx,'serie');
                
                %Resoluci�n de b�squeda -> cte
                deltaTOF = [0.5, 0.5, 0.5]*1e-9;
                
                %Rango de valores a buscar
                rangTOF=[   0, toa_max;      %step1
                            5, 5;       %step2
                            1, 1]*1e-9; %step3
                
                for step = 1:length(deltaTOF)
                    toa_range = toa(IC)-rangTOF(step,1):deltaTOF(step):toa(IC)+rangTOF(step,2);
                    %Filtramos los valores que no sean positivos
                    toa_range = toa_range(toa_range>0);
                    
                    %C�lculo de la funci�n de coste
                    Coste = zeros(1,length(toa_range));
                    for t = 1:length(Coste)
                        Coste(t) = sum(pow2(abs(sum(exp(1i*2*pi*freq_n*toa_range(t)).*permute(x_i,[2 1])',2))),1);
                    end
                    %Maximizaci�n
                    [~,Index] = max(Coste);
                    toa(IC) = toa_range(Index);
                end
                
                %B�squeda de DOA con mayor precisi�n
                deltaDOA = [10, 2, 0.2, 0.02];
                
                for step = 1:length(deltaDOA)
                    %Definimos los rangos a buscar
                    
                    if deltaDOA(step) == 10 %Si estamos en la primera iteraci�n
                        azm_range = 0:10:180;
                        ele_range = 0:10:180;
                    else %En el resto de iteraciones
                        azm_range = OmegaR(1,IC)-deltaDOA(step)*5:deltaDOA(step):OmegaR(1,IC)+deltaDOA(step)*5;
                        ele_range = OmegaR(2,IC)-deltaDOA(step)*5:deltaDOA(step):OmegaR(2,IC)+deltaDOA(step)*5;
                    end
                    
                    %C�lculo de la funci�n de coste
                    Coste2 = zeros(length(azm_range),length(ele_range));
                
                    for azm = 1:size(Coste2,1)
                        for ele = 1:size(Coste2,2)
                            c2 = steering(array_pos_rx,azm_range(azm),ele_range(ele),lambda,'tx_rx');
                            Coste2(azm,ele) = pow2(abs(c2' * sum(exp(1i*2*pi*freq_n*toa(IC)).*permute(x_i,[2 1])',2)));
                        end
                    end
                    %Maximizaci�n
                    [azm_max,ele_max] = find_max_peak(Coste2,azm_range,ele_range);
                    OmegaR(1,IC) = azm_max;
                    OmegaR(2,IC) = ele_max;
                end
            end    
            %FIN DEL CICLO DE INICIALIZACI�N
            
        else                %Parte iterativa del algoritmo
            for IC = 1:L
                 x_i = intercancelacion(signal_X,toa,OmegaR,OmegaT,ampl,IC,freq_n,array_pos_rx,'serie');
                deltaTOF = [0.5, 0.5, 0.5]*1e-9;
                
                rangTOF=[   0, toa_max;      %step1
                            5, 5;       %step2
                            1, 1]*1e-9; %step3
                
                for step = 1:length(deltaTOF)
                    if step == 1
                        toa_range = [0:0.5:toa_max]*1e-9;
                    else 
                        toa_range = toa(IC)-rangTOF(step,1):deltaTOF(step):toa(IC)+rangTOF(step,2);
                    end
                    %Filtramos los valores que no sean positivos
                    toa_range = toa_range(toa_range>0);
                    
                    Coste = zeros(1,length(toa_range));
                    for t = 1:length(Coste)
                        Theta_l = [toa_range(t) OmegaT(1,IC) OmegaT(2,IC) OmegaR(1,IC) OmegaR(2,IC)];
                        Coste(t) = funcion_coste2(x_i,freq_n,Theta_l,array_pos_rx,array_pos_tx,'3D_AOA2');
                    end
                    [~,Index] = max(abs(Coste));
                    toa(IC) = toa_range(Index);
                end
                
                deltaDOA = [10, 2, 0.2, 0.02];
                
                for step = 1:length(deltaDOA)
                    %Definimos los rangos a buscar
                    
                    if deltaDOA(step) == 10 %Si estamos en la primera iteraci�n
                        azm_range = 0:10:180;
                        ele_range = 0:10:180;
                    else %En el resto de iteraciones
                        azm_range = OmegaR(1,IC)-deltaDOA(step)*5:deltaDOA(step):OmegaR(1,IC)+deltaDOA(step)*5;
                        ele_range = OmegaR(2,IC)-deltaDOA(step)*5:deltaDOA(step):OmegaR(2,IC)+deltaDOA(step)*5;
                    end
       
                    Coste2 = zeros(length(azm_range),length(ele_range));
                
                    for azm = 1:size(Coste2,1)
                        for ele = 1:size(Coste2,2)
                            Theta_l = [toa(IC) OmegaT(1,IC) OmegaT(2,IC) azm_range(azm) ele_range(ele)];
                            Coste2(azm,ele) = funcion_coste2(x_i,freq_n,Theta_l,array_pos_rx,array_pos_tx,'3D_AOA2');
                        end
                    end
                    [azm_max,ele_max] = find_max_peak(Coste2,azm_range,ele_range);
                    OmegaR(1,IC) = azm_max;
                    OmegaR(2,IC) = ele_max;
                end
               
                
                Theta_l = [toa(IC) OmegaT(1,IC) OmegaT(2,IC) OmegaR(1,IC) OmegaR(2,IC)];
                Coste3 = funcion_coste2(x_i,freq_n,Theta_l,array_pos_rx,array_pos_tx,'3D_AOA2');
                ampl(IC) = (1/(M*K))*Coste3;    
            end
        end
        %Almacenamos los datos de salida
        sage_amp(y,:)=ampl;
        sage_toa(y,:)=toa;
        sage_aoa(y,:)=OmegaR(1,:);
        sage_eoa(y,:)=OmegaR(2,:);
    end
    
    
    
end
toc
%Fin del algoritmo
end
%--------------PARA REPRESENTACI�N GR�FICA AL EJECUTAR COMO SCRIPT---------
% ytx = 1;
% figure(1)
% subplot(1,3,1)
% scatter3(sage_aoa(ytx,:),sage_toa(ytx,:)*1e9,sage_eoa(ytx,:),[],10*log10(abs(sage_amp(ytx,:))),'filled');
% xlabel("Azimuth (�)"); ylabel("TOA (ns)"); zlabel("Elevation (�)");view(0,0)
% xlim([80 100]); zlim([80 100]); 
% grid on
% colormap(jet)
% colorbar
% set(gca,'ColorScale','log');
% 
% subplot(1,3,2)
% scatter3(sage_aoa(ytx,:),sage_toa(ytx,:)*1e9,sage_eoa(ytx,:),[],10*log10(abs(sage_amp(ytx,:))),'filled');
% xlabel("Azimuth (�)"); ylabel("TOA (ns)"); zlabel("Elevation (�)");view(90,90)
% xlim([80 100]); zlim([80 100]); 
% grid on
% colormap(jet)
% colorbar
% set(gca,'ColorScale','log');
% 
% subplot(1,3,3)
% scatter3(sage_aoa(ytx,:),sage_toa(ytx,:)*1e9,sage_eoa(ytx,:),[],10*log10(abs(sage_amp(ytx,:))),'filled');
% xlabel("Azimuth (�)"); ylabel("TOA (ns)"); zlabel("Elevation (�)");view(90,0)
% xlim([80 100]); zlim([80 100]); 
% grid on
% colormap(jet)
% colorbar
% set(gca,'ColorScale','log');

