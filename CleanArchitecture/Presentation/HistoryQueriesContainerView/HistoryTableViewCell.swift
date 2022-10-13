//
//  HistoryTableViewCell.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 10.10.2022.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    static var cellId = "HisoryTableViewCell"
    
    private var viewModel: HistoryCellViewModel!
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
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
        contentView.addSubview(titleLabel)
    }
    
    func configure(with viewModel: HistoryCellViewModel) {
        titleLabel.text = viewModel.title
    }
    
    private func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
        ])
    }
}
