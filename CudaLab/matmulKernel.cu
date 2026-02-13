#include "cudaErrorHandling.h"
#include "example.h"

#define BLOCK_DIM_X 32
#define BLOCK_DIM_Y 32

#define get_elem(array, Row, Column)      ( ((float*)((char*)array.ptr + (Row) * array.pitch))[(Column)]  )

__global__ void matmul_prnt( cudaPitchedPtr a )
{	int idx = threadIdx.x + blockIdx.x * blockDim.x;
	int idy = threadIdx.y + blockIdx.y * blockDim.y;

       if(idx < 1 && idy < 1 )
       {
	    for( int i = 0; i< a.xsize; i++ ){
		for( int j = 0; j< a.ysize; j++ )
		   printf( " %5.1f", get_elem( a, j, i ) );
		printf( "\n" );
            }
       } 
}


__global__ void matmul_kernel_00(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr c)
{
	int idx = threadIdx.x + blockIdx.x * blockDim.x , j = idx;
	int idy = threadIdx.y + blockIdx.y * blockDim.y , i = idy;
//	int idx = /* индекс столбца */ , j = idx;
//	int idy =  /* индекс строки */ , i = idy;

       if(idx < b.xsize && idy < a.ysize)
       {
            float sum = 0;
            for( int k=0; k<b.ysize; k++){

        	sum += get_elem( b, k, j ) * get_elem( a, i, k ); 


/****************************
		printf( "i=%d j=%d   %5.1f  * %5.1f\n", i, j,
			get_elem( b, k, j ),  get_elem( a, i, k ) );

        	sum += get_elem( b, j, k ) * get_elem( a, k, i ); 




//            get_elem( c, j, i ) = sum;
	    printf( "i=%d j=%d =  %5.1f\n", i, j, sum );
****************************/
            }
            /* Посчитать скалярное произведение строки на столбец*/
            /* Записать результат скалярного произведения в соответствующий элемент матрицы C */   
            get_elem( c, i, j ) = sum;
       } 
}

__global__ void matmul_kernel_10(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr c)
{
	int idx = threadIdx.x + blockIdx.x * blockDim.x , j = idx;
	int idy = threadIdx.y + blockIdx.y * blockDim.y , i = idy;

       if(idx < b.xsize && idy < a.xsize)
       {
            float sum = 0;
            for( int k=0; k<b.ysize; k++){

        	sum += get_elem( b, k, j ) * get_elem( a, k, i );

/********************************

		printf( "i=%d j=%d   %5.1f  * %5.1f\n", i, j,
			get_elem( b, k, j ),  get_elem( a, k, i ) );

	    printf( "i=%d j=%d =  %5.1f\n", i, j, sum );

********************************/
            }
            get_elem( c, i, j ) = sum;
       } 
}

__global__ void matmul_kernel_01(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr c)
{
	int idx = threadIdx.x + blockIdx.x * blockDim.x , j = idx;
	int idy = threadIdx.y + blockIdx.y * blockDim.y , i = idy;

       if(idx < b.ysize && idy < a.ysize)
       {
            float sum = 0;
            for( int k=0; k<b.xsize; k++){

		sum += get_elem( b, j, k ) * get_elem( a, i, k );

/********************************
		printf( "i=%d j=%d   %5.1f  * %5.1f\n", i, j,
			get_elem( b, j, k ),  get_elem( a, i, k ) );

	    printf( "i=%d j=%d =  %5.1f\n", i, j, sum );

********************************/


            }
            get_elem( c, i, j ) = sum;
       } 
}

__global__ void matmul_kernel_11(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr c)
{
	int idx = threadIdx.x + blockIdx.x * blockDim.x , j = idx;
	int idy = threadIdx.y + blockIdx.y * blockDim.y , i = idy;

       if(idx < b.ysize && idy < a.xsize)
       {
            float sum = 0;
            for( int k=0; k<b.xsize; k++){

		sum += get_elem( b, j, k ) * get_elem( a, k, i ); 


/********************************
		printf( "i=%d j=%d   %5.1f  * %5.1f\n", i, j,
			get_elem( b, j, k ),  get_elem( a, k, i ) );

	    printf( "i=%d j=%d =  %5.1f\n", i, j, sum );

00      	sum += get_elem( b, k, j ) * get_elem( a, i, k ); 
10      	sum += get_elem( b, k, j ) * get_elem( a, k, i );
01     		sum += get_elem( b, j, k ) * get_elem( a, i, k );
11        	sum += get_elem( b, j, k ) * get_elem( a, k, i ); 
********************************/

            }
            get_elem( c, i, j ) = sum;
       } 
}

void launchMatmulKernel_00(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr c)
{
   dim3 threads = dim3 ( BLOCK_DIM_X, BLOCK_DIM_Y);
//   dim3 blocks = dim3 ( /* число блоков по x*/, /* число блоков по y */);
   dim3 blocks = dim3 ( c.xsize/BLOCK_DIM_X+ ((c.xsize % BLOCK_DIM_X)?1:0 ), 
			c.ysize/BLOCK_DIM_Y+ ((c.ysize % BLOCK_DIM_Y)?1:0) );

/********************************
   printf( "A\n" );
   SAFE_KERNEL_CALL(( matmul_prnt <<<1, 1>>>( a ) ));
   printf( "\n\n\n" );

   printf( "B\n" );
   SAFE_KERNEL_CALL(( matmul_prnt <<<1, 1>>>( b ) ));
   printf( "\n\n\n" );
********************************/

   SAFE_KERNEL_CALL(( matmul_kernel_00<<<blocks, threads>>>(a,b,c) ));

}

void launchMatmulKernel_10(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr c)
{
   dim3 threads = dim3 ( BLOCK_DIM_X, BLOCK_DIM_Y);

//   dim3 blocks = dim3 ( /* число блоков по x*/, /* число блоков по y */);
   dim3 blocks = dim3 ( c.xsize/BLOCK_DIM_X+ ((c.xsize % BLOCK_DIM_X)?1:0 ), 
			c.ysize/BLOCK_DIM_Y+ ((c.ysize % BLOCK_DIM_Y)?1:0) );

/********************************
    printf( "a.pitch=%d  b.pitch=%d\n", (int)a.pitch, (int)b.pitch );
    printf( "A\n" );
    SAFE_KERNEL_CALL(( matmul_prnt <<<1, 1>>>( a ) ));
    printf( "\n\n\n" );

    printf( "B\n" );
    SAFE_KERNEL_CALL(( matmul_prnt <<<1, 1>>>( b ) ));
    printf( "\n\n\n" );
********************************/

    SAFE_KERNEL_CALL(( matmul_kernel_10<<<blocks, threads>>>(a,b,c) ));

}

void launchMatmulKernel_01(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr c)
{
   dim3 threads = dim3 ( BLOCK_DIM_X, BLOCK_DIM_Y);
//   dim3 blocks = dim3 ( /* число блоков по x*/, /* число блоков по y */);
   dim3 blocks = dim3 ( c.xsize/BLOCK_DIM_X+ ((c.xsize % BLOCK_DIM_X)?1:0 ), 
			c.ysize/BLOCK_DIM_Y+ ((c.ysize % BLOCK_DIM_Y)?1:0) );


/********************************
    printf( "a.pitch=%d  b.pitch=%d\n", (int)a.pitch, (int)b.pitch );

    printf( "A\n" );
    SAFE_KERNEL_CALL(( matmul_prnt <<<1, 1>>>( a ) ));
    printf( "\n\n\n" );

    printf( "B\n" );
    SAFE_KERNEL_CALL(( matmul_prnt <<<1, 1>>>( b ) ));
    printf( "\n\n\n" );
********************************/

    SAFE_KERNEL_CALL(( matmul_kernel_01<<<blocks, threads>>>(a,b,c) ));
 
}

void launchMatmulKernel_11(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr c)
{
   dim3 threads = dim3 ( BLOCK_DIM_X, BLOCK_DIM_Y);
//   dim3 blocks = dim3 ( /* число блоков по x*/, /* число блоков по y */);
   dim3 blocks = dim3 ( c.xsize/BLOCK_DIM_X+ ((c.xsize % BLOCK_DIM_X)?1:0 ), 
			c.ysize/BLOCK_DIM_Y+ ((c.ysize % BLOCK_DIM_Y)?1:0) );

/********************************
   printf( "a.pitch=%d  b.pitch=%d\n", (int)a.pitch, (int)b.pitch );

   printf( "A\n" );
   SAFE_KERNEL_CALL(( matmul_prnt <<<1, 1>>>( a ) ));
   printf( "\n\n\n" );

   printf( "B\n" );
   SAFE_KERNEL_CALL(( matmul_prnt <<<1, 1>>>( b ) ));
   printf( "\n\n\n" );
********************************/

   SAFE_KERNEL_CALL(( matmul_kernel_11<<<blocks, threads>>>(a,b,c) ));

}
