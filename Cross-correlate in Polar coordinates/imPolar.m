%daryagrm
%version:1.0
%Функция перевода изображения из декартовых координат в полярные.

function [ imp ] = imPolar( im1 )
    SZ = size(im1); % размер изображени€
    R_1 = ceil(SZ(1) / 2); % граница изображени
    R = ceil(50*log(R_1)); % увеличение оси на 50
for i = 1:R % по всем пикселм 
    for j=1:360 % на 360 градусов
        x(i,j) =(exp((i-1)/50) * cos((j-1)*pi/180)); % обратное преобразование относительно x
        y(i,j) =(exp((i-1)/50) * sin((j-1)*pi/180)); % обратное преобразование относительно y
        sub_pix=uint32(0);
        for di=-0.4:0.1:0.5 % проход по субпикселю
            for dj=-0.4:0.1:0.5 % проход по субпикселю
                if (round(R_1-y(i,j)+di)>0) % проверка попадани€ в субпиксель по y
                    ind_i=round(R_1-y(i,j)+di);  
                else
                    ind_i=1;
                end
                if (round(R_1+x(i,j)+dj)>0) % проверка попадани€ в субпиксель по x
                    ind_j=round(R_1+x(i,j)+dj); 
                else
                    ind_j=1;
                end
                sub_pix=sub_pix + uint32(im1(ind_i,ind_j)); % запись яркости
            end
        end
        buf_sp=uint8(sub_pix/100); 
        imp(i,j)=uint8(buf_sp); % выход функции
    end
end
end


