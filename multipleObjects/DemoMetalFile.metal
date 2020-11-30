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

/// Metal Structs for colorful triangle renderring.

struct basicTriangleVertexWithColorIn {
  float3 position;
  float4 color;
};

struct basicTriangleVertexWithColorOut {
  float4 position [[position]];
  float4 color;
};

vertex basicTriangleVertexWithColorOut basic_vertex_triangle_with_color_function(const device basicTriangleVertexWithColorIn *verticies [[buffer(0)]], uint vertexId [[vertex_id]]) {
  
  basicTriangleVertexWithColorOut vOut;
  vOut.position = float4(verticies[vertexId].position, 1);
  vOut.color = verticies[vertexId].color * 3.5;
  // vOut.color = verticies[vertexId].color;
  return vOut;
  
}

fragment float4 basic_fragment_triangle_with_color_function(basicTriangleVertexWithColorOut vIn [[stage_in]]) {
  return vIn.color;
}

// Per vertex based approach

struct basicTrianglePerVertexWithColorIn {
  float3 position [[attribute(0)]];
  float4 color [[attribute(1)]];
};

struct basicTrianglePerVertexWithColorOut {
  float4 position [[position]];
  float4 color;
};

vertex basicTrianglePerVertexWithColorOut basic_per_vertex_triangle_with_color_function(basicTrianglePerVertexWithColorIn vertexIn [[ stage_in ]]) {
  basicTrianglePerVertexWithColorOut vout;
  vout.position = float4(vertexIn.position, 1);
  vout.color = vertexIn.color;
  return vout;
}

fragment float4 basic_fragment_triangle_with_per_vertex_color_function(basicTrianglePerVertexWithColorOut vIn [[stage_in]]) {
  return vIn.color;
}


// Animation

struct DemoConstants {
  float animateBy{0.0};
};

vertex basicTrianglePerVertexWithColorOut basic_per_vertex_triangle_with_color_and_animation_function(basicTrianglePerVertexWithColorIn vertexIn [[ stage_in ]], constant DemoConstants &constants [[ buffer(1) ]]) {
  
  basicTrianglePerVertexWithColorOut vout;
  vout.position = float4(vertexIn.position, 1);
  vout.color = vertexIn.color;
  vout.position.y += cos(constants.animateBy)*0.4;
  vout.position.x += sin(constants.animateBy)*0.3;
  
  return vout;
}

fragment float4 basic_fragment_triangle_with_per_vertex_colorand_animation_function(basicTrianglePerVertexWithColorOut vIn [[stage_in]]) {
  return vIn.color;
}
