//
//  ImageLoader.swift
//  DiscordApp
//
//  Created by Victor Varenik on 20.03.2023.
//

import UIKit

private let cache = try? DataCache(name: "ImageCache")

final class ImageLoader {
    
    private var dataTask: URLSessionDataTask?
    
    deinit { cancel() }
    
    func image(for path: String, completion: @escaping (Result<UIImage, NetworkingError>) -> Void) {
        if let data = cache?[path], let image = UIImage(data: data) {
            completion(.success(image))
        } else if let url = URL(string: path) {
            load(from: url) {
                switch $0 {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        cache?[path] = data
                        completion(.success(image))
                    } else {
                        return completion(.failure(.notImageDataInResponse))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(.wrongURL))
        }
    }
    
    func cancel() {
        dataTask?.cancel()
    }
    
    private func load(from url: URL, completion: @escaping (Result<Data, NetworkingError>) -> Void) {
        dataTask?.cancel()
        let request = generateRequest(from: url)
        dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let result = self?.parseResponse(data: data, error: error) else { return }
            DispatchQueue.main.async {
                completion(result)
            }
        }
        dataTask?.resume()
    }
    
    private func generateRequest(from url: URL) -> URLRequest {
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
    
    private func parseResponse(data: Data?, error: Error?) -> Result<Data, NetworkingError> {
        if let error { return .failure(.other(error)) }
        guard let data else { return .failure(.emptyData) }
        return .success(data)
    }
    
    enum NetworkingError: LocalizedError {
        case emptyData, notImageDataInResponse
        case other(Error)
        case wrongURL
        public var errorDescription: String? {
            switch self {
            case .emptyData:
                return "Пустые данные в ответе сервера"
            case .notImageDataInResponse:
                return "Данные невозможно использовать для изображения"
            case .other(let error):
                return error.localizedDescription
            case .wrongURL:
                return "Неправильный URL"
            }
        }
    }
}

