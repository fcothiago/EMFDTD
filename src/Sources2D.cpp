#include <TH.h>

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
    int xy = this->grid->grid.xy(this->x,this->y);
    THCell * cells = this->grid->cells[this->grid->current];
    cells[xy].Hz = this->amplitude*sinf128(this->grid->time*this->frequency+this->phase);
}
