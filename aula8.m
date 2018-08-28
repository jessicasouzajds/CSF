%% --- COMUNICAÇÕES SEM FIO ---
% Propagação em pequena escala: Efeito doppler e potência do sinal
% DIA 21/08/2018
% Aluna: Jessica de Souza

clear all;
close all;
clc;

%% Parametros iniciais
Rb = 10e3;
ts = 1/Rb;
fd1 = 4; % frequencia de um usuario no celular na rua
fd2 = 40;% frequencia maxima doppler


%% Gerando o canal

% calculando para 4 Hz
chan4 = rayleighchan(ts,fd1);
chan4.StoreHistory = 1;
info4 = randint(1,5000,2);
info_mod4 = pskmod(info4,2);
sinal_rx4 = filter(chan4,info_mod4); 
canal_dopp4 = abs(chan4.PathGains);

% calculando para 40 Hz
chan40 = rayleighchan(ts,fd2);
chan40.StoreHistory = 1;
info40 = randint(1,5000,2);
info_mod40 = pskmod(info40,2);
sinal_rx40 = filter(chan40,info_mod40); 
canal_dopp40 = abs(chan40.PathGains);

%% Plotando os resultados

t = [0:ts:(length(info4)/Rb)-ts];

figure,
subplot(211)
plot(t,20*log10(abs(canal_dopp4)));  %p/ fazer em db
subplot(212)
plot(t,20*log10(abs(canal_dopp40)));
xlabel('total simbolos');
ylabel('Potencia (db)');

figure,
subplot(211)

plot(10*log10(canal_dopp4));  %p/ fazer em dbm
subplot(212)
plot(10*log10(canal_dopp40));
xlabel('total simbolos');
ylabel('potencia em dbm');  %p/ fazer em dbm

% figure,
% ganho_canal = chan40.PathGains;
% hist(abs(ganho_canal),100)