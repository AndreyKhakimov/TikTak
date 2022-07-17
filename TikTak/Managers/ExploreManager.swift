//
//  ExploreManager.swift
//  TikTak
//
//  Created by Andrey Khakimov on 03.07.2022.
//

import Foundation
import UIKit

protocol ExploreManagerDelegate: AnyObject {
    func pushViewController(_ vc: UIViewController)
    func didTapHashTag(_ hashtag: String)
}

final class ExploreManager {
    
    static let shared = ExploreManager()
    
    weak var delegate: ExploreManagerDelegate?
    
    enum BannerAction: String {
        case post
        case hashtag
        case user
    }
    
    private init() {}
    
    // MARK: - Public
    public func  getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.banners.compactMap { model in
            return ExploreBannerViewModel(
                image: UIImage(named: model.image),
                title: model.title,
                handler: { [weak self] in
                    guard let action = BannerAction(rawValue: model.action) else { return }
                    DispatchQueue.main.async {
                        let vc = UIViewController()
                        vc.view.backgroundColor = .systemBackground
                        vc.title = action.rawValue.uppercased()
                        self?.delegate?.pushViewController(vc)
                    }
                    switch action {
                    case .post:
                        break
                        // present post
                    case .hashtag:
                        break
                        // search for hashtag
                    case .user:
                        break
                        // present profile
                    }
                }
            )
        }
    }
    
    public func  getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.creators.compactMap { model in
            return ExploreUserViewModel(
                profilePicture: UIImage(named: model.image),
                username: model.username,
                followerCount: model.followers_count
            ) { [weak self] in
                let userId = model.id
                // Fetch user from firebase
                DispatchQueue.main.async {
                    let vc = ProfileViewController(user: User(username: "Bob", profilePictureURL: nil, identifier: userId))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
    public func  getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.hashtags.compactMap { model in
            return ExploreHashtagViewModel(
                text: "#" + model.tag,
                icon: UIImage(systemName: model.image),
                count: model.count) { [weak self] in
                    DispatchQueue.main.async {
                        self?.delegate?.didTapHashTag(model.tag)
                    }
                }
        }
    }
    
    /// Get Explore data for recent posts
    /// - Returns: Return collection of models
    public func  getExploreRecentPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.recentPosts.compactMap { model in
            return ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                // use id to fetch post from firebase
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(
                        model: PostModel(
                            identifier: postID,
                            user: User(
                                username: "Bob",
                                profilePictureURL: nil,
                                identifier: UUID().uuidString
                            )
                        )
                    )
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
    /// Get Explore data for popular posts
    /// - Returns: Return collection of models
    public func  getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.popular.compactMap { model in
            return ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(
                        model: PostModel(
                            identifier: postID,
                            user: User(
                                username: "Bob",
                                profilePictureURL: nil,
                                identifier: UUID().uuidString
                            )
                        )
                    )
                    self?.delegate?.pushViewController(vc)
                }
                
            }
        }
    }
    
    /// Get Explore data for recommended posts
    /// - Returns: Return collection of models
    public func  getExploreRecommendedPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.recommended.compactMap { model in
            return ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(
                        model: PostModel(
                            identifier: postID,
                            user: User(
                                username: "Bob",
                                profilePictureURL: nil,
                                identifier: UUID().uuidString
                            )
                        )
                    )
                    self?.delegate?.pushViewController(vc)
                }
                
            }
        }
    }
    
    
    /// Get Explore data for trending posts
    /// - Returns: Return collection of models
    public func  getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.trendingPosts.compactMap { model in
            return ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(
                        model: PostModel(
                            identifier: postID,
                            user: User(
                                username: "Bob",
                                profilePictureURL: nil,
                                identifier: UUID().uuidString
                            )
                        )
                    )
                    self?.delegate?.pushViewController(vc)
                }
                
            }
        }
    }
    
    // MARK: - Private
    
    /// Parse explore JSON data
    /// - Returns: Returns an optional response model
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else { return nil }
        
        let url  = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ExploreResponse.self, from: data)
        } catch  {
            print(error)
            return nil
        }
    }
    
}
