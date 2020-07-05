%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Funci�n para calcular la envolvente de unos datos <y> sobre unos datos
% <x>. Busca los puntos m�ximos de la funci�n y los une resultando en una
% envolvente de los datos. Al final se realiza una interpolaci�n sobre los
% valores originales de X. La envolvente se reaiza de la parte superior o
% inferior de la funci�n.
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%
% Atribuci�n al autor original: Andreas Martin, Volkswagen AG, Germany
%--------------------------------------------------------------------------
% Llamada: [env] = env_secant(x_data, y_data, view, side) 
%
% Par�metros:
%   -x_data: datos de la funci�n en el eje de abscisas
%   -y_data: valores de la funci�n en el eje Y 
%   -view: l�mite de valores para la funci�n de la envolvente
%   -side: elecci�n de la envolvente superior o inferior
%       -'top': envolvente superior
%       -'bottom': envolvente inferior
%
% Salida:
%   -env: envolvente de la se�al de entrada
%--------------------------------------------------------------------------


function [env] = env_secant(x_data, y_data, view, side) 



side = strcmpi ( {'top','bottom'}, side ) * [ 1 ; -1 ];

assert (view > 1, ...
    'Parameter <view> too small!');
assert (ndims (x_data) == 2, ...
    'Parameter <x_data> has to be vector type!' );
assert (size (x_data, 1) == 1 || size (x_data, 2) == 1, ...
    'Parameter <x_data> has to be vector type (Nx1)!' );
assert (ndims (y_data) == 2, ...
    'Parameter <y_data> has to be vector type (Nx1)!' );
assert (size (y_data, 1) == 1 || size (y_data, 2) == 1, ...
    'Parameter <y_data> has to be vector type (Nx1)!' );
assert (length (x_data) == length (y_data), ...
    'Parameters <x_data> and <y_data> must have same length!' );
assert (side ~= 0, ...
    'Parameter <side> must be ''top'' or ''bottom''' );

data_len = length (y_data);
x_new = [];
y_new = [];

i = 1;
while i < data_len;
    m_max = -Inf; % stores maximum slope in forward viewed neighbourhood
    for ii = i+1:min (i+view, data_len);
        m = ( y_data(ii) - y_data(i) ) / (ii-i) * side;
        % Equidistant x_data assumed! Use next row instead, if not:
        % m = ( y_data(ii) - y_data(i) ) / ( x_data(ii) - x_data(i) );
        if m >= m_max;
            % New max. slope found: store new "observation point"
            % always traced when ii==1
            m_max = m;
            i_op = ii;
        end;
    end;
    x_new = [ x_new x_data(i_op) ];
    y_new = [ y_new y_data(i_op) ];
    i = i_op;
end;

env = interp1 (x_new, y_new, x_data,'linear', 'extrap');
