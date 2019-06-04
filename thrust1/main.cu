#include <thrust/device_vector.h>
#include <thrust/execution_policy.h>
#include <thrust/copy.h>
#include <thrust/iterator/transform_iterator.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/advance.h>

int main()
{
    using U = unsigned int;
    auto p = thrust::device;
    thrust::device_vector< U > X{1};
    {
        auto halves = [] __device__ (U i) -> U { return i / 2; };
        auto bb = thrust::make_transform_iterator(thrust::make_counting_iterator< U >(0), halves);
#if 1
        thrust::copy_n(p, bb, X.size(), X.begin());
#else
        X.assign(bb, thrust::next(bb, X.size()));
#endif
    }
}
