#ifndef PLOT_2D_H
#define PLOT_2D_H
#include <TH.h>
#include <vector>
#include <string>
class THPlot
{
    public:
        THPlot(THGrid * grid);
        ~THPlot();
        void capture();
        void plotHz(std::string path);
    private:
        std::vector<THCell *> cells;
        THGrid * grid;
};
#endif