import UIKit
import ShimmerView

class ListViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShimmerReplicatorView(itemSize: <#T##ShimmerReplicatorView.ItemSize#>, cellProvider: <#T##() -> ShimmerReplicatorViewCell#>)
    }
}

