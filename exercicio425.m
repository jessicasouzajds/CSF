% --- COMUNICAÇÕES SEM FIO ---
% EXERCICIO 4.25 - RAPPAPORT (Questão 4 Avaliação de REC)
% DIA 15/12/2018
% Jessica de Souza

clear all;
close all;
clc;

% Parâmetros
n = 4;         % Expoente de perda de caminho
sigma = 6;     % Variância (dB)
P0 = 0;        % Pot. recebida d0 (dBm)
d0 = 1;        % Dist. Tx (m)
Pr_min = -118; % Pot. mínima aceitável no receptor (dBm)
Pr_HO = -112;  % Nível de patamar (dBm)
D = 1600;      % Dist. entre estações-base (m)
d1 = 1:1:D;    % Dist. entre estação móvel e BS1
d2 = D-d1;     % Dist. entre estação móvel e BS2

% Cálculo da potência recebida
Pr1 = P0 - 10*n*log10(d1./d0);
Pr2 = P0 - 10*n*log10(d2./d0);

% Probabilidade de um handoff ocorrer
Prd1_menor_Pr_HO = qfunc((Pr1 - Pr_HO)/sigma);   % Prob. sinal abaixo de Pr_HO
Prd2_maior_Pr_min = qfunc((Pr_min - Pr2)/sigma); % Prob. sinal acima de Pr_min

% Plotando os resultados
figure(1);
plot(d1, Pr1);
hold on;
plot(d1, Pr2);
plot ([0 D],[Pr_HO Pr_HO], '--');
plot ([0 D],[Pr_min Pr_min], '--');
xlabel('Distância (m)');
ylabel('Potência Recebida (dBm)');
legend('Potência recebida na BS1','Potência recebida na BS2','Handoff Threshold','Min. Received Power');
title('(a)');
hold off;

figure(2)
hold on;
plot(d1, Prd1_menor_Pr_HO);
plot(d1, Prd2_maior_Pr_min);
plot(d1, Prd1_menor_Pr_HO .* Prd2_maior_Pr_min); % Probabilidade do handoff ocorrer
plot(1000,0.8,'k*');
plot([1000 1000],[0 0.8],'k--');
plot([0 1000],[0.8 0.8],'k--');
xlabel('Distância (m)');
ylabel('Probabilidade');
legend('Prob. sinal abaixo Pr_HO','Prob. sinal acima Pr_min','Prob. Handoff','Prob. 80%');
title('(b)');
hold off;