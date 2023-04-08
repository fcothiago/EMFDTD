#include <plot2D.h>
#include <matplotlibcpp.h>

namespace plt = matplotlibcpp;

THPlot::THPlot(THGrid * grid)
{
    this->grid = grid;
    this->cells = new float[grid->space.nx * grid->space.ny];
}

void THPlot::plotHz(std::string filename)
{ 
    THCell * current = this->grid->cells[this->grid->current];
    int nx = (this->grid->space.nx);
    int ny = (this->grid->space.ny);
    for(int i = 0; i < nx*ny; i++)
    {
        this->cells[i] = (float) current[i].Ex;
    }
    plt::imshow(this->cells,ny,nx,1);
    plt::save(filename);
}