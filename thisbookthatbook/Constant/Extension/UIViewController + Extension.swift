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
        let confirm = UIAlertAction(title: "alert_action_confirm".localized, style: .default, handler: completionHandler)
        let cancel = UIAlertAction(title: "alert_action_cancel".localized, style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        transition(alert, type: .present)
    }
    
    func showAlertOnlyConfirm(title: String = "", message: String, completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "alert_action_confirm".localized, style: .default, handler: completionHandler)
        alert.addAction(confirm)
        transition(alert, type: .present)
    }
    
    func showActionSheet(modifyHandler: @escaping (UIAlertAction) -> Void, deleteHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modify = UIAlertAction(title: "alert_action_modify".localized, style: .default, handler: modifyHandler)
        let delete = UIAlertAction(title: "alert_action_delete_post".localized, style: .destructive, handler: deleteHandler)
        let cancel = UIAlertAction(title: "alert_action_cancel".localized, style: .cancel)
        alert.addAction(modify)
        alert.addAction(delete)
        alert.addAction(cancel)
        transition(alert, type: .present)
    }
    
    func showToast(message: String) {
        var style = ToastStyle()
        style.backgroundColor = Resource.Colors.primaryColor
        style.messageColor = Resource.Colors.white
        view.makeToast(message, style: style)
    }
    
    func setNewScene(_ rootVC: UIViewController) {
        // 화면이 쌓이지 않은 채 등장!
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        // 가져온 windowScene의 sceneDelegate 정의
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        // 처음 보여질 화면 root로 설정하고 보여주기
        sceneDelegate?.window?.rootViewController = rootVC
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
