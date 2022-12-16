//
//  UIView.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 15.12.2022.
//

import UIKit

extension UIView {
    
    func drawCircleProgressView(on view: UIView, till value: Float ) {
        let layer = CAShapeLayer()
        let endAngle = Math().percentToRadians(percentComplete: CGFloat(value))
        let startAngle = (3.0 * CGFloat.pi) / 2.0
        let thickness: CGFloat = 6
        
        let path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: view.frame.width/2 - thickness/2 , startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        
        layer.path = path.cgPath
        layer.strokeColor = UIColor(red: 150/255, green: 148/255, blue: 255/255, alpha: 1).cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 6
        layer.lineCap = .round
        let animation = CABasicAnimation()
        
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3.0
        layer.add(animation, forKey: nil)
        self.layer.addSublayer(layer)
    }
    
    class Math {
        func percentToRadians(percentComplete: CGFloat) -> CGFloat {
            let degrees = (percentComplete) * 360
            let startAngle = (3.0 * CGFloat.pi) / 2.0
            return startAngle + (degrees * (CGFloat.pi/180))
        }
    }
}


