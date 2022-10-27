//
//  MainTableViewCell.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import UIKit
import Kingfisher
import SwiftUI

class MainTableViewCell: UITableViewCell {
    static var cellId = "TableViewCell"
    
    private var viewModel: MainCellViewModel!
    
    private var recipeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
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
    
    func configure(with viewModel: MainCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title ?? ""
        recipeImage.updateImage(url: viewModel.imageURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImage.image = nil
        titleLabel.text = nil
    }
    
    // MARK: - private
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalCentering
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
