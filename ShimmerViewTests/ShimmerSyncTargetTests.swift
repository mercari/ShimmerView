import XCTest
import UIKit
@testable import ShimmerView

class ShimmerSyncTargetTests: XCTestCase {
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

            XCTAssertEqual(shimmerView, shimmerView.syncTarget)
        }
        
        XCTContext.runActivity(named: "ShimmerView's parent view is ShimmerSyncTarget") { _ in
            let shimmerView = ShimmerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            let syncTargetView = SyncTargetView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            syncTargetView.addSubview(shimmerView)

            XCTAssertEqual(syncTargetView, shimmerView.syncTarget)
        }
    }
}
