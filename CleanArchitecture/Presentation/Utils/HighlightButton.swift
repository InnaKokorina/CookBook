//
//  HighlightButton.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.01.2023.
//

import UIKit

@IBDesignable class HighlightButton: UIButton {
    
    @IBInspectable var normalBackgroundColor: UIColor? = .clear  {
        didSet {
            backgroundColor = normalBackgroundColor
        }
    }
    
    @IBInspectable var highlightedBackgroundColor: UIColor? = .systemGray5
    
    var highlightDuration: TimeInterval = 0.25
    
    override var isHighlighted: Bool {
        didSet {
            if oldValue == false && isHighlighted {
                highlight()
            } else if oldValue == true && !isHighlighted {
                unHighlight()
            }
        }
    }
    
    private func highlight() {
        animateBackground(to: highlightedBackgroundColor, duration: highlightDuration)
    }
    
    private func unHighlight() {
        animateBackground(to: normalBackgroundColor, duration: highlightDuration)
    }
    
    private func animateBackground(to color: UIColor?, duration: TimeInterval) {
        guard let color = color else { return }
        UIView.animate(withDuration: highlightDuration) {
            self.backgroundColor = color
        }
    }
}
