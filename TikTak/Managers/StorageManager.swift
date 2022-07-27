//
//  StorageManager.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import Foundation
import FirebaseStorage
import AVFoundation


final class StorageManager {
    public static let shared = StorageManager()
    
    private let storageBucket = Storage.storage().reference()
    
    private init() {}
    
    // Public
    
    /// Upload a new user video to firebase
    /// - Parameters:
    ///   - url: Local file url to video
    ///   - fileName: Desired video file upload name
    ///   - completion: Async callback result closure
    public func uploadVideo(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let asset = AVAsset(url: url)
                let generator = AVAssetImageGenerator(asset: asset)
                generator.appliesPreferredTrackTransform = true
                let start = DispatchTime.now()
                let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                print("Time to generate image \(timeInterval) seconds")
                
                let uiImage = UIImage(cgImage: cgImage)

                self?.storageBucket.child("videos/\(username)/\(fileName)/video.mov").putFile(from: url, metadata: nil) { _, error in
                    self?.storageBucket.child("videos/\(username)/\(fileName)/preview.jpeg").putData(uiImage.jpegData(compressionQuality: 0.95) ?? Data(), metadata: nil, completion: { _, error in
                        completion(error == nil)
                    })
                    
                }
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    /// Upload new profile picture
    /// - Parameters:
    ///   - image: New image to upload
    ///   - completion: Async callback of result
    public func uploadProfilePicture(with image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        guard let imageData = image.pngData() else { return }
        
        let path = "profile_pictures/\(username)/picture.png"
        
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let  error = error {
                completion(.failure(error))
            } else {
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    completion(.success(url))
                }
            }
        }
    }
    
    /// Generates a new file name
    /// - Returns: Return a unique generated file name
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimeStamp = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimeStamp)"
    }
    
    /// Get download url of video post
    /// - Parameters:
    ///   - post: Post model to get url for
    ///   - completion: Async callback
    func getDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let url = url {
                completion(.success(url))
            }
        }
        
    }
    
    func getPreviewDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        storageBucket.child(post.videoPreviewPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let url = url {
                completion(.success(url))
            }
        }
        
    }
    
}
