#include <TH.h>
#include <utils.h>
#include <math.h>

THSinHz::THSinHz(THGrid * grid,int x,int y,double amplitude,double frequency,double phase)
{
    this->amplitude = amplitude;
    this->frequency = frequency;
    this->phase = phase;
    this->x = x;
    this->y = y;
}


__global__  void update(THGrid * grid,THSinHz * sinHz)
{
    THCell * cells = grid->cells[grid->current];
    int xy = XY_TO_INDEX(sinHz->x,sinHz->y,grid->space.nx,grid->space.ny);
    cells[xy].Hz = sinHz->amplitude*sin(grid->time*sinHz->frequency+ sinHz->phase)/mu_0;
}
