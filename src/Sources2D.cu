#include <TH.h>
#include <utils.h>
#include <math.h>

THSinHz::THSinHz(THGrid * grid,int x,int y,double amplitude,double frequency,double phase)
{
    this->amplitude = amplitude;
    this->frequency = frequency;
    this->phase = phase;
    this->grid = grid;
    this->x = x;
    this->y = y;
    checkWaveStability(grid,frequency);
}

__global__ void cuda_update(THGrid * grid,int xy,double amplitude,double frequency, double phase)
{
    THCell * cells = grid->cells[grid->current];
    cells[xy].Hz = amplitude*sin(grid->time*frequency+phase);
}

void update(THSinHz * sinHz)
{
    THGrid * grid;

    int xy = XY_TO_INDEX(sinHz->x,sinHz->y,sinHz->grid->space.nx,sinHz->grid->space.ny);

    cudaMalloc((void **)&grid,sizeof(THGrid));
    cudaMemcpy(grid,sinHz->grid,sizeof(THGrid),cudaMemcpyHostToDevice);

    cuda_update<<<1,1>>>(grid,xy,sinHz->amplitude,sinHz->frequency,sinHz->phase);
    cudaFree(grid);
}
