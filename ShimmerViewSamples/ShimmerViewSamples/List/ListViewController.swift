import UIKit
import ShimmerView

class ListViewController: UIViewController, ShimmerSyncTarget {
    
    var style: ShimmerViewStyle = {
        var style = ShimmerViewStyle.default
        style.baseColor = UIColor(dynamicProvider: { trait -> UIColor in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
            } else {
                return UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
            }
        })
        return style
    }()
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
        
        view.backgroundColor = .systemBackground
        
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

