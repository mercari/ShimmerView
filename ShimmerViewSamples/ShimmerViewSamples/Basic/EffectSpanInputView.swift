import UIKit
import ShimmerView
import Combine

private extension ShimmerView.EffectSpan {
    var number: CGFloat {
        switch self {
        case .points(let points):
            return points
        case .ratio(let ratio):
            return ratio
        }
    }
    
    var effectSpanInputViewButtonKind: EffectSpanInputView.ButtonKind {
        switch self {
        case .points:
            return .points
        case .ratio:
            return .ratio
        }
    }
    
    init(buttonKind: EffectSpanInputView.ButtonKind, number: CGFloat) {
        switch buttonKind {
        case .points:
            self = .points(number)
        case .ratio:
            self = .ratio(number)
        }
    }
    
    var effectSpanInputViewState: EffectSpanInputView.State {
        return .init(selectedButton: effectSpanInputViewButtonKind, number: number)
    }
}

class EffectSpanInputView: UIView {
    
    private static let maxCharacterCount: Int = 4
    private var allowedCharSet: CharacterSet = {
        var baseCharSet = CharacterSet.decimalDigits
        baseCharSet.formUnion(CharacterSet(charactersIn: "."))
        return baseCharSet
    }()
    private var numberFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    fileprivate enum ButtonKind: Int, CaseIterable {
        case ratio, points
        
        var titleString: String {
            switch self {
            case .ratio:
                return "Ratio"
            case .points:
                return "Points"
            }
        }
        
        var unitString: String {
            switch self {
            case .ratio:
                return "%"
            case .points:
                return "Points"
            }
        }
    }
    
    fileprivate struct State: Equatable {
        var selectedButton: ButtonKind
        var number: CGFloat
        var effectSpan: ShimmerView.EffectSpan {
            return .init(buttonKind: selectedButton, number: number)
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.heightAnchor.constraint(equalToConstant: 56).isActive = true
        label.text = "Effect Span"
        return label
    }()
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var inputBaseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        view.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(numberInputStackView)
        NSLayoutConstraint.activate([
            numberInputStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            numberInputStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
        
    private lazy var buttons: [OutlinedButton] = {
        var buttons = [OutlinedButton]()
        for buttonKind in ButtonKind.allCases {
            let button = OutlinedButton()
            button.setTitle(buttonKind.titleString, for: .normal)
            button.tag = buttonKind.rawValue
            button.addTarget(self, action: #selector(buttonDidTap(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8
        for button in buttons {
            view.addArrangedSubview(button)
        }
        return view
    }()
    
    private lazy var numberInputView: TextInputView = {
        let view = TextInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2.0).isActive = true
        view.textFiled.textAlignment = .right
        view.textFiled.delegate = self
        return view
    }()
    
    private lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "%"
        return label
    }()
    
    private lazy var numberInputStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.axis = .horizontal
        view.spacing = 8.0
        view.addArrangedSubview(numberInputView)
        view.addArrangedSubview(unitLabel)
        return view
    }()
    
    private var valueDidUpdateClosure: ((ShimmerView.EffectSpan) -> ())?
    
    private let state: CurrentValueSubject<State, Never>
    private var disposeBag = DisposeBag()
    
    init(effectSpan: ShimmerView.EffectSpan) {
        state = CurrentValueSubject(effectSpan.effectSpanInputViewState)
        
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
        
        bind()
    }

    private func bind() {
        state.removeDuplicates().sink { [weak self] state in
            guard let self = self else { return }
            
            self.numberInputView.textFiled.text = self.numberFormatter.string(for: state.number)
            for _button in self.buttons {
                _button.isSelected = state.selectedButton.rawValue == _button.tag
            }
            self.unitLabel.text = state.selectedButton.unitString
        }.add(to: disposeBag)

        state.map(\.effectSpan).dropFirst().removeDuplicates().sink { [weak self] effectSpan in
            self?.valueDidUpdateClosure?(effectSpan)
        }.add(to: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonDidTap(button: UIButton) {
        guard let selectedButton = ButtonKind(rawValue: button.tag) else {
            return
        }

        guard selectedButton != state.value.selectedButton else {
            return
        }

        state.mutate { state in
            state.selectedButton = selectedButton
            state.number = 0
        }
    }

    func bindValueDidUpdate(closure: @escaping (ShimmerView.EffectSpan) -> ()) {
        self.valueDidUpdateClosure = closure
    }
}

extension EffectSpanInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            return true
        }

        if !allowedCharSet.isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }

        let newString = (textField.text ?? "") + string
        return newString.count <= EffectSpanInputView.maxCharacterCount
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
            textField.text = numberFormatter.string(for: state.value.number)
            return
        }

        state.mutate(\.number, CGFloat(convertedValue))
    }
}
