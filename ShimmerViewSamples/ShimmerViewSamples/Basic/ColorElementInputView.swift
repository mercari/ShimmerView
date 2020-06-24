import UIKit

class ColorElementInputView: UIView, UITextFieldDelegate {
    private static let maxCharacterCount: Int = 3
    
    enum Kind {
        case r, g, b
        var titleString: String {
            switch self {
            case .r:
                return "R"
            case .g:
                return "G"
            case .b:
                return "B"
            }
        }
    }
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 12.0
        view.alignment = .fill
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private(set) var slider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumValue = 0
        view.maximumValue = 255
        view.isContinuous = true
        return view
    }()
    
    private(set) lazy var textInputView: TextInputView = {
        let view = TextInputView()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.5)
        ])
        view.textFiled.delegate = self
        return view
    }()
    
    private var valueDidChangeClosure: ((Int) -> ())?
    
    init(kind: Kind, defaultValue: Int) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        titleLabel.text = kind.titleString
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(slider)
        stackView.addArrangedSubview(textInputView)
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderDidEndEditing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderDidEndEditing), for: .touchUpOutside)
        
        slider.value = Float(max(min(defaultValue, 255), 0))
        textInputView.textFiled.text = "\(max(min(defaultValue, 255), 0))"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindValuDidChange(closure: @escaping (Int) -> ()) {
        valueDidChangeClosure = closure
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // if string count == 0, return true
        guard string.count != 0 else {
            return true
        }
        
        // string should be consisted only from numbers
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
    
        // max length of the letters should be 3
        guard ((textField.text ?? "") + string).count <= ColorElementInputView.maxCharacterCount else {
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
            let convertedNumber = Int(text) else {
                return
        }
        let newValue = max(min(convertedNumber, 255), 0)
        textField.text = "\(newValue)"
        slider.value = Float(newValue)
        valueDidChangeClosure?(newValue)
    }
    
    @objc func sliderValueChanged() {
        textInputView.textFiled.text = "\(Int(slider.value))"
    }
    
    @objc func sliderDidEndEditing() {
        valueDidChangeClosure?(Int(slider.value))
    }
}
