%daryagrm
%version:1.0
%���������� �����-���������� ��������� ����������� � ����������, ������� �������� ������ ���������. �������� �������� ���������� ��� ��������� ����� �������, �������� �������.  

img_1 = imread('main.pcx');
img_2 = imread('own_1.pcx');

%///////////////2.2

figure('Name','�������� ����������� � ���������'), imshowpair(img_1, img_2, 'montage');
 
 c = normxcorr2(img_2(:, :, 1), img_1(:, :, 1));
 figure('Name','����������'), imshow(c);
 
 [y, x] = find(c == max(c(:)));
 yoffSet = y - size(img_2, 1);
 xoffSet = x - size(img_2, 2);
 
 figure('Name', '��������� ������� �� �������� �����������'), imshow(img_1);
 imrect(gca, [xoffSet + 1, yoffSet + 1, size(img_2, 2), size(img_2, 1)]);


%///////////////2.3

i = 2;
while i <= 10
    
    tmpIm = imrotate(img_2, i);
    
    cTmp = normxcorr2(tmpIm(:, :, 1), img_1(:, :, 1));
    figure('Name', '����������'), imshow(cTmp);
    
    i = i + 2;
    
end

% ///////////////2.4
 
 i = 0.9;
 while i <= 1.1
     
     tmpIm = imresize(img_2, i);
     
     cTmp = normxcorr2(tmpIm(:, :, 1), img_1(:, :, 1));
     figure('Name', '����������'), imshow(cTmp);
     
     i = i + 0.025;
     
 end

