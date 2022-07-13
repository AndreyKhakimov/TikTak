//
//  PostCollectionViewCell.swift
//  TikTak
//
//  Created by Andrey Khakimov on 13.07.2022.
//

import UIKit
import AVFoundation

class PostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with post: PostModel) {
        // Get download url
        StorageManager.shared.getDownloadURL(for: post) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    print("got url: \(url)")
                    // Generate thumbnail
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    var cgImage: CGImage?
                    // TODO: - Remake generator concurrency logic
                    let workItem = DispatchWorkItem {
                        do {
                            cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    DispatchQueue.global(qos: .userInitiated).async(execute: workItem)
                    workItem.notify(queue: .main) {
                        self.imageView.image = UIImage(cgImage: cgImage!)
                    }
                case .failure(let error):
                    print("failed to get download url: \(error)")
                }
            }
        }
        
        
    }
    
}
