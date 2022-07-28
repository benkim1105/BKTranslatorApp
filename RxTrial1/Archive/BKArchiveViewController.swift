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

class BKArchiveViewController: UIViewController, BKArchiveViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource {
    var episodes: BehaviorSubject<[BKEpisode]> = BehaviorSubject(value: [])
    var sentences: BehaviorSubject<[BKSentence]> = BehaviorSubject(value: [])
    var reloadData = PublishRelay<Bool>()
    var disposeBag = DisposeBag()
    
    let viewModel: BKArchiveViewModelProtocol
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Archive"
        view.backgroundColor = .systemBackground
        
        configUI()
        bindUI()
        
        viewModel.viewDidLoad()
    }
    
    func bindUI() {
        reloadData
            .subscribe(onNext:{ [weak self] _ in
            self?.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }
    
    //MARK: - BKArchiveViewProtocol

    func showError(_ message: String) {
        complain(message: message)
    }
    
    
    
    //MARK: - init
    init (viewModel: BKArchiveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

    //MARK: - ConfigUI
    enum Section: Int {
        case episodes = 0
        case playlists
        case sentences
        
        var title: String {
            switch self {
            case .episodes:
                return "Episode"
            case .playlists:
                return "Playlist"
            case .sentences:
                return "Sentence"
            }
        }
    }
    
    private func configUI() {
        navigationItem.searchController = searchVC
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SentenceCollectionViewCell.self, forCellWithReuseIdentifier: SentenceCollectionViewCell.identifier)
        collectionView.register(VerticalImageTextCell.self, forCellWithReuseIdentifier: VerticalImageTextCell.identifier)
        view.addSubview(collectionView)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
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
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            switch section {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
                
                let vgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(280), heightDimension: .absolute(120)), subitem: item, count: 2)
                
                let hgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(280), heightDimension: .absolute(120)), subitem: vgroup, count: 1)
                
                let section = NSCollectionLayoutSection(group: hgroup)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 5, bottom: 5, trailing: 1)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            }
        }
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = Section(rawValue: section)
        
        switch section {
        case .episodes:
            return try! episodes.value().count
        case .playlists:
            return 0
        case .sentences:
            return try! sentences.value().count
        case .none:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath)
                as? HeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        let section = Section(rawValue: indexPath.section)
        cell.configure(with: section?.title ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = Section(rawValue: indexPath.row)
        
        switch section {
        case .episodes:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalImageTextCell.identifier, for: indexPath) as? VerticalImageTextCell,
                let episode = try? episodes.value()[indexPath.row]
            else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: VerticalImageTextCellModel(imageUrl: episode.image, title: episode.title))
            cell.backgroundColor = .yellow
            
            return cell
        default:
            var cell = collectionView.dequeueReusableCell(withReuseIdentifier: SentenceCollectionViewCell.identifier, for: indexPath)
            cell.backgroundColor = .green
            return cell
        }
    }
}
