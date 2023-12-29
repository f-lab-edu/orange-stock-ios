//
//  LoginViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/17.
//

import UIKit
import SnapKit

/// View: 로그인
final class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    let viewModel = LoginViewModel()
    
    // MARK: Enum
    private enum Metric {
        static let orangeLabelInset = 30.0
        static let orangeLabelOffSet = -100.0
        static let logoLabelHeight = 64.0
        static let appleLoginButtonOffset = 120.0
        static let appleLoginButtonHeight = 50.0
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bindLoginViewModel()
    }
    
    // MARK: Bind
    
    func bindLoginViewModel() {
        bindLoginStatus()
        bindLoginErrorMessage()
    }
    
    private func bindLoginStatus() {
        viewModel.isSucceedLogin.bind { success in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.setViewControllers(
                        [FavoriteStockListViewController()],
                        animated: true
                    )
                }
            }
        }
    }
    
    private func bindLoginErrorMessage() {
        viewModel.errorMessage.bind { errMsg in
            guard let message = errMsg else { return }
            DispatchQueue.main.async {
                self.showAlert(
                    title: nil,
                    message: message,
                    actions: [.confirm]
                )
            }
        }
    }
    
    // MARK: Actions
    /// 애플 로그인 버튼 터치
    @objc func touchAppleLoginButton() {
        viewModel.didTouchAppleLoginButton()
    }
}

// MARK: - Layout

extension LoginViewController: LayoutProtocol {
    
    func layout() {
        self.view.backgroundColor = .background
        let orangeLabel = makeLogoLabel(title: "ORANGE",
                                        textColor: .mainTint)
        let stockLabel = makeLogoLabel(title: "STOCK🍊",
                                       textColor: .basic)
        let appleLoginButton = viewModel.makeAppleLoginButton()
        appleLoginButton.addTarget(self,
                                   action: #selector(touchAppleLoginButton),
                                   for: .touchUpInside)
        
        constraints(orangeLabel,
                    stockLabel,
                    appleLoginButton)
    }
    
    // MARK: Attributes
    
    func makeLogoLabel(title: String,
                       textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = textColor
        
        label.font = .logoLabel
        label.textAlignment = .center
        return label
    }
    
    // MARK: Constraint
    
    func constraints(_ orangeLabel: UILabel,
                     _ stockLabel: UILabel,
                     _ appleLoginButton: UIControl) {
        [orangeLabel, stockLabel, appleLoginButton]
            .forEach {
            view.addSubview($0)
        }
        
        orangeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.orangeLabelInset)
            $0.centerY.equalToSuperview().offset(Metric.orangeLabelOffSet)
            $0.height.equalTo(Metric.logoLabelHeight)
        }
        
        stockLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(orangeLabel)
            $0.top.equalTo(orangeLabel.snp.bottom)
            $0.height.equalTo(Metric.logoLabelHeight)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(orangeLabel)
            $0.top.equalTo(stockLabel.snp.bottom).offset(Metric.appleLoginButtonOffset)
            $0.height.equalTo(Metric.appleLoginButtonHeight)
        }
    }
}

