//
//  UIViewControlle+Extension.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, message: String, onClose: (() -> Void)?) {
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertCloseButton = UIAlertAction(title: "OK", style: .cancel) { _ in
            guard let onCloseHandler = onClose else { return }
            onCloseHandler()
        }
        newAlert.addAction(alertCloseButton)
        self.present(newAlert, animated: true)
    }
}
