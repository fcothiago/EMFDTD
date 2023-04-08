#include <plot2D.h>
#include <matplotlibcpp.h>

namespace plt = matplotlibcpp;

THPlot::THPlot(THGrid * grid)
{
    this->grid = grid;
    this->cells = new float[grid->grid.nx * grid->grid.ny];
}

void THPlot::plotHz(std::string filename)
{ 
    THCell * current = this->grid->cells[this->grid->current];
    int nx = (this->grid->grid.nx);
    int ny = (this->grid->grid.ny);
    for(int i = 0; i < nx*ny; i++)
    {
        this->cells[i] = (float) current[i].Hz;
    }
    plt::imshow(this->cells,ny,nx,1);
    plt::save(filename);
}