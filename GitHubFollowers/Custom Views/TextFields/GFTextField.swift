//
//  GFTextField.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 10.12.2020.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor

        //standart color for textfield text
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        //if sameone using very long name font will bi shrinks, text will be fit in textField
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12

        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        clearButtonMode = .whileEditing

        returnKeyType = .go
        placeholder = "Enter a username"
    }
}
