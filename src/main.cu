#include <cuda.h>
#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>

__global__ void vector_add(int *out, int *a, int *b, int n){
    int index = threadIdx.x;
    int stride = blockDim.x;

    for (int i = index; i < n; i+=stride) {
        out[i] = a[i] + b[i];
    }
}

int main() {
    int n = 10;
    int *a, *b, *out, *dev_a, *dev_b, *dev_out;

    a = (int*) malloc(n * sizeof(int));
    b = (int*) malloc(n * sizeof(int));
    out = (int*) malloc(n * sizeof(int));

    for (int i = 0; i < n; i++) {
        a[i] = 1;
        b[i] = 2;
    }

    // Allocate device memory
    cudaMalloc((void**)&dev_a, sizeof(float) * n);
    cudaMalloc((void**)&dev_b, sizeof(float) * n);
    cudaMalloc((void**)&dev_out, sizeof(float) * n);

    // Transfer data from host to device memory
    cudaMemcpy(dev_a, a, sizeof(float) * n, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, sizeof(float) * n, cudaMemcpyHostToDevice);

    // Executing kernel
    vector_add<<<1,256>>>(dev_out, dev_a, dev_b, n);

    // Transfer data back to host memory
    cudaMemcpy(out, dev_out, sizeof(float) * n, cudaMemcpyDeviceToHost);

    for (int i = 0; i < n; i++) {
        printf("%d\n", out[i]);
    }

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_out);

    delete[] a;
    delete[] out;
    delete[] b;

    return EXIT_SUCCESS;
}
