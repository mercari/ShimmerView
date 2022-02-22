import XCTest
@testable import ShimmerView

class ShimmerCoreViewTests: XCTestCase {
    func testStartAnimating() {
        let view = ShimmerCoreView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

        XCTAssertFalse(view.isAnimating)
        XCTAssertNil(view.gradientLayer.colors)
        XCTAssertNil(view.gradientLayer.animation(forKey: ShimmerCoreView.animationKey))

        view.startAnimating()

        XCTAssertTrue(view.isAnimating)
        XCTAssertNotNil(view.gradientLayer.colors)
        XCTAssertNotNil(view.gradientLayer.animation(forKey: ShimmerCoreView.animationKey))

        sleep(1)

        view.startAnimating()
        XCTAssertTrue(view.isAnimating)
        XCTAssertNotNil(view.gradientLayer.colors)
        XCTAssertNotNil(view.gradientLayer.animation(forKey: ShimmerCoreView.animationKey))
    }

    func testStopAnimating() {
        let view = ShimmerCoreView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

        XCTAssertEqual(view.effectBeginTime, 0)
        XCTAssertFalse(view.isAnimating)
        XCTAssertNil(view.gradientLayer.colors)
        XCTAssertNil(view.gradientLayer.animation(forKey: ShimmerCoreView.animationKey))

        view.startAnimating()

        view.stopAnimating()
        XCTAssertFalse(view.isAnimating)
        XCTAssertNil(view.gradientLayer.colors)
        XCTAssertNil(view.gradientLayer.animation(forKey: ShimmerCoreView.animationKey))
    }

    func testUpdate() {
        let view = ShimmerCoreView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

        // ShimmerCoreView's default style is ShimmerViewStyle.default
        XCTAssertEqual(view.style, ShimmerViewStyle.default)
        XCTAssertNil(view.gradientLayer.animation(forKey: ShimmerCoreView.animationKey))

        view.startAnimating()
        XCTAssertTrue(view.isAnimating)
        XCTAssertNotNil(view.gradientLayer.animation(forKey: ShimmerCoreView.animationKey))

        let previousAnimation = view.gradientLayer.animation(forKey: ShimmerCoreView.animationKey)
        let newStyle = ShimmerViewStyle(
            baseColor: .clear,
            highlightColor: .clear,
            duration: 10,
            interval: 10,
            effectSpan: .points(100),
            effectAngle: 0
        )

        view.update(style: newStyle)

        // When the style is updated and the view is animating, the animation object should be updated.
        XCTAssertTrue(view.isAnimating)
        XCTAssertNotEqual(view.gradientLayer.animation(forKey: ShimmerCoreView.animationKey), previousAnimation)
    }
    
    func testLayoutSubviews() {
        let view = ShimmerCoreView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

        XCTAssertEqual(view.gradientLayer.frame.width, view.gradientLayer.frame.height)

        XCTContext.runActivity(named: "Height is bigger") { _ in
            view.frame.size = CGSize(width: 100, height: 300)
            view.layoutSubviews()
            XCTAssertEqual(view.gradientLayer.frame.origin, CGPoint(x: -100, y: 0))
            XCTAssertEqual(view.gradientLayer.frame.width, view.gradientLayer.frame.height)
        }

        XCTContext.runActivity(named: "Width is bigger") { _ in
            view.frame.size = CGSize(width: 300, height: 100)
            view.layoutSubviews()
            XCTAssertEqual(view.gradientLayer.frame.origin, CGPoint(x: 0, y: -100))
            XCTAssertEqual(view.gradientLayer.frame.width, view.gradientLayer.frame.height)
        }
    }

    func testGradientFrame() {
        let baseBounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        let view = ShimmerCoreView(frame: baseBounds)
        view.layoutSubviews()

        XCTAssertEqual(view.gradientFrame, baseBounds)

        view.frame.size = CGSize(width: 100, height: 300)
        view.layoutSubviews()
        XCTAssertEqual(view.gradientFrame, CGRect(x: -100, y: 0, width: 300, height: 300))
    }
}
