//
// ProfileFilesAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire


open class ProfileFilesAPI {
    /**
     Создание файла 

     - parameter body: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func createFile(body: CreateFileViewModel? = nil, completion: @escaping ((_ data: FileViewModel?,_ error: Error?) -> Void)) {
        createFileWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Создание файла 
     - POST /profile/files

     - examples: [{contentType=application/json, example={
  "createdAt" : "2000-01-23T04:56:07.000+00:00",
  "fileName" : "fileName",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "uploaded" : true,
  "name" : "name",
  "description" : "description",
  "id" : "id",
  "mimeType" : "mimeType",
  "category" : "category"
}}]
     - parameter body: (body)  (optional)

     - returns: RequestBuilder<FileViewModel> 
     */
    open class func createFileWithRequestBuilder(body: CreateFileViewModel? = nil) -> RequestBuilder<FileViewModel> {
        let path = "/profile/files"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FileViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Удаление файла

     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteFile(_id: String, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        deleteFileWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     Удаление файла
     - DELETE /profile/files/{id}

     - parameter _id: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func deleteFileWithRequestBuilder(_id: String) -> RequestBuilder<Void> {
        var path = "/profile/files/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Скачивание бинарного объекта

     - parameter category: (path)  
     - parameter name: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func downloadCategoryFile(category: String, name: String, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        downloadCategoryFileWithRequestBuilder(category: category, name: name).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     Скачивание бинарного объекта
     - GET /profile/files/{category}/{name}/download

     - parameter category: (path)  
     - parameter name: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func downloadCategoryFileWithRequestBuilder(category: String, name: String) -> RequestBuilder<Void> {
        var path = "/profile/files/{category}/{name}/download"
        let categoryPreEscape = "\(category)"
        let categoryPostEscape = categoryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{category}", with: categoryPostEscape, options: .literal, range: nil)
        let namePreEscape = "\(name)"
        let namePostEscape = namePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{name}", with: namePostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Скачивание бинарного объекта

     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func downloadFile(_id: String, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        downloadFileWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     Скачивание бинарного объекта
     - GET /profile/files/{id}/download

     - parameter _id: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func downloadFileWithRequestBuilder(_id: String) -> RequestBuilder<Void> {
        var path = "/profile/files/{id}/download"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Получение файла в категории

     - parameter category: (path)  
     - parameter name: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getCategoryFileByName(category: String, name: String, completion: @escaping ((_ data: FileViewModel?,_ error: Error?) -> Void)) {
        getCategoryFileByNameWithRequestBuilder(category: category, name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Получение файла в категории
     - GET /profile/files/{category}/{name}

     - examples: [{contentType=application/json, example={
  "createdAt" : "2000-01-23T04:56:07.000+00:00",
  "fileName" : "fileName",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "uploaded" : true,
  "name" : "name",
  "description" : "description",
  "id" : "id",
  "mimeType" : "mimeType",
  "category" : "category"
}}]
     - parameter category: (path)  
     - parameter name: (path)  

     - returns: RequestBuilder<FileViewModel> 
     */
    open class func getCategoryFileByNameWithRequestBuilder(category: String, name: String) -> RequestBuilder<FileViewModel> {
        var path = "/profile/files/{category}/{name}"
        let categoryPreEscape = "\(category)"
        let categoryPostEscape = categoryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{category}", with: categoryPostEscape, options: .literal, range: nil)
        let namePreEscape = "\(name)"
        let namePostEscape = namePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{name}", with: namePostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FileViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Получение списка файлов категории

     - parameter category: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func listCategories(category: String, completion: @escaping ((_ data: [FileViewModel]?,_ error: Error?) -> Void)) {
        listCategoriesWithRequestBuilder(category: category).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Получение списка файлов категории
     - GET /profile/files/{category}

     - examples: [{contentType=application/json, example=[ {
  "createdAt" : "2000-01-23T04:56:07.000+00:00",
  "fileName" : "fileName",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "uploaded" : true,
  "name" : "name",
  "description" : "description",
  "id" : "id",
  "mimeType" : "mimeType",
  "category" : "category"
}, {
  "createdAt" : "2000-01-23T04:56:07.000+00:00",
  "fileName" : "fileName",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "uploaded" : true,
  "name" : "name",
  "description" : "description",
  "id" : "id",
  "mimeType" : "mimeType",
  "category" : "category"
} ]}]
     - parameter category: (path)  

     - returns: RequestBuilder<[FileViewModel]> 
     */
    open class func listCategoriesWithRequestBuilder(category: String) -> RequestBuilder<[FileViewModel]> {
        var path = "/profile/files/{category}"
        let categoryPreEscape = "\(category)"
        let categoryPostEscape = categoryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{category}", with: categoryPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[FileViewModel]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Получение списка файлов текущего пользователя

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func listFiles(completion: @escaping ((_ data: [FileViewModel]?,_ error: Error?) -> Void)) {
        listFilesWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Получение списка файлов текущего пользователя
     - GET /profile/files

     - examples: [{contentType=application/json, example=[ {
  "createdAt" : "2000-01-23T04:56:07.000+00:00",
  "fileName" : "fileName",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "uploaded" : true,
  "name" : "name",
  "description" : "description",
  "id" : "id",
  "mimeType" : "mimeType",
  "category" : "category"
}, {
  "createdAt" : "2000-01-23T04:56:07.000+00:00",
  "fileName" : "fileName",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "uploaded" : true,
  "name" : "name",
  "description" : "description",
  "id" : "id",
  "mimeType" : "mimeType",
  "category" : "category"
} ]}]

     - returns: RequestBuilder<[FileViewModel]> 
     */
    open class func listFilesWithRequestBuilder() -> RequestBuilder<[FileViewModel]> {
        let path = "/profile/files"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[FileViewModel]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Редактирование метаданных

     - parameter _id: (path)  
     - parameter body: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func updateFileMetadata(_id: String, body: UpdateFileViewModel? = nil, completion: @escaping ((_ data: FileViewModel?,_ error: Error?) -> Void)) {
        updateFileMetadataWithRequestBuilder(_id: _id, body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Редактирование метаданных
     - PUT /profile/files/{id}

     - examples: [{contentType=application/json, example={
  "createdAt" : "2000-01-23T04:56:07.000+00:00",
  "fileName" : "fileName",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "uploaded" : true,
  "name" : "name",
  "description" : "description",
  "id" : "id",
  "mimeType" : "mimeType",
  "category" : "category"
}}]
     - parameter _id: (path)  
     - parameter body: (body)  (optional)

     - returns: RequestBuilder<FileViewModel> 
     */
    open class func updateFileMetadataWithRequestBuilder(_id: String, body: UpdateFileViewModel? = nil) -> RequestBuilder<FileViewModel> {
        var path = "/profile/files/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FileViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Загрузка и создание/обновление файла категории

     - parameter category: (path)  
     - parameter name2: (path)  
     - parameter contentType: (form)  (optional)
     - parameter contentDisposition: (form)  (optional)
     - parameter headers: (form)  (optional)
     - parameter length: (form)  (optional)
     - parameter name: (form)  (optional)
     - parameter fileName: (form)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func uploadCategoryFile(category: String, name2: String, contentType: String? = nil, contentDisposition: String? = nil, headers: [String:[String]]? = nil, length: Int64? = nil, name: String? = nil, fileName: String? = nil, completion: @escaping ((_ data: FileViewModel?,_ error: Error?) -> Void)) {
        uploadCategoryFileWithRequestBuilder(category: category, name2: name2, contentType: contentType, contentDisposition: contentDisposition, headers: headers, length: length, name: name, fileName: fileName).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Загрузка и создание/обновление файла категории
     - PUT /profile/files/{category}/{name}

     - examples: [{contentType=application/json, example={
  "createdAt" : "2000-01-23T04:56:07.000+00:00",
  "fileName" : "fileName",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "uploaded" : true,
  "name" : "name",
  "description" : "description",
  "id" : "id",
  "mimeType" : "mimeType",
  "category" : "category"
}}]
     - parameter category: (path)  
     - parameter name2: (path)  
     - parameter contentType: (form)  (optional)
     - parameter contentDisposition: (form)  (optional)
     - parameter headers: (form)  (optional)
     - parameter length: (form)  (optional)
     - parameter name: (form)  (optional)
     - parameter fileName: (form)  (optional)

     - returns: RequestBuilder<FileViewModel> 
     */
    open class func uploadCategoryFileWithRequestBuilder(category: String, name2: String, contentType: String? = nil, contentDisposition: String? = nil, headers: [String:[String]]? = nil, length: Int64? = nil, name: String? = nil, fileName: String? = nil) -> RequestBuilder<FileViewModel> {
        var path = "/profile/files/{category}/{name}"
        let categoryPreEscape = "\(category)"
        let categoryPostEscape = categoryPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{category}", with: categoryPostEscape, options: .literal, range: nil)
        let name2PreEscape = "\(name2)"
        let name2PostEscape = name2PreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{name}", with: name2PostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let formParams: [String:Any?] = [
                "ContentType": contentType,
                "ContentDisposition": contentDisposition,
                "Headers": headers,
                "Length": length?.encodeToJSON(),
                "Name": name,
                "FileName": fileName
        ]

        let nonNullParameters = APIHelper.rejectNil(formParams)
        let parameters = APIHelper.convertBoolToString(nonNullParameters)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FileViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Загрузка бинарного объекта

     - parameter _id: (path)  
     - parameter contentType: (form)  (optional)
     - parameter contentDisposition: (form)  (optional)
     - parameter headers: (form)  (optional)
     - parameter length: (form)  (optional)
     - parameter name: (form)  (optional)
     - parameter fileName: (form)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func uploadFile(_id: String, contentType: String? = nil, contentDisposition: String? = nil, headers: [String:[String]]? = nil, length: Int64? = nil, name: String? = nil, fileName: String? = nil, completion: @escaping ((_ data: FileViewModel?,_ error: Error?) -> Void)) {
        uploadFileWithRequestBuilder(_id: _id, contentType: contentType, contentDisposition: contentDisposition, headers: headers, length: length, name: name, fileName: fileName).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Загрузка бинарного объекта
     - PUT /profile/files/{id}/upload

     - examples: [{contentType=application/json, example={
  "createdAt" : "2000-01-23T04:56:07.000+00:00",
  "fileName" : "fileName",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "uploaded" : true,
  "name" : "name",
  "description" : "description",
  "id" : "id",
  "mimeType" : "mimeType",
  "category" : "category"
}}]
     - parameter _id: (path)  
     - parameter contentType: (form)  (optional)
     - parameter contentDisposition: (form)  (optional)
     - parameter headers: (form)  (optional)
     - parameter length: (form)  (optional)
     - parameter name: (form)  (optional)
     - parameter fileName: (form)  (optional)

     - returns: RequestBuilder<FileViewModel> 
     */
    open class func uploadFileWithRequestBuilder(_id: String, contentType: String? = nil, contentDisposition: String? = nil, headers: [String:[String]]? = nil, length: Int64? = nil, name: String? = nil, fileName: String? = nil) -> RequestBuilder<FileViewModel> {
        var path = "/profile/files/{id}/upload"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let formParams: [String:Any?] = [
                "ContentType": contentType,
                "ContentDisposition": contentDisposition,
                "Headers": headers,
                "Length": length?.encodeToJSON(),
                "Name": name,
                "FileName": fileName
        ]

        let nonNullParameters = APIHelper.rejectNil(formParams)
        let parameters = APIHelper.convertBoolToString(nonNullParameters)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FileViewModel>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}