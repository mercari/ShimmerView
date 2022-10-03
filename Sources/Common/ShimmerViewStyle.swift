import UIKit

public extension ShimmerView {
    
    /// Effect Span
    /// Effect Span is the length of the gradation of shimmering effect.
    /// If it is specified in ratio, the effect span in points will be calculated as SyncTargetView.frame.diagonalDistance * ratio.
    enum EffectSpan: Equatable {
        case ratio(CGFloat)
        case points(CGFloat)
    }
}

public struct ShimmerViewStyle: Equatable {
    
    /// The base color of the skelton view/shimmering effect.
    public var baseColor: UIColor
    
    /// The highlight color of the shimmering effect.
    public var highlightColor: UIColor
    
    /// The duration of the shimmering effect.
    public var duration: CFTimeInterval
    
    /// The interval of the shimmering effect. The length of one repetition of shimmering effect will be `duration` + `interval`.
    public var interval: CFTimeInterval
    
    /// The length of the gradation of shimmering effect.
    public var effectSpan: ShimmerView.EffectSpan

    /// The tilt angle of the effect. Please specify using radian.
    public var effectAngle: CGFloat
    
    public init(baseColor: UIColor, highlightColor: UIColor, duration: CFTimeInterval, interval: CFTimeInterval, effectSpan: ShimmerView.EffectSpan, effectAngle: CGFloat) {
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.duration = duration
        self.interval = interval
        self.effectSpan = effectSpan
        self.effectAngle = effectAngle
    }
}

public extension ShimmerViewStyle {
    static let `default` = ShimmerViewStyle(baseColor: UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0), highlightColor: UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0), duration: 1.2, interval: 0.4, effectSpan: .points(120), effectAngle: 0 * CGFloat.pi)
}
