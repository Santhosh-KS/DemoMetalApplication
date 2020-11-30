import MetalKit

class DemoRenderrer: NSObject {
  
  var resourceInitializer:DemoResourceInitializer! = nil
  
  init(device: MTLDevice) {
    super.init()
    self.resourceInitializer = DemoResourceInitializer(device: device, demoType: DemoType.basicTriangleWithColor)
  }
}
extension DemoRenderrer: MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    // TODO: Enable Window Resizing later
  }
  
  func draw(in view: MTKView) {
    resourceInitializer.setupDrawPremitives(in: view)
    //print("KSS DELEGATED!")
  }
}
