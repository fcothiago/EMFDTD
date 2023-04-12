#include <plot2D.h>
#include <matplotlibcpp.h>

namespace plt = matplotlibcpp;

THPlot::THPlot(THGrid * grid)
{
    this->grid = grid;
    this->cells = std::vector<THCell *>();
}

THPlot::~THPlot()
{
    for(THCell * i : this->cells)
        delete i;
}

void THPlot::capture()
{
    int size = this->grid->space.nx*this->grid->space.ny;
    THCell * print = new THCell[size];
    THCell * current = this->grid->cells[this->grid->current];
    cudaError_t err = cudaMemcpy(print,current,size*sizeof(THCell),cudaMemcpyDeviceToHost);
    if(err != cudaSuccess)
        std::cout << cudaGetErrorString(err) << std::endl;
    this->cells.push_back(print);
}

void THPlot::plotHz(std::string path)
{ 
    int nx = this->grid->space.nx;
    int ny = this->grid->space.ny;
    float * data = new float[nx*ny];
    int t = 0;
    for(THCell * i : this->cells)
    {
        for(int j = 0; j < nx*ny ; j++)
            data[j] = i[j].Hz;
        plt::imshow(data,ny,nx,1);
        plt::save(path+"/Hz"+std::to_string(t++)+".png");
    }
    delete data;
}