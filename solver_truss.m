%% Programa de Treliça (Solver)
% Rômulo Luz Cortez e Kamilla Emily Santos Silva
% Disciplina Elementos Finitos Lineares
% Santos, 08 de março de 2020

%% Entrada de dados:
data_truss

nel = size(conect,1); %número de elementos
nnos = size(cnos,1); % número de nós
l = zeros(nel,1);
m = zeros(nel,1);
k_el = zeros(4,4); % matriz de rigidez do elemento
m_el = zeros(4,4); % matriz de massa do elemento

%% Montagem da matriz de Rigidez
gdl = length(F); %graus de liberdade total
K = zeros(gdl); 
M = zeros(gdl);
for i=1:nel
    x1 = cnos(conect(i,2),2); % cordenada x do 1° elemento
    x2 = cnos(conect(i,3),2); % cordenada x do 2° elemento
    y1 = cnos(conect(i,3),3); % cordenada y do 1° elemento
    y2 = cnos(conect(i,2),3); % cordenada y do 2° elemento
    L = sqrt((x2-x1)^2+(y2-y1)^2); %comprimento do elemento
    % cossenos diretores:
    l(i) = (x2-x1)/L; % cos a 
    m(i) = (y2-y1)/L; % sen a
    %matriz de rigidez elementar:
    k_el(1:4,1:4) = E*A/L*[ l(i)*l(i)  m(i)*l(i) -l(i)*l(i) -l(i)*m(i)
                            m(i)*l(i)  m(i)*m(i) -l(i)*m(i) -m(i)*m(i)
                           -l(i)*l(i) -m(i)*l(i)  l(i)*l(i)  l(i)*m(i)
                           -m(i)*l(i) -m(i)*m(i)  l(i)*m(i)  m(i)*m(i)];
    %location vector
    loc=[2*conect(i,2)-1,2*conect(i,2),2*conect(i,3)-1,2*conect(i,3)]; 
    K(loc,loc) = K(loc,loc) + k_el; % Matriz global
    %matriz de masssa elementar:
    m_el(1:4,1:4) = ((rho*A*L)/6)*[2 0 1 0
                                    0 2 0 1
                                    1 0 2 0
                                    0 1 0 2];
        
    M(loc,loc) = M(loc,loc) + m_el; % Matriz global
end

%% Incorporando as condições de contorno
gdlcc = find(~cc(:,2)); %procura os valores nulos da matriz de cond de contorno
val = cc(gdlcc,3); % acessa matriz cc na coluna 3 e pega os valores correspondentes
df = setdiff(1:gdl, gdlcc); %degree-free: Nó livre
Kf = K(df, df); % cortando as linhas e colunas da matriz de rigidez
Mf = M(df, df); % cortando as linhas e colunas da matriz de massa
Fdf = F(df) - K(df, gdlcc)*val; %passando cond. n/homogênea p o outro lado

%% Resolvendo equações reduzidas
dfVals = Kf\Fdf; % calculando os deslocamentos desconhecidos
d = zeros(gdl,1); % criando vetor de deslocamentoes 
d(gdlcc) = val; % impondo as cc
d(df) = dfVals; % Deslocamentos que eram desconhecidos (o resto é zero)
rf = K(gdlcc,:)*d - F(gdlcc); % calculo das reações nos gdl restritos




