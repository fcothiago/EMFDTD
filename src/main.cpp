#include <iostream>
#include <TH.h>
#include <plot2D.h>
#include <string>

int main(int argc,char * argv[])
{
    //std::vector<double> y = {1, 3, 2, 4};
    //plot::plot(y);
    //plot::show();
    std::cout << sizeof(double) << std::endl;

    THGrid * grid = new THGrid(100,100,1E-7,10);
    int x = 50;
    int y = 50;
    int xy = grid->grid.xy(x,y);
    THSinHz * wave = new THSinHz(grid,x,y,100.0,4.0E6,0);
    THPlot plot = THPlot(grid);
    for(int i = 0 ; i <= 10000 ; i++)
    {
        grid->update();
        wave->updateH();
    }
    plot.plotHz("out/1.png");
    return 0;
}