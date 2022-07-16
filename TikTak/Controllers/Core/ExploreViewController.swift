//
//  ExploreViewController.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    
    private var sections = [ExploreSection]()
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        ExploreManager.shared.delegate = self
        configureModels()
        setUpSearchBar()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func configureModels() {
        sections.append(
            ExploreSection(
                type: .banners,
                cells: ExploreManager.shared.getExploreBanners().compactMap({
                    ExploreCell.banner(viewModel: $0)
                })
            )
        )
        
        sections.append(
            ExploreSection(
                type: .trendingPosts,
                cells: ExploreManager.shared.getExploreTrendingPosts().compactMap({
                    ExploreCell.post(viewModel: $0)
                })
            )
        )
        
        sections.append(
            ExploreSection(
                type: .users,
                cells: ExploreManager.shared.getExploreCreators().compactMap({
                    ExploreCell.user(viewModel: $0)
                })
            )
        )
        
        sections.append(
            ExploreSection(
                type: .trendingHashtags,
                cells: ExploreManager.shared.getExploreHashtags().compactMap({
                    ExploreCell.hashtag(viewModel: $0)
                })
            )
        )
        
        sections.append(
            ExploreSection(
                type: .recommended,
                cells: ExploreManager.shared.getExploreRecommendedPosts().compactMap({
                    ExploreCell.post(viewModel: $0)
                })
            )
        )
        
        sections.append(
            ExploreSection(
                type: .popular,
                cells: ExploreManager.shared.getExplorePopularPosts().compactMap({
                    ExploreCell.post(viewModel: $0)
                })
            )
        )
        
        sections.append(
            ExploreSection(
                type: .new,
                cells: ExploreManager.shared.getExploreRecentPosts().compactMap({
                    ExploreCell.post(viewModel: $0)
                })
            )
        )
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            ExploreBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier
        )
        collectionView.register(
            ExplorePostCollectionViewCell.self,
            forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier
        )
        collectionView.register(
            ExploreHashtagCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier
        )
        collectionView.register(
            ExploreUserCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier
        )
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
}

// MARK: - CollectionView Delegate and DataSource methods
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreBannerCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreBannerCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExplorePostCollectionViewCell.identifier,
                for: indexPath
            ) as? ExplorePostCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreHashtagCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreUserCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreUserCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(viewModel: let viewModel):
            viewModel.handler()
        case .post(viewModel: let viewModel):
            viewModel.handler()
        case .hashtag(viewModel: let viewModel):
            viewModel.handler()
        case .user(viewModel: let viewModel):
            viewModel.handler()
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
    }
    
    @objc private func didTapCancel() {
        navigationItem.rightBarButtonItem = nil
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Section Layouts
extension ExploreViewController {
    
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        switch sectionType {
        case .banners:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            return sectionLayout
        case .users:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            return sectionLayout
        case .trendingHashtags:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                ),
                subitems: [item]
            )
            
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            
            return sectionLayout
            
        case .trendingPosts, .recommended, .new:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(300)
                ),
                subitem: item,
                count: 2
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(300)
                ),
                subitems: [verticalGroup]
            )
            
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            return sectionLayout
        case .popular:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            return sectionLayout
        }
    }
    
}

extension ExploreViewController: ExploreManagerDelegate {
    func didTapHashTag(_ hashtag: String) {
        HapticsManager.shared.vibrateForSelection()
        searchBar.text = hashtag
        searchBar.becomeFirstResponder()
    }
    
    func pushViewController(_ vc: UIViewController) {
        HapticsManager.shared.vibrateForSelection()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
