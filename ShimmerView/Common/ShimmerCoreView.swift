import UIKit

internal class ShimmerCoreView: UIView {
    static let animationKey = "ShimmerEffect"

    private(set) var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()

    private(set) var isAnimating: Bool = false

    private(set) var baseBounds: CGRect = .zero
    private(set) var elementFrame: CGRect = .zero
    var gradientFrame: CGRect {
        gradientLayer.frame
    }
    private(set) var style: ShimmerViewStyle = .default
    private(set) var effectBeginTime: CFTimeInterval = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)
        scaleGradientLayerToAspectFill()
    }

    func startAnimating() {
        isAnimating = true

        setupAnimation()
    }

    private func setupAnimation() {
        gradientLayer.removeAnimation(forKey: ShimmerCoreView.animationKey)
        let animator = ShimmerCoreView.Animator(
            baseBounds: baseBounds,
            elementFrame: elementFrame,
            gradientFrame: gradientFrame,
            style: style,
            effectBeginTime: effectBeginTime
        )
        gradientLayer.colors = animator.interpolatedColors
        gradientLayer.add(animator.gradientLayerAnimation, forKey: ShimmerCoreView.animationKey)
    }

    func stopAnimating() {
        isAnimating = false
        gradientLayer.removeAnimation(forKey: ShimmerCoreView.animationKey)
        gradientLayer.colors = nil
    }

    func update(
        baseBounds: CGRect? = nil,
        elementFrame: CGRect? = nil,
        style: ShimmerViewStyle? = nil,
        effectBeginTime: CFTimeInterval? = nil
    ) {
        if let baseBounds = baseBounds {
            self.baseBounds = baseBounds
        }
        
        if let elementFrame = elementFrame {
            self.elementFrame = elementFrame
        }
        
        if let style = style {
            self.style = style
        }
        
        if let effectBeginTime = effectBeginTime {
            self.effectBeginTime = effectBeginTime
        }
        
        if isAnimating {
            setupAnimation()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        scaleGradientLayerToAspectFill()

        if isAnimating {
            startAnimating()
        }
    }

    private func scaleGradientLayerToAspectFill() {
        if frame.width > frame.height {
            gradientLayer.frame.origin = CGPoint(x: 0, y: -(frame.width - frame.height)/2)
            gradientLayer.frame.size = CGSize(width: frame.width, height: frame.width)
        } else if frame.height > frame.width {
            gradientLayer.frame.origin = CGPoint(x: -(frame.height - frame.width)/2, y: 0)
            gradientLayer.frame.size = CGSize(width: frame.height, height: frame.height)
        } else {
            gradientLayer.frame = bounds
        }
    }
}
