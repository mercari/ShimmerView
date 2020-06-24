import UIKit

class NumberInputView: UIView {
    enum Kind {
        case duration, interval, effectAngle
        var titleString: String {
            switch self {
            case .duration:
                return "Duration"
            case .interval:
                return "Interval"
            case .effectAngle:
                return "Effect Angle"
            }
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private var textFiled: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .body)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 20)
        ])
        return view
    }()
    
    private(set) lazy var textInputView: TextInputView = {
        let view = TextInputView()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2.0)
        ])
        return view
    }()
    
    init(kind: Kind) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        addSubview(titleLabel)
        titleLabel.text = kind.titleString
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
        ])
        
        addSubview(textInputView)
        NSLayoutConstraint.activate([
            textInputView.centerYAnchor.constraint(equalTo: centerYAnchor),
            textInputView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
