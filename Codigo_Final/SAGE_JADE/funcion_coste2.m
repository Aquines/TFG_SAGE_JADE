%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Funci�n auxiliar para el c�lculo de la funci�n de coste en base a los
% par�metros utilizados. Se han mantenido las versiones m�s interesantes
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Llamada: C = funcion_coste2(X_l,freq_n,params,array_pos_rx,array_pos_tx,Tipo)
% 
% Par�metros:
%   -X_l: matriz con los valores de medida 
%   -freq_n: vector con las frecuencias utilizadas en la medida
%   -params: array de par�metros estimados para calcular el valor
%   -array_pos_rx: posici�n de los elementos del array receptor
%   -array_pos_tx: posici�n de los elementos del array transmisor
%   -Tipo: modelo de funcion de coste a usar
%   (en la pr�ctica se han implementado con el modelo '3D_AOA2'
%
% Salida:
%   -C: valor de la funci�n de coste para los par�metros introducidos
%--------------------------------------------------------------------------

function C = funcion_coste2(X_l,freq_n,params,array_pos_rx,array_pos_tx,Tipo)

N=size(X_l,1); %N�mero de elementos transmisor
M=size(X_l,2); %N�mero de elementos receptor
K=size(X_l,3); %N�mero de frecuencias
%Extraemos los par�metros necesarios

switch(Tipo)
    case '3D_TOA' %Cambiarlo despu�s a 3D_TOA_SIMO
        toa = rango;
        az_tx = params(1);  el_tx = params(2);
        az_rx = params(3);  el_rx = params(4);
        %ampl = params(5);
        %Pasamos de coordenadas circulares a cartesianas los �ngulos
        [~,~,eRX] = az_el_solid_angles(az_rx,el_rx,[],'d');
        [~,~,eTX] = az_el_solid_angles(az_tx,el_tx,[],'d');
        %Hallamos el valor del diagrama de radiaci�n
        f_rad_rx = diagrama_rad(az_rx,el_rx,'bocina'); 
        f_rad_tx = diagrama_rad(az_tx,el_tx,'bocina');
        %Inicializamos la funci�n de coste
        C = zeros(1,length(toa));
        for tau = 1:length(toa)
            C_aux = 0;
            for k = 1:length(freq_n)
                %Steeting vector del transmisor
                c1 = zeros(1,length(array_pos_tx(:,1)));
                c2 = zeros(1,length(array_pos_rx(:,1)));
                for i = 1:length(array_pos_tx(:,1))
                    c1(i) = f_rad_tx*exp(1i*2*pi*(freq_n(k)/(3e8))*dot(eTX,array_pos_tx(i,:)));
                end
                
                %Steering vector del receptor
                for j = 1:length(array_pos_rx(:,1))
                    c2(j) = f_rad_rx*exp(1i*2*pi*(freq_n(k)/(3e8))*dot(eRX,array_pos_rx(j,:)));
                end
                
                C_aux = C_aux + exp(1i*2*pi*freq_n(k)*toa(tau))*X_l(:,:,k)*conj(c1);
            end
            C(tau) = c2*C_aux';
        end

    case '3D_AOA2'
        %fprintf("\nHas seleccionado esta opci�n");
        %Extraemos los par�metros que calculamos
        toa = params(1);        %ampl = params(6);
        az_tx = params(2);      el_tx = params(3);
        az_rx = params(4);      el_rx = params(5);     
        
        %Hallamos el valor del diagrama de radiaci�n
        f_rad_rx = diagrama_rad(az_rx,el_rx,'bocina'); 
        f_rad_tx = diagrama_rad(az_tx,el_tx,'bocina');

        %Pasamos de coordenadas circulares a cartesianas los �ngulos
        [~,~,eRX] = az_el_solid_angles(az_rx,el_rx,[],'d');
        [~,~,eTX] = az_el_solid_angles(az_tx,el_tx,[],'d');
        
        
        %Steering vector del receptor
        c2 = zeros(length(array_pos_rx(:,1)),1);
        for j = 1:length(array_pos_rx(:,1))
            c2(j,:) = f_rad_rx*exp(1i*2*pi*(freq_n(ceil(length(freq_n)/2))/(3e8))*dot(eRX,array_pos_rx(j,:)));
%             c2(j,:) = exp(1i*2*pi*(freq_n(ceil(length(freq_n)/2))/(3e8))*dot(eRX,array_pos_rx(j,:)));
        end
          
        %Steeting vector del transmisor
        c1 = zeros(length(array_pos_tx(:,1)),1);
        for i = 1:length(array_pos_tx(:,1))
            c1(i,:) = f_rad_tx*exp(1i*2*pi*(freq_n(ceil(length(freq_n)/2))/(3e8))*dot(eTX,array_pos_tx(i,:)));
%             c1(i,:) = exp(1i*2*pi*(freq_n(ceil(length(freq_n)/2))/(3e8))*dot(eTX,array_pos_tx(i,:)));
        end
        C = c2'*sum(exp(1i*2*pi*freq_n*toa).*X_l*conj(c1),2);
        
    otherwise
        error('Error: No has seleccionado ninguna funci�n de coste');    
end

end