function [cx, cy] = CalCentroides( imagen, manera, display)
%Centroide busca el centro de una imagen, de varias formas
%Imagen es la imagen en cuesti�n. En principio cualquier tama�o vale

%EN REALIDAD ESTO NO VALE PARA NADA, PORQUE TODAS LAS MANERAS DAN
%EXACTAMENTE EL MISMO RESULTADO

%Manera indica c�mo vamos a calcular el centroide
% Manera = 1, la forma usada hasta ahora, multiplicando por el vector 
%           de distancias. Puede tener el problema de la sensibilidad a
%           cambios de bias
% Manera = ,  una nueva, que busca primero el m�ximo de la imagen y trabaja
%           en torno a �l.

%Si display = 1, pintamos la imagen y el centroide, dej�ndolo en pausa para
%verlo

%vamos a evitar lineas rojas en casos de salidas no normales
cx=0;
cy=0;

%en principio, vamos a admitir �nicamente matrices positivas como im�genes
if min(min(imagen)) < 0
    disp('Centroide s�lo admite matrices positivas o cero, nunca con valores negativos');
    return
end

[size_y,size_x]=size(imagen);

%El caso especial de que toda la matriz est� a cero lo resolvemos antes, 
%para evitar errores embarazosos
if sum(sum(imagen))==0 
     cx=length(sum(imagen))/2;
     cy=length(sum(imagen'))/2;

elseif manera == 1    
    %El array por el que se
    %multiplica debe empezar en uno.
    %hay que descontar el caso de que el trozo de imagen, despu�s de
    %pasar el umbral y dem�s, est� todo a cero, ya que entonces produce
    %un NaN y fastidia todo lo dem�s
    %los pesos van desde 1 hasta donde sea, ya que as� se es coherente
    %con la nomenclatura MATLAB, y con la instrucci�n line
    cx=(sum(imagen)*(1:length(sum(imagen)))')/sum(sum(imagen));
    cy=(sum(imagen')*(1:length(sum(imagen')))')/sum(sum(imagen'));

elseif manera ==2
    % En esta manera, buscamos primero el m�ximo
    [vall, indd] = max2(imagen);
    maximo_x=indd(2); %columnas corresponde a coordenada horizontal 
    maximo_y=indd(1);
    vector_x= -maximo_x+1:(size_x-maximo_x);
    vector_y= -maximo_y+1:(size_y-maximo_y);
    delta_x=(sum(imagen)*(vector_x'))/sum(sum(imagen));
    delta_y=(sum(imagen')*(vector_y)')/sum(sum(imagen'));    
    
    %finalmente anotamos los desplazamientos sobre el m�ximo
    cx= maximo_x+delta_x;
    cy= maximo_y+delta_y;
elseif manera ==3
    %normalizamos el pico
    %buscamos primero el m�ximo
    [vall, indd] = max2(imagen);  
    imagen2=imagen./vall;
    cx=(sum(imagen2)*(1:length(sum(imagen2)))')/sum(sum(imagen2));
    cy=(sum(imagen2')*(1:length(sum(imagen2')))')/sum(sum(imagen2'));  
    
elseif manera ==4
    % ponemos un umbral ubicado en la media de los bordes (marco) mas 3 veces la
    % desviaci�n t�pica, y luego calculamos en centroide.
    
    %sacamos el marco
    marco=[imagen(1,:) imagen(:,size_x)' imagen(size_y,:) imagen(:,1)'];
    media_marco=mean(marco);
    std_marco=std(marco);
    umbral = media_marco+3*std_marco;
    imagen2=imagen-umbral;
    imagen2(imagen2<0)=0;  %Ponemos a cero los negativos, por si acaso
    
    %avisamos por si acaso:
%     if sum(imagen2(:))==0
%         display('ojo centroide: no hay pixeles por encima del umbral');
%     end
    cx=(sum(imagen2)*(1:length(sum(imagen2)))')/sum(sum(imagen2));
    cy=(sum(imagen2')*(1:length(sum(imagen2')))')/sum(sum(imagen2'));   
    
elseif manera ==5
    % ponemos un umbral ubicado en la media de la imagen, cuando los bordes no tienen
    % informaci�n    
    roi=imagen(imagen > 0); % (quitamos los ceros, �til cuando hay una mascara)
    umbral = mean(roi(:));

    imagen2=imagen-umbral;
    imagen2(imagen2<0)=0;  %Ponemos a cero los negativos, por si acaso
    
    %avisamos por si acaso:
%     if sum(imagen2(:))==0
%         display('ojo centroide: no hay pixeles por encima del umbral');
%     end
    cx=(sum(imagen2)*(1:length(sum(imagen2)))')/sum(sum(imagen2));
    cy=(sum(imagen2')*(1:length(sum(imagen2')))')/sum(sum(imagen2'));        
else
    
 disp('Manera no definida de calcular el centroide (error)');  
 return
end

if manera ==4
    if display == 1
        %ahora pintamos el centroide, sea cual sea la forma de c�lculo
        %pintamos el centroide calculado, si procede
        %Tener en cuenta que la instrucci�n line es enga�osa, ya que es
        %line([x1,x2],[y1,y2]). Adem�s el primer pixel de la imagen est� en
        %(x=1,y=1), ya que el �ndice cero no existe en MATLAB. La
        %coordenada x=0 s� que existe, pero quedar�a fuera de la imagen if display == 1
        figure;
        subplot(1,2,1);imshow(imagen, []);
        line([cx-1,cx+1],[cy ,cy],'color','b'); %l�nea horizontal 
        line([cx,cx],[cy-1 ,cy+1],'color','b'); %l�nea vertical 

        if manera ==4
            subplot(1,2,2);
            plot(imagen);
            hold;plot(umbral*ones(size(imagen)),'o'); %un poco bestia para pintar el umbral
        end
        shg;
        zoom(4);
        pause(0.3);
        close;
    end  
else
    if display == 1
        %ahora pintamos el centroide, sea cual sea la forma de c�lculo
        %pintamos el centroide calculado, si procede
        %Tener en cuenta que la instrucci�n line es enga�osa, ya que es
        %line([x1,x2],[y1,y2]). Adem�s el primer pixel de la imagen est� en
        %(x=1,y=1), ya que el �ndice cero no existe en MATLAB. La
        %coordenada x=0 s� que existe, pero quedar�a fuera de la imagen if display == 1
        imshow(imagen, []);
        line([cx-1,cx+1],[cy ,cy],'color','b'); %l�nea horizontal 
        line([cx,cx],[cy-1 ,cy+1],'color','b'); %l�nea vertical 
        shg;
        zoom(4);
        pause(0.1);
    end

end  
end

    

