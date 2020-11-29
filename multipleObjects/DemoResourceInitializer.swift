import MetalKit

class DemoResourceInitializer {
  
  var commandQueue:MTLCommandQueue! = nil
  var renderPipelineState: MTLRenderPipelineState! = nil
  
  init(device: MTLDevice) {
    setupCommandQueue(device: device)
    setupRenderPipelineState(device: device)
  }
  
  func setupCommandQueue(device: MTLDevice) {
    commandQueue = device.makeCommandQueue()!
  }
  
  func setupRenderPipelineState(device:MTLDevice) {
    let library = device.makeDefaultLibrary()
    let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
    let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
    
    let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
    renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    renderPipelineDescriptor.vertexFunction = vertexFunction
    renderPipelineDescriptor.fragmentFunction = fragmentFunction
    do {
      renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
    } catch let error as NSError {
      print("Error during RenderPipelineStateCreattion \(error)")
    }
  }
  
  func setupDrawPremitives(in view: MTKView) {
    
    guard let drawable = view.currentDrawable, let renderPassDescriptor  = view.currentRenderPassDescriptor else { return }
    
    let commandBuffer = commandQueue.makeCommandBuffer()
    let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
    commandEncoder?.setRenderPipelineState(renderPipelineState)
    
    commandEncoder?.endEncoding()
    commandBuffer?.present(drawable)
    commandBuffer?.commit()
    
  }
}


