//
// ProfileITNAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire


open class ProfileITNAPI {
    /**
     Получение изображения ИНН текущего пользователя

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func downloadItn(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        downloadItnWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     Получение изображения ИНН текущего пользователя
     - GET /profile/itn/download


     - returns: RequestBuilder<Void> 
     */
    open class func downloadItnWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/profile/itn/download"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     ИНН текущего пользователя

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getItn(completion: @escaping ((_ data: StoryITN?,_ error: Error?) -> Void)) {
        getItnWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     ИНН текущего пользователя
     - GET /profile/itn

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

     - returns: RequestBuilder<StoryITN> 
     */
    open class func getItnWithRequestBuilder() -> RequestBuilder<StoryITN> {
        let path = "/profile/itn"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<StoryITN>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Удаление изображения ИНН текущего пользователя

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func removeItnBlob(completion: @escaping ((_ data: StoryITN?,_ error: Error?) -> Void)) {
        removeItnBlobWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Удаление изображения ИНН текущего пользователя
     - DELETE /profile/itn/upload

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

     - returns: RequestBuilder<StoryITN> 
     */
    open class func removeItnBlobWithRequestBuilder() -> RequestBuilder<StoryITN> {
        let path = "/profile/itn/upload"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<StoryITN>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Изменение ИНН текущего пользователя

     - parameter body: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func setItn(body: StoryITNDTO? = nil, completion: @escaping ((_ data: StoryITN?,_ error: Error?) -> Void)) {
        setItnWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Изменение ИНН текущего пользователя
     - PUT /profile/itn

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
     - parameter body: (body)  (optional)

     - returns: RequestBuilder<StoryITN> 
     */
    open class func setItnWithRequestBuilder(body: StoryITNDTO? = nil) -> RequestBuilder<StoryITN> {
        let path = "/profile/itn"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<StoryITN>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Загрузка изображения ИНН текущего пользователя

     - parameter contentType: (form)  (optional)
     - parameter contentDisposition: (form)  (optional)
     - parameter headers: (form)  (optional)
     - parameter length: (form)  (optional)
     - parameter name: (form)  (optional)
     - parameter fileName: (form)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func uploadItn(contentType: String? = nil, contentDisposition: String? = nil, headers: [String:[String]]? = nil, length: Int64? = nil, name: String? = nil, fileName: String? = nil, completion: @escaping ((_ data: StoryITN?,_ error: Error?) -> Void)) {
        uploadItnWithRequestBuilder(contentType: contentType, contentDisposition: contentDisposition, headers: headers, length: length, name: name, fileName: fileName).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Загрузка изображения ИНН текущего пользователя
     - PUT /profile/itn/upload

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
     - parameter contentType: (form)  (optional)
     - parameter contentDisposition: (form)  (optional)
     - parameter headers: (form)  (optional)
     - parameter length: (form)  (optional)
     - parameter name: (form)  (optional)
     - parameter fileName: (form)  (optional)

     - returns: RequestBuilder<StoryITN> 
     */
    open class func uploadItnWithRequestBuilder(contentType: String? = nil, contentDisposition: String? = nil, headers: [String:[String]]? = nil, length: Int64? = nil, name: String? = nil, fileName: String? = nil) -> RequestBuilder<StoryITN> {
        let path = "/profile/itn/upload"
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

}
