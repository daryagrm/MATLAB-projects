%daryagrm
%version:1.0
%�����-���������� ���� ����������� � �������� �����������. �������� ��������� ���������� ��� ��������� ����� �������, ��������� ��������� �����������.

im1 = imread('main.pcx');

figure('Name','�c������','NumberTitle','off'), imshow(im1);
im1 = imrotate(im1, 18);
im1 = imresize(im1, 1.3);
figure('Name','�c������','NumberTitle','off'), imshow(im1);
 imp1 = imPolar(imrotate(im1, 18));
 imp2 = imPolar(imresize(im1, 1.3));
 
 imp1(end + 1, :) = zeros(1, length(imp1(1, :)));
 imp1(end + 1, :) = zeros(1, length(imp1(1, :)));
 
 figure('Name','����������� 1.��������.','NumberTitle','off'), imshow(imrotate(imp1, 180));
 
 figure('Name','����������� 2.���������������.','NumberTitle','off'), imshow(imrotate(imp2, 180));
 
 c = normxcorr2(imp2(:, :, 1), imp1(:, :, 1));
 
 figure('Name', '��������� ����������', 'NumberTitle', 'off'), imshow(c);


