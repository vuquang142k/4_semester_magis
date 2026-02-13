all: matmul matmul_debug
OBJECTS = main.o kernel.o
OBJECTSDEBUG = main_debug.o kernel_debug.o
matmul: $(OBJECTS)
	g++ -L/usr/local/cuda/lib64 $^ -lcudart -o $@ -fopenmp
main.o: matmulMain.cpp example.h
	g++ -I/usr/local/cuda/include $< -c -o $@ -fopenmp
kernel.o: matmulKernel.cu
	nvcc -Xptxas -v -lineinfo -arch=sm_70 $< -c -o $@	

matmul_debug: $(OBJECTSDEBUG)
	g++ -L/usr/local/cuda/lib64 $^ -lcudart -o $@ -fopenmp
main_debug.o: matmulMain.cpp
	g++ -I/usr/local/cuda/include $< -g -c -o $@ -fopenmp
kernel_debug.o: matmulKernel.cu example.h
	nvcc -arch=sm_70 $< -g -G -c -o $@
clean:
	rm -rf *.o matmul_debug matmul 
