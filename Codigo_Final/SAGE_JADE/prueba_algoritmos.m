%% Estudio de Escenarios C�MARA ANECOICA
% Trabajo de Fin de Grado - Curso 2019-2020 -
% Realizado por: Jes�s Enrique Fern�ndez-Aparicio Ortega
% Tutor: Juan Francisco Valenzuela Vald�s 
%--------------------------------------------------------------------------
% Este script tiene como finalidad emplear los algoritmos de estimaci�n del
% �ngulo de llegada a diferentes medidas realizadas en la c�mara y tiene
% diferentes secciones con distintas gr�ficas que permiten comparar los
% resultados as� como el escenario original.
%--------------------------------------------------------------------------
clc; clear all;
%% Selecci�n del Escenario
medida='Medidas_Usadas/PlanoExterior_Mesa_4x4x3x3';
L=3;
iters=3;
polar=2;
param='S21';

%% Estudio en Tiempo - Power Delay Profile



%% OJO

%Hay que cambiar los �ngulos donde buscamos y tener en cuenta el origen de
%los �ngulos theta y phi. Cuidado!!!!! Lo que hemos visto esta ma�ana
%%
[sage_aoa,sage_eoa,sage_toa,sage_amp]=f_v2_sage_alg(medida,L,iters,polar,param,40);
%%
[aml_azm,aml_ele,aml_toa,aml_amp] = jade_alg(medida,L,iters,polar,param,40);
%%
Ys = 2;
SNR = 1;
figure(9)
subplot(1,3,1)
scatter3(sage_aoa(Ys,:),sage_eoa(Ys,:),10*log10(abs(sage_amp(Ys,:))),'filled','g');
hold on
scatter3(aml_azm(Ys,:),aml_ele(Ys,:),10*log10(abs(aml_amp(Ys,:))),'filled','b');
hold off
% xlim([0 180]); ylim([0 90]);
xlabel("Azimutal");ylabel("Vertical");zlabel("Amplitud (dB)");
legend("SAGE","JADE");
grid on; view(90,90)

subplot(1,3,2)
scatter3(sage_toa(Ys,:),sage_eoa(Ys,:),10*log10(abs(sage_amp(Ys,:))),'filled','g');
hold on
scatter3(aml_toa(Ys,:),aml_ele(Ys,:),10*log10(abs(aml_amp(Ys,:))),'filled','b');
hold off
xlim([0 45*10^-9]);% ylim([0 90]);
xlabel("Tiempo");ylabel("Vertical");zlabel("Amplitud (dB)");
legend("SAGE","JADE");
grid on; view(90,90)

subplot(1,3,3)
scatter3(sage_toa(Ys,:),sage_aoa(Ys,:),10*log10(abs(sage_amp(Ys,:))),'filled','g');
hold on
scatter3(aml_toa(Ys,:),aml_azm(Ys,:),10*log10(abs(aml_amp(Ys,:))),'filled','b');
hold off
xlim([0 45*10^-9]);% ylim([0 90]);
xlabel("Tiempo");ylabel("Azimuth");zlabel("Amplitud (dB)");
legend("SAGE","JADE");
grid on; view(90,90)



% subplot(3,1,3)
% scatter3(sage_toa(Ys,:),sage_aoa(Ys,:),10*log10(abs(sage_amp(Ys,:))),'filled','g');
% hold on
% scatter3(aml_toa(Ys,:),aml_azm(Ys,:),10*log10(abs(aml_amp(Ys,:))),'filled','b');
% hold off
% xlim([0 5e-8])
% ylim([0 180]);
% xlabel("Tiempo");ylabel("Azimutal");zlabel("Amplitud (dB)");
% legend("SAGE","JADE");
% grid on

%%
ytx = 2;
figure(10)
subplot(1,3,1)
scatter3(aml_azm(ytx,:),aml_toa(ytx,:)*1e9,aml_ele(ytx,:),[],10*log10(abs(aml_amp(ytx,:))),'filled');
xlabel("Azimuth (�)"); ylabel("TOA (ns)"); zlabel("Elevation (�)");view(0,0)
xlim([0 180]); zlim([0 180]); 
grid on
colormap(jet)
colorbar
set(gca,'ColorScale','log');

subplot(1,3,2)
scatter3(aml_azm(ytx,:),aml_toa(ytx,:)*1e9,aml_ele(ytx,:),[],10*log10(abs(aml_amp(ytx,:))),'filled');
xlabel("Azimuth (�)"); ylabel("TOA (ns)"); zlabel("Elevation (�)");view(90,90)
xlim([0 180]); zlim([0 180]); 
grid on
colormap(jet)
colorbar
set(gca,'ColorScale','log');

subplot(1,3,3)
scatter3(aml_azm(ytx,:),aml_toa(ytx,:)*1e9,aml_ele(ytx,:),[],10*log10(abs(aml_amp(ytx,:))),'filled');
xlabel("Azimuth (�)"); ylabel("TOA (ns)"); zlabel("Elevation (�)");view(90,0)
xlim([0 180]); zlim([0 180]); 
grid on
colormap(jet)
colorbar
set(gca,'ColorScale','log');

%%
ytx = 1;
figure(11)
subplot(1,3,1)
scatter3(sage_aoa(ytx,:),sage_toa(ytx,:)*1e9,sage_eoa(ytx,:),[],10*log10(abs(sage_amp(ytx,:))),'filled');
xlabel("Azimuth (�)"); ylabel("TOA (ns)"); zlabel("Elevation (�)");view(0,0)
%xlim([80 100]); zlim([80 100]); 
grid on
colormap(jet)
colorbar
set(gca,'ColorScale','log');

subplot(1,3,2)
scatter3(sage_aoa(ytx,:),sage_toa(ytx,:)*1e9,sage_eoa(ytx,:),[],10*log10(abs(sage_amp(ytx,:))),'filled');
xlabel("Azimuth (�)"); ylabel("TOA (ns)"); zlabel("Elevation (�)");view(90,90)
%xlim([80 100]); zlim([80 100]); 
grid on
colormap(jet)
colorbar
set(gca,'ColorScale','log');

subplot(1,3,3)
scatter3(sage_aoa(ytx,:),sage_toa(ytx,:)*1e9,sage_eoa(ytx,:),[],10*log10(abs(sage_amp(ytx,:))),'filled');
xlabel("Azimuth (�)"); ylabel("TOA (ns)"); zlabel("Elevation (�)");view(90,0)
%xlim([80 100]); zlim([80 100]); 
grid on
colormap(jet)
colorbar
set(gca,'ColorScale','log');