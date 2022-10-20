#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

internal extension Responder {
    var nearestShimmerSyncTarget: (ShimmerSyncTarget & Responder)? {
        var current: Responder? = self.next
        while current != nil {
            if let syncTarget = current as? (ShimmerSyncTarget & Responder) {
                return syncTarget
            } else {
                current = current?.next
            }
        }
        return nil
    }
}

#if os(macOS)
private extension NSResponder {
    var next: NSResponder? {
        nextResponder
    }
}
#endif
