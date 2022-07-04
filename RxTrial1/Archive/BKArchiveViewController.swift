//
//  BKArchiveViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BKArchiveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Archive"
        view.backgroundColor = .systemBackground
        
        configUI()
    }

    //MARK: ConfigUI
    private func configUI() {
        navigationItem.searchController = searchVC
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SentenceCollectionViewCell.self, forCellWithReuseIdentifier: SentenceCollectionViewCell.identifier)
        collectionView.register(VerticalImageTextCell.self, forCellWithReuseIdentifier: VerticalImageTextCell.identifier)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.topMargin.bottomMargin.equalToSuperview()
        }
    }
    
    private var searchVC: UISearchController = {
        let resultVC = BKSearchResultViewController()
        let view = UISearchController(searchResultsController: resultVC)
        view.searchBar.placeholder = "Episodes, Words"
        view.searchBar.searchBarStyle = .minimal
        view.definesPresentationContext = true
        return view
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            switch section {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //MARK: UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalImageTextCell.identifier, for: indexPath)
            cell.backgroundColor = .yellow
            return cell
        default:
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: SentenceCollectionViewCell.identifier, for: indexPath)
            cell.backgroundColor = .green
            return cell
        }
    }
}
