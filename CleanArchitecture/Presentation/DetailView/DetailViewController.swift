//
//  DetailViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import UIKit

class DetailViewController: UIViewController {

    private var viewModel: DetailViewModelProtocol!
    private var collectionView: UICollectionView?
    var imagesRepository: ImagesRepositoryPrototcol?
    
    static func create(with viewModel: DetailViewModelProtocol, imagesRepository: ImagesRepositoryPrototcol?) -> DetailViewController {
        let view = DetailViewController()
        view.viewModel = viewModel
        view.imagesRepository = imagesRepository
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        setupCollectionView()
        setConstrtaints()
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }

    // MARK: - private
    private func bind(to: DetailViewModelProtocol) {
        viewModel.detailHeaderItems.subscribe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        viewModel.dishTypesItems.subscribe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        viewModel.ingredientstems.subscribe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        view.addSubview(collectionView!)
        collectionView?.register(HeaderDetailCell.self, forCellWithReuseIdentifier: HeaderDetailCell.reuseIdentifier)
        collectionView?.register(DishTypesCell.self, forCellWithReuseIdentifier: DishTypesCell.reuseIdentifier)
        collectionView?.register(IngredientsCell.self, forCellWithReuseIdentifier: IngredientsCell.reuseIdentifier)
        collectionView?.collectionViewLayout = layout
    }
    
    private func setConstrtaints() {
        guard let collectionView = collectionView else { return }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return viewModel.detailHeaderItems.value.count
        case 1 :
            return  viewModel.dishTypesItems.value.count
        case 2 :
            return  viewModel.ingredientstems.value.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderDetailCell.reuseIdentifier, for: indexPath) as? HeaderDetailCell else { return UICollectionViewCell() }
            cell.configure(with: viewModel.detailHeaderItems.value[indexPath.item], imagesRepository: imagesRepository)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishTypesCell.reuseIdentifier, for: indexPath) as? DishTypesCell else { return UICollectionViewCell() }
            cell.configure(with: viewModel.dishTypesItems.value[indexPath.item])
            return cell
        case 2:
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientsCell.reuseIdentifier, for: indexPath) as? IngredientsCell else { return UICollectionViewCell() }
            cell.configure(with: viewModel.ingredientstems.value[indexPath.item], imageRepository: imagesRepository)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
     return UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width, height: view.frame.width/1.5)
        case 1:
            let width = view.frame.width - 16
            return CGSize(width: width, height: 50)
        case 2:
            return CGSize(width: view.frame.width/2, height: view.frame.width/2)
        default:
            return CGSize(width: view.frame.width, height: view.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
