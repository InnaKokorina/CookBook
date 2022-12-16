//
//  ProgressViewBase.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 15.11.2022.
//

import Foundation
import UIKit

@IBDesignable class ProgressViewBase: UIProgressView {
    
    @IBInspectable var myColor: UIColor = .green {
        didSet {
            self.tintColor = myColor
        }
    }
    @IBInspectable var myWidth: CGFloat = 66 {
        didSet {
            self.frame.size.width = myWidth
        }
    }
    @IBInspectable var myHeight: CGFloat = 66 {
        didSet {
            self.frame.size.height = myHeight
        }
    }
}
