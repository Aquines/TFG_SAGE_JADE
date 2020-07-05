%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Funci�n auxiliar para el c�lculo del steering vector considerando el
% diagrama de radiaci�n de la antena base
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Llamada: [stv] = steering(K_pos,azm,ele,lambda,tipo)
%
% Par�metros:
%   -K_pos: posici�n en cartesianas de cada elemento del array de antenas
%   -azm: �ngulo azimutal phi a estudiar (grados) 
%   -ele: �ngulo de elevaci�n theta a estudiar (grados)
%   -lambda: longitud de onda media de la medida
%   -tipo: seleccionamos si consideramos o no el diagrama de radiaci�n
%
% Salida:
%   -RMS_DS: valor medio de retardo del PDP
%   -RMS_DS_Envolvente: valor medio de retardo de la envolvente de PDP
%--------------------------------------------------------------------------


function stv = steering(K_pos,azm,ele,lambda,tipo)

switch(tipo)
    case 'tx_rx' %Cuando consideramos el diagrama de radiaci�n de transmisor y receptor
        
        stv = zeros(size(K_pos,1),1);
        f_rad = diagrama_rad(azm,ele,'bocina');
        [~,~,eTX] = az_el_solid_angles(azm,ele,[],'d');
        for i = 1:size(K_pos,1)          
            stv(i) = f_rad*exp((1i*2*pi/lambda)*dot(eTX,K_pos(i,:)));
        end

    otherwise
        %Ejecuta la misma operaci�n que en la funci�n arst.m

        d2pi = pi/180;
        %Version 3D contando con una K_pos de 3 dimensiones
        %rho = [cos(azm*d2pi).*cos(ele*d2pi); sin(azm*d2pi).*cos(ele*d2pi);sin(ele*d2pi)];

        %Version 2D contando con una K_pos de 2 dimensiones
        %rho = [cos(azm*d2pi).*cos(ele*d2pi); sin(azm*d2pi).*cos(ele*d2pi)];
        
        rho=[cos(azm.*d2pi).*sin(ele.*d2pi); cos(0.*azm).*cos(ele.*d2pi)];
        stv = exp(K_pos*rho);     
       
end
