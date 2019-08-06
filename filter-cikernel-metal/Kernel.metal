#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {
    
    float4 grayscale(sample_t s) {
        half y = 0.2 * s.r + 0.7 * s.g + 0.1 * s.b;
        return float4(y, y, y, s.a);
    }
    
}}

