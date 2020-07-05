%% LABORATORIO 5G - SWAT TIC-244
% Universidad de Granada
%--------------------------------------------------------------------------
% Funci�n para hallar el PDP medio recibido en una direcci�n y polarizaci�n
% determinada. Obtenemos un par de gr�ficas donde se muestra el PDP en
% unidades lineales y logar�tmicas.
%--------------------------------------------------------------------------
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Llamada: [RMS_DS, RMS_DS_Envolvente] = PDP_canal(medida,pos_y,polar,canal)
%
% Par�metros:
%   -medida: nombre del fichero de medida de la c�mara ('nombre_fichero')
%   -pos_y: �ndice de una posici�n del Eje Y de la c�mara. 
%   -polar: seleccionamos la posici�n del vector de polarizaci�n eje E deseada.
%   Se puede dejar en blanco y se tomar� el valor central sin polarizaci�n.
%   -canal: seleccionamos la direcci�n del canal que queremos medir
%   correspondiente a uno de los par�metros S
%           -'S21': par�metro S21
%           -'S12': par�metro S12
%
% Salida:
%   -RMS_DS: valor medio de retardo del PDP
%   -RMS_DS_Envolvente: valor medio de retardo de la envolvente de PDP
%--------------------------------------------------------------------------

function [RMS_DS, RMS_DS_Envolvente] = PDP_canal(medida,pos_y,polar,canal)

%% CARGA DE DATOS C�MARA %%

switch(canal)
    case 'S12'
        param = 1;
    case 'S21'
        param = 2;
    otherwise
        param = 1;
end

load(medida)
Sxy=S;
total = zeros(1,size(Sxy,5));


%Hallamos el PDP medio de todos los elementos de la antena
for i = 1:length(Xs)
    for j = 1:length(Zs)
        p_s12 = reshape(Sxy(i,j,pos_y,polar,:,param),1,size(Sxy,5));
%         p_s12 = awgn(p_s12,40,'measured');
        total(1,:) = total(1,:) + p_s12(1,:); 
    end
end
p_s12 = total./(length(Xs)*length(Zs))

%Rango de frecuencias
fini=freqInicial*1e9;
fstop=freqFinal*1e9;
fres_aux=linspace(fini,fstop,puntosFreq);


%% Relleno con ceros y reflejo de la se�al para que sea sim�trica %%
dF=fres_aux(2)-fres_aux(1); %Resoluci�n en frecuencia
T=1/(2*fstop);  % Periodo de Muestreo
N_frec=round(fstop/dF);  % Desde 0
relleno=zeros(1,N_frec-length(p_s12));
P_rellena=[relleno p_s12];

Preflejada(1:length(P_rellena))=P_rellena(end:-1:1);



%% IFFT %%
[h_t3] = ifft([P_rellena conj(Preflejada)],'symmetric');
tiempo=1:length(h_t3);
t3=T*tiempo;

h_t=h_t3; t=t3;

%% Calculo del PDP y Normalizaci�n %%
PDP=abs(h_t).^2;
PDP=PDP(1:round(length(PDP)/2));    %Por simetr�a de la IFFT, me quedo con la primera mitad
[max_p ind_max] =max(abs(PDP));     %Normalizaci�n
%PDP=PDP(ind_max:end);
PDP_norm=abs(PDP)/max_p;
[u,b]=max(PDP_norm);
t=t(1:length(PDP_norm));


%% Representaci�n
figure(10)
subplot(2,1,1)
plot(t/1e-9,PDP_norm);hold on
title('Power Delay Profile (PDP)');
xlabel('Tiempo (ns)');
ylabel('Potencia Normalizada');
%xlim([0 500]); 
%ylim([0 1]); 

%% Se�al en dB %%

PDP_log=10*log10(PDP_norm);
figure(10)
subplot(2,1,2)
hold on
plot(t/1e-9,PDP_log);hold on
title('Power Delay Profile (PDP)');
xlabel('Tiempo (ns)');
ylabel('Potencia Normalizada (dB)');
ylim([-80 0]); 

%% C�LCULO DEL RMS DELAY SPREAD A PARTIR DE LA SE�AL OBTENIDA CON IFFT %%
%ds_bluetest=sqrt((sum(PDP_norm.*(t.^2))/sum(PDP_norm))-(sum(PDP_norm.*t)/sum(PDP_norm)).^2)
tau_med=sum(PDP_norm.*t)/sum(PDP_norm);
RMS_DS=sqrt(sum(PDP_norm.*((t-tau_med).^2))/sum(PDP_norm))

%% Suavizado de la se�al (Me quedo con la envolvente) %%
PDP_log = env_secant(t, 10*log10(PDP_norm),round(length(P_rellena)*0.01),'top');
plot(t/1e-9,PDP_log,'r');hold off

%% Reconstruccion del PDP a partir de la se�al suavizada %%
figure(10)
subplot(2,1,1)
PDP_log=PDP_log(1:length(t));
h_lineal=10.^(PDP_log./10);
plot(t/1e-9,h_lineal,'r');hold off
PDP_norm=h_lineal;

%% C�LCULO DEL RMS DELAY SPREAD A PARTIR DE LA ENVOLVENTE %%
%ds_bluetest2=sqrt((sum(PDP_norm.*(t.^2))/sum(PDP_norm))-(sum(PDP_norm.*t)/sum(PDP_norm)).^2)
tau_med=sum(PDP_norm.*t)/sum(PDP_norm);
RMS_DS_Envolvente=sqrt(sum(PDP_norm.*((t-tau_med).^2))/sum(PDP_norm))

end