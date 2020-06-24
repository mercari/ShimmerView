import UIKit
import Combine

class NumberInputView: UIView, UITextFieldDelegate {
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
    
    enum Kind {
        case duration, interval
        var titleString: String {
            switch self {
            case .duration:
                return "Duration"
            case .interval:
                return "Interval"
            }
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
        
    private(set) lazy var textInputView: TextInputView = {
        let view = TextInputView()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2.0)
        ])
        view.textFiled.delegate = self
        return view
    }()
    
    private var state: CurrentValueSubject<CGFloat, Never>
    private var valueDidUpdateClosure: ((CGFloat) -> ())?
    private var disposeBag = DisposeBag()
    
    init(kind: Kind, defaultValue: CGFloat) {
        state = CurrentValueSubject(defaultValue)
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
        
        bind()
    }
    
    private func bind() {
        state.sink { [weak self] value in
            self?.textInputView.textFiled.text = self?.numberFormatter.string(for: value)
        }.add(to: disposeBag)
        
        state.dropFirst().removeDuplicates().sink { [weak self] value in
            self?.valueDidUpdateClosure?(value)
        }.add(to: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        guard ((textField.text ?? "") + string).count <= NumberInputView.maxCharacterCount else {
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
        
        state.send(CGFloat(convertedValue))
        
        return
    }
    
    func bindValueDidUpdate(closure: @escaping (CGFloat) -> ()) {
        self.valueDidUpdateClosure = closure
    }
}
