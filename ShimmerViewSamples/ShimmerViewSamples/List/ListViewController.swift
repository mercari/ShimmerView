import UIKit
import ShimmerView

class ListViewController: UIViewController, ShimmerSyncTarget {
    
    var style = ShimmerViewStyle(baseColor: .red, highlightColor: .blue, duration: 1.2, interval: 0, effectSpan: .points(120), effectAngle: 0)
    var effectBeginTime = CACurrentMediaTime()
    
    private var shimmerReplicatorView: ShimmerReplicatorView = {
        let view = ShimmerReplicatorView(itemSize: .fixedHeight(120)) { () -> ShimmerReplicatorViewCell in
            return UINib(nibName: "ListViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ListViewCell
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(shimmerReplicatorView)
        NSLayoutConstraint.activate([
            shimmerReplicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            shimmerReplicatorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            shimmerReplicatorView.rightAnchor.constraint(equalTo: view.rightAnchor),
            shimmerReplicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        shimmerReplicatorView.startAnimating()
    }
}

