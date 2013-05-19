# Compilazione file MEX su Linux #


## Installazione librerie OpenCV ##
Bisogna avere installate le varie librerie di sviluppo
per OpenCV

apt-get install ^libopencv-.*-dev$


## Sistemare i link alle librerie ##
Usando un sistema a 64bit bisogna sistemare due link
a due librerie

cd /usr/lib/x86_64-linux-gnu/
ln -s libraw1394.so.11.0.1 libraw1394.so.8

cd $PATH_TO_MATLAB_FOLDER/MATLAB/R2011a/sys/os/glnxa64
mv libstdc++.so.6 libstdc++.so.6_backup
ln -s libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.17

Le varie versioni della libraw1394 e libstdc++ protrebbero
cambiare a seconda delle distro e altro, se non sono esattemente
quelle indicate è necessario cambiare con quelle di sistema


## Compilare funzione ##
Bisogna compilare la funzione C++ con il tool mex di Matlab

export PATH=$PATH:$PATH_TO_MATLAB_FOLDER/MATLAB/R2011a/bin
mex fastcv_hough.cpp $(pkg-config --libs --cflags opencv)


## Esecuzione funzione ##
La funzione fastcv_hough sarà disponibile in Matlab come una
normale funzione, bisogna mettere il file fastcv_hough.mexa64
nella directory dove Matlab sta lavorando

I parametri delle funzione sono
	filename
 	lowCannyThreshold
	highCannyThreshold
	houghThreshold
	minLineLengtH
	maxLineGap

filename deve essere il percorso relativo del file partendo dalla
cartella di lavoro di Matlab, gli altri parametri sono gli stessi
dell'esempio HoughP che c'è sul branch hough
