import UIKit

class ColorInputView: UIView {
    enum Kind {
        case base, highlight
        var titleString: String {
            switch self {
            case .base:
                return "Base Color"
            case .highlight:
                return "Highlight Color"
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var colorCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 20),
            view.heightAnchor.constraint(equalToConstant: 20)
        ])
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(colorCircleView)
        view.addArrangedSubview(SpacerView(height: 0))
        view.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return view
    }()
    
    private lazy var rInputView: ColorElementInputView = {
        let view = ColorElementInputView(kind: .r)
        return view
    }()
    
    private lazy var gInputView: ColorElementInputView = {
        let view = ColorElementInputView(kind: .g)
        return view
    }()
    
    private lazy var bInputView: ColorElementInputView = {
        let view = ColorElementInputView(kind: .b)
        return view
    }()
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 0
        return view
    }()
    
    init(kind: Kind) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = kind.titleString
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(rInputView)
        stackView.addArrangedSubview(SpacerView(height: 12))
        stackView.addArrangedSubview(gInputView)
        stackView.addArrangedSubview(SpacerView(height: 12))
        stackView.addArrangedSubview(bInputView)
        stackView.addArrangedSubview(SpacerView(height: 16))
        
        rInputView.bindValuDidChange { newRValue in
            
        }
        
        gInputView.bindValuDidChange { newGValue in
            
        }
        
        bInputView.bindValuDidChange { newBValue in
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
