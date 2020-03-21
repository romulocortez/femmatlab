%% Análise dinâmica da barra 
% Rômulo Luz Cortez e Kamilla 
% Santos, fevereiro de 2020 
% Disciplina: Elementos Finitos Lineares 

clc
clear all
close all
format compact

%% Dados de Entrada:
nel = 10;      % número de elementos
nnos = nel+1;   % número de nós total
ngln = 1;       % número de graus de liberdade por nó
Lt = 20;        %m tamanho total da barra
E = 30e6;       % Módulo de elasticidade
A = 1;          % pol^2 área da seção transversal
rho = 6e-4;   % densidade de massa
P = 100;        %N carregamento axial
%% Condições de contorno:
cc = zeros(nnos,2); %primeira coluna: (0 = livre ou 1 = restrito)
cc(end,[1 2]) = [1 0 0 0]; % 1 = Restrito; 0 = Valor do des., vel. e acel.
F_ext = zeros(nnos,1); % criando vetor de forças
F_ext(1) = P; % carga no primeiro nó

%% Configurações Básicas
Le = Lt/nel;        % tamanho do elemento
c = (E/rho)^(1/2);  % velocidade da onda elástica no meio
t = 2; %Valor que multiplica Lt/c tem TIME
TIME = t *Lt/c;     % tempo total da simulação
Cn = 1.0;           % número de Courant
DT = Cn*Le/c;       % Passo temporal
n0 = TIME/DT;       % número de incrementos
% n0 = t*nel;
n = (TIME-rem(TIME,DT))/DT; %gera sempre um resultado inteiro
if n0~=n %quano n0 não é inteiro, temos que usar essa estratégia:
    nt = ceil(n+1); 
else 
    nt = ceil(n);
end
% nnospel = 2;      % número de nós por elemento

cnos = linspace(0,Le,nnos); % coordenada dos nós
%% Cálculo das matrizes de Rigidez e Massa
k_el = zeros(2,2);      % matriz de rigidez elementar
m_el = zeros(2,2);      % matriz de massa elementar
K_g = zeros(nnos,nnos); % matriz de rigidez global
M_g = zeros(nnos,nnos); % matriz de massa global
for j=1:nel
    k_el = E*A/Le*[1 -1; 
                  -1  1]; % matriz elementar do j-ésimo elemento
    K_g(j:j+1,j:j+1)=K_g(j:j+1,j:j+1)+k_el; % matriz de rigidez global
    m_el = rho*A*Le*[1/2 0
                      0 1/2]; %matriz diagonal
    M_g(j:j+1,j:j+1)=M_g(j:j+1,j:j+1)+m_el; % matriz de rigidez global
end
% K_g
% M_g
%% conectividade dos elementos
for i=1:nel
    conect(i,[1 2])=[i i+1]; % matriz de conectividade dos nós
    barra(i,1)=Le;
end
coord(1,1)=0;
for i = 2:nnos
    coord(1,i)= coord(1,i-1)+Le; % coordenada de cada nó i
end

%% Condições de Iniciais:
% n = 0; u_0, tempo = 0;
D=zeros(nnos*ngln,nt+1);      % deslocamento linhas: dominio x; colunas: domínio: tempo;
Ddot=zeros(nnos*ngln,nt+1);   % velocidade 
Ddotdot=zeros(nnos*ngln,nt+1);% aceleração

Ddotdot(:,1)=inv(M_g)*(F_ext-K_g*D(:,1)); % Aceleração em n=0
% linG = no_rest; % nó restrito
gdlcc = find(cc(:,1)); % retorna os indices valores não-nulos na coluna 1 de cc (restritos)
Ddotdot(gdlcc,:)= cc(gdlcc,2); % aplica as condições de contorno para todos os tempos
K_geff  = (4/ DT^2)*M_g + K_g; % Matriz efetiva
iK_geff =inv(K_geff);


%% Integração explicita

n=0;
for j = 1: nt %variando no tempo
    TT(j+1,1) = j*DT
    n = n + 1
    FGeff(:,j+1) = F_ext (:,1) + M_g*((4/ DT^2)*D(:,j) + (4/ DT)*Ddot (:,j) + Ddotdot (:,j))
    D(:,j+1) = iK_geff*FGeff(:,j+1)
    gdlcc = find(cc(:,1));% retorna os indices de valores não-nulos na coluna 1 de cc (restritos)
    D(linG ,j+1)=VAL_RESTR 
    Ddot (:,j+1) = (2/ DT)*(D(:,j+1) - D(:,j)) - Ddot (:,j)
    Ddotdot (:,j+1) = (4/ DT^2) *(D(:,j+1)  -D(:,j)) - (4/ DT)*Ddot (:,j) - Ddotdot (:,j)
    Ddotdot(linG ,j+1)=VAL_RESTR 
    for i=1: NEL %deformation  and  stress  calculation
        delta_Le (i,1) = D(CONECT(i,2) ,j+1) -D(CONECT(i,1) ,j+1)
        STRAIN(i,j+1) = delta_Le (i,1)/barra (i,1)
        STRESS(i,j+1) = Elas  * STRAIN(i,j+1)
    end
end














%% ==== Aplicando o corte nas linhas e colunas ======
u(2:end)=inv(K_g(2:end,2:end))*F(2:end); % O calculo é feito sem consiredar 
                                         % as primeiras linhas e coluna dos
                                         % vetores e da matriz pois u(1)=0;

Fpp= zeros(nnos,1); %criando vetor da Força devido ao peso próprio
for i = 1:nnos
    Fpp(i)=rho*g*(A_R-A_r)/2*(Le-cnos(i));% em cada nó uma parcela do peso
end
F = F + Fpp;

% ==== Aplicando o corte nas linhas e colunas ======
upp(2:end)=inv(K_g(2:end,2:end))*F(2:end); % O calculo é feito sem consiredar 
                                         % as primeiras linhas e coluna dos
                                         % vetores e da matriz pois u(1)=0;

% Solução analítica:
x2 = linspace(0,Le);
u_a = (P*Le/(E*(A_R-A_r))).*log(A_R./(A_R-(A_R-A_r).*(x2/Le))); 

% Rearranjando vetor de deslocamentos para o plot:
x = linspace(0,Le,nnos);

u = u*1e3; %metros para milímetros
upp = upp*1e3; %metros para milímetros
u_a = u_a*1e3; %metros para milímetros

plot(x,u,'-o',x2,u_a,x,upp,'-d')
axis([0,Le,0,max(upp)*1.2])
title({'Deslocamento axial',['Razão: carga axial / peso próprio: ',num2str(P/W)]})
xlabel('Comprimento da barra \bf{(x}) (m)')
ylabel('Deslocamento axial \bf{u(x)} (mm)')
legend('Método do Elementos Finitos (sem peso próprio)',...
        'Resposta Analítica (sem peso próprio)',...
        'Método do Elementos Finitos (com peso próprio)',...
        'Location','northwest')
    
% plota somente resultados sem peso próprio:
% plot(x,u,'-o',x2,u_a) 
% title({'Deslocamento axial',['Carga axial: P = ',num2str(P)]})
% legend('Método do Elementos Finitos',...
%         'Resposta Analítica','Location','northwest')































