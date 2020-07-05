%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Funci�n para estimar la funci�n de respuesta de un array en el plano XZ 
% usando la f�rmula simple en funci�n de una matriz de posiciones y los
% �ngulos de llegada.
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Llamada: a = arst(K_pos, azm, ele)
% 
% Par�metros:
%   -K_pos: matriz con las posiciones en coordenadas cartesianas en 
%    2D de los elementos del array.
%   -azm: array de �ngulos azimutales a estudiar su respuesta
%   -ele: array de �ngulos de elevaci�n a estudiar su respuesta
% 
% Salida:
%   -a: respuesta del array de antenas a los �ngulos azm y ele en cada
%   elemento
%--------------------------------------------------------------------------

function a = arst(K_pos, azm, ele)

d2pi = pi/180; %Transformaci�n de �ngulo en grados a radianes

%Consideramos el plano XZ
rho=[cos(azm.*d2pi).*sin(ele.*d2pi); cos(0.*azm).*cos(ele.*d2pi)];

%--------------EXTRA-------------------------------------------------------
% Considerando coordenadas en 3D tendr�amos
% rho = [cos(azm*d2pi).*cos(ele*d2pi); sin(azm*d2pi).*cos(ele*d2pi); cos(0.*azm).*cos(ele.*d2pi)];
%--------------------------------------------------------------------------

a = exp(K_pos*rho); %Obtenemos la respuesta del array

end