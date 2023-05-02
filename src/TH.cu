#include <TH.h>
#include <utils.h>
#include <iostream>

THGrid::THGrid(unsigned int nx, unsigned int ny, double ds):Grid2D(nx,ny,ds)
{
    THCell * array = new THCell[nx*ny];

    cudaError_t err1 = cudaMalloc((void **)&this->cells[0],sizeof(THCell)*nx*ny);
    cudaError_t err2 = cudaMalloc((void **)&this->cells[1],sizeof(THCell)*nx*ny);

    if(err1 != cudaSuccess)
        std::cout << cudaGetErrorString(err1) << std::endl;
    if(err2 != cudaSuccess)
        std::cout << cudaGetErrorString(err2) << std::endl;

    err1 = cudaMemcpy(this->cells[0],array,sizeof(THCell)*nx*ny,cudaMemcpyHostToDevice);
    err2 = cudaMemcpy(this->cells[1],array,sizeof(THCell)*nx*ny,cudaMemcpyHostToDevice);

    if(err1 != cudaSuccess)
        std::cout << cudaGetErrorString(err1) << std::endl;
    if(err2 != cudaSuccess)
        std::cout << cudaGetErrorString(err2) << std::endl;

    delete array;
}

THGrid::~THGrid()
{
    cudaFree((void **)&this->cells[0]);
    cudaFree((void **)&this->cells[1]);
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
 
__device__ void updateE(THGrid * grid,int & x,int & y)
{   
    const unsigned int lx = XY_TO_INDEX(x-1,y,grid->space.nx,grid->space.ny);
    const unsigned int ly = XY_TO_INDEX(x,y-1,grid->space.nx,grid->space.ny);
    const unsigned int xy = XY_TO_INDEX(x,y,grid->space.nx,grid->space.ny);

    THCell * next = & grid->cells[1-grid->current][xy] ;
    THCell * old = grid->cells[grid->current] ;

    /*const double Coef_eex = (2*next->Epsx-grid->space.dt*next->Rhoxe)
                    /(2*next->Epsx+grid->space.dt*next->Rhoxe);
    const double Coef_ehx = (2*grid->space.dt)
                    /((2*next->Epsx+grid->space.dt*next->Rhoxe)*grid->space.ds);
    const double Coef_eix = (-2*grid->space.dt)
                    /(2*next->Epsx+grid->space.dt*next->Rhoxe);

    const double Coef_eey = (2*next->Epsy-grid->space.dt*next->Rhoye)
                    /(2*next->Epsy+grid->space.dt*next->Rhoye);
    const double Coef_ehy = (- 2*grid->space.dt)
                    /((2*next->Epsy+grid->space.dt*next->Rhoye)*grid->space.ds);
    const double Coef_eiy = (-2*grid->space.dt)
                    /(2*next->Epsy+grid->space.dt*next->Rhoye);*/

    const double Coef_eex = 1;
    const double Coef_ehx = (grid->space.dt)/((next->Epsx)*grid->space.ds);
    const double Coef_eix = (-grid->space.dt)/(next->Epsx);

    const double Coef_eey = 1;
    const double Coef_ehy = (-grid->space.dt)/((next->Epsy)*grid->space.ds);
    const double Coef_eiy = (-grid->space.dt)/(next->Epsy);


    next->Ex = Coef_eex*old[xy].Ex
            + (mu_0/eps_0)*Coef_ehx*(old[xy].Hz - old[ly].Hz)
            + (mu_0/eps_0)*Coef_eix*(old[xy].Jx);

    next->Ey = Coef_eey*old[xy].Ey 
            + (mu_0/eps_0)*Coef_ehy*(old[xy].Hz - old[lx].Hz) 
            + (mu_0/eps_0)*Coef_eiy*(old[xy].Jy);
}

__device__ void updateH(THGrid * grid,int & x,int & y)
{
    const long unsigned int ux = XY_TO_INDEX(x+1,y,grid->space.nx,grid->space.ny);
    const long unsigned int uy = XY_TO_INDEX(x,y+1,grid->space.nx,grid->space.ny);
    const long unsigned int xy = XY_TO_INDEX(x,y,grid->space.nx,grid->space.ny);

    THCell * next = & grid->cells[1-grid->current][xy] ;
    THCell * old = grid->cells[grid->current] ;

    /*const double Coef_hhz = (2*next->Muz- grid->space.dt*next->Rhozm)
                            /(2*next->Muz+ grid->space.dt*next->Rhozm);

    const double Coef_hex = (2*grid->space.dt)
                            /((2*next->Muz+ grid->space.dt*next->Rhozm)*grid->space.ds);

    const double Coef_hzm = -(2*grid->space.dt)
                            /(2*next->Muz+ grid->space.dt*next->Rhozm);*/

    const double Coef_hhz = 1;

    const double Coef_hex = (grid->space.dt)/((next->Muz)*grid->space.ds);

    const double Coef_hzm = -(grid->space.dt)/(next->Muz);

    next->Hz = Coef_hhz*old[xy].Hz
               + (eps_0/mu_0)*Coef_hex*(old[uy].Ex-old[xy].Ex) 
               - (eps_0/mu_0)*Coef_hex*(old[ux].Ey-old[xy].Ey) 
               + (eps_0/mu_0)*Coef_hzm*old[xy].Mz;
}

__global__  void update(THGrid * grid)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    int x = INDEX_TO_X(i,grid->space.nx);
    int y = INDEX_TO_Y(i,grid->space.nx);

    if(!grid->current)
    {
        updateE(grid,x,y);
    }
    else
    {
        updateH(grid,x,y);
    }  
}
