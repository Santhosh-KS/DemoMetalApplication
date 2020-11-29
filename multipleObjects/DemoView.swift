import MetalKit

class DemoView: MTKView {
  
  var renderrer: DemoRenderrer! = nil
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    self.device = MTLCreateSystemDefaultDevice()
    self.colorPixelFormat = .bgra8Unorm
    self.clearColor = MTLClearColorMake(0.2, 0.6, 0.3, 1)
    self.renderrer = DemoRenderrer(device: self.device!)
    self.delegate = renderrer
  }
}
