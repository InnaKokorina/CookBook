//
//  DishTypesCell.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.10.2022.
//

import UIKit

class DishTypesCell: UICollectionViewCell {
    static let reuseIdentifier = "DishTypesCell"

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis  = .horizontal
        stackView.distribution  = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: DishTypesCellViewModel?) {
        setupViews()
        setupStackView(with: viewModel)
    }
    
    // MARK: - private
    private func setupViews() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setupStackView(with viewModel: DishTypesCellViewModel?) {
        guard let dishTypes = viewModel?.types else { return }
        for dishtype in dishTypes {
            let dishTypeLabel: UILabel  = {
                let label = UILabel()
                label.numberOfLines = 0
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 12)
                label.textColor = .white
                return label
            }()
            let grayView: UIView = {
                let view = UIView()
                view.backgroundColor = .gray
                view.layer.cornerRadius = 5
                return view
            }()
            dishTypeLabel.text = dishtype
            grayView.addSubview(dishTypeLabel)
            stackView.addArrangedSubview(grayView)
            setLabelConstraint(view: grayView, label: dishTypeLabel)
        }
        setConstraints()
    }
    
    override func prepareForReuse() {
        stackView.removeFromSuperview()
    }
    
    private func setConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 4),
            scrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
            
        ])
        self.layoutIfNeeded()
        if stackView.frame.width <= self.frame.width - 32 {
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        }
    }
    
    private func setLabelConstraint(view: UIView, label: UILabel) {
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
        ])
    }
}
