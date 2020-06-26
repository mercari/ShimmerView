import XCTest
@testable import ShimmerView

class ShimmerViewTests: XCTestCase {

    func testStartAnimating() {
        let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
        XCTAssertEqual(shimmerView.effectBeginTime, 0)
        XCTAssertFalse(shimmerView.isAnimating)
        XCTAssertNil(shimmerView.gradientLayer.colors)
        XCTAssertNil(shimmerView.gradientLayer.animation(forKey: ShimmerView.animationKey))
        
        shimmerView.startAnimating()
        
        XCTAssertNotEqual(shimmerView.effectBeginTime, 0)
        XCTAssertTrue(shimmerView.isAnimating)
        XCTAssertNotNil(shimmerView.gradientLayer.colors)
        XCTAssertNotNil(shimmerView.gradientLayer.animation(forKey: ShimmerView.animationKey))
        
        sleep(1)
        
        let previousEffectBeginTime = shimmerView.effectBeginTime
        
        /// effectBeginTime should be updated everytime `startAnimating` is called.
        shimmerView.startAnimating()
        XCTAssertNotEqual(shimmerView.effectBeginTime, previousEffectBeginTime)
        XCTAssertTrue(shimmerView.isAnimating)
        XCTAssertNotNil(shimmerView.gradientLayer.colors)
        XCTAssertNotNil(shimmerView.gradientLayer.animation(forKey: ShimmerView.animationKey))
    }

    func testStopAnimating() {
        let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
        XCTAssertEqual(shimmerView.effectBeginTime, 0)
        XCTAssertFalse(shimmerView.isAnimating)
        XCTAssertNil(shimmerView.gradientLayer.colors)
        XCTAssertNil(shimmerView.gradientLayer.animation(forKey: ShimmerView.animationKey))
        
        shimmerView.startAnimating()
        
        shimmerView.stopAnimating()
        XCTAssertFalse(shimmerView.isAnimating)
        XCTAssertNil(shimmerView.gradientLayer.colors)
        XCTAssertNil(shimmerView.gradientLayer.animation(forKey: ShimmerView.animationKey))
    }

    func testApplyStyle() {
        let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let customStyle = ShimmerViewStyle(baseColor: .red, highlightColor: .blue, duration: 1.0, interval: 1.0, effectSpan: .points(100), effectAngle: 0)
        
        // ShimmerView's default style is ShimmerViewStyle.default
        XCTAssertEqual(shimmerView.style, ShimmerViewStyle.default)
        
        XCTContext.runActivity(named: "Apply a new style before animation is started") { _ in
            shimmerView.apply(style: customStyle)
            
            XCTAssertEqual(shimmerView.style, customStyle)
            XCTAssertFalse(shimmerView.isAnimating)
            XCTAssertNil(shimmerView.gradientLayer.colors)
            XCTAssertNil(shimmerView.gradientLayer.animation(forKey: ShimmerView.animationKey))
        }
        
        sleep(1)
        
        shimmerView.startAnimating()
        let effectBeginTime = shimmerView.effectBeginTime
        
        XCTContext.runActivity(named: "Apply a new style after animation is started") { _ in
            shimmerView.apply(style: customStyle)
            
            XCTAssertEqual(shimmerView.style, customStyle)
            XCTAssertEqual(shimmerView.effectBeginTime, effectBeginTime)
        }
    }
    
    func testLayoutSubviews() {
        let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        XCTAssertEqual(shimmerView.gradientLayer.frame.width, shimmerView.gradientLayer.frame.height)
        
        XCTContext.runActivity(named: "Height is bigger") { _ in
            shimmerView.frame.size = CGSize(width: 100, height: 300)
            shimmerView.layoutSubviews()
            XCTAssertEqual(shimmerView.gradientLayer.frame.origin, CGPoint(x: -100, y: 0))
            XCTAssertEqual(shimmerView.gradientLayer.frame.width, shimmerView.gradientLayer.frame.height)
        }
        
        XCTContext.runActivity(named: "Width is bigger") { _ in
            shimmerView.frame.size = CGSize(width: 300, height: 100)
            shimmerView.layoutSubviews()
            XCTAssertEqual(shimmerView.gradientLayer.frame.origin, CGPoint(x: 0, y: -100))
            XCTAssertEqual(shimmerView.gradientLayer.frame.width, shimmerView.gradientLayer.frame.height)
        }
    }
}
