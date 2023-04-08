#ifndef FDTD_2D_H
#define FDTD_2D_H

typedef struct
{
    long double dt,ds;
    unsigned int nx,ny;
}Space2D;

class Grid2D
{
    public:
        Grid2D(unsigned int nx, unsigned int ny, double dt, double ds);
        Space2D space;
        unsigned short int current;
        double time;
};

enum Stability2D
{
    Stable,
    TimeStepToHigh,
    WaveLengthToSmall
};

Stability2D checkGridStability(Grid2D * grid);

Stability2D checkWaveStability(Grid2D * grid,long double frequency);

#endif
