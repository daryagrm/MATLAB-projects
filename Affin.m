%daryagrm
%version:1.0
%Аффинные преобразования и нормализация изображения.

VAR = 3;

im1 = imread(['image_' num2str(VAR) '_6.pcx']);

figure('Name','Изображение 1.','NumberTitle','off'), imshow(im1);

Xc = 0;
Yc = 0;

sumT = sum(sum(im1));

lengthM = 500;

vecXY = 1 : lengthM;

i = 1;
while i <= lengthM

    Xc = Xc + sum(vecXY .* double(im1(i, :)));
    
    Yc = Yc + sum(vecXY .* double(im1(:, i)'));
   
    i = i + 1;
   
end

Xc = Xc / sumT;
Yc = Yc / sumT;

B = 0;
C = 0;
D = 0;

tmpVecX = vecXY - Xc;
tmpVecY = vecXY - Yc;


i = 1;
while i <= lengthM
    
    B = B + sum( double(im1(i, :)) .* (tmpVecX.^2 - tmpVecY(i)^2));
    C = C + sum( tmpVecX .* double(im1(i, :)) * 2 * tmpVecY(i));
    D = D + sum( double(im1(i, :)) .* (tmpVecX.^2 + tmpVecY(i)^2));
    
    i = i + 1;
    
end


mi = D + sqrt(C^2 + B^2);
mi = mi / (D - sqrt(C^2 + B^2));
mi = sqrt(mi);

n = 0;

if (B > 0) && (C > 0)
    
    teta = 0.5 * atan(C / B) + pi * n;
    
elseif (B > 0) && (C < 0)
    
    teta = 0.5 * atan(C / B) + pi * n;
    
elseif (B < 0) && (C > 0)
    
    teta = (0.5 * atan2(0, C / B) + pi * n);
    
else
    
    teta = -atan(C / B) + pi * n;
    
end


newIm1X = zeros(lengthM);
newIm1Y = zeros(lengthM);

M = 0;

i = 1;
while i <= lengthM
    
    j = 1;
    while j <= lengthM
        
        tmp1 = tmpVecX(j) * cos(-teta);
        tmp1 = tmp1 - tmpVecY(i) * sin(-teta);
        
        tmp2 = tmpVecX(j) * sin(-teta);
        tmp2 = tmp2 + tmpVecY(i) * cos(-teta);
        
        newIm1X(i, j) = tmp1 * cos(teta) / mi;
        newIm1X(i, j) = newIm1X(i, j) - tmp2 * sin(teta);
        
        newIm1Y(j, i) = tmp1 * sin(teta) / mi;
        newIm1Y(j, i) = newIm1Y(j, i) + tmp2 * cos(teta);
        
        tmp = newIm1X(i, j)^2 + newIm1Y(j, i)^2;
        tmp = sqrt(tmp);
        tmp = sum(tmp * double(im1(i, j)));

        M = M + tmp;
        
        j = j + 1;
        
    end
    
    i = i + 1;
   
end


K = 10;

M = M / (K * sumT);

newIm1X = int32(newIm1X / M + Xc);
newIm1Y = int32(newIm1Y / M + Yc);

newIm1 = uint8(zeros(lengthM));

i = lengthM;
while i >= 1
    
    j = lengthM;
    while j >= 1

        newIm1(newIm1Y(j, i), newIm1X(i, j)) = im1(i, j);
        
        j = j - 1;
        
    end
    
    i = i - 1;
    
end

figure('Name','Изображение 2.','NumberTitle','off'), imshow(newIm1);




