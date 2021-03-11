//
//  UIViewController+Extension.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 01.02.2021.
//

import UIKit
import SafariServices

extension UIViewController {

    // MARK: - Shows custom Alert
    func presentAlertViewController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVc = GFAlertViewController(title: title, message: message, buttontitle: buttonTitle)
            alertVc.modalPresentationStyle = .overFullScreen
            alertVc.modalTransitionStyle = .crossDissolve
            self.present(alertVc, animated: true)
        }
    }

    // MARK: - Present Safari View Controller
    func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemGreen
        present(safariViewController, animated: true)
    }
}
