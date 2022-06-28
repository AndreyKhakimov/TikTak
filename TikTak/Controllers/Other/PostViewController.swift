//
//  PostViewController.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import AVFoundation
import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
}

class PostViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    var model: PostModel
    var player: AVPlayer?
    
    private var playerDidFinishObserver: NSObjectProtocol?
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ellipsis.bubble.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Test"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.masksToBounds = true
        button.tintColor = .white
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Check out this video! #foryou"
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideo()
        let colors: [UIColor] = [
            .green, .orange, .brown, .cyan, .systemPink
        ]
        view.backgroundColor = colors.randomElement()
        
        setUpButtons()
        setUpDoubleTapToLike()
        view.addSubview(captionLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size: CGFloat = 40
        
        let yStart: CGFloat = view.height - (size * 5) - (tabBarController?.tabBar.height ?? 0)
        for (index, button) in [likeButton, commentButton, shareButton].enumerated() {
            button.frame = CGRect(x: view.width - size - 8, y: yStart + (CGFloat(index) * size * 1.25), width: size, height: size)
        }
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(
            x: 8,
            y: view.height - 8 - labelSize.height - (tabBarController?.tabBar.height ?? 0),
            width: view.width - size - 12,
            height: labelSize.height
        )
        
        profileButton.frame = CGRect(
            x: likeButton.left,
            y: likeButton.top - 10 - size,
            width: size,
            height: size
        )
        
        profileButton.layer.cornerRadius = profileButton.height / 2
    }
    
    private func setUpButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        view.addSubview(profileButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
    }
    
    @objc private func didTapLike() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
    }
    
    @objc private func didTapComment() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    
    @objc private func didTapShare() {
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        present(vc, animated: true)
    }
    
    @objc private func didTapProfile() {
        delegate?.postViewController(self, didTapProfileButtonFor: model)
    }
    
    private func setUpDoubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    private func configureVideo() {
        guard let path = Bundle.main.path(forResource: "BMW", ofType: "mp4") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        player?.volume = 0
        player?.play()
        
        guard let player = player else {
            return
        }
        playerDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
            }
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
        }
        
        let touchPoint = gesture.location(in: view)
        let imageView = UIImageView(image: UIImage(systemName: "suit.heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    imageView.alpha = 0
                } completion: { done in
                    if done {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            imageView.removeFromSuperview()
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    
}
