clear all;
K = imread('INSERT_IMAGE_FILEPATH');

colour_quality = 1;% Keep this at one
adjustment = 15;
quality = 50;%input('What quality of compression you require - ');

for i=1:floor(size(K,1)/8)*8
    for j=1:floor(size(K,2)/8)*8
        I(i,j,1) = K(i,j,1);
        I(i,j,2) = K(i,j,2);
        I(i,j,3) = K(i,j,3);
    end
end

I = rgb2ycbcr(I);
C(:,:) = double(I(:,:,1));
D(:,:) = double(I(:,:,2))./colour_quality;
E(:,:) = double(I(:,:,3))./colour_quality;
[U,S,V]=svd(C);
[nx, ny] = size(C);
Z = zeros(size(C));
for i=1:size(C,1)
    if i < 2
        Z(i, i) = S(i, i);
    end
end

H = U*Z*V';
figure(1000);
imshow(H, []);
title('\sigma 1');

for i=1:nx
    RemDataX(i) = -U(i,1);
end
for i=nx:max(nx,ny)
    RemDataX(i) = -U(i-nx+1,1);
end
for j=1:ny
    RemDataY(j) = -V(j,1);
end
for j=ny:max(nx,ny)
    RemDataY(j) = -V(j-nx+1,1);
end
RemDataS = S(1,1);
recMat = zeros(nx,ny);
recMat(1,1) = RemDataS;
for i=1:nx
    for j=1:ny
        recMat(i,j) = RemDataX(i)*RemDataY(j);
    end
end
testH = RemDataS*recMat;
figure(100);imshow(testH, []);
title('Reconstructed H');

[Z2, saveData2] = jpegCompress(C, quality);
[Z1, saveData1] = jpegCompress(C-H, quality-adjustment);
[Z3, saveDataCB] = jpegCompress(D, quality);
[Z4, saveDataCR] = jpegCompress(E, quality);

for i=1:size(saveData1,2)
    finalSaveREM(i) = saveData1(i);
end
for i=1:size(saveData2,2)
    finalSaveReg(i) = saveData2(i);
end
for i=1:size(saveDataCB,2)
    finalSaveREM(i+size(saveData1,2)) = saveDataCB(i);
    finalSaveReg(i+size(saveData2,2)) = saveDataCB(i);
end
for i=1:size(saveDataCR,2)
    finalSaveREM(i+size(saveData1,2)+size(saveDataCB,2)) = saveDataCR(i);
    finalSaveReg(i+size(saveData2,2)+size(saveDataCB,2)) = saveDataCR(i);
end
for i=1:size(RemDataX,2)
    finalSaveREM(i+size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)) = RemDataX(i)*100;
end
for i=1:size(RemDataY,2)
    finalSaveREM(i+size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)+size(RemDataX,2)) = RemDataY(i)*100;
end
finalSaveREM(size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)+size(RemDataX,2)+size(RemDataY,2)+1) = RemDataS;
finalSaveREM(size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)+size(RemDataX,2)+size(RemDataY,2)+2) = colour_quality;
finalSaveREM(size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)+size(RemDataX,2)+size(RemDataY,2)+3) = quality-adjustment;
finalSaveReg(size(saveData2,2)+size(saveDataCB,2)+size(saveDataCR,2)+1) = colour_quality;
finalSaveReg(size(saveData2,2)+size(saveDataCB,2)+size(saveDataCR,2)+2) = quality;
Q50 = [ 16 11 10 16 24 40 51 61;
        12 12 14 19 26 58 60 55;
        14 13 16 24 40 57 69 56;
        14 17 22 29 51 87 80 62; 
        18 22 37 56 68 109 103 77;
        24 35 55 64 81 104 113 92;
        49 64 78 87 103 121 120 101;
        72 92 95 98 112 100 103 99];
for i=1:8
    for j=1:8
        finalSaveREM(size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)+size(RemDataX,2)+size(RemDataY,2)+3+8*(i-1)+j) = Q50(i,j);
        finalSaveReg(size(saveData2,2)+size(saveDataCB,2)+size(saveDataCR,2)+2+8*(i-1)+j) = Q50(i,j);
    end
end
finalSaveREM(size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)+size(RemDataX,2)+size(RemDataY,2)+68) = nx;
finalSaveREM(size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)+size(RemDataX,2)+size(RemDataY,2)+69) = ny;
finalSaveReg(size(saveData2,2)+size(saveDataCB,2)+size(saveDataCR,2)+67) = nx;
finalSaveReg(size(saveData2,2)+size(saveDataCB,2)+size(saveDataCR,2)+68) = ny;
finalSaveREM(size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)+size(RemDataX,2)+size(RemDataY,2)+70) = size(saveDataCR,2)/100;
finalSaveREM(size(saveData1,2)+size(saveDataCB,2)+size(saveDataCR,2)+size(RemDataX,2)+size(RemDataY,2)+71) = size(saveDataCB,2)/100;
finalSaveReg(size(saveData2,2)+size(saveDataCB,2)+size(saveDataCR,2)+69) = size(saveDataCR,2)/100;
finalSaveReg(size(saveData2,2)+size(saveDataCB,2)+size(saveDataCR,2)+70) = size(saveDataCB,2)/100;

fID1 = fopen('FILEPATH\test.txt', 'w');
fID2 = fopen('FILEPATH\testREM.txt', 'w');
for i=1:size(finalSaveReg,2)
    fprintf(fID1,[num2str(finalSaveReg(i)),' ']);
end
for i=1:size(finalSaveREM,2)
    fprintf(fID2,[num2str(finalSaveREM(i)),' ']);
end
fclose(fID1);
fclose(fID2);

finalIm(:,:,1) = Z1+testH;
finalIm(:,:,2) = Z3.*colour_quality;
finalIm(:,:,3) = Z4.*colour_quality;
finalIm = ycbcr2rgb(uint8(finalIm));

finalIm2(:,:,1) = Z2;
finalIm2(:,:,2) = Z3.*colour_quality;
finalIm2(:,:,3) = Z4.*colour_quality;
finalIm2 = ycbcr2rgb(uint8(finalIm2));

figure(1);imshow(ycbcr2rgb(I));title('Original Image');
figure(2);imshow(finalIm);title('Post-Compression Image, \sigma 1 REMOVED');
figure(3);imshow(finalIm2);title('Post-Compression Image, NO REMOVAL');
error = finalIm-I;
error = abs(error).^2;
MSE = sum(error, "all")/numel(error);
errorREM = finalIm2-I;
errorREM = abs(errorREM).^2;
MSEREM = sum(errorREM, "all")/numel(errorREM);

function [output_image, saveData] = jpegCompress(I, quality)
    index = 1;
    [row, coln]= size(I);
    I= double(I);
    %---------------------------------------------------------
    % Subtracting each image pixel value by 128 
    %--------------------------------------------------------
    I = I - (128*ones(row, coln));
    %----------------------------------------------------------
    % Quality Matrix Formulation
    %----------------------------------------------------------
    Q50 = [ 16 11 10 16 24 40 51 61;
        12 12 14 19 26 58 60 55;
        14 13 16 24 40 57 69 56;
        14 17 22 29 51 87 80 62; 
        18 22 37 56 68 109 103 77;
        24 35 55 64 81 104 113 92;
        49 64 78 87 103 121 120 101;
        72 92 95 98 112 100 103 99];
 
    if quality > 50
        QX = round(Q50.*(ones(8)*((100-quality)/50)));
        QX = uint8(QX);
    elseif quality < 50
        QX = round(Q50.*(ones(8)*(50/quality)));
        QX = uint8(QX);
    elseif quality == 50
        QX = Q50;
    end
 
    %----------------------------------------------------------
    % Formulation of forward DCT Matrix and inverse DCT matrix
    %----------------------------------------------
    DCT_matrix8 = dct(eye(8));
    iDCT_matrix8 = DCT_matrix8';   %inv(DCT_matrix8);
    %----------------------------------------------------------
    % Jpeg Compression
    %----------------------------------------------------------
    dct_restored = zeros(row,coln);
    QX = double(QX);
    %----------------------------------------------------------
    % Jpeg Encoding
    %----------------------------------------------------------
    %----------------------------------------------------------
    % Forward Discrete Cosine Transform
    %----------------------------------------------------------
    for i1=[1:8:row]
        for i2=[1:8:coln]
            zBLOCK=I(i1:i1+7,i2:i2+7);
            win1=DCT_matrix8*zBLOCK*iDCT_matrix8;
            dct_domain(i1:i1+7,i2:i2+7)=win1;
        end
    end
    %-----------------------------------------------------------
    % Quantization of the DCT coefficients
    %-----------------------------------------------------------
    sharp_tol = 50;

    for i1=[1:8:row]
        for i2=[1:8:coln]
            win1 = dct_domain(i1:i1+7,i2:i2+7);
            win2=round(win1./QX);
            sd = false;
            for i=i1:i1+7
                for j=i2:i2+7
                    if (I(i,j) >= sharp_tol + I(max(1,i-1), j))
                        sd = true;
                    elseif (I(i,j) >= sharp_tol + I(min(size(I,1),i+1),j))
                        sd = true;
                    elseif (I(i,j) >= sharp_tol + I(i,max(1,j-1)))
                        sd = true;
                    elseif (I(i,j) >= sharp_tol + I(i,min(size(I,2),j+1)))
                        sd = true;
                    end
                end
            end
            if (sd == true)
                temp = round(win1.*100);
                win2 = temp./100;
            end
            dct_quantized(i1:i1+7,i2:i2+7)=win2;
            % Save win2 as a zigzag, cutting off extra zeroes
            cur = win2;
            %reshape(cur,1,64);
            %for i=1:64
                %if (cur(i) ~= 0)
                    %cur2(i) = cur(i);
                %end
            %end
            %if (size(cur2) ~= 64)
                %cur2(size(cur2)+1) = 0;
            %end
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
            for i=1:64%size(cur,1)*size(cur,2)
                %if (cur(moveArray(i)) ~= 0)
                test3 = cur(1,2);
                test = cur(moveArray(i,2),moveArray(i,1));
                temp = moveArray(i,2);
                temp2 = moveArray(i,1);
                %test2 = cur(temp);
                breakVal = true;
                for j=i:64
                    if (cur(moveArray(j,2),moveArray(j,1)) ~= 0)
                        breakVal = false;
                    end
                end
                if (breakVal == true)
                    saveData(index) = 0.101;
                    index = index + 1;
                    break;
                end
                %else
                    %saveData(index) = 0;
                    %index = index + 1;
                %end
                saveData(index) = cur(moveArray(i,2),moveArray(i,1));
                index = index + 1;
            end
            %saveData(index) = 0;
            %index = index + 1;
        end
    end
    %-----------------------------------------------------------
    % Jpeg Decoding 
    %-----------------------------------------------------------
    % Dequantization of DCT Coefficients
    %-----------------------------------------------------------
    for i1=[1:8:row]
        for i2=[1:8:coln]
            win2 = dct_quantized(i1:i1+7,i2:i2+7);
            nozeroes = false;
            for i=1:8
                for j=1:8
                    if (win2(i,j)-floor(win2(i,j)) ~= 0)
                        nozeroes = true;
                    end
                end
            end
            if (nozeroes == false)
                win3 = win2.*QX;
            else
                win3 = win2;
            end
            dct_dequantized(i1:i1+7,i2:i2+7) = win3;
        end
    end
    %-----------------------------------------------------------
    % Inverse DISCRETE COSINE TRANSFORM
    %-----------------------------------------------------------
    for i1=[1:8:row]
        for i2=[1:8:coln]
            win3 = dct_dequantized(i1:i1+7,i2:i2+7);
            win4=iDCT_matrix8*win3*DCT_matrix8;
            dct_restored(i1:i1+7,i2:i2+7)=win4;
        end
    end
    I2=dct_restored;
    % ---------------------------------------------------------
    % Conversion of Image Matrix to Intensity image
    %----------------------------------------------------------
    output_image = I2+(128*ones(row, coln));
end
