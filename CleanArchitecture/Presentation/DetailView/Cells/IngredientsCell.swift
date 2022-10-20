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
    private var imageRepository: ImagesRepositoryPrototcol?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    private let ingredientImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
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
    
    func configure(with viewModel: IngredientsViewModel?, imageRepository: ImagesRepositoryPrototcol?) {
        self.viewModel = viewModel
        self.imageRepository = imageRepository
        updateImage()
        ingredientNameLabel.text = viewModel?.ingredientName
    }
    // MARK: - private
    private func updateImage() {
        ingredientImage.image = nil
        guard let imagePath = viewModel.ingredientImagePath else { return }
        imageLoadTask = imageRepository?.fetchIngredientImage(with: imagePath) { [weak self] result in
            guard let self = self else { return }
            if case let .success(data) = result {
                self.ingredientImage.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
    }
    
    private func setConstraints() {
        ingredientImage.translatesAutoresizingMaskIntoConstraints = false
        ingredientNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ingredientImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            ingredientImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: ingredientImage.trailingAnchor, constant: 4),
            ingredientImage.widthAnchor.constraint(equalToConstant: self.frame.width * 0.9)
        ])
        NSLayoutConstraint.activate([
            ingredientNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            ingredientNameLabel.topAnchor.constraint(equalTo: ingredientImage.bottomAnchor, constant: 4),
            contentView.trailingAnchor.constraint(equalTo: ingredientNameLabel.trailingAnchor, constant: 4),
            contentView.bottomAnchor.constraint(equalTo: ingredientNameLabel.bottomAnchor, constant: 0)
        ])
    }
}
