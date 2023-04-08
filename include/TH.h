#ifndef FDTD_TH_H
#define FDTD_TH_H

#include <2D.h>
#include <cmath>

class THCell
{
    public:
        THCell();
        long double Ex,Ey,Hz,Jx,Jy,Mz;
        long double Epsx, Epsy,Rhoxe,Rhoye;
        long double Muz, Rhozm;
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
        THSinHz(THGrid * grid,int x,int y,long double amplitude,long double frequency,long double phase);
        void updateH();
    private:
        long double amplitude,frequency,phase;
        int x,y;
        THGrid * grid;
};

#endif