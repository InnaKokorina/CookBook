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
            return label
        }()
    private lazy var stackView = UIStackView(arrangedSubviews: [recipeImage, titleLabel])
   
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
    }
    
    func configure(image: String) {
        titleLabel.text = "Рецепт"
        recipeImage.image = UIImage(named: "Person")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImage.image = nil
    }
    
    private func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
