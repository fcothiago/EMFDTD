#include <2D.h>
#include <utils.h>
#include <iostream>

Grid2D::Grid2D(unsigned int nx, unsigned int ny, double ds)
{
    this->space.nx = nx;
    this->space.ny = ny;
    this->space.dt = ds/(2*c_0);
    this->space.ds = ds;
    this->current = 0;
    this->time = 0.0;
}

Stability2D checkWaveStability(Grid2D * grid,double frequency)
{
    if(grid->space.ds <= 0.5*c_0/frequency)
        return Stable;
    else
    {
        std::cout << "Warning: Wave length to small. Current Wl = " << c_0/frequency << "m Min Value " <<  2*grid->space.ds   << "m ("<< 2*c_0/grid->space.ds <<" hz)" << std::endl;
        return WaveLengthToSmall;
    }
}