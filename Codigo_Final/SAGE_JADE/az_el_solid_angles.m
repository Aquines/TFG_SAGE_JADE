%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Funci�n para transformar de coordenadas cartesianas a esf�ricas y
% viveversa
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Llamada: [az_out,el_out,s_out] = az_el_solid_angles(<az_in>,<el_in>,<s_in>,modo)
% 
% Par�metros:
%   -az_in: �ngulo azimutal phi (grados)
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


function [az_out,el_out,s_out] = az_el_solid_angles(az_in,el_in,s_in,modo)
 
%Pasamos a radianes los �ngulos
az_in = az_in .* pi/180;
el_in = el_in .* pi/180;

switch(modo)
    case 'r' %Cambiamos de �ngulo s�lido a az y el
        el_out = acos(s_in(3))*(180/pi);
        az_out = asin(s_in(2)/sin(el_out))*(180/pi);
        s_out = s_in;
    case 'd' %Cambiamos de az y el a �ngulo s�lido
        s_out(:) = [cos(az_in).*sin(el_in),sin(az_in).*sin(el_in),cos(el_in)]';
        az_out = az_in.*(180/pi);
        el_out = el_in.*(180/pi);
end
        

    
