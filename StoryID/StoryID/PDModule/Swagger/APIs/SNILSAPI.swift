//
// SNILSAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire


open class SNILSAPI {
    /**
     Скачивание изображения

     - parameter _id: (path) Уникальный идентификатор в формате StoryId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func downloadSnils(_id: String, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        downloadSnilsWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     Скачивание изображения
     - GET /profiles/{id}/snils/download

     - parameter _id: (path) Уникальный идентификатор в формате StoryId 

     - returns: RequestBuilder<Void> 
     */
    open class func downloadSnilsWithRequestBuilder(_id: String) -> RequestBuilder<Void> {
        var path = "/profiles/{id}/snils/download"
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
     Получение СНИЛС

     - parameter _id: (path) Уникальный идентификатор в формате StoryId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSnilsById(_id: String, completion: @escaping ((_ data: StorySNILS?,_ error: Error?) -> Void)) {
        getSnilsByIdWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Получение СНИЛС
     - GET /profiles/{id}/snils

     - examples: [{contentType=application/json, example={
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "verified" : true,
  "verifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "modifiedBy" : "modifiedBy",
  "mimeType" : "mimeType",
  "verifiedBy" : "verifiedBy",
  "snils" : "snils"
}}]
     - parameter _id: (path) Уникальный идентификатор в формате StoryId 

     - returns: RequestBuilder<StorySNILS> 
     */
    open class func getSnilsByIdWithRequestBuilder(_id: String) -> RequestBuilder<StorySNILS> {
        var path = "/profiles/{id}/snils"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<StorySNILS>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Изменение СНИЛС

     - parameter _id: (path) Уникальный идентификатор в формате StoryId 
     - parameter body: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func setSnils(_id: String, body: StorySNILSDTO? = nil, completion: @escaping ((_ data: StorySNILS?,_ error: Error?) -> Void)) {
        setSnilsWithRequestBuilder(_id: _id, body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Изменение СНИЛС
     - PUT /profiles/{id}/snils

     - examples: [{contentType=application/json, example={
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "verified" : true,
  "verifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "modifiedBy" : "modifiedBy",
  "mimeType" : "mimeType",
  "verifiedBy" : "verifiedBy",
  "snils" : "snils"
}}]
     - parameter _id: (path) Уникальный идентификатор в формате StoryId 
     - parameter body: (body)  (optional)

     - returns: RequestBuilder<StorySNILS> 
     */
    open class func setSnilsWithRequestBuilder(_id: String, body: StorySNILSDTO? = nil) -> RequestBuilder<StorySNILS> {
        var path = "/profiles/{id}/snils"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<StorySNILS>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Загрузка изображения

     - parameter _id: (path)  
     - parameter contentType: (form)  (optional)
     - parameter contentDisposition: (form)  (optional)
     - parameter headers: (form)  (optional)
     - parameter length: (form)  (optional)
     - parameter name: (form)  (optional)
     - parameter fileName: (form)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func uploadSnils(_id: String, contentType: String? = nil, contentDisposition: String? = nil, headers: [String:[String]]? = nil, length: Int64? = nil, name: String? = nil, fileName: String? = nil, completion: @escaping ((_ data: StoryITN?,_ error: Error?) -> Void)) {
        uploadSnilsWithRequestBuilder(_id: _id, contentType: contentType, contentDisposition: contentDisposition, headers: headers, length: length, name: name, fileName: fileName).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Загрузка изображения
     - PUT /profiles/{id}/snils/upload

     - examples: [{contentType=application/json, example={
  "itn" : "itn",
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "verified" : true,
  "verifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "modifiedBy" : "modifiedBy",
  "mimeType" : "mimeType",
  "verifiedBy" : "verifiedBy"
}}]
     - parameter _id: (path)  
     - parameter contentType: (form)  (optional)
     - parameter contentDisposition: (form)  (optional)
     - parameter headers: (form)  (optional)
     - parameter length: (form)  (optional)
     - parameter name: (form)  (optional)
     - parameter fileName: (form)  (optional)

     - returns: RequestBuilder<StoryITN> 
     */
    open class func uploadSnilsWithRequestBuilder(_id: String, contentType: String? = nil, contentDisposition: String? = nil, headers: [String:[String]]? = nil, length: Int64? = nil, name: String? = nil, fileName: String? = nil) -> RequestBuilder<StoryITN> {
        var path = "/profiles/{id}/snils/upload"
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

        let requestBuilder: RequestBuilder<StoryITN>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Подтверждение ИНН

     - parameter _id: (path) Уникальный идентификатор в формате StoryId 
     - parameter verified: (query)  (optional, default to false)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func verifySnils(_id: String, verified: Bool? = nil, completion: @escaping ((_ data: StorySNILS?,_ error: Error?) -> Void)) {
        verifySnilsWithRequestBuilder(_id: _id, verified: verified).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Подтверждение ИНН
     - PUT /profiles/{id}/snils/verify

     - examples: [{contentType=application/json, example={
  "size" : 0,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "verified" : true,
  "verifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "modifiedBy" : "modifiedBy",
  "mimeType" : "mimeType",
  "verifiedBy" : "verifiedBy",
  "snils" : "snils"
}}]
     - parameter _id: (path) Уникальный идентификатор в формате StoryId 
     - parameter verified: (query)  (optional, default to false)

     - returns: RequestBuilder<StorySNILS> 
     */
    open class func verifySnilsWithRequestBuilder(_id: String, verified: Bool? = nil) -> RequestBuilder<StorySNILS> {
        var path = "/profiles/{id}/snils/verify"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
                        "verified": verified
        ])

        let requestBuilder: RequestBuilder<StorySNILS>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
