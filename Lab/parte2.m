% --- COMUNICACAO SEM FIO ---
% Trabalho 1: MIMO
% DIA 15/10/2018
% Aluna: Jessica de Souza

% Parte 2

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

% Canal 1: AS com 1 Tx e 4 Rx
canalAS1 = rayleighchan(ts, fd);
canalAS1.StoreHistory = 1;
sinalRxAS1 = filter(canalAS1, info_mod);
ganhocanalAS1 = canalAS1.PathGains;

canalAS2 = rayleighchan(ts, fd);
canalAS2.StoreHistory = 1;
sinalRxAS2 = filter(canalAS2, info_mod);
ganhocanalAS2 = canalAS2.PathGains;

canalAS3 = rayleighchan(ts, fd);
canalAS3.StoreHistory = 1;
sinalRxAS3 = filter(canalAS3, info_mod);
ganhocanalAS3 = canalAS3.PathGains;

canalAS4 = rayleighchan(ts, fd);
canalAS4.StoreHistory = 1;
sinalRxAS4 = filter(canalAS4, info_mod);
ganhocanalAS4 = canalAS4.PathGains;

%%
% Canal 2: MRC com 1 Tx e 2 Rx
canalMRC1 = rayleighchan(ts, fd);
canalMRC1.StoreHistory = 1;
sinalRxMRC1 = filter(canalMRC1, info_mod);
ganhocanalMRC1 = canalMRC1.PathGains;

canalMRC2 = rayleighchan(ts, fd);
canalMRC2.StoreHistory = 1;
sinalRxMRC2 = filter(canalMRC2, info_mod);
ganhocanalMRC2 = canalMRC2.PathGains;

canalMRC3 = rayleighchan(ts, fd);
canalMRC3.StoreHistory = 1;
sinalRxMRC3 = filter(canalMRC3, info_mod);
ganhocanalMRC3 = canalMRC3.PathGains;

canalMRC4 = rayleighchan(ts, fd);
canalMRC4.StoreHistory = 1;
sinalRxMRC4 = filter(canalMRC4, info_mod);
ganhocanalMRC4 = canalMRC4.PathGains;

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

    sinal_rx_awgn_AS2 = awgn(sinalRxAS2, SNR, 'measured');
    sinal_AS_eq2 = sinal_rx_awgn_AS2.*ganhocanalAS2';  

    sinal_rx_awgn_AS3 = awgn(sinalRxAS3, SNR, 'measured');
    sinal_AS_eq3 = sinal_rx_awgn_AS3.*ganhocanalAS3';  

    sinal_rx_awgn_AS4 = awgn(sinalRxAS4, SNR, 'measured');
    sinal_AS_eq4 = sinal_rx_awgn_AS4.*ganhocanalAS4';  
    
    max12 = max(sinal_AS_eq1,sinal_AS_eq2);
    max34 = max(sinal_AS_eq3,sinal_AS_eq4);
    sinal_rx_AS = max(max12,max34);
    
    % RX do MRC
    sinal_rx_awgn_MRC1 = awgn(sinalRxMRC1, SNR, 'measured');
    sinal_MRC_eq1 = sinal_rx_awgn_MRC1.*ganhocanalMRC1';  

    sinal_rx_awgn_MRC2 = awgn(sinalRxMRC2, SNR, 'measured');
    sinal_MRC_eq2 = sinal_rx_awgn_MRC2.*ganhocanalMRC2';  
 
    sinal_rx_awgn_MRC3 = awgn(sinalRxMRC3, SNR, 'measured');
    sinal_MRC_eq3 = sinal_rx_awgn_MRC3.*ganhocanalMRC3';  

    sinal_rx_awgn_MRC4 = awgn(sinalRxMRC4, SNR, 'measured');
    sinal_MRC_eq4 = sinal_rx_awgn_MRC4.*ganhocanalMRC4'; 
    
    sinal_rx_MRC = sinal_MRC_eq1 + sinal_MRC_eq2 + sinal_MRC_eq3 + sinal_MRC_eq4;
    
    % RX do Alamouti
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
    sinaldemodMRC = pskdemod(sinal_rx_MRC,M);
    sinaldemodALA = pskdemod(sinal_rx_ALA,M);
 
    [numAS(SNR + 1) ,  taxaAS(SNR + 1)] = biterr(info, sinaldemodAS);
    [numMRC(SNR + 1), taxaMRC(SNR + 1)] = biterr(info, sinaldemodMRC);
    [numALA(SNR + 1), taxaALA(SNR + 1)] = biterr(info, sinaldemodALA);

end

%%
semilogy([0:SNR_max], taxaAS, 'k',[0:SNR_max], taxaMRC, 'b',[0:SNR_max], taxaALA, 'm')
legend('taxaAS', 'taxaMRC','taxaALA')
xlabel('SNR');
ylabel('Probabilidade de erro (Pb)');