#include <TH.h>
#include <utils.h>
#include <iostream>

#define THREADS_PER_BLOCK 100

THGrid::THGrid(unsigned int nx, unsigned int ny, double dt, double ds):Grid2D(nx,ny,dt,ds)
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

    const double Coef_eex = (2*next->Epsx-grid->space.dt*next->Rhoxe)
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
                    /(2*next->Epsy+grid->space.dt*next->Rhoye);

    next->Ex = Coef_eex*old[xy].Ex
            + Coef_ehx*(old[xy].Hz - old[ly].Hz)
            + Coef_eix*(old[xy].Jx);


    next->Ey = Coef_eey*old[xy].Ey 
            + Coef_ehy*(old[xy].Hz - old[lx].Hz) 
            + Coef_eiy*(old[xy].Jy);
}

__device__ void updateH(THGrid * grid,int & x,int & y)
{
    const long unsigned int ux = XY_TO_INDEX(x+1,y,grid->space.nx,grid->space.ny);
    const long unsigned int uy = XY_TO_INDEX(x,y+1,grid->space.nx,grid->space.ny);
    const long unsigned int xy = XY_TO_INDEX(x,y,grid->space.nx,grid->space.ny);

    THCell * next = & grid->cells[1-grid->current][xy] ;
    THCell * old = grid->cells[grid->current] ;

    const double Coef_hhz = (2*next->Muz- grid->space.dt*next->Rhozm)
                            /(2*next->Muz+ grid->space.dt*next->Rhozm);

    const double Coef_hex = (2*grid->space.dt)
                            /((2*next->Muz+ grid->space.dt*next->Rhozm)*grid->space.ds);

    const double Coef_hzm = -(2*grid->space.dt)
                            /(2*next->Muz+ grid->space.dt*next->Rhozm);

    next->Hz = Coef_hhz*old[xy].Hz
               + Coef_hex*(old[uy].Ex-old[xy].Ex) 
               - Coef_hex*(old[ux].Ey-old[xy].Ey) 
               + Coef_hzm*old[xy].Mz;
}

__global__ void cuda_update(THGrid * grid)
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

void update(THGrid * grid)
{
    int size = grid->space.nx* grid->space.ny;
    THGrid * cuda_grid;
    
    cudaMalloc((void **)&cuda_grid,sizeof(THGrid));
    cudaMemcpy(cuda_grid,grid,sizeof(THGrid),cudaMemcpyHostToDevice);
    cuda_update<<<size/THREADS_PER_BLOCK,THREADS_PER_BLOCK>>>(cuda_grid);
    
    grid->time += 0.5*grid->space.dt;
    grid->current = 1 - grid->current;
    cudaFree(cuda_grid);

    cudaError_t error = cudaGetLastError();
    if(error != cudaSuccess)
    {
        std::cout <<  cudaGetErrorString(error) << std::endl;
    }
}
