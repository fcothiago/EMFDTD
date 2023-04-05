#ifndef FDTD_TH_H
#define FDTD_TH_H

#include <2D.h>
#include <cmath>
#include <iostream>

class THCell
{
    public:
        THCell();
        double Ex,Ey,Hz,Jx,Jy,Mz;
        double Epsx, Epsy,Rhoxe,Rhoye;
        double Muz, Rhozm;
        void updateE(Space2D & grid,THCell * cells, double & t,int & x,int & y);
        void updateH(Space2D & grid,THCell * cells, double & t,int & x,int & y);
};

class THGrid : public Grid2D
{
    public:
        THGrid(unsigned int nx, unsigned int ny, double dt, double ds);
        ~THGrid();
        THCell * cells[2];
        void update();
};

class THSinHz
{
    public:
        THSinHz(THGrid * grid,int x,int y,double amplitude,double frequency,double phase);
        void updateH();
    private:
        double amplitude,frequency,phase;
        int x,y;
        THGrid * grid;
};

void THPlotHZ(THGrid * grid);
#endif