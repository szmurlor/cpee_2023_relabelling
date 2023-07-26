% file responsible for figure 5

close all
DATADIR = 'C:\Users\szmurlor\Nextcloud\ALEX_obrazy_all';
I1 = imread([DATADIR,'\1\1.jpg']);
I2 = imread([DATADIR,'\10\10.jpg']);
I3 = imread([DATADIR,'\56\12.jpg']);
subplot(2,3,1)
imshow(I1)
xlabel("Class 1")
subplot(2,3,2)
imshow(I2)
xlabel("Class 10")
subplot(2,3,3)
imshow(I3)
xlabel("Class 56")

subplot(2,3,4)
I1g = rgb2gray(imnoise(I1, 'gaussian', 0, 0.05))
I1 = cat(3, I1g, I1g, I1g)
imshow(I1);
xlabel("Class 1")

subplot(2,3,5)
I2g = rgb2gray(imnoise(I2, 'gaussian', 0, 0.05))
I2 = cat(3, I2g, I2g, I2g)
imshow(I2);
xlabel("Class 10")

subplot(2,3,6)

I3g = rgb2gray(imnoise(I3, 'gaussian', 0, 0.05))
I3 = cat(3, I3g, I3g, I3g)
imshow(I3);
xlabel("Class 56")

