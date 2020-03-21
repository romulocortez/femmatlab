%% Plot da animação
% Rômulo Luz Cortez e Kamilla Emily Santos Silva
% Disciplina Elementos Finitos Lineares
% Santos, 08 de março de 2020

%% Entrada de dados
pos_truss

%% PLOT DA TRELIÇA 
mult = linspace(1e2,1e5,30);
mult = [mult,mult(end:-1:1)];
for t=1:length(mult) %número de frames
%     t=1
    for i=1:nel
        D(i,:) = d(loc);
        trel(i,:) = [cnos(conect(i,2),2:3),cnos(conect(i,3),2:3)];
    end
    trel = trel + mult(t)*D;
    EF = [trel(1,1) trel(1,2) trel(1,1)+L*cos(pi/4)/2 trel(1,2)+L*sin(pi/4)/2];
    trel(end,:) = EF;
    j = figure;
    [C,XY]=unmesh(trel);
    [xd,yd] = gplot(C,XY); %plot da treliça
    h = plot(xd,yd,'-o','LineWidth',2,...
        'MarkerFaceColor','k',...
        'Color',[t/length(mult) 0 0],...
        'MarkerSize',5);

    axis off
    % Representações seta da força:
    patch([trel(end,3)+0.05 trel(end,3)-0.07 trel(end,3)-0.02],...
          [trel(end,4)+0.05 trel(end,4)-0.02 trel(end,4)-0.07],[0 0 0]);
    % Representações das restrições:
    patch([cnos(2,2) cnos(2,2)-0.05 cnos(2,2)+0.05],...
          [cnos(2,3) cnos(2,3)+0.0866 cnos(2,3)+0.0866],[1 1 1]);
    patch([cnos(3,2) cnos(3,2)-0.05 cnos(3,2)+0.05],...
          [cnos(3,3) cnos(3,3)-0.0866 cnos(3,3)-0.0866],[1 1 1]);
    patch([cnos(4,2) cnos(4,2)-0.05 cnos(4,2)+0.05],...
          [cnos(4,3) cnos(4,3)-0.0866 cnos(4,3)-0.0866],[1 1 1]);
%     name = ['trelica_',num2str(t)]; %nome do arquivo
%     saveas(j,name,'pdf') %salva o arquivo como .pdf


    % Códigos para criação da animação (.gif)
%     frame = getframe(j);   
%     im = frame2im(frame); 
%     [imind,cm] = rgb2ind(im,256); 
%     if t == 1 
%       imwrite(imind,cm,filename,'gif', 'DelayTime',0, 'Loopcount',inf); 
%     else 
%       imwrite(imind,cm,filename,'gif', 'DelayTime',0, 'WriteMode','append'); 
%     end 

end
% close all