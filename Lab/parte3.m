% --- COMUNICACAO SEM FIO ---
% Trabalho 1: MIMO
% DIA 15/10/2018
% Aluna: Jessica de Souza

% Parte 3

clear all;
close all;
clc;

% Parametros iniciais
Rs = 150e3;  % Total de simbolos
ts = 1/Rs;  % Tempo de simbolos
fd = 100;   % Frequencia doppler
M = 2;      % Modulacao BPSK
SNR_max = 20;

% Gerando a informação
info = randint(1,Rs,M);
info_mod = pskmod(info, M);  % Modula em BPSK 

%%
% Canal 1: SISO com 1 Tx e 1 Rx
canalAS1 = rayleighchan(ts, fd);
canalAS1.StoreHistory = 1;
sinalRxAS1 = filter(canalAS1, info_mod);
ganhocanalAS1 = canalAS1.PathGains;


%%
%Canal 3: Alamouti com 2 Tx e 1 Rx

data1a = zeros(1, Rs);
data2a =data1a;

data1a(1:2:end) = info_mod(1:2:end);          % S0
data1a(2:2:end) = -conj(info_mod(2:2:end));   % -S1 conjugado

data2a(2:2:end) = conj(info_mod(1:2:end));    % S0 conjugado
data2a(1:2:end) = info_mod(2:2:end);          % S1

canalALA1a = rayleighchan(ts, fd);
canalALA1a.StoreHistory = 1;
sinalRxALA1a = filter(canalALA1a, data1a);
ganhocanalALA1a = transpose(canalALA1a.PathGains);

canalALA2a = rayleighchan(ts, fd);
canalALA2a.StoreHistory = 1;
sinalRxALA2a = filter(canalALA2a, data2a);
ganhocanalALA2a = transpose(canalALA2a.PathGains);


%%
% Canal 3: Alamouti com 2 Tx e 2 Rx
data1 = zeros(1, Rs);
data2 =data1;

data1(1:2:end) = info_mod(1:2:end);          % S0
data1(2:2:end) = -conj(info_mod(2:2:end));   % -S1 conjugado

data2(2:2:end) = conj(info_mod(1:2:end));    % S0 conjugado
data2(1:2:end) = info_mod(2:2:end);          % S1

canalALA1 = rayleighchan(ts, fd);
canalALA1.StoreHistory = 1;
sinalRxALA1 = filter(canalALA1, data1);
ganhocanalALA1 = transpose(canalALA1.PathGains);

canalALA2 = rayleighchan(ts, fd);
canalALA2.StoreHistory = 1;
sinalRxALA2 = filter(canalALA2, data2);
ganhocanalALA2 = transpose(canalALA2.PathGains);

canalALA3 = rayleighchan(ts, fd);
canalALA3.StoreHistory = 1;
sinalRxALA3 = filter(canalALA3, data1);
ganhocanalALA3 = transpose(canalALA3.PathGains);

canalALA4 = rayleighchan(ts, fd);
canalALA4.StoreHistory = 1;
sinalRxALA4 = filter(canalALA4, data2);
ganhocanalALA4 = transpose(canalALA4.PathGains);


%%
for SNR = 0:SNR_max

    % RX do AS
    sinal_rx_awgn_AS1 = awgn(sinalRxAS1, SNR, 'measured');
    sinal_AS_eq1 = sinal_rx_awgn_AS1.*ganhocanalAS1';  
    sinal_rx_AS = sinal_AS_eq1;
    
    % RX do Alamouti (1)
    sinalALAa = sinalRxALA1a + sinalRxALA2a;
    sinalRxALAa = awgn(sinalALAa, SNR);

    aa = conj(ganhocanalALA1a(1:2:end)) .* sinalRxALAa(1:2:end);
    ba = ganhocanalALA2a(2:2:end) .* conj(sinalRxALAa(2:2:end));
    
    ca = conj(ganhocanalALA2a(1:2:end)) .* sinalRxALAa(1:2:end);
    da = ganhocanalALA1a(2:2:end) .* conj(sinalRxALAa(2:2:end));
    
    sinal_rx_ALAa = zeros(1, length(info));
    sinal_rx_ALAa(1:2:end) =  aa + ba;
    sinal_rx_ALAa(2:2:end) =  ca - da;
    
    % RX do Alamouti (2)
    sinalALA1 = sinalRxALA1 + sinalRxALA2;
    sinalALA11 = awgn(sinalALA1, SNR);
        
    a = conj(ganhocanalALA1(1:2:end)) .* sinalALA11(1:2:end);
    b = ganhocanalALA2(2:2:end) .* conj(sinalALA11(2:2:end));
    c = conj(ganhocanalALA2(1:2:end)) .* sinalALA11(1:2:end);
    d = ganhocanalALA1(2:2:end) .* conj(sinalALA11(2:2:end));

    sinalALA2 = sinalRxALA3 + sinalRxALA4;
    sinalALA22 = awgn(sinalALA2, SNR);
    
    e = conj(ganhocanalALA3(1:2:end)) .* sinalALA22(1:2:end);
    f = ganhocanalALA4(2:2:end) .* conj(sinalALA22(2:2:end));
    g = conj(ganhocanalALA4(1:2:end)) .* sinalALA22(1:2:end);
    h = ganhocanalALA3(2:2:end) .* conj(sinalALA22(2:2:end));
    
    sinal_rx_ALA = zeros(1, length(info));
    sinal_rx_ALA(1:2:end) =  a + b + e + f;
    sinal_rx_ALA(2:2:end) =  c - d + g - h;
    
    
    % Demodulando
    sinaldemodAS  = pskdemod(sinal_rx_AS ,M);
    sinaldemodALAa = pskdemod(sinal_rx_ALAa,M);
    sinaldemodALA = pskdemod(sinal_rx_ALA,M);

    [numAS(SNR + 1) ,  taxaAS(SNR + 1)] = biterr(info, sinaldemodAS);
    [numALAa(SNR + 1), taxaALAa(SNR + 1)] = biterr(info, sinaldemodALAa);
    [numALA(SNR + 1), taxaALA(SNR + 1)] = biterr(info, sinaldemodALA);

end

%%
semilogy([0:SNR_max], taxaAS, 'k',[0:SNR_max], taxaALAa, 'b',[0:SNR_max], taxaALA, 'm')
legend('taxaAS', 'taxaALA - 1Rx','taxaALA - 2Rx')
xlabel('SNR');
ylabel('Probabilidade de erro (Pb)');