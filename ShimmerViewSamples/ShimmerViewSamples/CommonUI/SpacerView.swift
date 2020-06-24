import UIKit

class SpacerView: UIView {
    
    private var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(height: CGFloat, leftPadding: CGFloat = 0, backgroundColor: UIColor = .clear) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
        ])
        
        addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: topAnchor),
            lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: leftPadding),
            lineView.rightAnchor.constraint(equalTo: rightAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        lineView.backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
