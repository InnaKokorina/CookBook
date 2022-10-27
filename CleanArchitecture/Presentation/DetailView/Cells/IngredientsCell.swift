//
//  IngredientsCell.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.10.2022.
//

import UIKit

class IngredientsCell: UICollectionViewCell {
    static let reuseIdentifier = "IngredientsCell"
    private var viewModel: IngredientsViewModel!
   
    private let ingredientImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        return image
    }()
    private let ingredientNameLabel: UILabel  = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(ingredientImage)
        contentView.addSubview(ingredientNameLabel)
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: IngredientsViewModel?) {
        self.viewModel = viewModel
        ingredientNameLabel.text = viewModel?.ingredientName
        if let imageURL = viewModel?.ingredientImagePath {
            ingredientImage.updateImage(url: imageURL)
        } else {
            ingredientImage.image = UIImage(named: Constants.placeholderImage)
        }
    }
    // MARK: - private

    private func setConstraints() {
        ingredientImage.translatesAutoresizingMaskIntoConstraints = false
        ingredientNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ingredientImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            ingredientImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: ingredientImage.trailingAnchor, constant: 4),
            ingredientImage.widthAnchor.constraint(equalToConstant: self.frame.width * 0.9),
            ingredientImage.heightAnchor.constraint(equalToConstant: self.frame.width * 0.9)
        ])
        NSLayoutConstraint.activate([
            ingredientNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            ingredientNameLabel.topAnchor.constraint(equalTo: ingredientImage.bottomAnchor, constant: 4),
            contentView.trailingAnchor.constraint(equalTo: ingredientNameLabel.trailingAnchor, constant: 4),
            contentView.bottomAnchor.constraint(equalTo: ingredientNameLabel.bottomAnchor, constant: 0)
        ])
    }
}
