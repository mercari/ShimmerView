import XCTest
import UIKit
@testable import ShimmerView

class ShimmerViewAnimatorTests: XCTestCase {
    func testSyncTarget() {
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
        
        XCTContext.runActivity(named: "There is no sync target in the UIReponder") { _ in
            let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            let syncTargetView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            syncTargetView.addSubview(shimmerView)
            
            let animator = ShimmerView.Animator(shimmerView: shimmerView)
            XCTAssertEqual(shimmerView, animator.syncTarget)
        }
        
        XCTContext.runActivity(named: "ShimmerView's parent view is ShimmerSyncTarget") { _ in
            let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            let syncTargetView = SyncTargetView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            syncTargetView.addSubview(shimmerView)
            
            let animator = ShimmerView.Animator(shimmerView: shimmerView)
            XCTAssertEqual(syncTargetView, animator.syncTarget)
        }
    }
    
    func testEffectRadius() {
        var style = ShimmerViewStyle(baseColor: .clear, highlightColor: .clear, duration: 10, interval: 10, effectSpan: .points(100), effectAngle: 0.25*CGFloat.pi)
        let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        shimmerView.apply(style: style)
        
        XCTContext.runActivity(named: "Effect Angle = 0.25 pi") { _ in
            let animator = ShimmerView.Animator(shimmerView: shimmerView)
            XCTAssertEqual(animator.effectRadius, shimmerView.frame.diagonalDistance/2)
        }
        
        XCTContext.runActivity(named: "Effect Angle = 0.75 pi") { _ in
            style.effectAngle = 0.25 * CGFloat.pi
            shimmerView.apply(style: style)
            let animator = ShimmerView.Animator(shimmerView: shimmerView)
            XCTAssertEqual(animator.effectRadius, shimmerView.frame.diagonalDistance/2)
        }
    }
    
    func testStartPoint() {
        let style = ShimmerViewStyle(baseColor: .clear, highlightColor: .clear, duration: 10, interval: 10, effectSpan: .points(100), effectAngle: 0)
        let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        shimmerView.apply(style: style)
        
        let animator = ShimmerView.Animator(shimmerView: shimmerView)
        let denominator = max(shimmerView.frame.width, shimmerView.frame.height)
        let fromValue = animator.startPointAnimationFromValue
        XCTAssertEqual(fromValue.x, -100/denominator, accuracy: 0.01)
        XCTAssertEqual(fromValue.y, 150/denominator, accuracy: 0.01)
        
        let toValue = animator.startPointAnimationToValue
        XCTAssertEqual(toValue.x, 300/denominator, accuracy: 0.01)
        XCTAssertEqual(toValue.y, 150/denominator, accuracy: 0.01)
    }
    
    func testEndPoint() {
        let style = ShimmerViewStyle(baseColor: .clear, highlightColor: .clear, duration: 10, interval: 10, effectSpan: .points(100), effectAngle: 0)
        let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        shimmerView.apply(style: style)
        
        let animator = ShimmerView.Animator(shimmerView: shimmerView)
        let denominator = max(shimmerView.frame.width, shimmerView.frame.height)
        let fromValue = animator.endPointAnimationFromValue
        XCTAssertEqual(fromValue.x, 0/denominator, accuracy: 0.01)
        XCTAssertEqual(fromValue.y, 150/denominator, accuracy: 0.01)
        
        let toValue = animator.endPointAnimationToValue
        XCTAssertEqual(toValue.x, 400/denominator, accuracy: 0.01)
        XCTAssertEqual(toValue.y, 150/denominator, accuracy: 0.01)
    }
}
