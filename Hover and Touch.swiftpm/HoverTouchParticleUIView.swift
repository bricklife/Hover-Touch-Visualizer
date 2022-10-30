import UIKit

class HoverTouchParticleUIView: UIView {
    
    private let emitterLayer = CAEmitterLayer()
    private let imageLayer = CALayer()
    private var isHovering = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func makeParticleImage() -> CGImage {
        return UIImage(named: "particle")!.cgImage!
    }
    
    private func makeEmitterCell() -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        
        emitterCell.contents = makeParticleImage()
        emitterCell.emissionRange = .pi * 2
        emitterCell.birthRate = 200
        emitterCell.scale = 0.5
        emitterCell.scaleSpeed = -0.2
        emitterCell.lifetime = 1.0
        emitterCell.lifetimeRange = 0.5
        emitterCell.velocity = 200
        emitterCell.alphaSpeed = -0.5
        
        emitterCell.beginTime = CACurrentMediaTime()
        emitterCell.duration = 0.2
        
        return emitterCell
    }
    
    private func setup() {
        imageLayer.contents = makeParticleImage()
        imageLayer.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        layer.addSublayer(imageLayer)
        
        emitterLayer.renderMode = .additive
        layer.addSublayer(emitterLayer)
        
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(hover(_:)))
        addGestureRecognizer(hover)
        
        backgroundColor = .black
        imageLayer.opacity = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        imageLayer.opacity = 0
        emitterLayer.emitterPosition = location
        emitterLayer.emitterCells = [makeEmitterCell()]
        
        isHovering = false
    }
    
    @objc private func hover(_ hover: UIHoverGestureRecognizer) {
        //print(hover.state.rawValue, terminator: " ")
        switch hover.state {
        case .began:
            isHovering = true
            
        case .changed:
            if isHovering {
                let location = hover.location(in: hover.view)
                var zOffset = CGFloat(0)
                if #available(iOS 16.1, *) {
                    zOffset = hover.zOffset
                }
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                imageLayer.position = location
                imageLayer.setAffineTransform(.init(scaleX: zOffset * 10, y: zOffset * 10))
                imageLayer.opacity = 1 - Float(zOffset)
                CATransaction.commit()
            }
            
        default:
            imageLayer.opacity = 0
        }
    }
}
