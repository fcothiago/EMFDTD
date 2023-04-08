#include <TH.h>
#include <constants.h>

THGrid::THGrid(unsigned int nx, unsigned int ny, double dt, double ds):Grid2D(nx,ny,dt,ds)
{
    this->cells[0] = new THCell[nx*ny];
    this->cells[1] = new THCell[nx*ny];
}

THGrid::~THGrid()
{
    delete this->cells[0];
    delete this->cells[1];
}

THCell::THCell()
{
    this->Ex = 0;
    this->Ey = 0;
    this->Hz = 0;
    this->Epsx = eps_0;
    this->Epsy = eps_0;
    this->Muz = mu_0;
    this->Rhoxe = 0;
    this->Rhoye = 0;
    this->Rhozm = 0;
}
 
void THCell::updateE(Space2D & grid,THCell * cells, double & t,int & x,int & y)
{   
    const unsigned int lx = grid.xy(x-1,y);
    const unsigned int ly = grid.xy(x,y-1);
    const unsigned int xy = grid.xy(x,y);

    const long double Coef_eex = (2*this->Epsx-grid.dt*this->Rhoxe)
                    /(2*this->Epsx+grid.dt*this->Rhoxe);
    const long double Coef_ehx = (2*grid.dt)
                    /((2*this->Epsx+grid.dt*this->Rhoxe)*grid.ds);
    const long double Coef_eix = (-2*grid.dt)
                    /(2*this->Epsx+grid.dt*this->Rhoxe);

    const long double Coef_eey = (2*this->Epsy-grid.dt*this->Rhoye)
                    /(2*this->Epsy+grid.dt*this->Rhoye);
    const long double Coef_ehy = (- 2*grid.dt)
                    /((2*this->Epsy+grid.dt*this->Rhoye)*grid.ds);
    const long double Coef_eiy = (-2*grid.dt)
                    /(2*this->Epsy+grid.dt*this->Rhoye);

    this->Ex = Coef_eex*cells[xy].Ex
            + Coef_ehx*(cells[xy].Hz - cells[ly].Hz)
            + Coef_eix*(cells[xy].Jx);


    this->Ey = Coef_eey*cells[xy].Ey 
            + Coef_ehy*(cells[xy].Hz - cells[lx].Hz) 
            + Coef_eiy*(cells[xy].Jy);
}

void THCell::updateH(Space2D & grid,THCell * cells, double & t,int & x,int & y)
{
    const long unsigned int ux = grid.xy(x+1,y);
    const long unsigned int uy = grid.xy(x,y+1);
    const long unsigned int xy = grid.xy(x,y);

    const long double Coef_hhz = (2*this->Muz-grid.dt*this->Rhozm)
                            /(2*this->Muz+grid.dt*this->Rhozm);
    const long double Coef_hex = (2*grid.dt)
                            /((2*this->Muz+grid.dt*this->Rhozm)*grid.ds);
    const long double Coef_hzm = -(2*grid.dt)
                            /(2*this->Muz+grid.dt*this->Rhozm);
    
    this->Hz = Coef_hhz*cells[xy].Hz + Coef_hex*(cells[uy].Ex-cells[xy].Ex) - Coef_hex*(cells[ux].Ey - cells[xy].Ey) + Coef_hzm*cells[xy].Mz;

}

void THGrid::update()
{
    for(int y = 0; y < this->grid.ny ; y++)
    {
        for(int x = 0; x < this->grid.nx ; x++)
        {
            int xy = this->grid.xy(x,y);
            if(!this->current)
            {
               this->cells[1-this->current][xy].updateE(this->grid,this->cells[this->current],this->time,x,y);
            }
            else
            {
               this->cells[1-this->current][xy].updateH(this->grid,this->cells[this->current],this->time,x,y);
            }
        }
    }
    time += 0.5*this->grid.dt;
    this->current = 1 - this->current;
}
