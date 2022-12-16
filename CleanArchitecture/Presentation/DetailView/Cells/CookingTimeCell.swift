//
//  CookingTimeCell.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.11.2022.
//

import UIKit

class CookingTimeCell: UICollectionViewCell {
    static let reuseIdentifier = "CookingTimeCell"
    private var viewModel: CookingTimeCellViewModel?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var internalView: UIView!
    @IBOutlet weak var internalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeView.layer.cornerRadius = timeView.bounds.height/2
        internalView.layer.cornerRadius = internalView.bounds.height/2
        
    }
    func configure(with viewModel: CookingTimeCellViewModel?) {
        self.viewModel = viewModel
        guard let viewModel = viewModel else { return }
        internalLabel.text = String(viewModel.cookingTime ?? 0) + " мин"
        print("cookingTime =\(viewModel.cookingTime)")
        contentView.drawCircleProgressView(on: timeView, till: viewModel.setStrokeEndValue())
    }
    
}
