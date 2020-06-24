import UIKit
import ShimmerView

class BasicViewController: UIViewController {
    
    private var constrationForScrollViewBottom: NSLayoutConstraint?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var centeringView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shimmerView)
        NSLayoutConstraint.activate([
            shimmerView.topAnchor.constraint(equalTo: view.topAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            shimmerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shimmerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        return view
    }()
    
    private lazy var shimmerView: ShimmerView = {
        let view = ShimmerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: view.heightAnchor)
        ])
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let baseColorInputView: ColorInputView = {
        let view = ColorInputView(kind: .base, defaultValue: .magenta)
        return view
    }()
    
    private let highlightColorInputView: ColorInputView = {
        let view = ColorInputView(kind: .highlight, defaultValue: .magenta)
        return view
    }()
    
    private let durationInputView: NumberInputView = {
        let view = NumberInputView(kind: .duration, defaultValue: 0)
        return view
    }()
    
    private let intervalInputView: NumberInputView = {
        let view = NumberInputView(kind: .interval, defaultValue: 0)
        return view
    }()
    
    private let effectSpanInputView: EffectSpanInputView = {
        let view = EffectSpanInputView(effectSpan: .points(120))
        return view
    }()
    
    private let effectAngleInputView: EffectAngleInputView = {
        let view = EffectAngleInputView(defaultValue: 0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.frameLayoutGuide.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.frameLayoutGuide.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        constrationForScrollViewBottom = scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        constrationForScrollViewBottom?.isActive = true
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        stackView.addArrangedSubview(SpacerView(height: 36))
        
        stackView.addArrangedSubview(centeringView)
        stackView.setCustomSpacing(36, after: centeringView)
        
        stackView.addArrangedSubview(baseColorInputView)
        stackView.addArrangedSubview(SpacerView(height: 1.0, leftPadding: 16, backgroundColor: .separator))
        stackView.addArrangedSubview(highlightColorInputView)
        stackView.addArrangedSubview(SpacerView(height: 1.0, leftPadding: 16, backgroundColor: .separator))
        stackView.addArrangedSubview(durationInputView)
        stackView.addArrangedSubview(SpacerView(height: 1.0, leftPadding: 16, backgroundColor: .separator))
        stackView.addArrangedSubview(intervalInputView)
        stackView.addArrangedSubview(SpacerView(height: 1.0, leftPadding: 16, backgroundColor: .separator))
        stackView.addArrangedSubview(effectSpanInputView)
        stackView.addArrangedSubview(SpacerView(height: 1.0, leftPadding: 16, backgroundColor: .separator))
        stackView.addArrangedSubview(effectAngleInputView)
        
        stackView.addArrangedSubview(SpacerView(height: 36))
        
        shimmerView.startAnimating()
        
        bind()
    }
    
    private func bind() {
        baseColorInputView.bindValueDidUpdate { value in
            print("Base Color: \(value)")
        }
        
        highlightColorInputView.bindValueDidUpdate { value in
            print("Highlight Color: \(value)")
        }
        
        durationInputView.bindValueDidUpdate { value in
            print("Duration: \(value)")
        }
        
        intervalInputView.bindValueDidUpdate { value in
            print("Duration: \(value)")
        }
        
        effectSpanInputView.bindValueDidUpdate { value in
            print("Effect Span: \(value)")
        }
        
        effectAngleInputView.bindValueDidUpdate { value in
            print("Effect Angle: \(value)")
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        // animation key
        guard let animationKey = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        let animationOption = UIView.AnimationOptions(rawValue: animationKey)
        
        // duration
        guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
    
        guard let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        constrationForScrollViewBottom?.constant = -endFrame.height
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: animationOption,
                       animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        // animation key
        guard let animationKey = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        let animationOption = UIView.AnimationOptions(rawValue: animationKey)
        
        // duration
        guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        constrationForScrollViewBottom?.constant = 0
            
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: animationOption,
                       animations: {
            self.view.layoutIfNeeded()
        })
    }
}
