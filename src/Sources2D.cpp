#include <TH.h>
#include <utils.h>

THSinHz::THSinHz(THGrid * grid,int x,int y,long double amplitude,long double frequency,long double phase)
{
    this->amplitude = amplitude;
    this->frequency = frequency;
    this->phase = phase;
    this->grid = grid;
    this->x = x;
    this->y = y;
    checkWaveStability(grid,frequency);
}

void THSinHz::updateH()
{

    int xy = XY_TO_INDEX(this->x,this->y,this->grid->space.nx,this->grid->space.ny);
    THCell * cells = this->grid->cells[this->grid->current];
    cells[xy].Hz = this->amplitude*sinf128(this->grid->time*this->frequency+this->phase);
}
