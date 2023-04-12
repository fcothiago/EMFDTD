#include <iostream>
#include <TH.h>
#include <plot2D.h>
#include <string>
#include <utils.h>

int main(int argc,char * argv[])
{
    THGrid * grid = new THGrid(100,100,1E-7,10);
    int x = 50;
    int y = 50;
    THSinHz * wave = new THSinHz(grid,x,y,10.0,4.0E2,0);
    THPlot plot = THPlot(grid);
    for(int i = 0 ; i < 100 ; i++)
    {   
        update(grid);
        update(wave);
        plot.capture();

    }
    std::cout << "Saving" << std::endl;
    plot.plotHz("out/");
    return 0;
}