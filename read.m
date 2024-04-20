clear all;

fID1 = fopen('FILEPATH\test.txt', 'r');
fID2 = fopen('FILEPATH\testREM.txt', 'r');
A = fscanf(fID1, '%c');
B = fscanf(fID2, '%c');
fclose(fID1);
fclose(fID2);

temp = '';
index = 1;
A = A';
for i=1:size(A,1)
    if (A(i) == ' ')
        temp2 = str2num(convertCharsToStrings(temp));
        transformedA(index) = temp2;
        temp = '';
        index = index + 1;
    else
        temp = [temp, A(i)];
    end
end
temp = '';
index = 1;
B = B';
for i=1:size(B,1)
    if (B(i) == ' ')
        temp2 = str2num(convertCharsToStrings(temp));
        transformedB(index) = temp2;
        temp = '';
        index = index + 1;
    else
        temp = [temp, B(i)];
    end
end

sizeCB = 100*transformedA(size(transformedA,2));
sizeCR = 100*transformedA(size(transformedA,2)-1);
sizeCBREM = 100*transformedB(size(transformedB,2));
sizeCRREM = 100*transformedB(size(transformedB,2)-1);
ny = transformedA(size(transformedA,2)-2);
nx = transformedA(size(transformedA,2)-3);
nyREM = transformedB(size(transformedB,2)-2);
nxREM = transformedB(size(transformedB,2)-3);
for i=1:8
    for j=1:8
        Q50(9-i,9-j) = transformedA(size(transformedA,2)-3-8*(i-1)-j);
        Q50REM(9-i,9-j) = transformedB(size(transformedB,2)-3-8*(i-1)-j);
    end
end

quality = transformedA(size(transformedA,2)-68);
colour_quality = transformedA(size(transformedA,2)-69);
qualityREM = transformedB(size(transformedB,2)-68);
colour_qualityREM = transformedB(size(transformedB,2)-69);
RemDataS = transformedB(size(transformedB,2)-70);

for i=1:max(nxREM,nyREM)
    RemDataY(max(nxREM,nyREM)-i+1) = -transformedB(size(transformedB,2)-70-i)/100;
end
for i=1:max(nxREM,nyREM)
    RemDataX(max(nxREM,nyREM)-i+1) = -transformedB(size(transformedB,2)-70-max(nxREM,nyREM)-i)/100;
end

for i=1:sizeCR
    crData(sizeCR-i+1) = transformedA(size(transformedA,2)-69-i);
end
for i=1:sizeCRREM
    crDataREM(sizeCRREM-i+1) = transformedB(size(transformedB,2)-70-2*max(nxREM,nyREM)-i);
end
for i=1:sizeCB
    cbData(i) = transformedA(size(transformedA,2)-69-sizeCR-i);
end
for i=1:sizeCBREM
    cbDataREM(i) = transformedB(size(transformedB,2)-70-2*max(nxREM,nyREM)-sizeCRREM-i);
end
cbData = flip(cbData);
cbDataREM = flip(cbDataREM);
for i=1:size(transformedA,2)-69-sizeCR-sizeCB
    yData(i) = transformedA(i);
end
for i=1:size(transformedB,2)-70-2*max(nxREM,nyREM)-sizeCRREM-sizeCBREM
    yDataREM(i) = transformedB(i);
end

recMat = zeros(nxREM,nyREM);
recMat(1,1) = RemDataS;
for i=1:nxREM
    for j=1:nyREM
        recMat(i,j) = RemDataX(i)*RemDataY(j);
    end
end
H = RemDataS*recMat;

NOREM = decodeBlockVector(yData, quality, Q50, nx, ny);
NOREM_CB = decodeBlockVector(cbData, quality, Q50, nx, ny);
NOREM_CR = decodeBlockVector(crData, quality, Q50, nx, ny);
REM = decodeBlockVector(yDataREM, qualityREM, Q50REM, nxREM, nyREM);
REM_CB = decodeBlockVector(cbDataREM, qualityREM, Q50REM, nxREM, nyREM);
REM_CR = decodeBlockVector(crDataREM, qualityREM, Q50REM, nxREM, nyREM);
finalImNOREM(:,:,1) = NOREM;
finalImNOREM(:,:,2) = NOREM_CB.*colour_quality;
finalImNOREM(:,:,3) = NOREM_CR.*colour_quality;
finalIm(:,:,1) = REM+H;
finalIm(:,:,2) = REM_CB.*colour_qualityREM;
finalIm(:,:,3) = REM_CR.*colour_qualityREM;
finalImNOREM = ycbcr2rgb(uint8(finalImNOREM));
finalIm = ycbcr2rgb(uint8(finalIm));
imshow(abs(uint8(REM_CB)-uint8(NOREM_CB)))
imshow(abs(uint8(REM_CR)-uint8(NOREM_CR)))
figure(1);imshow(finalImNOREM);title('Recovered image, NO REMOVED \sigma');
figure(2);imshow(finalIm);title('Recovered Image, \sigma REMOVED');

function [output_image] = decodeBlockVector(inVec, quality, Q50, nx, ny)
    index = 1;
    for i=1:size(inVec,2)
        if (inVec(i) == 0.101)
            zeroList(index) = i;
            index = index + 1;
        end
    end

    index = 1;
    moveArray = [[1,1];
            [2,1];
            [1,2];
            [1,3];
            [2,2];
            [3,1];
            [4,1];
            [3,2];
            [2,3];
            [1,4];
            [1,5];
            [2,4];
            [3,3];
            [4,2];
            [5,1];
            [6,1];
            [5,2];
            [4,3];
            [3,4];
            [2,5];
            [1,6];
            [1,7];
            [2,6];
            [3,5];
            [4,4];
            [5,3];
            [6,2];
            [7,1];
            [8,1];
            [7,2];
            [6,3];
            [5,4];
            [4,5];
            [3,6];
            [2,7];
            [1,8];
            [2,8];
            [3,7];
            [4,6];
            [5,5];
            [6,4];
            [7,3];
            [8,2];
            [8,3];
            [7,4];
            [6,5];
            [5,6];
            [4,7];
            [3,8];
            [4,8];
            [5,7];
            [6,6];
            [7,5];
            [8,4];
            [8,5];
            [7,6];
            [6,7];
            [5,8];
            [6,8];
            [7,7];
            [8,6];
            [8,7];
            [7,8];
            [8,8]];
    last = 0;
    cur = zeros(8,8);
    quantIndex = 1;
    for i=1:size(inVec,2)
        if (index <= size(zeroList,2))
            checkVal = zeroList(index);
        else
            checkVal = size(inVec,2) - last;
        end
        if (i == checkVal)
            index = index + 1;
            last = i;
            quantBlocks(:,:,quantIndex) = cur;
            quantIndex = quantIndex + 1;
            clear cur;
            cur = zeros(8,8);
        else
            if (i-last > 64)
                last = i - 1;
                quantBlocks(:,:,quantIndex) = cur;
                quantIndex = quantIndex + 1;
                clear cur;
                cur = zeros(8,8);
                cur(moveArray(i-last,2),moveArray(i-last,1)) = inVec(i);
            else
                cur(moveArray(i-last,2),moveArray(i-last,1)) = inVec(i);
            end
        end
    end

    if quality > 50
        QX = round(Q50.*(ones(8)*((100-quality)/50)));
        QX = uint8(QX);
    elseif quality < 50
        QX = round(Q50.*(ones(8)*(50/quality)));
        QX = uint8(QX);
    elseif quality == 50
        QX = Q50;
    end
    DCT_matrix8 = dct(eye(8));
    iDCT_matrix8 = DCT_matrix8';
    index = 1;

    for i1=[1:8:nx]
        for i2=[1:8:ny]
            if (index <= size(quantBlocks,3))
                win2(:,:) = quantBlocks(:,:,index);
                index = index + 1;
            end
            nozeroes = false;
            for i=1:8
                for j=1:8
                    if (win2(i,j)-floor(win2(i,j)) ~= 0)
                        nozeroes = true;
                    end
                end
            end
            if (nozeroes == false)
                win3 = win2.*double(QX);
            else
                win3 = win2;
            end
            %win3 = win2.*double(QX);
            dct_dequantized(i1:i1+7,i2:i2+7) = win3;
        end
    end
    for i1=[1:8:nx]
        for i2=[1:8:ny]
            win3 = dct_dequantized(i1:i1+7,i2:i2+7);
            win4=iDCT_matrix8*double(win3)*DCT_matrix8;
            dct_restored(i1:i1+7,i2:i2+7)=win4;
        end
    end
    output_image = dct_restored + (128*ones(nx,ny));
end
