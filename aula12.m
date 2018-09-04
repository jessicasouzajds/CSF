% --- COMUNICACAO SEM FIO ---
% AULA 12: Comparação de desempenho Rayleigh x AWGN
% DIA 31/08/2018
% Jessica de Souza

clear all;
close all;
clc;

SNR_max = 25;
M = 2; %bpsk
Nbits = 100e3;

info = randi([0 1], 1, Nbits);

info_mod_Ncod = pskmod(info, M);

canal_NLOS = rayleighchan(1/Nbits, 10) %Canal sem visada
canal_NLOS.StoreHistory = 1;

ganho_canal_NLOS = canal_NLOS.PathGains;

sinal_Rx_NLOS_Ncod = filter(canal_NLOS, info_mod_Ncod);
ganho_canal_NLOS_Ncod = canal_NLOS.PathGains;

for SNR = 0:SNR_max

    info_rx_Ncod_ray = awgn(sinal_Rx_NLOS_Ncod, SNR);
    info_rx_Ncod = awgn(info_mod_Ncod, SNR);

    sinal_eq_NLOS_Ncod_ray = info_rx_Ncod_ray./transpose(ganho_canal_NLOS_Ncod);   
   
    info_demod_Ncod_ray = pskdemod(sinal_eq_NLOS_Ncod_ray, M);
    info_demod_Ncod = pskdemod(info_rx_Ncod, M);
    
    [num_ncod_ray(SNR + 1), taxa_ncod_ray(SNR + 1)] = biterr(info, info_demod_Ncod_ray);
    [num_ncod(SNR + 1), taxa_ncod(SNR + 1)] = biterr(info, info_demod_Ncod);
end

semilogy([0:SNR_max], taxa_ncod_ray, 'r',[0:SNR_max], taxa_ncod,'m')
legend('Rayleigh com canal', 'Sem canal')

if(SNR_max)
    scatterplot(info_rx_Ncod); title('Sem canal');
    scatterplot(info_rx_Ncod_ray); title('Com canal');
    scatterplot(sinal_eq_NLOS_Ncod_ray); title('Com canal + equalizado');
end