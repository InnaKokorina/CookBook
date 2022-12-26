//
//  TimeProgressView.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 16.12.2022.
//

import UIKit


@IBDesignable class TimeProgressView: UIView {
    
    @IBOutlet weak var internalView: UIView!
    @IBOutlet weak var internalLabel: UILabel!
    
    private var viewModel: CookingTimeCellViewModel?
    private var firstGradientColor: UIColor  = .black
    private var secondGradientColor: UIColor = .black
    private var gradientLineWidth: CGFloat = 1
    
    // MARK: - @IBInspectable
    
    @IBInspectable public var firstColor: UIColor {
        get {
            self.firstGradientColor
        }
        set {
            firstGradientColor = newValue
        }
    }
    
    @IBInspectable public var secondColor: UIColor {
        get {
            firstGradientColor
        }
        set {
            self.secondGradientColor = newValue
        }
    }
    @IBInspectable public var progreessLineWidth: CGFloat {
        get {
            gradientLineWidth
        }
        set {
            self.gradientLineWidth = newValue
        }
    }
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func create() -> TimeProgressView? {
        let bundle = Bundle(for: TimeProgressView.self)
        let nib = UINib(nibName: "TimeProgressView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? TimeProgressView
        view?.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin]
        return view
    }
    
    func configure(with viewModel: CookingTimeCellViewModel?)  {
        self.viewModel = viewModel
        guard let viewModel = viewModel else { return }
        internalView.layer.cornerRadius = internalView.bounds.height/2
        internalLabel.text = String(viewModel.cookingTime ?? 0) + " мин"
        drawCircle(with: viewModel, firstColor: firstGradientColor.cgColor, secondColor: secondGradientColor.cgColor, lineWidth: gradientLineWidth)
    }
    
    private func drawCircle(with viewModel: CookingTimeCellViewModel?, firstColor: CGColor?, secondColor: CGColor?, lineWidth: CGFloat? ) {
        guard let firstColor = firstColor,
              let secondColor = secondColor,
              let lineWidth = lineWidth,
              let viewModel = viewModel else { return }
        self.drawCircleProgressView(on: self, till: viewModel.cookingTimeInPercent(), firstGradientColor: firstColor, secondGradientColor: secondColor, lineWidth: lineWidth)
        internalView.setGradient(firstColor: firstColor, secondColor: secondColor)
    }
}
 
