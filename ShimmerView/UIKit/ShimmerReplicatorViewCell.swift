import UIKit

/// ShimmerReplicatorViewCell
/// ShimmerReplicatorView's each cell comforms to this protocol. The replicator view will replicate the cell as needed by the cell provider specified in its initializer.
/// Also, `ShimmerReplicatorView` starts all the cells' animation when its `startAnimating` is called.
public protocol ShimmerReplicatorViewCell: UIView {
    func startAnimating()
    func stopAnimating()
}
