#include <iostream>
#include <cuda_runtime.h>
#include <limits>
#include <stdint.h>
#include <time.h>
#include <math.h>
#include <omp.h>
#include <locale>

#include "cudaErrorHandling.h"
#include "example.h"


const float MY_INT32_MAX = std::numeric_limits<int32_t>::max();

void launchMatmulKernel(cudaPitchedPtr a, cudaPitchedPtr b, cudaPitchedPtr c);

float fTime();
void CPU_matmult( float *A, float *B, float *R, int n, int m, int p );

int CompareArrays( float *a, float *b, int length )
{
    int count = 0;
    for(int i =0; i < length; i++)
        if( fabs( a[i] - b[i] ) > fabs( 1e-3*a[i] ) ){
	    count++;
	    std::cout << "[" << i << "] " << a[i] << " != " << b[i] << "\n";
	    if( count > 20 )
		return( count );
	}
    return( count );
}

void prntArrayT( float * aM, int row, int col ){

    for( int j=0; j<col; j++ ){
	for( int i=0; i<row; i++ )
	    printf( "%8.2f ", aM[i*col + j ] );
	printf( "\n" );
    }
}

void TransposeArray( float *aFrom, float *aTo, int row, int col ){

    for( int j=0; j<col; j++ )
	for( int i=0; i<row; i++ )
	   *(aTo++) = aFrom[i*col + j ];
    
}

void initializeRandomArray1(float *array, int length)
{
    for(int i =0; i < length; i++)
        array[i] = rand() / MY_INT32_MAX;
}

void initializeRandomArray(float *array, int length, int mult )
{
    for(int i =0; i < length; i++)
        array[i] = (i+1)*mult;//rand() / MY_INT32_MAX;
}


int main(int argc, char ** argv)
{
	std::setlocale(LC_ALL, "ru-RU.UTF-8");
	if( argc < 4 ){
	    std::cout << "Необходимо три (+2 дополнительных) целых положительных параметра\n" ;
		return 100;
	}
        int n = atoi(argv[1]);
        if( n <= 0 ){
	    std::cout << "Введите #1 ( " << argv[1] << " ) >0  !\n" ;
	    n = 1000;
        }
        int m = atoi(argv[2]);
        if( m <= 0 ){
	    std::cout << "Введите #2 ( " << argv[2] << " ) >0  !\n" ;
	    n = 1000;
        }
        int p = atoi(argv[3]);
        if( p <= 0 ){
	    std::cout << "Введите #3 ( " << argv[3] << " ) >0  !\n" ;
	    n = 1000;
        }
        int patchstep = 16;

	if( argc < 5 ){
          int pat = atoi(argv[4]);
          if( pat <= 0 ){
	    std::cout << "Введите #4 ( " << argv[4] << " ) >0  !\n" ;
	  }
	  else{
	    patchstep = pat;
	  }
        }
	patchstep = 1;
        
	int caseKernel = 0;
	if( argc == 6 ){
          int cK = atoi(argv[5]);
          if( cK < 0 || cK > 3 ){
	    std::cout << "Введите #5 ( 0<= "" <=3  ) !\n" ;
	  }
	  else{
	    std::cout << "Matrix orientation № "  << argv[5] <<  "\n" ;
	    caseKernel = cK;
	  }
        }


	cudaEvent_t start, stop, start_total, stop_total;
	float elapsedTime, elapsedTime_total, cpuTime;
	double cpuTimeD;


        int deviceCount = -1;
        cudaGetDeviceCount( &deviceCount );
        if( deviceCount == 0 ){
    	    printf( "Нет устройств совместимых с CUDA.\n" );
    	    return 200; 
        }
//	cudaSetDevice(/*Ваш номер % deviceCount */);
	cudaSetDevice( deviceCount-1 );

        //Матрицы на хосте
        int n1 = ( n % patchstep );
        n1 = n + ((n1==0)?0:(patchstep-n1));
	n1 = n;

	int m1 = m;

        int p1 = ( p % patchstep );
        p1 = p + ((p1==0)?0:(patchstep-p1));
	p1 = p;

	cudaPitchedPtr matAHost  = make_cudaPitchedPtr(malloc(n*m*sizeof(float)), n1*sizeof(float), n, m); 
	cudaPitchedPtr matAHostT = make_cudaPitchedPtr(malloc(n*m*sizeof(float)), m1*sizeof(float), m, n); ;

	cudaPitchedPtr matBHost  = make_cudaPitchedPtr(malloc(p*n*sizeof(float)), p1*sizeof(float), p, n);
	cudaPitchedPtr matBHostT = make_cudaPitchedPtr(malloc(p*n*sizeof(float)), n1*sizeof(float), n, p);

	cudaPitchedPtr matResHost = make_cudaPitchedPtr(malloc(m*p*sizeof(float)), p1*sizeof(float), p, m);

	initializeRandomArray( (float*)matAHost.ptr, n*m, 1);
	initializeRandomArray( (float*)matBHost.ptr, p*n, 10);

	TransposeArray( (float*)matAHost.ptr, (float*)matAHostT.ptr, m, n ); 

	TransposeArray( (float*)matBHost.ptr, (float*)matBHostT.ptr, n, p ); 
//  void TransposeArray( float *aFrom, float *aTo, int row, int col ){


//	initializeRandomArray1( (float*)matAHost, n*m );
//	initializeRandomArray1( (float*)matBHost, p*n );


	SAFE_CALL(cudaEventCreate(&start));  
   	SAFE_CALL(cudaEventCreate(&stop));
	SAFE_CALL(cudaEventCreate(&start_total));  
   	SAFE_CALL(cudaEventCreate(&stop_total));


	SAFE_CALL(cudaEventRecord(start, 0));
        // Матрицы на устройстве
	cudaPitchedPtr matADevice =
	    ( caseKernel % 2 == 0 ) 
	    ?  make_cudaPitchedPtr(NULL, n1*sizeof(float), n, m)
	    :  make_cudaPitchedPtr(NULL, m1*sizeof(float), m, n); 

/**************************************
	if( caseKernel % 2 == 0 ){
	    std::cout << "A initial " << n1 <<"\n";
	}
	else{
	    std::cout << "A transpose" << m1 <<"\n";
	}
**************************************/
	
	cudaPitchedPtr matBDevice = 
	    ( caseKernel / 2 == 0 )
	    ?  make_cudaPitchedPtr(NULL, p1*sizeof(float), p, n)
	    :  matBDevice = make_cudaPitchedPtr(NULL, n1*sizeof(float), n, p);

/**************************************
	if( caseKernel / 2 == 0 ){
	    std::cout << "B initial\n";
	}
	else{
	    std::cout << "B transpose\n";
	}
**************************************/

	cudaPitchedPtr matResDevice = make_cudaPitchedPtr(NULL, p1*sizeof(float), p, m);
	
	printf( "matADevice=( xsize=%d   ysize=%d pitched=%d)\n", 
		    (int) matADevice.xsize,
		    (int) matADevice.ysize,
		    (int) matADevice.pitch );
	printf( "matBDevice=( xsize=%d   ysize=%d pitched=%d)\n", 
		    (int) matBDevice.xsize,
		    (int) matBDevice.ysize,
		    (int) matBDevice.pitch );
	printf( "matResDevice=( xsize=%d   ysize=%d pitched=%d)\n", 
		    (int) matResDevice.xsize,
		    (int) matResDevice.ysize,
		    (int) matResDevice.pitch );
	
	SAFE_CALL(cudaEventRecord(start_total, 0));
	
	cudaMalloc( (void**)&matADevice.ptr, sizeof(float)*n*m );

	cudaMalloc( (void**)&matBDevice.ptr, sizeof(float)*p*n );
//	cudaMalloc( /* выделение памяти для матрицы B */);

//	cudaMalloc( /* выделение памяти для результата */ );
	cudaMalloc( (void**)&matResDevice.ptr, sizeof(float)*p*m );



//	cudaMemcpy(/* скопировать на утройство матрицу A */);
	if( caseKernel % 2 == 0 ){
	  SAFE_CALL( cudaMemcpy( matADevice.ptr, matAHost.ptr,  sizeof(float)*n1*m, cudaMemcpyHostToDevice));
	} else {
	  SAFE_CALL( cudaMemcpy( matADevice.ptr, matAHostT.ptr, sizeof(float)*n*m1, cudaMemcpyHostToDevice));
	}

//	cudaMemcpy(/* скопировать на утройство матрицу B */);
	if( caseKernel / 2 == 0 ){
	  SAFE_CALL( cudaMemcpy( matBDevice.ptr, matBHost.ptr, sizeof(float)*p1*n, cudaMemcpyHostToDevice));
	} else {
	  SAFE_CALL( cudaMemcpy( matBDevice.ptr, matBHostT.ptr, sizeof(float)*p*n1, cudaMemcpyHostToDevice));
	}

	SAFE_CALL(cudaEventRecord(start, 0));
	
	if( caseKernel == 0 ){

	  launchMatmulKernel_00( matADevice, matBDevice, matResDevice);

	}


	if( caseKernel == 1 ){

	  launchMatmulKernel_10( matADevice, matBDevice, matResDevice);

	}

	if( caseKernel == 2 ){

	  launchMatmulKernel_01( matADevice, matBDevice, matResDevice);

	}


	if( caseKernel == 3 ){

	  launchMatmulKernel_11( matADevice, matBDevice, matResDevice);

	}

	SAFE_CALL(cudaEventRecord(stop, 0));


//	cudaMemcpy(/* скопировать на хост результат */);
	SAFE_CALL( cudaMemcpy( matResHost.ptr, matResDevice.ptr, sizeof(float)*p*m, cudaMemcpyDeviceToHost));


	SAFE_CALL(cudaEventRecord(stop_total, 0));
	SAFE_CALL(cudaEventSynchronize(stop_total));

	SAFE_CALL(cudaEventElapsedTime(&elapsedTime_total, start_total, stop_total));
	SAFE_CALL(cudaEventElapsedTime(&elapsedTime, start, stop));

	printf("GPU processing clean time: %14.4f milliseconds\n", elapsedTime);
	printf("GPU processing total time: %14.4f milliseconds\n", elapsedTime_total);
	printf("On GPU used  : %14.4f MFLOPS\n", ( ((float) n)*p*m ) / (elapsedTime) );
	printf("On GPU+ used : %14.4f MFLOPS\n", ( ((float)n) *p*m )/(elapsedTime_total) );

	float *Res = (float*) malloc(m*p*sizeof(float));

	cpuTime = fTime();
	cpuTimeD = omp_get_wtime();
	CPU_matmult( (float*) matAHost.ptr, (float*) matBHost.ptr, Res, n, m, p );
	cpuTime = fTime() - cpuTime;
	cpuTimeD = omp_get_wtime() - cpuTimeD;

	printf("CPU processing time: %14.4lf milliseconds\n", cpuTimeD*1000 );
	printf("On CPU used : %14.4f MFLOPS\n", 
                            ( ((float)n) *p*m )/(cpuTime*1000) );

	if( int ir = CompareArrays( Res, (float*) matResHost.ptr, m*p ) ){
	    std::cout << "Different Result [" << ir << "]\n";
	} else {
	    std::cout << "Same Result\n";
	}

	printf( "GPU Speedup clean = %14.4f \nGPU Speedup total = %14.4f \n",
		    cpuTime*1000/elapsedTime, 
		    cpuTime*1000/elapsedTime_total );

	if( m<11 && n<11 && p <11 ){
	    printf( "Ahost[%3d %3d]\n", (int) matAHost.xsize, 
                                        (int) matAHost.ysize );
	    prntArrayT( (float*) matAHost.ptr, matAHost.ysize, matAHost.xsize );
	    printf( "\n\n" );

	    printf( "AIhost[%3d %3d]\n", (int) matAHostT.xsize, 
                                         (int) matAHostT.ysize );
	    prntArrayT( (float*) matAHostT.ptr, matAHostT.ysize, matAHostT.xsize );
	    printf( "\n\n" );

	    printf( "Bhost[%3d %3d]\n", (int) matBHost.xsize, 
					(int) matBHost.ysize );
	    prntArrayT( (float*) matBHost.ptr, matBHost.ysize, matBHost.xsize );
	    printf( "\n\n" );

	    printf( "BThost[%3d %3d]\n", (int) matBHostT.xsize, 
				 	 (int) matBHostT.ysize );
	    prntArrayT( (float*) matBHostT.ptr, matBHostT.ysize, matBHostT.xsize );
	    printf( "\n\n" );


	    printf( "Chost[%3d %3d]\n", m, p );
	    prntArrayT( Res, m, p  );
	    printf( "\n\n" );

	    printf( "Cdrive[%3d %3d]\n", m, p );
	    prntArrayT( (float*) matResHost.ptr, m, p  );
	    printf( "\n\n" );

	}


	free(matAHost.ptr);
	free(matBHost.ptr);
	free(matResHost.ptr);
	free(Res);

	cudaFree(matADevice.ptr);
	cudaFree(matBDevice.ptr);
	cudaFree(matResDevice.ptr);


        // Проверить не случилось ли где ошибки
	std::cout << cudaGetErrorString(cudaGetLastError()) << " in CUDA drive\n"; 
}


void CPU_matmult( float *A, float *B, float *R, int n, int m, int p ){
	int i,j,k;
	float s;

//	printf( "CPY [n=%8d, m=%8d p=%8d]\n", n, m, p );
//		n * m    p * n       p * m
	
	for( i=0; i<m; i++ ){
	   for( j=0; j<p; j++ ){
		s = 0.0;
		for( k=0; k<n; k++ ){
		  s += A[i*n+k] * B[k*p + j];
//		  printf( "%4.1f  * %4.1f   ", A[i*n+k], B[k*p + j] );
		}
	        R[ i*p + j ] = s;
//		printf( "= %4.1f [%3d %3d] = [%4d]\n", 
//			s, i, j, i*p+j );
	   }
	}
}


float fTime(){
	float ft;
	clock_t it;
	it = clock();
	ft = ( (float) it ) / CLOCKS_PER_SEC * 1000;
	return ft;
}
