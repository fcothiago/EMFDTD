#include <TH.h>

THSinHz::THSinHz(THGrid * grid,int x,int y,double amplitude,double frequency,double phase)
{
    this->amplitude = amplitude;
    this->frequency = frequency;
    this->phase = phase;
    this->grid = grid;
    this->x = x;
    this->y = y;
}

void THSinHz::updateH()
{
    int xy = this->grid->grid.xy(this->x,this->y);
    THCell * cells = this->grid->cells[this->grid->current];
    cells[xy].Hz = this->amplitude*sin(this->grid->time*this->frequency+this->phase);
}
