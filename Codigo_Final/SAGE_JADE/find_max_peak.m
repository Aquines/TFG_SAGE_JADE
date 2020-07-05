%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Funci�n auxiliar para el c�lculo del m�ximo de una matriz de dos
% dimensiones.
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Llamada: [phi, theta] = find_max_peak(spec, azm_range, ele_range)
% 
% Par�metros:
%   -spec: funci�n 2D con los valores en el eje Z para cada posici�n X,Y
%   -azm_range: rango de �ngulos azimutales a buscar
%   -ele_range: rango de �ngulos de elevaci�n a buscar
%
% Salida:
%   -phi: �ngulo azimutal phi m�ximo (grados)
%   -theta: �ngulo de elevaci�n theta m�ximo (grados)
%--------------------------------------------------------------------------

function [phi, theta] = find_max_peak(spec, azm_range, ele_range)
    
[m1, im1] = max(spec);
[m2, im2] = max(m1);
phi = azm_range(im2);
theta = ele_range(im1(im2));

%-----------PARA REPRESENTACI�N DE LA FUNCI�N 2D A MAXIMIZAR---------------
% [AZ,EL] = meshgrid(azm_range, ele_range);
% figure(10); mesh(AZ,EL,spec); xlabel('Azimuth (degree)'); ylabel('Elevation (degree)');
% ylim([azm_range(1), azm_range(end)]); zlim([0 1.1]);%view(90,0);

end