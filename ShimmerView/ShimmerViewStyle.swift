import UIKit

public extension ShimmerView {
    enum EffectSpan {
        case ratio(CGFloat)
        case points(CGFloat)
    }
}

public protocol ShimmerViewStyle {
    var baseColor: UIColor { get }
    var highlightColor: UIColor { get }
    var duration: CFTimeInterval { get }
    var interval: CFTimeInterval { get }
    var effectSpan: ShimmerView.EffectSpan { get }

    /// The tilt angle of the effect. Please specify using radian.
    var effectAngle: CGFloat { get }
}

internal struct DefaultShimmerViewStyle: ShimmerViewStyle {
    let baseColor: UIColor = .systemGray2
    let highlightColor: UIColor = .systemGray3
    let duration: CFTimeInterval = 1.2
    let interval: CFTimeInterval = 0.4
    let effectSpan: ShimmerView.EffectSpan = .points(120)
    let effectAngle: CGFloat = 0
}
