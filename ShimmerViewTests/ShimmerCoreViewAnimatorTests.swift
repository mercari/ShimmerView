import XCTest
import UIKit
@testable import ShimmerView

class ShimmerCoreViewAnimatorTests: XCTestCase {
    func testEffectRadius() {
        let style = ShimmerViewStyle(
            baseColor: .clear,
            highlightColor: .clear,
            duration: 10,
            interval: 10,
            effectSpan: .points(100),
            effectAngle: 0
        )
        let baseBounds = CGRect(x: 0, y: 0, width: 300, height: 300)

        var animator = ShimmerCoreView.Animator(
            baseBounds: baseBounds,
            elementFrame: baseBounds,
            gradientFrame: baseBounds,
            style: style,
            effectBeginTime: 0
        )

        XCTContext.runActivity(named: "Effect Angle = 0.25 pi") { _ in
            animator.style.effectAngle = 0.25 * CGFloat.pi
            XCTAssertEqual(animator.effectRadius, baseBounds.diagonalDistance/2)
        }

        XCTContext.runActivity(named: "Effect Angle = 0.75 pi") { _ in
            animator.style.effectAngle = 0.75 * CGFloat.pi
            XCTAssertEqual(animator.effectRadius, baseBounds.diagonalDistance/2)
        }
    }
    
    func testStartPoint() {
        let style = ShimmerViewStyle(
            baseColor: .clear,
            highlightColor: .clear,
            duration: 10,
            interval: 10,
            effectSpan: .points(100),
            effectAngle: 0
        )
        let baseBounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        let animator = ShimmerCoreView.Animator(
            baseBounds: baseBounds,
            elementFrame: baseBounds,
            gradientFrame: baseBounds,
            style: style,
            effectBeginTime: 0
        )
        let denominator = max(baseBounds.width, baseBounds.height)
        let fromValue = animator.startPointAnimationFromValue
        XCTAssertEqual(fromValue.x, -100/denominator, accuracy: 0.01)
        XCTAssertEqual(fromValue.y, 150/denominator, accuracy: 0.01)
        
        let toValue = animator.startPointAnimationToValue
        XCTAssertEqual(toValue.x, 300/denominator, accuracy: 0.01)
        XCTAssertEqual(toValue.y, 150/denominator, accuracy: 0.01)
    }
    
    func testEndPoint() {
        let style = ShimmerViewStyle(
            baseColor: .clear,
            highlightColor: .clear,
            duration: 10,
            interval: 10,
            effectSpan: .points(100),
            effectAngle: 0
        )
        let baseBounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        let animator = ShimmerCoreView.Animator(
            baseBounds: baseBounds,
            elementFrame: baseBounds,
            gradientFrame: baseBounds,
            style: style,
            effectBeginTime: 0
        )
        let denominator = max(baseBounds.width, baseBounds.height)
        let fromValue = animator.endPointAnimationFromValue
        XCTAssertEqual(fromValue.x, 0/denominator, accuracy: 0.01)
        XCTAssertEqual(fromValue.y, 150/denominator, accuracy: 0.01)
        
        let toValue = animator.endPointAnimationToValue
        XCTAssertEqual(toValue.x, 400/denominator, accuracy: 0.01)
        XCTAssertEqual(toValue.y, 150/denominator, accuracy: 0.01)
    }
}
