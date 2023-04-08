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
    int xy = XY_TO_INDEX(x,y,100,100);
    THSinHz * wave = new THSinHz(grid,x,y,100.0,4.0E6,0);
    THPlot plot = THPlot(grid);
    for(int i = 0 ; i <= 1000 ; i++)
    {
        wave->updateH();
        update(*grid);
        plot.plotHz("out/"+std::to_string(i)+".png");

    }
    //plot.plotHz("out/out.png");
    return 0;
}