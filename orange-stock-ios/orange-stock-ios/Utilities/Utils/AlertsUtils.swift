//
//  AlertsUtils.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/22.
//

import UIKit

/// UIViewController: show Alert
extension UIViewController {
    func showAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction]
    ) {
        let alertViewController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        actions.forEach {
            alertViewController.addAction($0)
        }
        self.present(alertViewController, animated: true)
    }
}

/// UIAlertAction: 기본적으로 사용하는 alertAction
extension UIAlertAction {
    /// 확인
    static var confirm: UIAlertAction {
        return UIAlertAction(title: "확인", style: .default)
    }
    /// 취소
    static var cancel: UIAlertAction {
        return UIAlertAction(title: "취소", style: .cancel)
    }
}
