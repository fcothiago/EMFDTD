#ifndef FDTD_TH_H
#define FDTD_TH_H

#include <2D.h>
#include <cmath>

class THCell
{
    public:
        THCell();
        double Ex,Ey,Hz,Jx,Jy,Mz;
        double Epsx, Epsy,Rhoxe,Rhoye;
        double Muz, Rhozm;
};

class THGrid : public Grid2D
{
    public:
        THGrid(unsigned int nx, unsigned int ny, double dt, double ds);
        ~THGrid();
        THCell * cells[2];
};

class THSinHz
{
    public:
        THSinHz(THGrid * grid,int x,int y,double amplitude,double frequency,double phase);
        void updateH();
        double amplitude,frequency,phase;
        int x,y;
        THGrid * grid;
};

void update(THGrid * grid);
void update(THSinHz * sinHz);

#endif