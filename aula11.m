% --- COMUNICACAO SEM FIO ---
% AULA 11: Desvanecimento - Distribuicao de Rayleigh e Rice, parte 2
% DIA 31/08/2018
% Jessica de Souza

clear all;
close all;
clc;

Rb = 100e3;
ts = 1/Rb;
fd = 200;
k = 1000;  %linear 
snr = 20;

%% Transmissao

% gerando a informacao
info = randint(1,Rb);
info_mod = pskmod(info,2); %2 eh o nivel de fase

%gerando o canal
canal_ray = rayleighchan(ts,fd); %sem linha de visada e componente
canal_ray.StoreHistory = 1;

%agora vamos simular a transmissao, conv entre info_mod e h(t)
sinal_rec_ray = filter(canal_ray,info_mod);

%ganhos
ganho_ray = canal_ray.PathGains;  %divisor do h

%% Recepcao
for i=0:snr
    sinal_rx = awgn(sinal_rec_ray,i);
    sinal_rx_r = sinal_rx./transpose(ganho_ray);
    sinal_demod = pskdemod(sinal_rx_r,2);    %demodulando
    [num_erro(i + 1), taxa_erro(i + 1)] = biterr(info, sinal_demod>0);
end

semilogy([0:snr],taxa_erro,'r');