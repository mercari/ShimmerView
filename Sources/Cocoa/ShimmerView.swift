import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

open class ShimmerView: BaseView, ShimmerSyncTarget {
    internal var coreView: ShimmerCoreView = {
        let view = ShimmerCoreView()
        #if os(iOS) || os(tvOS)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        #else
        view.autoresizingMask = [.width, .height]
        #endif
        return view
    }()

    public var style: ShimmerViewStyle = .default

    public var effectBeginTime: CFTimeInterval = 0

    internal var syncTarget: ShimmerSyncTarget {
        nearestShimmerSyncTarget ?? self
    }

    internal var baseBounds: CGRect {
        syncTarget.syncTargetView.bounds
    }

    internal var elementFrame: CGRect {
        convert(bounds, to: syncTarget.syncTargetView)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        coreView.frame = bounds
        addSubview(coreView)
    }

    public func startAnimating() {
        effectBeginTime = CACurrentMediaTime()
        
        coreView.update(
            baseBounds: baseBounds,
            elementFrame: elementFrame,
            style: style,
            effectBeginTime: syncTarget.effectBeginTime
        )

        coreView.startAnimating()
    }

    public func stopAnimating() {
        coreView.stopAnimating()
    }

    public func apply(style: ShimmerViewStyle) {
        coreView.update(style: style)
    }

    #if os(iOS) || os(tvOS)
    override public func layoutSubviews() {
        super.layoutSubviews()

        coreView.update(baseBounds: baseBounds, elementFrame: elementFrame)
    }
    #else
    override public func layout() {
        super.layout()

        coreView.update(baseBounds: baseBounds, elementFrame: elementFrame)
    }
    #endif
}
