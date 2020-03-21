%% Programa de Treli�a (Pos-processamento)
% R�mulo Luz Cortez e Kamilla Emily Santos Silva
% Disciplina Elementos Finitos Lineares
% Santos, 08 de mar�o de 2020

% clc
% clear all
% close all

format compact
%% Entrada de dados
solver_truss

%% C�lculo das deforma��es, tens�es e for�as
trel = zeros(nel+1,4); % coordenada das barras da treli�a para plot
D = zeros(nel+1,4); % deforma��o das barras da treli�a para plot
for i=1:nel
    loc=[2*conect(i,2)-1,2*conect(i,2),2*conect(i,3)-1,2*conect(i,3)]; 
    eps(i,1) = 1/L*[-l(i) -m(i) l(i) m(i)]*d(loc); % deforma��o epsilon
    D(i,:) = d(loc);
    trel(i,:) = [cnos(conect(i,2),2:3),cnos(conect(i,3),2:3)];
end
sig = MAT(i,1)*eps; % tens�o em cada elemento
trac = MAT(i,1)*GEO(i,1)*eps;%for�a de tra��o na barra

%% Calculando as frequencias e os modos de vibrar naturais
[V,lam] = eig(Kf,Mf); %resolve o problema de autovalor
freq = diag(sqrt(lam));
[sort_freq,N] = sort(freq); % tem que usar o sort pq nem sempre sai ordenado.
modeShapes = V(:,N); % N � o indice das frequencias em ordem;
