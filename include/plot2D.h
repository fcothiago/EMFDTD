#ifndef PLOT_2D_H
#define PLOT_2D_H
#include <TH.h>
#include <string>
class THPlot
{
    public:
        THPlot(THGrid * grid);
        float * cells;
        THGrid * grid;
        void plotHz(std::string filename);
};
#endif