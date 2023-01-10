//
//  PopUpErrorViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 09.01.2023.
//


import UIKit

class PopUpErrorViewController: UIViewController {
    // MARK: - private UI properties
    private let backgroundPopUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#E5E5E5")
        view.alpha = 0.4
        return view
    }()
    
    private let baseShadowView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let baseView: UIView = {
        let view = UIView()
        view.alpha = 1
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let titleLabel: UILabel = {
      let label = UILabel()
        label.text = "Превышено число запросов к серверу"
        return label
    }()

    private let  apiKeyView: UIView = {
        let textView = UIView()
        textView.backgroundColor = UIColor(hexString: "#F7F8F8")
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        return textView
    }()
    
    private let buttonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.setTitle("ok", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let arrowsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(systemName: "arrow.up.arrow.down")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let keyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.systemGray
        textView.backgroundColor = UIColor(hexString: "#F7F8F8")
        textView.text = "Введите новый API ключ\nspoonacular.com "
        return textView
    }()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [apiKeyView, buttonView])
 
    // MARK: - life cycle
    
    override func viewDidLoad() {
        setupViews()
        setupConstraints()
        keyTextView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        baseView.frame = baseShadowView.bounds
        setButtonGradien()
        let contentSize = self.keyTextView.sizeThatFits(self.keyTextView.bounds.size)
            var frame = self.keyTextView.frame
            frame.size.height = contentSize.height
            self.keyTextView.frame = frame

//       let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.keyTextView, attribute: .Height, relatedBy: .Equal, toItem: self.keyTextView, attribute: .Width, multiplier: keyTextView.bounds.height/keyTextView.bounds.width, constant: 1)
//            self.keyTextView.addConstraint(aspectRatioTextViewConstraint!)
    }
    
   // MARK: - private methtods
    
    private func setupViews() {
        view.addSubview(backgroundPopUpView)
        view.addSubview(baseShadowView)
        baseShadowView.addSubview(baseView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(stackView)
        buttonView.addSubview(okButton)
        apiKeyView.addSubview(arrowsImage)
        apiKeyView.addSubview(keyTextView)
        titleLabel.numberOfLines = 0
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        keyTextView.isScrollEnabled = false
        
    }
    private func setButtonGradien() {
        let firstColor: UIColor? = UIColor(hexString: "#C58BF2")
        let secondColor: UIColor? = UIColor(hexString: "#EEA4CE")
        guard let firstColor = firstColor,
              let secondColor = secondColor
        else { return }
        okButton.setGradient(firstColor: firstColor.cgColor, secondColor: secondColor.cgColor, transform: CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1))
    }
    
    private func setupConstraints() {
        baseShadowView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        apiKeyView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        arrowsImage.translatesAutoresizingMaskIntoConstraints = false
        keyTextView.translatesAutoresizingMaskIntoConstraints = false
        backgroundPopUpView.frame = view.bounds
        
        NSLayoutConstraint.activate([
            baseShadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            baseShadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            baseShadowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 125),
            baseShadowView.heightAnchor.constraint(greaterThanOrEqualToConstant: 232)
        ])
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor , constant: -24),
            titleLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor , constant: 24),
            titleLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 28),
            titleLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -24),
            stackView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant:  24),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -24)
        ])
        NSLayoutConstraint.activate([
            buttonView.widthAnchor.constraint(equalToConstant: 48 )
        ])
        NSLayoutConstraint.activate([
            arrowsImage.leadingAnchor.constraint(equalTo: apiKeyView.leadingAnchor, constant: 8),
            arrowsImage.topAnchor.constraint(equalTo: apiKeyView.topAnchor, constant: 8),
            arrowsImage.widthAnchor.constraint(equalToConstant: 20),
            arrowsImage.heightAnchor.constraint(equalToConstant: 20)
        ])
        NSLayoutConstraint.activate([
            keyTextView.leadingAnchor.constraint(equalTo: arrowsImage.trailingAnchor, constant: 8),
            keyTextView.trailingAnchor.constraint(equalTo: apiKeyView.trailingAnchor, constant: -8),
            keyTextView.topAnchor.constraint(equalTo: apiKeyView.topAnchor, constant: 8),
            keyTextView.bottomAnchor.constraint(equalTo: apiKeyView.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 0),
            okButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: 0),
            okButton.widthAnchor.constraint(equalToConstant: 48),
            okButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

// MARK: - set placeholder

extension PopUpErrorViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите новый API ключ \n spoonacular.com "
            textView.textColor = UIColor.systemGray
        }
    }
//    func textViewDidChange(_ textView: UITextView) {
//        keyTextView.sizeToFit()
//        keyTextView.layoutIfNeeded()
//    }
}
