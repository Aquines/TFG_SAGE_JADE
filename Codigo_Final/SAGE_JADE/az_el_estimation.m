%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Funci�n auxiliar del algoritmo JADE para hallar los �ngulos de llegada
% mediante la maximizaci�n de la matriz B
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Llamada: [azm, ele] = az_el_estimation(b, azm_range, ele_range, array_pos)
% 
% Par�metros:
%   -b: matriz B 
%   -el_in: �ngulo de elevaci�n theta (grados)
%   -s_in: array con las posiciones en sistema cartesiano [X,Y,Z]
%   -modo: modo de operacion de la funci�n
%           -'r': cambio de cartesianas a �ngulos de esf�ricas
%           -'d': cambio de angulos de esf�ricas a cartesianas
% Salida:
%   -az_out: �ngulo azimutal phi de salida correspondiente a unas coordenadas
%   cartesianas (grados)
%   -el_out: �ngulo de elevaci�n theta de salida correspondiente a unas 
%   coordenadas cartesianas (grados)
%   -s_out: array con las posiciones en sistema cartesiano correspondientes
%   a unos �ngulos de esf�ricas [X,Y,Z]
%--------------------------------------------------------------------------

function [azm, ele] = az_el_estimation(b, azm_range, ele_range, array_pos)
    
d2pi = pi/180;
    
for ele=1:length(ele_range)
    for azm = 1:length(azm_range)
        %-----NOTA---------------------------------------------------------
        % Otras configuraciones de rho son posibles en distintos planos. La
        % expresi�n general ser�a
        % rho = [cos(azm_range*d2pi).*cos(ele_range(ke)*d2pi); sin(azm_range*d2pi).*cos(ele_range(ke)*d2pi); cos(azm_range(azm)*0).* cos(ele_range(ele)*d2pi)];
        %------------------------------------------------------------------
        rho = [cos(azm_range(azm)*d2pi).*sin(ele_range(ele)*d2pi); cos(azm_range(azm)*0).* cos(ele_range(ele)*d2pi)];
        azel(azm,ele) = pow2(abs(b'*exp(array_pos*rho)));
    end
end

%Buscamos en 2D el valor m�ximo
[m1, im1] = max(azel);
[m2, im2] = max(m1);
azm = azm_range(im2);
ele = ele_range(im1(im2));

%-----------------EXTRA----------------------------------------------------
% Representaci�n en 3D de la funci�n que estamos maximizando
% [AZ,EL] = meshgrid(azm_range, ele_range);
% figure(10); mesh(AZ,EL,azel/max(azel(:))); 
% xlabel('Azimuth (�)'); 
% ylabel('Elevation (�)');
% ylim([azm_range(1), azm_range(end)]); zlim([0 1.1]);%view(90,0);
%--------------------------------------------------------------------------
end