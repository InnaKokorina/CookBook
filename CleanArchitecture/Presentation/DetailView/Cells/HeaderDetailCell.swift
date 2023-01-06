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
    
    private let baseView : UIView = {
        let baseView = UIView()
        baseView.backgroundColor = .clear
        baseView.clipsToBounds = false
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.5
        baseView.layer.shadowOffset = CGSize(width: -3, height: 3)
        baseView.layer.shadowRadius = 3
        return baseView
    }()
    private let recipeNameLabel: UILabel  = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    private let recipeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 15
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
        [recipeNameLabel, baseView].forEach { view in
            stackView.addArrangedSubview(view)
        }
        baseView.addSubview(recipeImage)
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
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeNameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            recipeNameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 16),
            recipeNameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8),
            recipeNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            baseView.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            recipeImage.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0),
            recipeImage.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 0),
            recipeImage.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 0),
            recipeImage.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0),
        ])
    }
}
