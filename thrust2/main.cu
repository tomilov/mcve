#include <thrust/functional.h>
#include <thrust/transform.h>
#include <thrust/copy.h>

#include <thrust/iterator/transform_output_iterator.h>

#include <thrust/system/cuda/vector.h>
#include <thrust/device_vector.h>

#include <cstdio>

template< typename T >
#if 1
using container = thrust::device_vector< T >;
#else
using container = thrust::cuda::vector< T >;
#endif

int main()
{
    container< int > input{5};
    input[0] = 1;
    input[1] = 2;
    input[2] = 3;
    input[3] = 4;
    input[4] = 5;
    container< int > stencil{input.size()};
    stencil[0] = 0;
    stencil[1] = 1;
    stencil[2] = 0;
    stencil[3] = 1;
    stencil[4] = 0;
    auto f = [] __host__ __device__ (int i) -> int
    {
        printf("%i\n", i);
        return i * 100;
    };
    container< int > output{input.size()};
    auto output_begin = thrust::make_transform_output_iterator(output.begin(), f);
    using namespace thrust::placeholders;
    thrust::copy_if(input.cbegin(), input.cend(), stencil.cbegin(), output_begin, _1 == 0);
}
