#include <2D.h>
Grid2D::Grid2D(unsigned int nx, unsigned int ny, double dt, double ds)
{
    this->grid.nx = nx;
    this->grid.ny = ny;
    this->grid.dt = dt;
    this->grid.ds = ds;
    this->current = 0;
    this->time = 0.0;
}