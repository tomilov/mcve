#include <thrust/functional.h>
#include <thrust/transform.h>
#include <thrust/copy.h>

#include <thrust/iterator/transform_iterator.h>
#include <thrust/iterator/discard_iterator.h>

#include <thrust/device_vector.h>

#include <cstdio>

int main()
{
    thrust::device_vector< int > input{5};
    input[0] = 1;
    input[1] = 2;
    input[2] = 3;
    input[3] = 4;
    input[4] = 5;
    thrust::device_vector< int > stencil{input.size()};
    stencil[0] = 0;
    stencil[1] = 1;
    stencil[2] = 0;
    stencil[3] = 1;
    stencil[4] = 0;
    using namespace thrust::placeholders;
    {
        auto f = [] __host__ __device__ (int i) -> int
        {
            printf("%i copy_if\n", i);
            return i * 100;
        };
        auto input_begin = thrust::make_transform_iterator(input.cbegin(), f);
        thrust::copy_if(input_begin, thrust::next(input_begin, input.size()), stencil.cbegin(), thrust::make_discard_iterator(), _1 == 0);
    }
    {
        auto g = [] __host__ __device__ (int i) -> int
        {
            printf("%i transform_if\n", i);
            return i * 100;
        };
        auto input_begin = thrust::make_transform_iterator(input.cbegin(), g);
        thrust::transform_if(input_begin, thrust::next(input_begin, input.size()), stencil.cbegin(), thrust::make_discard_iterator(), thrust::identity< int >{}, _1 == 0);
    }
}
