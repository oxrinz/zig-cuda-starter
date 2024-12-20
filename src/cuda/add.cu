extern "C" __global__ void addKernel(int *a, int *b, int *c)
{
    *c = *a + *b;
}

extern "C" void launchAddKernel(int *a, int *b, int *c) 
{
    addKernel<<<1, 1>>>(a, b, c); 
}