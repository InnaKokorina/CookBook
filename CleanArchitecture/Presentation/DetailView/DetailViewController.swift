//
//  DetailViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import UIKit

class DetailViewController: UIViewController, Alertable {

    var viewModel: DetailViewModelProtocol!
    var activityIndicator: UIActivityIndicatorView?
    
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        setupCollectionView()
        setConstrtaints()
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }

    // MARK: - private
    private func bind(to viewModel: DetailViewModelProtocol) {
        viewModel.dataSource.subscribe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        viewModel.error.subscribe(on: self) { [weak self] error in
            guard !error.isEmpty else { return }
            viewModel.loading.value = .none
            self?.showAlert(message: error)
        }
        viewModel.loading.subscribe(on: self) { [weak self] in
            self?.updateLoading($0)
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
        collectionView?.register(UINib(nibName: "CookingTimeCell", bundle: nil),forCellWithReuseIdentifier: CookingTimeCell.reuseIdentifier)
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
    
    private func updateLoading(_ loading: ListViewModelLoading?) {
        //let loaderView = LoaderView()
        switch loading {
        case .fullScreen: LoaderView.shared.show()
        case .nextPage: LoaderView.shared.hide()
        case .none:
            LoaderView.shared.hide()
        }
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  viewModel.dataSource.value.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItems = viewModel.setSectionItem(sectionIndex: section)
        return sectionItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionItems = viewModel.setSectionItem(sectionIndex: indexPath.section)
      
        switch sectionItems[indexPath.row] {
        case is HeaderDetailCellViewModel:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderDetailCell.reuseIdentifier, for: indexPath) as? HeaderDetailCell else { return UICollectionViewCell() }
            cell.configure(with: sectionItems[indexPath.item] as? HeaderDetailCellViewModel)
            return cell
        case is DishTypesCellViewModel:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishTypesCell.reuseIdentifier, for: indexPath) as? DishTypesCell else { return UICollectionViewCell() }
            cell.configure(with: sectionItems[indexPath.item] as? DishTypesCellViewModel)
            return cell
        case is CookingTimeCellViewModel:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CookingTimeCell.reuseIdentifier, for: indexPath) as? CookingTimeCell else { return UICollectionViewCell() }
            cell.configure(with: sectionItems[indexPath.item] as? CookingTimeCellViewModel)
            return cell
        case is IngredientsViewModel:
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientsCell.reuseIdentifier, for: indexPath) as? IngredientsCell else { return UICollectionViewCell() }
            cell.configure(with: sectionItems[indexPath.item] as? IngredientsViewModel)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
     return UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionItems = viewModel.setSectionItem(sectionIndex: indexPath.section)
        
        switch sectionItems[indexPath.row] {
        case is HeaderDetailCellViewModel:
            return CGSize(width: view.frame.width, height: view.frame.width/1.5)
        case is DishTypesCellViewModel:
            let width = view.frame.width - 16
            return CGSize(width: width, height: 50)
        case is CookingTimeCellViewModel:
            return CGSize(width: view.frame.width, height: 150)
        case is IngredientsViewModel:
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
