import UIKit

public protocol ShimmerSyncTarget: UIResponder {
    var baseColor: UIColor { get }
    var highlightColor: UIColor { get }
    var duration: CFTimeInterval { get }
    var interval: CFTimeInterval { get }
    var effectBeginTime: CFTimeInterval { get }
    var effectSpan: ShimmerView.EffectSpan { get }

    /// The tilt angle of the effect. Please specify using radian.
    var effectAngle: CGFloat { get }

    var syncTargetView: UIView { get }
}

public extension ShimmerSyncTarget where Self: UIView {
    var syncTargetView: UIView {
        return self
    }
}

public extension ShimmerSyncTarget where Self: UIViewController {
    var syncTargetView: UIView {
        return view
    }
}
