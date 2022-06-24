//
//  SIDLegacyFileLoader.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 16.06.2020.
//

import Foundation
import Alamofire
import AlamofireImage

public final class SIDLegacyFileLoader {

    static let instance = SIDLegacyFileLoader()

    private let sessionManager = Session()

    private init() {}

    // MARK: - APIs

    public func getFile(with id: String, completion: ((Data?, Error?) -> Void)?) {
        guard var url = URL(string: SwaggerClientAPI.basePath) else {
            completion?(nil, nil)
            return
        }

        url = url.appendingPathComponent("profile")
            .appendingPathComponent("files")
            .appendingPathComponent("\(id)")
            .appendingPathComponent("download")

        self.request(with: url, method: HTTPMethod.get, headers: [:], parameters: nil).validate().responseData { dataResponse in
            switch dataResponse.result {
            case let .success(data):
                completion?(data, nil)
            case let .failure(error):
                completion?(nil, error)
            }
        }
    }

    public func getFile(category: String, name: String, completion: ((Data?, Error?) -> Void)?) {
        guard var url = URL(string: SwaggerClientAPI.basePath) else {
            completion?(nil, nil)
            return
        }

        url = url.appendingPathComponent("profile")
            .appendingPathComponent("files")
            .appendingPathComponent("\(category)")
            .appendingPathComponent("\(name)")
            .appendingPathComponent("download")

        self.request(with: url, method: HTTPMethod.get, headers: [:], parameters: nil).validate().responseData { dataResponse in
            switch dataResponse.result {
            case let .success(data):
                completion?(data, nil)
            case let .failure(error):
                completion?(nil, error)
            }
        }
    }

    public func uploadFile<T: Codable>(category: String, name: String, data: Data, completion: @escaping (T?, Error?) -> Void) {
        guard var url = URL(string: SwaggerClientAPI.basePath) else {
            completion(nil, nil)
            return
        }

        url = url.appendingPathComponent("profile")
            .appendingPathComponent("files")
            .appendingPathComponent("\(category)")
            .appendingPathComponent("\(name)")

        var headers = HTTPHeaders()
        headers["Content-type"] = "multipart/form-data"

        let interceptor = AlamofireRetrier.interceptor

        AF.upload(multipartFormData: { $0.append(data, withName: "file", fileName: "avatar.jpeg", mimeType: "image/jpeg") },
                  to: url,
                  usingThreshold: MultipartFormData.encodingMemoryThreshold,
                  method: HTTPMethod.put,
                  headers: headers,
                  interceptor: interceptor)
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success:
                    self.prepareSuccessResponse(data: dataResponse, completion: completion)
                case let .failure(afError):
                    completion(nil, afError)
                }
            }
    }

    public func deleteFile<T: Codable>(with id: String, completion: @escaping (T?, Error?) -> Void) {
        guard var url = URL(string: SwaggerClientAPI.basePath) else {
            completion(nil, nil)
            return
        }

        url = url.appendingPathComponent("profile")
            .appendingPathComponent("files")
            .appendingPathComponent("\(id)")

        self.request(with: url, method: HTTPMethod.delete, headers: [:], parameters: nil).validate().responseJSON { data in
            self.prepareSuccessResponse(data: data, completion: completion)
        }
    }

    // MARK: - Helpers

    private func prepareSuccessResponse<T: Codable, R: Any>(data: AFDataResponse<R>, completion: @escaping (T?, _ error: AFError?) -> Void) {
        switch data.result {
        case .success:
            var result: T?
            if let jsonData = data.data {
                result = try? JSONDecoder().decode(T.self, from: jsonData)
            }
            completion(result, nil)
        case let .failure(error):
            completion(nil, error)
        }
    }

    // MARK: -

    private func request(with url: URL, method: HTTPMethod, headers: HTTPHeaders, parameters: [String: Any]?) -> DataRequest {
        let interceptor = AlamofireRetrier.interceptor

        do {
            var originalRequest = try URLRequest(url: url, method: method, headers: headers)
            originalRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            originalRequest.timeoutInterval = 60.0

            let encodedURLRequest = try URLEncoding.default.encode(originalRequest, with: parameters)
            return AF.request(encodedURLRequest, interceptor: interceptor)
        } catch {
            return AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: interceptor)
        }
    }
}
