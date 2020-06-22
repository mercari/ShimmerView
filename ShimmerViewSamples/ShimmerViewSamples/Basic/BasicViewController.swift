import UIKit
import ShimmerView

class BasicViewController: UIViewController {
    private let shimmerView: ShimmerView = {
        let view = ShimmerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 300),
            view.heightAnchor.constraint(equalToConstant: 300)
        ])
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(shimmerView)
        NSLayoutConstraint.activate([
            shimmerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            shimmerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        shimmerView.startAnimating()
    }
}
