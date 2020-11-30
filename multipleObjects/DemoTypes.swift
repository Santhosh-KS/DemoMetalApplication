import MetalKit

// .basic or .basicTriangle
struct Vertex {
  let position:SIMD3<Float> // .basicTriangle
}

// .basicTrianglewithColor
struct VertexWithColor {
  let position:SIMD3<Float>
  let color:SIMD4<Float>
}

struct Constants {
  var animateBy:Float = 0.0
}

