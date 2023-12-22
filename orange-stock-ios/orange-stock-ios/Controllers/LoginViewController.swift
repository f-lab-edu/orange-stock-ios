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
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    // MARK: Bind
    
    func bind() {
        viewModel.isSucceedLogin.bind { success in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.setViewControllers([FavoriteStockListViewController()], animated: true)
                }
            }
        }
        viewModel.errorMessage.bind { errMsg in
            guard let message = errMsg
                else { return }
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
        appleLoginButton.addTarget(self, action: #selector(touchAppleLoginButton), for: .touchUpInside)
        
        constraints(orangeLabel,
                    stockLabel,
                    appleLoginButton)
    }
    
    // MARK: Attributes
    
    func makeLogoLabel(title: String,
                       textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 60.0, weight: .semibold)
        label.textColor = textColor
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
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.centerY.equalToSuperview().offset(-100.0)
            $0.height.equalTo(64.0)
        }
        
        stockLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(orangeLabel)
            $0.top.equalTo(orangeLabel.snp.bottom)
            $0.height.equalTo(64.0)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(orangeLabel)
            $0.top.equalTo(stockLabel.snp.bottom).offset(120)
            $0.height.equalTo(50.0)
        }
    }
}
