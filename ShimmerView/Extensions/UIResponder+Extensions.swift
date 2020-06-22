import UIKit

internal extension UIResponder {
    var nearestShimmerSyncTarget: (ShimmerSyncTarget & UIResponder)? {
        var current: UIResponder? = self.next
        while current != nil {
            if let syncTarget = current as? (ShimmerSyncTarget & UIResponder) {
                return syncTarget
            } else {
                current = current?.next
            }
        }
        return nil
    }
}
