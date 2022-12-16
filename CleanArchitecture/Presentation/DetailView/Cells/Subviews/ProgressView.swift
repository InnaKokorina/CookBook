//
//  ProgressView.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 15.11.2022.
//

import UIKit

class ProgressView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}
