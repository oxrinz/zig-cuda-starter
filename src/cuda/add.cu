#include <cuda_runtime.h>

__global__ void addKernel(int *a, int *b, int *c) {
    *c = *a + *b;
}

extern "C" {
    int addNumbers(int a, int b) {
        int *d_a, *d_b, *d_c;
        int result;
        
        cudaMalloc((void**)&d_a, sizeof(int));
        cudaMalloc((void**)&d_b, sizeof(int));
        cudaMalloc((void**)&d_c, sizeof(int));
        
        cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);
        
        addKernel<<<1,1>>>(d_a, d_b, d_c);
        
        cudaMemcpy(&result, d_c, sizeof(int), cudaMemcpyDeviceToHost);
        
        cudaFree(d_a);
        cudaFree(d_b);
        cudaFree(d_c);
        
        return result;
    }
}