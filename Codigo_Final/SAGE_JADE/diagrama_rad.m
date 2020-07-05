

function f_rad = diagrama_rad(az_in,el_in,tipo_antena)

persistent bocina
if isempty(bocina)
    %Leemos la medida (en este caso es potencia en Watts)
    %bocina = xlsread('DATA.CSV.xlsx','B2:BU187'); %Diagrama alternativo
    bocina = load("Medidas_Usadas/d"); 
end
tipo_antena = 'otro';
switch (tipo_antena)
      
    case 'bocina_inicial'
        data = bocina;
        %Vectores de coordenadas
        theta = data(1,2:end); phi = data(2:end,1)';
        %A continuaci�n buscamos la posici�n en la matriz m�s pr�xima al valor
        %de radiaci�n que buscamos
        [~,pos_theta] = min(abs(theta-el_in));
        [~,pos_phi] = min(abs(phi-az_in));
        %Hallamos el valor del diagrama de radiaci�n en ese punto
        f_dB = data(2:end,2:end);
        f = 10^(f_dB(pos_phi,pos_theta)/10);

    case 'bocina'
        data = bocina.Mgain_34GHz_360;
        %Buscamos el m�ximo del diagrama para hallar la direcci�n a la que
        %apunta del diagrama
        [theta_max,phi_max]=find_max_peak(abs(data),1:size(data,1),1:size(data,2));
        %Normalizamos el diagrama
        data = data/data(phi_max,theta_max);
        
        %Conocido el m�ximo rotamos la antena para situarla perpendicular
        %al plano XZ de manera que los m�ximos est�n en theta=90 y phi=90
        %(esto se realiza ya que puede que alguna vez no tengamos el
        %diagrama centrado)
        
        %La forma m�s sencilla es cambiar el valor de los �ngulos de
        %entrada
        az_in = az_in + phi_max - 90;
        el_in = el_in + theta_max - 90;
        
        %Vectores de coordenadas
        theta = 1:size(data,2); phi = (1:size(data,1));
        %A continuaci�n buscamos la posici�n en la matriz m�s pr�xima al valor
        %de radiaci�n que buscamos
        [~,pos_theta] = min(abs(theta-el_in));
        [~,pos_phi] = min(abs(phi-az_in));
        %Hallamos el valor del diagrama de radiaci�n en ese punto
        f=data(pos_phi,pos_theta); %Ya esta en unidades lineales
    
        
    otherwise
        f = 1;
end

f_rad = f;

end