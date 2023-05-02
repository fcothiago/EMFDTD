#include <iostream>
#include <TH.h>
#include <plot2D.h>
#include <string>
#include <utils.h>

#define THREADS_PER_BLOCK 100

__global__ void step(THGrid * grid)
{
    grid->time += 0.5*grid->space.dt;
    grid->current = 1 - grid->current;
}

int main(int argc,char * argv[])
{
    int x = 50;
    int y = 50;
    int nx = 100;
    int ny = 100;
    int size = nx*ny;
    
    THGrid * grid = new THGrid(nx,ny,1);

    THGrid * device_grid = NULL;
    THSinHz * device_wave = NULL;
    THPlot * device_plot = NULL;

    THPlot * plot = new THPlot(200,grid);
    THSinHz * wave = new THSinHz(device_grid,x,y,10.0,6.0E7,0);

    cudaMalloc((void **)&device_grid,sizeof(THGrid));
    cudaMalloc((void **)&device_wave,sizeof(THSinHz));
    cudaMalloc((void **)&device_plot,sizeof(THPlot));

    cudaMemcpy(device_grid,grid,sizeof(THGrid),cudaMemcpyHostToDevice);
    cudaMemcpy(device_wave,wave,sizeof(THSinHz),cudaMemcpyHostToDevice);
    cudaMemcpy(device_plot,plot,sizeof(THPlot),cudaMemcpyHostToDevice);

    for(int i = 0 ; i <= 1000 ;i++)
    {
        update<<<size/THREADS_PER_BLOCK,THREADS_PER_BLOCK>>>(device_grid);
        step<<<1,1>>>(device_grid);
        update<<<1,1>>>(device_grid,device_wave);
        if((i%5) == 0)
            capture(device_grid,plot);
    }

    plot->plotHz("out/");

    return 0;
}