#ifndef PLOT_2D_H
#define PLOT_2D_H
#include <TH.h>
#include <vector>
#include <string>

class THPlot
{
    public:
        THPlot(int n,THGrid * grid);
        ~THPlot();
        void plotHz(std::string path);
        THCell ** prints;
        int capture_counter,capture_limit,nx,ny;
};

void capture(THGrid * grid, THPlot * plot);

#endif