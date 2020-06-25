import UIKit

public extension ShimmerView {
    enum EffectSpan: Equatable {
        case ratio(CGFloat)
        case points(CGFloat)
    }
}

public struct ShimmerViewStyle: Equatable {
    public var baseColor: UIColor
    public var highlightColor: UIColor
    public var duration: CFTimeInterval
    public var interval: CFTimeInterval
    public var effectSpan: ShimmerView.EffectSpan

    /// The tilt angle of the effect. Please specify using radian.
    public var effectAngle: CGFloat
}

public extension ShimmerViewStyle {
    static let `default` = ShimmerViewStyle(baseColor: .systemGray2, highlightColor: .systemGray3, duration: 1.2, interval: 0.4, effectSpan: .points(120), effectAngle: 0 * CGFloat.pi)
}
