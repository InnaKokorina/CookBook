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
    @IBOutlet weak var timeView: TimeProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        timeView.layer.cornerRadius = timeView.bounds.height/2
    }
    
    func configure(with viewModel: CookingTimeCellViewModel?) {
        self.viewModel = viewModel
        guard let viewModel = viewModel,
              let progressBarView = TimeProgressView.create() else { return }
        timeView.addSubview(progressBarView)
        progressBarView.configure(with: viewModel)
    }
}
