#include <metal_stdlib>
using namespace metal;

struct basicTriangleVertex {
  float4 position [[position]];
};

vertex float4 basic_vertex_function() {
  return float4(1);
}

vertex basicTriangleVertex basic_vertex_triangle_function(const device float3 *verticies [[buffer(0)]],
                                         uint vertexId [[vertex_id]]) {
  basicTriangleVertex v;
  v.position = float4(verticies[vertexId], 1);
  return v;
}

fragment float4 basic_fragment_function() {
  return float4(1);
}
