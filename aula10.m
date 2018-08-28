% --- COMUNICACAO SEM FIO ---
% AULA 10: Desvanecimento - Distribuicao de Rayleigh e Rice
% DIA 28/08/2018
% Jessica de Souza

clear all;
close all;
clc;

ts = 1/10000;
fd = 200;
k = 1000;  %linear 

% gerando a informacao
info = randint(1,700000);
info_mod = pskmod(info,2); %2 eh o nivel de fase

%gerando o canal
canal_ray = rayleighchan(ts,fd); %sem linha de visada e componente
canal_ray.StoreHistory = 1;
%estacionaria predominante
canal_rice = ricianchan(ts,fd,k); % k escala linear, com linha de visada
canal_rice.StoreHistory = 1;


canal_ray_teste = randn(1,10000) + j*randn(1,10000);

%agora vamos simular a transmissao, conv entre info_mod e h(t)
sinal_rec_ray = filter(canal_ray,info_mod);
sinal_rec_rice = filter(canal_rice, info_mod);

%ganhos
ganho_ray = abs(canal_ray.PathGains);
ganho_rice = abs(canal_rice.PathGains);



%plotando os resultados
figure,
subplot(211)
plot(20*log10(ganho_ray)); 
subplot(212)
plot(20*log10(ganho_rice)); 

figure,
hist(ganho_ray,200);

figure,
hist(ganho_rice,200);
