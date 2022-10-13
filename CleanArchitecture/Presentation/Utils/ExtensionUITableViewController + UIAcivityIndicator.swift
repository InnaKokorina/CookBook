//
//  ExtensionUITableViewController + UIAcivityIndicator.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 13.10.2022.
//

import Foundation
import UIKit

extension UITableViewController {
    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style
        if #available(iOS 12.0, *) {
                style = UIActivityIndicatorView.Style.medium
        } else {
            style = .gray
        }
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)
        return activityIndicator
    }
}
