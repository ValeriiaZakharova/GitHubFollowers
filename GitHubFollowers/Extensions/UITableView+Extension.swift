//
//  UITableView+Extension.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 15.03.2021.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
