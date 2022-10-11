//
//  MainTableViewCell.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    static var cellId = "TableViewCell"
    
    private var viewModel: MainCellViewModel!
    private var imagesRepository: ImagesRepositoryPrototcol?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    private let recipeImage: UIImageView = {
            let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.layer.masksToBounds = false
            image.clipsToBounds = true
            image.layer.cornerRadius = 15
            return image
        }()
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }()
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel,recipeImage])
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
        selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalCentering
    }
    
    func configure(with viewModel: MainCellViewModel, imagesRepository: ImagesRepositoryPrototcol?) {
        self.viewModel = viewModel
        self.imagesRepository = imagesRepository
        titleLabel.text = viewModel.title ?? ""
        updatePosterImage(width: 100)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImage.image = nil
    }
    
    private func updatePosterImage(width: Int) {
        recipeImage.image = nil
        guard let posterImagePath = viewModel.imagePath?.deletingPrefix("https://spoonacular.com") else { return }

        imageLoadTask = imagesRepository?.fetchImage(with: posterImagePath, width: width) { [weak self] result in
            guard let self = self else { return }
            if case let .success(data) = result {
                self.recipeImage.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
    }
    
    private func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 4),
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: recipeImage.leadingAnchor, constant: 4),
            titleLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            recipeImage.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -2),
            recipeImage.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 2),
            stackView.trailingAnchor.constraint(equalTo: recipeImage.trailingAnchor, constant: -2),
            recipeImage.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
