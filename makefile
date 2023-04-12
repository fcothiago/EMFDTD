#Implemetation Files
OUT = bin/fdtd
SRC = src/main.cu \
	src/Grid2D.cpp \
	src/TH.cu \
	src/THPlot.cu \
	src/Sources2D.cu 
INC = include/
HEADERS = include/2D.h \
		include/TH.h \
		include/plot2D.h \
		include/matplotlibcpp.h

#Math Plot Libs configs. See https://matplotlib-cpp.readthedocs.io/en/latest/compiling.html#compiling for more.
python_headers = /usr/include/python3.10/
numpy_headers = /usr/include/python3.10/numpy/
MPLib = -I $(python_headers) -I $(numpy_headers) -lpython3.10 -lpthread

CC = nvcc
CC_Flags = --compiler-bindir "/usr/bin/g++-10" --gpu-architecture compute_50

all:compile
compile:$(INC) $(SRC)
	$(CC) $(CC_Flags) -o $(OUT) $(SRC) -I $(INC) $(MPLib)