//
//  UIView.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 15.12.2022.
//

import UIKit

extension UIView {
    
    func drawCircleProgressView(on view: UIView, till value: Float, firstGradientColor: CGColor, secondGradientColor: CGColor, lineWidth: CGFloat) {
        let shapeLayer = CAShapeLayer()
        let endAngle = Math().percentToRadians(percentComplete: CGFloat(value))
        let startAngle = (3.0 * CGFloat.pi) / 2.0
        let thickness: CGFloat = 6
        let path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: view.frame.width/2 - thickness/2 , startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
      
        let animation = CABasicAnimation()
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3.0
        shapeLayer.add(animation, forKey: nil)
        view.layer.addSublayer(shapeLayer)
        
        view.setGradient(maskLayer: shapeLayer, firstColor: firstGradientColor, secondColor: secondGradientColor)
    }
    
    func setGradient(maskLayer: CALayer? = nil, firstColor: CGColor, secondColor: CGColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor, secondColor]
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        gradient.mask = maskLayer
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    class Math {
        func percentToRadians(percentComplete: CGFloat) -> CGFloat {
            let degrees = (percentComplete) * 360
            let startAngle = (3.0 * CGFloat.pi) / 2.0
            return startAngle + (degrees * (CGFloat.pi/180))
        }
    }
   
}


