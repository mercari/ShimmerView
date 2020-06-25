import UIKit

class TextInputView: UIView {
    
    private(set) lazy var textFiled: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .body)
        view.textAlignment = .center
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(textFiled)
        NSLayoutConstraint.activate([
            textFiled.topAnchor.constraint(equalTo: topAnchor),
            textFiled.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            textFiled.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            textFiled.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
