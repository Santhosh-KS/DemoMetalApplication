import MetalKit

public enum DemoType {
  case basic, basicTriangle, basicTriangleWithColor, squareWithTwoTrianglesBasic
}

class DemoResourceInitializer {
  
  var commandQueue:MTLCommandQueue! = nil
  var renderPipelineState: MTLRenderPipelineState! = nil
  var verticiesCount = 0
  var vertexBuffer:MTLBuffer! = nil
  var demo:DemoType = .basic
  
  init(device: MTLDevice, demoType: DemoType = .basic) {
    demo = demoType
    setupCommandQueue(device: device)
    setupRenderPipelineState(device: device)
    setupVerticies(device: device)
  }
  
  func setupVertexDescriptor() -> MTLVertexDescriptor {
    let vertexDescriptor = MTLVertexDescriptor()
    vertexDescriptor.attributes[0].bufferIndex = 0
    vertexDescriptor.attributes[0].format = .float3
    vertexDescriptor.attributes[0].offset = 0
    
    vertexDescriptor.attributes[1].bufferIndex = 0
    vertexDescriptor.attributes[1].format = .float4
    vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.size
    
    vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
    return vertexDescriptor
  }
  
  fileprivate func setupCommandQueue(device: MTLDevice) {
    
    commandQueue = device.makeCommandQueue()!
  }
  
  fileprivate func setupRenderPipelineState(device:MTLDevice) {

    var renderPipelineDescriptor = setupRenderDescriptor(device:device , vFunc: "basic_vertex_function", fFunc: "basic_fragment_function")
    
     if demo != .basic {
      if demo == .basicTriangle {
        renderPipelineDescriptor = setupRenderDescriptor(device:device , vFunc: "basic_vertex_triangle_function", fFunc: "basic_fragment_function")
        let vertexDescriptor = setupVertexDescriptor()
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
      } else if demo == .basicTriangleWithColor {
        renderPipelineDescriptor = setupRenderDescriptor(device:device , vFunc: "basic_vertex_triangle_with_color_function", fFunc: "basic_fragment_triangle_with_color_function")
        let vertexDescriptor = setupVertexDescriptor()
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
      } else if demo == .squareWithTwoTrianglesBasic {
        renderPipelineDescriptor = setupRenderDescriptor(device:device , vFunc: "basic_vertex_triangle_with_color_function", fFunc: "basic_fragment_triangle_with_color_function")
        let vertexDescriptor = setupVertexDescriptor()
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
      }
      
    }
    
    do {
      renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor )
    } catch let error as NSError {
      print("Error during RenderPipelineStateCreattion \(error)")
    }
  }
  
  func setupVerticies(device:MTLDevice) {
    /// Basic approach
    let size:Float = 0.6
    if demo == .basic || demo == .basicTriangle {
      let verticies:[Vertex] = [
        Vertex(position: SIMD3<Float>(0,size,0)), // v0
        Vertex(position: SIMD3<Float>(-size,-size,0)), // v1
        Vertex(position: SIMD3<Float>(size,-size,0)), // v2
      ]
      verticiesCount = verticies.count
      vertexBuffer = device.makeBuffer(bytes: verticies, length: MemoryLayout<Vertex>.stride*verticiesCount, options: [])
    } else if demo == .basicTriangleWithColor {
      let verticies:[VertexWithColor] = [
        VertexWithColor(position: SIMD3<Float>(0,size,0), color:SIMD4<Float>(1,0,0,1)), // v0
        VertexWithColor(position: SIMD3<Float>(-size,-size,0), color:SIMD4<Float>(0,1,0,1)), // v1
        VertexWithColor(position: SIMD3<Float>(size,-size,0), color:SIMD4<Float>(0,0,1,1)), // v2
      ]
      verticiesCount = verticies.count
      vertexBuffer = device.makeBuffer(bytes: verticies, length: MemoryLayout<VertexWithColor>.stride*verticiesCount, options: [])
    } else if demo == .squareWithTwoTrianglesBasic {
      print("KSS I'm trying square")
      let verticies:[VertexWithColor] = [
        VertexWithColor(position: SIMD3<Float>(size,size,0), color:SIMD4<Float>(1,0,0,1)), // v0
        VertexWithColor(position: SIMD3<Float>(-size,size,0), color:SIMD4<Float>(0,1,0,1)), // v1
        VertexWithColor(position: SIMD3<Float>(-size,-size,0), color:SIMD4<Float>(0,0,1,1)), // v2
        
        VertexWithColor(position: SIMD3<Float>(size,size,0), color:SIMD4<Float>(1,1,0,1)), // v0
        VertexWithColor(position: SIMD3<Float>(-size,-size,0), color:SIMD4<Float>(0,1,1,1)), // v2
        VertexWithColor(position: SIMD3<Float>(size,-size,0), color:SIMD4<Float>(1,0,1,1)), // v3
      ]
      verticiesCount = verticies.count
      vertexBuffer = device.makeBuffer(bytes: verticies, length: MemoryLayout<VertexWithColor>.stride*verticiesCount, options: [])
    }
    
  }
  
   func setupRenderDescriptor(device: MTLDevice, vFunc vf:String, fFunc ff:String) -> MTLRenderPipelineDescriptor  {
    
    let library = device.makeDefaultLibrary()
    let vertexFunction = library?.makeFunction(name: vf)
    let fragmentFunction = library?.makeFunction(name: ff)
    
    let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
    renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    renderPipelineDescriptor.vertexFunction = vertexFunction
    renderPipelineDescriptor.fragmentFunction = fragmentFunction
    return renderPipelineDescriptor
  }
  
  func setupDrawPremitives(in view: MTKView) {
    
    guard let drawable = view.currentDrawable, let renderPassDescriptor  = view.currentRenderPassDescriptor else { return }
    
    let commandBuffer = commandQueue.makeCommandBuffer()
    let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
    commandEncoder?.setRenderPipelineState(renderPipelineState)
    commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    print("KSS Verticies count \(verticiesCount)")
    if demo != .basic {
      commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: verticiesCount)
    }
    commandEncoder?.endEncoding()
    commandBuffer?.present(drawable)
    commandBuffer?.commit()
  }
}


