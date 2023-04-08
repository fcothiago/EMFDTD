#ifndef UTILS_H
#define UTILS_H

#include <cmath>

#define const_pi 3.14159265359
#define eps_0 8.854e-12
#define mu_0 (4*const_pi*1e-7)
#define c_0 (1/sqrt(eps_0*mu_0))

#define REMAINDER(u,l) ( u >= 0 ? u % l : l - ((-u) % l ) ) 

#define XY_TO_INDEX(x,y,nx,ny) ( REMAINDER(x,nx) + REMAINDER(y,ny)*nx )
#define INDEX_TO_X(index,nx) ( REMAINDER(index,nx) )
#define INDEX_TO_Y(index,nx) ( index/nx )


#endif
