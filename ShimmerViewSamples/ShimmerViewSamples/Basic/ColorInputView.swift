import UIKit
import Combine

class ColorInputView: UIView {
    struct State: Equatable {
        var r: Int
        var g: Int
        var b: Int
        
        init(color: UIColor) {
            let components = color.components
            r = Int(components.red*255)
            g = Int(components.green*255)
            b = Int(components.blue*255)
        }
        
        var uiColor: UIColor {
            UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
        }
    }
    
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
        let view = ColorElementInputView(kind: .r, defaultValue: state.value.r)
        return view
    }()
    
    private lazy var gInputView: ColorElementInputView = {
        let view = ColorElementInputView(kind: .g, defaultValue: state.value.g)
        return view
    }()
    
    private lazy var bInputView: ColorElementInputView = {
        let view = ColorElementInputView(kind: .b, defaultValue: state.value.b)
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
    
    private var valueDidUpdateClosure: ((UIColor) -> Void)?
    private var state: CurrentValueSubject<State, Never>
    private var disposeBag = DisposeBag()
    
    init(kind: Kind, defaultValue: UIColor) {
        state = CurrentValueSubject(State(color: defaultValue))

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
        
        rInputView.bindValuDidChange { [weak self] newValue in
            self?.state.mutate(\.r, newValue)
        }
        
        gInputView.bindValuDidChange { [weak self] newValue in
            self?.state.mutate(\.g, newValue)
        }
        
        bInputView.bindValuDidChange { [weak self] newValue in
            self?.state.mutate(\.b, newValue)
        }
        
        state.removeDuplicates().sink { [weak self] output in
            self?.colorCircleView.backgroundColor = output.uiColor
        }.add(to: disposeBag)
        
        state.dropFirst().removeDuplicates().sink { [weak self] output in
            self?.valueDidUpdateClosure?(output.uiColor)
        }.add(to: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindValueDidUpdate(closure: @escaping (UIColor) -> Void) {
        valueDidUpdateClosure = closure
    }
}
