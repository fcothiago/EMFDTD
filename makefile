#Implemetation Files
OUT = bin/fdtd
SRC = src/main.cpp \
	src/Grid2D.cpp \
	src/TH.cpp \
	src/Sources2D.cpp 
INC = include/
HEADERS = include/2D.h \
		include/TH.h \
		include/matplotlibcpp.h

#Math Plot Libs configs. See https://matplotlib-cpp.readthedocs.io/en/latest/compiling.html#compiling for more.
python_headers = /usr/include/python3.10/
numpy_headers = /usr/include/python3.10/numpy/
MPLib = -I $(python_headers) -I $(numpy_headers) -lpython3.10 -lpthread

CC = g++
CC_Flags = -std=c++11

all:compile
compile:$(INC) $(SRC)
	$(CC) $(CC_Flags) -o $(OUT) $(SRC) -I $(INC) $(MPLib)