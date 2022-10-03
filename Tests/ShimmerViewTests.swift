import XCTest
import UIKit
@testable import ShimmerView

class ShimmerViewTests: XCTestCase {
    func testCoreViewFrame() {
        let baseBounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        let view = ShimmerView(frame: baseBounds)

        XCTContext.runActivity(named: "When the shimmer view is initialized") { _ in
            XCTAssertEqual(view.bounds, view.coreView.frame)
        }

        view.frame.size = CGSize(width: 100, height: 100)

        XCTContext.runActivity(named: "When the size of shimmer view is changed") { _ in
            XCTAssertEqual(view.bounds, view.coreView.frame)
        }
    }
    
    func testBaseBoundsAndElementFrame() {
        let baseBounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        let view = ShimmerView(frame: baseBounds)

        XCTContext.runActivity(named: "When the shimmer sync target is the view itself") { _ in
            XCTAssertEqual(view.baseBounds, view.bounds)
            XCTAssertEqual(view.elementFrame, view.bounds)
        }

        class SyncTargetView: UIView, ShimmerSyncTarget {
            var style: ShimmerViewStyle = .default
            var effectBeginTime: CFTimeInterval = 0

            override init(frame: CGRect) {
                super.init(frame: frame)
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }

        let parentBounds = CGRect(x: 0, y: 0, width: 500, height: 500)
        let parentView = SyncTargetView(frame: parentBounds)
        parentView.addSubview(view)
        view.frame.origin = CGPoint(x: 100, y: 100)
        XCTContext.runActivity(named: "When the shimmer sync target is the parent view") { _ in
            XCTAssertEqual(view.baseBounds, parentBounds)
            XCTAssertEqual(view.elementFrame, CGRect(x: 100, y: 100, width: 300, height: 300))
        }
    }

    func testStartAnimating() {
        let view = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

        XCTAssertEqual(view.effectBeginTime, 0)
        XCTAssertFalse(view.coreView.isAnimating)

        view.startAnimating()

        XCTAssertNotEqual(view.effectBeginTime, 0)
        XCTAssertTrue(view.coreView.isAnimating)

        sleep(1)

        let previousEffectBeginTime = view.effectBeginTime

        /// effectBeginTime should be updated everytime `startAnimating` is called.
        view.startAnimating()
        XCTAssertNotEqual(view.effectBeginTime, previousEffectBeginTime)
        XCTAssertTrue(view.coreView.isAnimating)
    }

    func testStopAnimating() {
        let view = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

        XCTAssertEqual(view.effectBeginTime, 0)
        XCTAssertFalse(view.coreView.isAnimating)

        view.startAnimating()
        XCTAssertTrue(view.coreView.isAnimating)

        view.stopAnimating()
        XCTAssertFalse(view.coreView.isAnimating)
    }

    func testApplyStyle() {
        let view = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        XCTAssertEqual(view.coreView.style, .default)

        let newStyle = ShimmerViewStyle(
            baseColor: .clear,
            highlightColor: .clear,
            duration: 10,
            interval: 10,
            effectSpan: .points(100),
            effectAngle: 0
        )
        view.apply(style: newStyle)
        XCTAssertEqual(view.coreView.style, newStyle)
    }
}
