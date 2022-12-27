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
    var likeSelect: (() -> Void)?
    private var viewModel: MainCellViewModel!
    
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
    
    private var recipeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 15
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private var highlightingView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.alpha = 0.5
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.likeImage), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel,baseView])
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
        selectionStyle = .none
        likeButton.addTarget(self, action: #selector(likeButtonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: MainCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title ?? ""
        recipeImage.updateImage(url: viewModel.imageURL)
        if let isLiked = viewModel.isLiked {
            likeButton.tintColor = isLiked ?  .systemPink : .systemGray4
        }
        likeButton.setBackgroundColor(color: .systemGray5, forState: .highlighted)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImage.image = nil
        titleLabel.text = nil
    }
    
    // MARK: - private
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.addSubview(likeButton)
        baseView.addSubview(recipeImage)
        recipeImage.addSubview(highlightingView)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        highlightingView.isHidden = true
    }

    private func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        highlightingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 4),
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            baseView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -16),
            baseView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 2),
            baseView.widthAnchor.constraint(equalToConstant: 150)
        ])
        NSLayoutConstraint.activate([
            recipeImage.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0),
            recipeImage.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 0),
            recipeImage.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 0),
            recipeImage.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0),
        ])
        NSLayoutConstraint.activate([
            highlightingView.bottomAnchor.constraint(equalTo: recipeImage.bottomAnchor, constant: 0),
            highlightingView.topAnchor.constraint(equalTo: recipeImage.topAnchor, constant: 0),
            highlightingView.trailingAnchor.constraint(equalTo: recipeImage.trailingAnchor, constant: 0),
            highlightingView.leadingAnchor.constraint(equalTo: recipeImage.leadingAnchor, constant: 0),
        ])
        NSLayoutConstraint.activate([
            likeButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -4),
            likeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -4),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    
        layoutIfNeeded()
        likeButton.layer.cornerRadius = likeButton.frame.height/2
    }
    
    @objc private func likeButtonTap() {
        likeSelect?()
    }
}
// MARK: - Image Hover Effect

extension MainTableViewCell {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first!
        if touch.view == recipeImage {
            startAnimation()
            highlightingView.isHidden = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let _: UITouch = touches.first!
        highlightingView.isHidden = true
    }
    
    private func startAnimation() {
        let hover = CABasicAnimation(keyPath: "position")
        hover.isAdditive = true
        hover.fromValue = NSValue(cgPoint: CGPoint.zero)
        hover.toValue = NSValue(cgPoint: CGPoint(x: 0.0, y: 5.0))
        hover.autoreverses = true
        hover.duration = 0.5
        recipeImage.layer.add(hover, forKey: "myHoverAnimation")
    }
}

