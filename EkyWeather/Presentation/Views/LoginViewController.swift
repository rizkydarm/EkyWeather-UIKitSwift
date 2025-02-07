//
//  ViewController.swift
//  EkyWeather
//
//  Created by Eky on 18/01/25.
//

import UIKit
import SnapKit
import Combine
import FloatingPanel

class LoginViewController: UIViewController {
    
    private let fpc = FloatingPanelController()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.addDoneButton()
        
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .quaternarySystemFill
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.addDoneButton()
        
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .quaternarySystemFill
        
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .accent
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addBounceAnimation()
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .accent
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addBounceAnimation()
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Eky Weather"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.titleLabel
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login & Register"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor.titleLabel
        return label
    }()
    
    private let logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "LogoImage"))
        image.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 32
        image.clipsToBounds = true
        return image
    }()

    private var notchView: UIView = {
        let view = UIView(
            frame: CGRect(x: 0, y: 0, width: 0, height: 0),
            color: UIColor.primary)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupFloatingPanel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(notchView)
        notchView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(getNotchHeight())
        }
        
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.systemBackground
        
        titleLabel.font = .systemFont(ofSize: FontUtility.scaledFontSize(baseFontSize: 52, minimumFontSize: 32), weight: .bold)
        
        view.addSubviews(
            logoImage,
            titleLabel,
            loginButton,
            registerButton,
            skipButton
        )
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.snp.left).offset(20)
            make.width.equalTo(SizeUtility.resizeDimension(160))
            make.height.equalTo(SizeUtility.resizeDimension(160))
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(registerButton.snp.top).offset(-20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(skipButton.snp.top).offset(-32)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        skipButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.frame.width*0.3)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(navigateToHome), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        showFloatingPanel("Login")
    }
    
    @objc private func registerButtonTapped() {
        showFloatingPanel("Register")
    }
    
    @objc private func navigateToHome() {
        let homeVC = MainTabBarViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
        
    private func setupFloatingPanel() {
        fpc.delegate = self
        
        fpc.layout = LoginFloatingPanelLayout()
        fpc.behavior = LoginFloatingPanelBehavior()
    
        fpc.isRemovalInteractionEnabled = true
        
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        
        fpc.surfaceView.appearance.cornerRadius = 40
        fpc.surfaceView.appearance.backgroundColor = .clear
        
        fpc.surfaceView.grabberHandle.barColor = .quaternaryLabel
        fpc.surfaceView.grabberHandleSize = CGSize(width: 100, height: 8)
    }

    private func showFloatingPanel(_ label: String) {
        let vc = LoginFloatingViewController()
        vc.label = label
        fpc.set(contentViewController: vc)
        fpc.addPanel(toParent: self)
        fpc.show(animated: true) { [weak self] in
            self?.fpc.didMove(toParent: self)
        }
    }
    
    private func hideFloatingPanel() {
        fpc.willMove(toParent: nil)
        fpc.hide(animated: true) { [weak self] in
            self?.fpc.removePanelFromParent(animated: false)
            self?.fpc.removeFromParent()
        }
    }
}

extension LoginViewController: FloatingPanelControllerDelegate {
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {

    }
}

class LoginFloatingPanelLayout: FloatingPanelLayout {
    
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .half
    var supportedStates: Set<FloatingPanelState> = [.half, .full]
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .full: FloatingPanelLayoutAnchor(fractionalInset: 0.8, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
            case .full, .half: return 0.5
            default: return 0.0
        }
    }
}

class LoginFloatingPanelBehavior: FloatingPanelBehavior {
    let springDecelerationRate = UIScrollView.DecelerationRate.fast.rawValue + 0.02
    let springResponseTime = 2.0
    
    func shouldProjectMomentum(_ fpc: FloatingPanelController, to proposedState: FloatingPanelState) -> Bool {
        return true
    }
}

class LoginFloatingViewController: UIViewController {
    
    var label: String?
    
    private let viewModel = LoginViewModel(authUseCase: AuthUseCaseImpl())
    private var cancellables = Set<AnyCancellable>()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.addDoneButton()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .quaternarySystemFill
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.addDoneButton()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .quaternarySystemFill
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .accent
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addBounceAnimation()
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.titleLabel
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupKeyboardObservers()
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let fpc = parent as? FloatingPanelController {
            fpc.move(to: .full, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let fpc = parent as? FloatingPanelController {
            fpc.move(to: .half, animated: true)
        }
    }

    @objc private func submitButtonTapped() {
        if (label == "Login") {
            viewModel.login()
        } else if (label == "Register") {
            viewModel.register()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        titleLabel.text = label ?? "-"
        titleLabel.font = .systemFont(ofSize: FontUtility.scaledFontSize(baseFontSize: 24, minimumFontSize: 16), weight: .bold)
        submitButton.setTitle(label ?? "Submit", for: .normal)
        
        view.addSubviews(
            titleLabel,
            emailTextField,
            passwordTextField,
            submitButton
        )
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(20)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(20)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.height.equalTo(48)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupBindings() {
        
        emailTextField.publisher(for: \.text)
            .compactMap { $0 }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
            
        passwordTextField.publisher(for: \.text)
            .compactMap { $0 }
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)

        viewModel.$isLoggedIn
            .sink { [weak self] isLoggedIn in
                if isLoggedIn {
                    self?.navigateToHome()
                }
            }
            .store(in: &cancellables)
            
        viewModel.$isSubmitLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.submitButton.showActivityIndicator()
                } else {
                    self?.submitButton.hideActivityIndicator()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .sink { [weak self] error in
                if let error = error {
                    self?.showToast(message: error)
                    self?.viewModel.error = nil
                }
            }
            .store(in: &cancellables)
    }

    private func navigateToHome() {
        let homeVC = MainTabBarViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }

}

@available(iOS 17, *)
#Preview {
    LoginViewController()
 }
