%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Algoritmo de cancelaci�n para la separaci�n de se�ales superpuestas
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Llamada: x_out = intercancelacion(H_k,toa,OmegaR,OmegaT,ampl,i,freq_n,array_pos,Modelo)
% 
% Par�metros:   -H_k    : vector con las muestras del canal completo
%               -toa    : Tiempo de Llegada para cada MPC
%               -OmegaR : �ngulo AZ y EL de llegada
%               -OmegaT : �ngulo AZ y EL de salida (para futuras mejoras)
%               -ampl   : Amplitud de cada MPC
%               -i      : �ndice del MPC de inter�s
%               -freq_n : vector de frecuencias muestreadas
%               -K_pos  : vector de posiciones de array muestreadas
%               -Modelo : indica el tipo de cancelaci�n de componentes
%                         -> 'serie' - Successive Interference Cancelation
%                         -> 'paralelo' -Paralel Interference Canelaction
%       
% Salida:       -x_out  : componente del canal correspondiente al MPC i
%------------------------POSIBLE MEJORA------------------------------------
% -array_pos_tx : vector de posiciones muestreadas del array de transmisi�n
%--------------------------------------------------------------------------

function x_out = intercancelacion(H_k,toa,OmegaR,OmegaT,ampl,i,freq_n,array_pos,Modelo)

%Obtenemos el tama�o del array
Dim = size(H_k,1);

%Obtenemos el n�mero de MPCs que intervienen
L = size(toa,2); %Se podr�a hacer con cualquiera de los 4 par�metros

switch(lower(Modelo))
    case 'serie' %Successive Interference Cancelation
        %Cancelamos las interferencias dominantes
        Componentes = [1:i-1];
    case 'paralelo' %Paralel Interference Cancelation
        Componentes = [1:L];
        %Eliminamos la componente que no nos interesa
        Componentes(find(Componentes == i))=[];
    otherwise
        error("\nError: modo de Cancelaci�n de Interferencias Desconocido");
end

%Hacemos una copia de la matriz de componentes
x_out = H_k;

%Cancelamos las componentes secuencialmente
for Indice = Componentes
    Theta = [toa(Indice) OmegaR(1,Indice) OmegaR(2,Indice) OmegaT(1,Indice) OmegaT(2,Indice) ampl(Indice)];
    %Cancelamos la componente actual
    aux = modelo_senial(Theta,Dim,freq_n,array_pos,'modelo2');
    x_out = x_out - permute(aux,[2 3 1]);
    
    %****************NOTA**************************************************
    %El modelo de la se�al utilizado es uno que tiene en cuenta el steering
    %vector del transmisor. Como en nuestro caso espec�fico el TX solo
    %tiene una posici�n (CANAL SIMO) en las medidas no aparece esta
    %dimensi�n por lo que es necesario ajustar el orden de las dimensiones
    %para poder operar. Cuando las medidas se hagan con varios TX se podr�
    %eliminar
    %**********************************************************************
   
    
end


end 





