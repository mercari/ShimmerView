import UIKit
import Combine

class EffectAngleInputView: UIView {
    private static let maxCharacterCount: Int = 4
    private var allowedCharSet: CharacterSet = {
        var baseCharSet = CharacterSet.decimalDigits
        baseCharSet.formUnion(CharacterSet(charactersIn: "."))
        return baseCharSet
    }()
    private var numberFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.heightAnchor.constraint(equalToConstant: 56).isActive = true
        label.text = "Effect Angle"
        return label
    }()
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var inputBaseView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        view.addArrangedSubview(slider)
        view.addArrangedSubview(textInputView)
        view.addArrangedSubview(piLabel)
        return view
    }()
    
    private(set) lazy var slider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumValue = 0
        view.maximumValue = 2
        view.isContinuous = true
        return view
    }()
    
    private(set) lazy var textInputView: TextInputView = {
        let view = TextInputView()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2.0)
        ])
        view.textFiled.delegate = self
        return view
    }()
    
    private lazy var piLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .body)
        view.text = "π"
        return view
    }()
    
    private var state: CurrentValueSubject<CGFloat, Never>
    private var valueDidUpdateClosure: ((CGFloat) -> ())?
    private var disposeBag = DisposeBag()
    
    init(defaultValue: CGFloat) {
        state = CurrentValueSubject(max(min(CGFloat(defaultValue), 2), 0))
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(inputBaseView)
        stackView.addArrangedSubview(SpacerView(height: 16))
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderDidEndEditing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderDidEndEditing), for: .touchUpOutside)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        state.sink { [weak self] value in
            self?.textInputView.textFiled.text = self?.numberFormatter.string(for: value)
        }.add(to: disposeBag)
    }
    
    func bindValueDidUpdate(closure: @escaping (CGFloat) -> ()) {
        self.valueDidUpdateClosure = closure
    }
    
    @objc func sliderValueChanged() {
        state.send(CGFloat(slider.value))
    }
    
    @objc func sliderDidEndEditing() {
        valueDidUpdateClosure?(state.value)
    }
}

extension EffectAngleInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // if string count == 0, return true
        guard string.count != 0 else {
            return true
        }
        
        // string should be consisted only from numbers
        guard allowedCharSet.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
    
        // max length of the letters
        guard ((textField.text ?? "") + string).count <= EffectAngleInputView.maxCharacterCount else {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        guard let convertedValue = Float(text) else {
            textField.text = numberFormatter.string(for: state.value)
            return
        }
        
        state.send(max(min(CGFloat(convertedValue), 2), 0))
        
        valueDidUpdateClosure?(state.value)
        return
    }
}
