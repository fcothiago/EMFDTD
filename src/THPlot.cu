#include <plot2D.h>
#include <utils.h>
#include <matplotlibcpp.h>

#include <iostream>

#include <stdio.h>

namespace plt = matplotlibcpp;

THPlot::THPlot(int n, THGrid * grid)
{
    this->capture_counter = 0;
    this->capture_limit = n;

    this->nx = grid->space.nx;
    this->ny = grid->space.ny;

    this->prints = new THCell * [n];

    for(int i = 0; i < n; i++)
        this->prints[i] = new THCell[this->nx*this->ny];
}

THPlot::~THPlot()
{
    for(int i = 0; i < this->capture_limit; i++)
        delete this->prints[i];
    delete this->prints;
}

void capture(THGrid * grid, THPlot * plot)
{

    if(plot->capture_counter >= plot->capture_limit)
        return;

    THGrid * copy = (THGrid *) malloc(sizeof(THGrid));
    cudaMemcpy(copy,grid,sizeof(THGrid),cudaMemcpyDeviceToHost);
    cudaError_t error = cudaMemcpy(plot->prints[plot->capture_counter],copy->cells[copy->current],sizeof(THCell)*plot->nx*plot->ny,cudaMemcpyDeviceToHost);
    plot->capture_counter++;

    free(copy);
}

void THPlot::plotHz(std::string path)
{ 
    float * data = new float [this->nx*this->ny];
    for(int i = 0; i < this->capture_limit; i++)
    {
        for(int j = 0; j < this->nx*this->ny; j++)
            data[j] = this->prints[i][j].Hz;

        plt::imshow(data,this->ny,this->nx,1);
        plt::save(path+"/Hz"+std::to_string(i)+".png");

    }

    delete data;
}