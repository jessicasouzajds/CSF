% --- COMUNICACAO SEM FIO ---
% AULA 6: Canal com multipercurso
% DIA 14/08/2018
% Jessica de Souza

% Exercicio 4.25 pagina 111 (Livro Rappaport)

close all;
clear all;
clc;

% Criacao dos parametros
n = 4
desvio = 12 % sigma, em dB
d0 = 1
P0 = 0
D = 1600
d1 = 1:1:D
d2 = D - d1
Ph0 = -112
Pr_min = -118
Pr1 = P0 -10*n*log10(d1./d0);
Pr2 = P0 -10*n*log10(d2./d0);

%probabilidades, as duas tem q ocorrer simultaneamente, sombreamento, acima do limiar minimo
Prb1 = qfunc((Pr1 - (Ph0))./desvio); % prob_pr_d1_ho %prob na potencia na base 1 estar abaixo no valor de handoff
Prb2 = qfunc((Pr_min - Pr2)./desvio);% prob_pr_d2_min

%probabilidade total (seguindo teorema estatistico)
Ptot = Prb1.*Prb2;

%vermelho = abaixo handoff, base 1
%base 2, prob de ficar acima do limiar minimo

% Plotando os resultados
figure()
plot(Pr1)
hold on
plot(Pr2)
hold off;
xlabel('Distância (m)');
ylabel('Potencia recebida (dB)'); % na estacao

figure()
plot(Prb1,'r');
hold on
plot(Prb2,'b');
plot(Ptot,'k');
xlabel('Distância (m)');
ylabel('Probabilidade');
hold off;