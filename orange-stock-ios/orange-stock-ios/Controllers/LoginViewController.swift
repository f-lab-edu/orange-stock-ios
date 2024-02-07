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
    
    // MARK: Enum
    
    private enum Metric {
        static let orangeLabelInset = 30.0
        static let orangeLabelOffSet = -100.0
        static let logoLabelHeight = 64.0
        static let appleLoginButtonOffset = 120.0
        static let appleLoginButtonHeight = 50.0
    }
    
    // MARK: UIComponents
    
    private struct LoginViewUIComponents {
        let orangeLabel = UILabel()
        let stockLabel = UILabel()
        let appleLoginButton = AppleLoginHelper.makeAppleLoginButton()
    }
    
    // MARK: Properties
    
    let viewModel = LoginViewModel()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bindLoginViewModel()
    }
    
    // MARK: Actions
    /// 애플 로그인 버튼 터치
    @objc func touchAppleLoginButton() {
        viewModel.didTouchAppleLoginButton()
    }
}

// MARK: - Layout

extension LoginViewController: LayoutProtocol {
    
    private typealias SubViews = LoginViewUIComponents
    
    func layout() {
        let subViews: SubViews = LoginViewUIComponents()
        attributes(subViews)
        constraints(subViews)
    }
    
    // MARK: Attributes
    
    private func attributes(_ views: SubViews) {
        setBackgroundViewColor()
        setLogoLabelAttribute(for: views.orangeLabel, title: "ORANGE", textColor: .mainTint)
        setLogoLabelAttribute(for: views.stockLabel, title: "STOCK🍊", textColor: .basic)
        views.appleLoginButton.addTarget(self,
                                         action: #selector(touchAppleLoginButton),
                                         for: .touchUpInside)
    }
    
    private func setBackgroundViewColor() {
        self.view.backgroundColor = .background
    }
    
    private func setLogoLabelAttribute(for label: UILabel, title: String, textColor: UIColor) {
        label.text = title
        label.textColor = textColor
        
        label.font = .logoLabel
        label.textAlignment = .center
    }
    
    // MARK: Constraints
    
    private func constraints(_ views: SubViews) {
        [views.orangeLabel, views.stockLabel, views.appleLoginButton].forEach {
            view.addSubview($0)
        }
        setOrangeLabelConstraints(for: views.orangeLabel)
        setStockLabelConstraints(for: views.stockLabel, with: views.orangeLabel)
        setAppleLoginButtonConstraints(for: views.appleLoginButton, with: views.stockLabel)
    }
    
    private func setOrangeLabelConstraints(for orangeLabel: UILabel) {
        orangeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.orangeLabelInset)
            $0.centerY.equalToSuperview().offset(Metric.orangeLabelOffSet)
            $0.height.equalTo(Metric.logoLabelHeight)
        }
    }
    
    private func setStockLabelConstraints(for stockLabel: UILabel,
                                          with orangeLabel: UILabel) {
        stockLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(orangeLabel)
            $0.top.equalTo(orangeLabel.snp.bottom)
            $0.height.equalTo(Metric.logoLabelHeight)
        }
    }
    
    private func setAppleLoginButtonConstraints(for appleLoginButton: UIControl,
                                                with stockLabel: UILabel) {
        appleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(stockLabel)
            $0.top.equalTo(stockLabel.snp.bottom).offset(Metric.appleLoginButtonOffset)
            $0.height.equalTo(Metric.appleLoginButtonHeight)
        }
    }
}


// MARK: Bind

extension LoginViewController {
    
    func bindLoginViewModel() {
        bindLoginStatus()
        bindLoginErrorMessage()
    }
    
    private func bindLoginStatus() {
        viewModel.isSucceedLogin.bind { success in
            if success {
                DispatchQueue.main.async {
                     // 로그인 성공 시 NavigationController의 rootViewController을
                     // 로그인뷰 -> 관심주식뷰(FavoriteStockListViewController)로 강제 변경하여
                     // 로그인 상태에서는 로그인 뷰를 노출하지 않도록 한다.
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
}
