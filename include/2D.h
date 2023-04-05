#ifndef FDTD_2D_H
#define FDTD_2D_H

typedef struct
{
    double dt,ds;
    unsigned int nx,ny;
    inline unsigned int xy(int x,int y)
    { 
        x = x >= 0 ? x % this->nx : nx - ((-x) % this->nx );
        y = y >= 0 ? y % this->ny : ny - ((-y) % this->ny );
        return x + y*this->nx;
    }
}Space2D;

class Grid2D
{
    public:
        Grid2D(unsigned int nx, unsigned int ny, double dt, double ds);
        Space2D grid;
        unsigned short int current;
        double time;
};
#endif
