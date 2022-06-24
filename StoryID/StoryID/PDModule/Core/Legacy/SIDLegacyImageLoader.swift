//
//  SIDLegacyImageLoader.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 06.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

// MARK: - FileParam

public struct FileParam {

    var data: Data
    var name: String
    var fileName: String
    var type: String

    public init(data: Data, name: String, fileName: String? = nil, type: String = "image/jpeg") {
        self.data = data
        self.name = name
        self.fileName = fileName ?? name
        self.type = type
    }
}

// MARK: - SIDLegacyImageLoader

public final class SIDLegacyImageLoader {

    static let instance = SIDLegacyImageLoader()

    private let sessionManager = Session()

    private init() {}

    // MARK: - APIs

    public func getImage(with path: String, parameters: [String: Any]?, completion: ((UIImage?, Error?) -> Void)?) {
        let URLString = SwaggerClientAPI.basePath + path
        guard let url = URL(string: URLString) else {
            completion?(nil, nil)
            return
        }

        let headers = HTTPHeaders()

        self.request(with: url, method: HTTPMethod.get, headers: headers, parameters: parameters).validate().responseImage { dataResponse in
            switch dataResponse.result {
            case let .success(image):
                completion?(image, nil)
            case let .failure(error):
                completion?(nil, error)
            }
        }
    }

    public func loadFiles<T: Codable>(to path: String, files: [FileParam], parameters: [String: Any]?, completion: @escaping (T?, Error?) -> Void) {
        let URLString = SwaggerClientAPI.basePath + path
        guard let url = URL(string: URLString) else {
            completion(nil, nil)
            return
        }

        var headers = HTTPHeaders()
        headers["Content-type"] = "multipart/form-data"

        let interceptor = AlamofireRetrier.interceptor

        let multipartFormDataBlock = { (multipartFormData: MultipartFormData) in
            for file in files {
                multipartFormData.append(file.data, withName: file.name, fileName: file.fileName, mimeType: file.type)
            }
        }

        AF.upload(multipartFormData: multipartFormDataBlock,
                  to: url,
                  usingThreshold: MultipartFormData.encodingMemoryThreshold,
                  method: .put,
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

    public func deleteFile<T: Codable>(at path: String, completion: @escaping (T?, AFError?) -> Void) {
        let URLString = SwaggerClientAPI.basePath + path
        guard let url = URL(string: URLString) else {
            completion(nil, nil)
            return
        }

        let headers = HTTPHeaders()

        self.request(with: url, method: HTTPMethod.delete, headers: headers, parameters: nil).validate().responseJSON { data in
            self.prepareSuccessResponse(data: data, completion: completion)
        }
    }

    private func prepareSuccessResponse<T: Codable, R: Any>(data: AFDataResponse<R>, completion: @escaping (T?, _ error: AFError?) -> Void) {
        switch data.result {
        case .success:
            let decoder = JSONDecoder()
            var result: T?
            if let jsonData = data.data {
                result = try? decoder.decode(T.self, from: jsonData)
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
            return self.sessionManager.request(encodedURLRequest, interceptor: interceptor)
        } catch {
            return self.sessionManager.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: interceptor)
        }
    }
}
