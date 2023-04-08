#include <2D.h>
#include <constants.h>
#include <iostream>

Grid2D::Grid2D(unsigned int nx, unsigned int ny, double dt, double ds)
{
    this->grid.nx = nx;
    this->grid.ny = ny;
    this->grid.dt = dt;
    this->grid.ds = ds;
    this->current = 0;
    this->time = 0.0;
}

Stability2D checkGridStability(Grid2D * grid)
{
    double dt = grid->grid.dt;
    double ds = grid->grid.ds;
    double testvalue = (ds)/(2*c_0);

    if(dt <= testvalue)
    {
        return Stable;
    }
    else
    {   std::cout << "Warining: Time Step to High. Current dt = " << dt << "s Min Value " <<  testvalue << "s" << std::endl;
        return TimeStepToHigh;
    }
}

Stability2D checkWaveStability(Grid2D * grid,long double frequency)
{
    if(grid->grid.ds <= 0.5*c_0/frequency)
        return Stable;
    else
    {
        std::cout << "Warining: Wave length to small. Current Wl = " << c_0/frequency << "m Min Value " <<  2*grid->grid.ds   << "m ("<< 2*c_0/grid->grid.ds <<" hz)" << std::endl;
        return WaveLengthToSmall;
    }
}