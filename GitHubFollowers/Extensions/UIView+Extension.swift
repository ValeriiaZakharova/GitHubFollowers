//
//  UIView+Extension.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 15.03.2021.
//

import UIKit
///... - variatic parametr, now you can pass any number subviews into our addSubviews, UIView...- it automaticly terns views into an array that you can use in the scope of function

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }

    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
}
