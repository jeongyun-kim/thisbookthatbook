//
//  UIViewController + Extension.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import UIKit
import Toast

extension UIViewController {
    func transition(_ vc: UIViewController, type: Resource.TransitionType = .push) {
        switch type {
        case .push:
            navigationController?.pushViewController(vc, animated: true)
        case .present:
            present(vc, animated: true)
        }
    }
    
    func showAlertTwoBtns(title: String, message: String, completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: Resource.AlertActionType.confirm.localized, style: .default, handler: completionHandler)
        let cancel = UIAlertAction(title: Resource.AlertActionType.cancel.localized, style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
    }
    
    func showAlertOnlyConfirm(title: String, message: String, completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: Resource.AlertActionType.confirm.localized, style: .default, handler: completionHandler)
        alert.addAction(confirm)
    }
    
    func showToast(message: String) {
        var style = ToastStyle()
        style.backgroundColor = Resource.Colors.primaryColor
        style.messageColor = Resource.Colors.white
        view.makeToast(message, style: style)
    }
}
