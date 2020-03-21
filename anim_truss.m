function anim_truss(action)
%ANIM_TRUSS  Animação de uma ponte treliçada
%   Esse código anima as 12 modos naturias de vibrar
%   de uma treliça bi-dimensional. Esses modos de vibrar
%   são resultado da análise de um problema de autovalores.
%   Eles foram ordenados de acordo com as frequências naturais
%   com 1 sendo o primeiro modo (e mais fácil de excitar) e 
%   12 sendo o modo de maior frequência.
%
%   Use a caixa de seleção "Modo" para selecionar 
%   uma entre os vários modos. Os botões "Começar" 
%   e "Parar" Controlam a animação.
%   Criado por: Ned Gulley, 6-21-93
%   Modificado por: Rômulo Cortez, 03-18-2020

%   Copyright 1984-2014 The MathWorks, Inc.

% Information regarding the play status will be held in
% the axis user data according to the following table:
play =  1;
stop = -1;

if nargin < 1,
   action = 'initialize';
end;

if strcmp(action,'initialize'),
   oldFigNumber = watchon;
   
   figNumber = figure( ...
      'Name','Modos de Vibrar de uma Ponte Treliçada', ...
      'NumberTitle','off', ...
      'Visible','off', ...
      'Colormap',[]);
   axes( ...
      'Units','normalized', ...
      'Position',[0.05 0.05 0.75 0.90], ...
      'Visible','off', ...
      'NextPlot','add');
   
   text(0,0,'Aperte o botão "Começar" para ver os modos de vibrar', ...
      'HorizontalAlignment','center');
   axis([-1 1 -1 1]);
   
   % ===================================
   % Information for all buttons
   labelColor = [0.8 0.8 0.8];
   yInitPos = 0.90;
   xPos = 0.85;
   btnWid = 0.10;
   btnHt = 0.10;
   % Spacing between the button and the next command's label
   spacing = 0.05;
   
   % ====================================
   % The CONSOLE frame
   frmBorder = 0.02;
   yPos = 0.05-frmBorder;
   frmPos = [xPos-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
   h = uicontrol( ...
      'Style','frame', ...
      'Units','normalized', ...
      'Position',frmPos, ...
      'BackgroundColor',[0.5 0.5 0.5]);
   
   % ====================================
   % The START button
   btnNumber = 1;
   yPos = 0.90-(btnNumber-1)*(btnHt+spacing);
   labelStr = 'Começar';
   cmdStr = 'start';
   callbackStr = 'truss(''start'');';
   
   % Generic button information
   btnPos = [xPos yPos-spacing btnWid btnHt];
   startHndl = uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'String',labelStr, ...
      'Interruptible','on', ...
      'Callback',callbackStr);
   
   % ====================================
   % The MODE popup button
   btnNumber = 2;
   yPos = 0.90-(btnNumber-1)*(btnHt+spacing);
   textStr = 'Modo';
   popupStr = reshape(' 1  2  3  4  5  6  7  8  9 10 11 12 ',3,12)';
   
   % Generic button information
   btnPos1 = [xPos yPos-spacing+btnHt/2 btnWid btnHt/2];
   btnPos2 = [xPos yPos-spacing btnWid btnHt/2];
   popupHndl = uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',btnPos1, ...
      'String',textStr);
   btnPos = [xPos yPos-spacing btnWid btnHt/2];
   popupHndl = uicontrol( ...
      'Style','popup', ...
      'Units','normalized', ...
      'Position',btnPos2, ...
      'String',popupStr);
   
   % ====================================
   % The STOP button
   btnNumber = 3;
   yPos = 0.90-(btnNumber-1)*(btnHt+spacing);
   labelStr = 'Parar';
   % Setting userdata to -1 (= stop) will stop the demo.
   callbackStr = 'set(gca,''Userdata'',-1)';
   
   % Generic button information
   btnPos = [xPos yPos-spacing btnWid btnHt];
   stopHndl = uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',btnPos, ...
      'Enable','off', ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
   % ====================================
   % The INFO button
   labelStr = 'Info';
   callbackStr = 'truss(''info'')';
   infoHndl = uicontrol( ...
      'Style','push', ...
      'Units','normalized', ...
      'Position',[xPos 0.20 btnWid 0.10], ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
   % ====================================
%    The CLOSE button
   labelStr = 'Fechar';
   callbackStr = 'close(gcf)';
   closeHndl = uicontrol( ...
      'Style','push', ...
      'Units','normalized', ...
      'Position',[xPos 0.05 btnWid 0.10], ...
      'String',labelStr, ...
      'Callback',callbackStr);
   
   % Uncover the figure
   hndlList = [startHndl popupHndl stopHndl infoHndl closeHndl];
   set(figNumber,'Visible','on', ...
      'UserData',hndlList);
   
   watchoff(oldFigNumber);
   figure(figNumber);
   
elseif strcmp(action,'start'),
   wnumber = watchon;
   axHndl = gca;
   figNumber = gcf;
   hndlList = get(figNumber,'UserData');
   startHndl = hndlList(1);
   popupHndl = hndlList(2);
   stopHndl = hndlList(3);
   infoHndl = hndlList(4);
   closeHndl = hndlList(5);
   set([startHndl closeHndl infoHndl],'Enable','off');
   set(stopHndl,'Enable','on');
   
   % ====== Start of Demo
%    load truss.mat a x0 xy;
   pos_truss
   xy = cnos(:,[2 3]); %coordenada dos nós
   x0 = 100*modeShapes; %matriz dos autovalores
   n = get(popupHndl,'Value');
   set(axHndl,'Userdata',play);
   numframes = 15;
   del = x0(:,n);
%    del = reshape([del' zeros(1,4)] ,2,10)';
   del = reshape([del(1:12)' zeros(1,2) del(13:20)' zeros(1,2)],2,gdl/2)';
   [xd,yd] = gplot(a,xy);
   cla;
   [max_val,xory_max] = max(max(xy)); % 1 x é max, 2 y é max
   borda = L/2;
   axis_max = borda+(max([max(xy(:,1)),max(xy(:,2))])-min([max(xy(:,1)),max(xy(:,2))]))/2;
   if xory_max == 1 % dim. em x > dim. em y
       axis([min(xy(:,1))-borda max_val+borda -axis_max axis_max]);
       text(max(xy(:,1))/2, max(xy(:,2))+2.5,'Modos de vibrar da Ponte Treliçada', ...
      'HorizontalAlignment','center');
   elseif xory_max == 2 % dim em y. > dim. em x
       axis([-axis_max axis_max min(xy(:,2))-borda max_val+borda]);
       text(max(xy(:,2))+2.5, max(xy(:,1))/2,'Modos de vibrar da Ponte Treliçada', ...
      'HorizontalAlignment','center');
   end
   h = plot(xd,yd,'-ok','LineWidth',1.5);
   % Desenhar os apoios da ponte treliçada .
% (Trabalhos futuros) Definir de acordo com as BC para ficar o mais geral possível
    patch([min(xy(:,1)) min(xy(:,1))+0.1*L min(xy(:,1))-0.1*L],...
       [0 -0.17*L -0.17*L],...
       [0 0 0]);
   patch([max(xy(:,1)) max(xy(:,1))+0.1*L max(xy(:,1))-0.1*L],...
       [min(xy(:,1)) -0.17*L -0.17*L],...
       [0 0 0]);
   
   
   axis off;
   set(gca,'SortMethod','childorder');
   
   t = linspace(0,2*pi,numframes+1);
   watchoff(wnumber);
   while get(axHndl,'Userdata') == play,
      for count = 1:numframes,
         if get(axHndl,'Userdata') ~= play
            break
         end;
         
         if n ~= get(popupHndl,'Value'),
            n = get(popupHndl,'Value');
            del =  x0(:,n);
%             del = reshape([del' zeros(1,4)] ,2,10)';
            del = reshape([del(1:12)' zeros(1,2) del(13:20)' zeros(1,2)],2,gdl/2)';
         end;
         
         delnow = del*sin(t(count));
         [xd,yd] = gplot(a,xy+delnow);
         set(h,'xdata',xd,'ydata',yd);
         drawnow;
         pause(0.01)
         
         % Bail out if the user closed the figure during the animation.
         if ~ishghandle(startHndl)
            return
         end
         
      end;    % for count=...
   end;    % while get(axHndl,...
   
   % ====== End of Demo
   set([startHndl closeHndl infoHndl],'Enable','on');
   set(stopHndl,'Enable','off');
   
elseif strcmp(action,'info');
   helpwin(mfilename)
   
end;    % if strcmp(action, ...
