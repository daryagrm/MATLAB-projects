%Есть последовательность.
%Собираем информацию о ней.
%Генерируем код Хаффмана.
%Считаем таблицу с вершинами.
%Запоминаем длины полученных кодовых слов для символов.
%Сортируем по увеличению длины.
%Имея длины, генерируем новые кодовые слова (к.с.) (с сохранением длины) функцией canonCodeword
%(первое к.с. - нули, остальные - +1 к числу предыдущего к.с., с увеличением длины в конце приписывается 0)



function [  ] = encodeHuffRegular(  )
clc;
inputStr='не_имей_сто_рублей,_а_имей_сто_друзей.';
inputStr='IF_WE_CANNOT_DO_AS_WE_WOULD_WE_SHOULD_DO_AS_WE_CAN';
inputStr='везде_передо_мной_подвижные_картины:_здесь_вижу_двух_озер_лазурные_равнины._на_севере_диком_стоит_одиноко_на_голой_вершине_сосна.';
% -------------------------------------------------------------------------
% Первый проход : сбор статистики источника
a = unique(inputStr); % уникальные символы последовательности
N = size(inputStr,2); % кол-во символов последовательности
Nx = zeros(1, size(a,2)); % частота уникальных символов
for i = 1:size(a,2)
	for j = 1:N        
        if find(a(i) == inputStr(j), 1)
             Nx(i) = Nx(i)+1;
        end
	end
end
for i = 1 : size(a,2)
	prob(i) = Nx(i) / N;
end
% -------------------------------------------------------------------------
% Второй проход : кодирование последовательности
global CODE
CODE = cell( length(prob), 1 );
% -------------------------------------------------------------------------
% ------------- дерево  
p=prob;
s = cell( length(p), 1 );
for i = 1:length(p)
	s{i} = i;   % соответствует исходным символам
end
while size(s, 1) > 2
	[p,i] = sort(p, 'ascend');	% сортировка вероятностей (по возрастанию)
	p(2) = p(1) + p(2); 
	p(1) = [];          % удаление наименьшей вероятности
    % то же самое для s
	s = s(i);           % реордер для нового кол-ва вероятностей
	s{2} = {s{1},s{2}}; % слияние звеньев
	s(1) = [];          % удаление звена, кот. соотв. минимальному
end
% ------------- конец дерева  
CODE = makecode(s, []);         % рекурсивно генерируется код
% -------------------------------------------
symbols=num2cell(unique(inputStr));
dict = huffmandict(symbols,prob);
for i=1:size(dict,1)
    CODE{i}=num2str(dict{i,2}, '%d');
    a(i)=num2str(dict{i,1});
end
% -------------------------------------------------------------------------
for i = 1:length(CODE)
    len(i) = length(CODE{i});   % длина кодового слова
end
% -------------------------------------------------------------------------
[len, sortIndex] = sort(len);   
a = a(sortIndex);
CODE = CODE(sortIndex);
%CODE=sortCodeword(CODE); % упорядочивание к.с. лексикографически
CODE = canonCodeword(len);      % новые каноничные кодовые слова
% -------------------------------------------------------------------------
level=max(len); % кол-во ярусов = макс. длина кодового слова
symbols=256; 
for lvl=1:level 
    % поиск кол-ва концевых вершин (endVert) данного яруса
    % = кол-ва кодовых слов с данной длиной lvl
    endVert(lvl)=0;
    for j=1:size(a,2) % +1, если длина j-того к.с. совпадает с текущим ярусом
       if find (len(j)==lvl, 1) endVert(lvl)=endVert(lvl)+1; end;
    end
    % поиск настоящего кол-ва вершин numVert
    sub=0;
    for i=lvl-1:-1:1  % поиск кол-ва недостающих вершин с предыдущего по 1-й ярус
        raznica=lvl-i; % разница между текущим и более ранним i-тым ярусом
        if (raznica==0) raznica=1; end
        sub = sub + endVert(i)*power(2, raznica); % возвести 2 в степень разницы между ярусами
                                                  % концевых вершин i-того яруса раз
    end
    % настоящее кол-во вершин можно найти проще, пока лень
    numVert(lvl) = power(2, lvl) - sub; % (настоящее) кол-во вершин
    costs(lvl) = ceil( log2(numVert(lvl)+1) ); % затраты в битах
    if (endVert(lvl)>0) 
       comb(lvl)=ceil(log2(nchoosek(symbols, endVert(lvl)))); % число комбинаций
       symbols = symbols - endVert(lvl);
    else
       comb(lvl)=0;
    end
end
ttlCost = sum(costs) + 1; 
ttlComb = sum(comb);
l1 = ttlCost + ttlComb;
l2 = ttlComb;
l = l1 + l2;
% -------------------------------------------------------------------------
% Вывод таблиц
disp ('---------------------------------------- Canonical Huffman');
disp('symbol | len | codeword');
for i=1:length(prob)
        fprintf('%4s\t %3d\t %s\n', a(i), len(i), num2str(CODE{i}));
end
disp ('------------------------------------------------------------');
disp(' level | вершин | конц верш | диапазон | затраты | комбинац');
fprintf('%4d\t %4d\t %6d\t \t\t0..%d\t %4d\t %5d\n', 0, 1, 0, 1, 1, 0);
for lvl=1:level
    fprintf('%4d\t %4d\t %6d\t \t\t0..%d\t %4d\t %5d\n', lvl, numVert(lvl), endVert(lvl), numVert(lvl), costs(lvl), comb(lvl));
end
disp ('------------------------------------------------------------');
fprintf('Total cost = %d bits\n', ttlCost);
fprintf('Total combinations = %d\n', ttlComb);
fprintf('l1 = %d\n', l1);
fprintf('l2 = %d\n', l2);
fprintf('l = %d\n', l);

end 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function y = sortCodeword(x) % сортировка массива кодовых слов лексикографически
n=length(x);
for k=1:n-1 
	for j=1:n-k
        % сравнивать кодовые слова в десятичном представлении
        % меньшее должно идти раньше
        a=bin2dec(num2str(x{j})); 
        b=bin2dec(num2str(x{j+1}));
        len_a = length(x{j});
        len_b = length(x{j+1});
        % если неправильный порядок И равные длины, то поменять местами
        if (a > b  && len_a==len_b)
            temp = x(j);
            x(j) = x(j+1);
            x(j+1) = temp;
       end % if
	end % for j
end % for k
y = x;
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function x = canonCodeword ( len )
% по известным длинам len кодовых слов
% составляются новые кодовые слова x

% первое к.с. - прежняя длина, все символы - 0
x{1}='0';
if (len(1)>1)
    for i=1:len(1)-1
        x{1} = [x{1}  '0'];
    end
end

% остальные кодовые слова (со 2-го до конца)
for i=2:length(len)
    if (len(i) > len(i-1))            
        flagZeroEnd = len(i) - len(i-1);
    else
        flagZeroEnd=0;
    end
    
    b = bin2dec(num2str(x{i-1})); 
    b = b+1;                      
    b = dec2bin(b);               
    
    if (len(i-1) > length(b))           
        flagZeroSt=len(i-1)-length(b); 
    else
        flagZeroSt=0;
    end
    
    x{i}=b; % текущее кодовое слово = полученное число
            
    if (flagZeroEnd > 0)     
        for j=1:flagZeroEnd 
            x{i}=[x{i} '0'];
        end
    end
    if (flagZeroSt>0)        
        for j=1:flagZeroSt   
            x{i}=['0' x{i}];
        end
    end
end

end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [CODE]=makecode(ss, codeword)
% рекурсивно генерируются кодовые слова
global CODE
if isa(ss,'cell')   % для узла
	makecode( ss{1}, [codeword 1] );
	makecode( ss{2}, [codeword 0] );
else                % для листа
	CODE{ss} = char('0' + codeword);
end
end
