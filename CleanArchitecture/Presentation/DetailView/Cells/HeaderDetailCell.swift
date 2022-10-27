//
//  HeaderDetailCell.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.10.2022.
//

import UIKit

class HeaderDetailCell: UICollectionViewCell {
    static let reuseIdentifier = "HeaderDetailCell"
    private var viewModel: HeaderDetailCellViewModel!
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    private let recipeNameLabel: UILabel  = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    private let recipeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        return image
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackView)
        [recipeNameLabel, recipeImage].forEach { view in
            stackView.addArrangedSubview(view)
        }
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: HeaderDetailCellViewModel?) {
        stackView.frame = self.frame
        self.viewModel = viewModel
        recipeNameLabel.text = viewModel?.title
        recipeImage.updateImage(url: viewModel?.imageURL)
    }
    
    // MARK: - private
    private func setConstraints() {
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeNameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            recipeNameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 16),
            recipeNameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            recipeImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            recipeImage.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: recipeImage.trailingAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: recipeImage.bottomAnchor, constant: 0)
        ])
    }
}
