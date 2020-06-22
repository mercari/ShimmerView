import UIKit

public protocol ShimmerSyncTarget: UIResponder {
    var style: ShimmerViewStyle { get }

    var effectBeginTime: CFTimeInterval { get }

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
