% --- SISTEMAS DE COMUNICACAO 1 ---
% AULA 7: Conversão analógico-digital
% DIA 17/08/2018
% Jessica de Souza

clear all;
close all;
clc;

% Criacao dos parametros
Rb = 10e3;
ts = 1/Rb;
fd = 40; %usuario conversando no celular na rua
fd1 = 4;

% Cria o canal
chan = rayleighchan(ts,fd);
chan.StoreHistory = 1;

chan1 = rayleighchan(ts,fd1);
chan1.StoreHistory = 1;

% Gera a informacao
info = randint(1,5000,2);
info_mod = pskmod(info,2);

% Convolucao da info com canal
sinal_rx = filter(chan,info_mod);
canal_dopp40 = abs(chan.PathGains);
canal_dopp4 = abs(chan1.PathGains);

% Plotando os resultados
figure,
subplot(211)
plot(20*log10(canal_dopp4));  %p/ fazer em db
subplot(212)
plot(20*log10(canal_dopp40));
xlabel('total simbolos');
ylabel('potencia em db');

figure,
plot(10*log10(canal_dopp40));  %p/ fazer em dbm
xlabel('total simbolos');
ylabel('potencia em dbm');