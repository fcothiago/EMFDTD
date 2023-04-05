#include <iostream>
#include <TH.h>
#include <matplotlibcpp.h>

//namespace plot = matplotlibcpp;

int main(int argc,char * argv[])
{
    //std::vector<double> y = {1, 3, 2, 4};
    //plot::plot(y);
    //plot::show();
    //std::cout << "Hello Eletromagnetic World" << std::endl;

    THGrid * grid = new THGrid(20,20,1,0.1);
    int x = 10;
    int y = 10;
    int xy = grid->grid.xy(x,y);
    THSinHz * wave = new THSinHz(grid,x,y,10,10,10);
    for(int i = 0 ; i <= 10 ; i++)
    {
        grid->update();
        wave->updateH();
        std::cout << std::endl;
    }

    return 0;
}