%% Programa de Treliça (Entrada de dados)
% Priogrema criado por
% Rômulo Luz Cortez e Kamilla Emily Santos Silva
% Disciplina Elementos Finitos Lineares
% Santos, 08 de março de 2020

%% Dados do problema
E = 206e9; % Pa coeficiente de Elasticidade
v = 0.3; % coeficiente de Poison
rho = 7860; % massa específica do aço
A = 19e-4; % m^2 área
I = 1; % momento de inécia de área
L = 1; % comprimento do elemento

%% Propriedade dos materiais 
% MAT = [E1,v1,rho1; E2,v2,rho2;...];
% Propiedades Geométricas
% GEO = [A1,I1; A2,I2; ...];
MAT = zeros(21,3);
GEO = zeros(21,2);
for t=1:21 %elementos
    MAT(t,:) = [E,v,rho];
    GEO(t,:) = [A,I];
end


%% Coordenada dos nós
% cnos =  [nó, x, y]   
cnos = [1  18  6
        2  18  0
        3  24  0
        4  24  5.32
        5  30  0
        6  30  3.54
        7  36  0
        8  12  0
        9  12  5.32
        10  6  0
        11  6  3.54
        12  0  0];
%% Matriz de conectividade
% conect = [el, nó1, nó2, MAT, GEO]; 
conect = [1, 12, 10, MAT(1,1), GEO(1,1)
          2, 12, 11, MAT(2,1), GEO(2,1)
          3, 10, 11, MAT(3,1), GEO(3,1)
          4, 10,  8, MAT(3,1), GEO(3,1)
          5, 10,  9, MAT(3,1), GEO(3,1)
          6, 11,  9, MAT(3,1), GEO(3,1)
          7,  8,  9, MAT(3,1), GEO(3,1)
          8,  8,  1, MAT(3,1), GEO(3,1)
          9,  9,  1, MAT(3,1), GEO(3,1)
          10, 8,  2, MAT(3,1), GEO(3,1)
          11, 2,  1, MAT(3,1), GEO(3,1)
          12, 1,  3, MAT(3,1), GEO(3,1)
          13, 1,  4, MAT(3,1), GEO(3,1)
          14, 2,  3, MAT(3,1), GEO(3,1)
          15, 3,  4, MAT(3,1), GEO(3,1)
          16, 3,  5, MAT(3,1), GEO(3,1)
          17, 4,  5, MAT(3,1), GEO(3,1)
          18, 4,  6, MAT(3,1), GEO(3,1)
          19, 5,  6, MAT(3,1), GEO(3,1)
          20, 6,  7, MAT(3,1), GEO(3,1)
          21, 5,  7, MAT(3,1), GEO(3,1)];
      
%% Matriz de adjacência:
% A matriz de adjacência tem um elemento a(i,j) não nulo se, e somente se
% o nó i está conectado com o nó j.
a = [1 1 1 1 0 0 0 1 1 0 0 0
     1 1 1 0 0 0 0 1 0 0 0 0
     1 1 1 1 1 0 0 0 0 0 0 0
     1 0 1 1 1 1 0 0 0 0 0 0
     0 0 1 1 1 1 1 0 0 0 0 0 
     0 0 0 1 1 1 1 0 0 0 0 0
     0 0 0 0 1 1 1 0 0 0 0 0
     1 1 0 0 0 0 0 1 1 1 0 0 
     1 0 0 0 0 0 0 1 1 1 1 0
     0 0 0 0 0 0 0 1 1 1 1 1
     0 0 0 0 0 0 0 0 1 1 1 1
     0 0 0 0 0 0 0 0 0 1 1 1];
      
%% Condições de contorno 
% cc = [gld, cond, val] Condição: 1=livre; 0=Restrito
cc = [1   1  0   % 1 grau de liberdade do nó 1, x1
      2   1  0   % 2 grau de liberdade do nó 1, y1
      3   1  0   % 1 grau de liberdade do nó 2, x2
      4   1  0   % 2 grau de liberdade do nó 2, y2
      5   1  0   % 1 grau de liberdade do nó 3
      6   1  0   % 2 grau de liberdade do nó 3
      7   1  0
      8   1  0
      9   1  0
      10  1  0
      11  1  0
      12  1  0
      13  0  0 
      14  0  0
      15  1  0
      16  1  0
      17  1  0
      18  1  0
      19  1  0
      20  1  0
      21  1  0
      22  1  0
      23  1  0
      24  0  0];
%% Forças aplicadas nos nós 
% F = [Fx_1; 
%      Fy_1;
%      Fx_2; 
%      Fy_2;
%      Fx_3; 
%      Fy_3...] 
F = [0 
     70000
     0 
     0
     0 
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0
     0]; % Caminhão de 7 ton
     