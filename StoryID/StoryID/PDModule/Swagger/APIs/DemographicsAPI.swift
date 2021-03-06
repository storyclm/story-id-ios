//
// DemographicsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire


open class DemographicsAPI {
    /**
     Получение личных данных

     - parameter _id: (path) Уникальный идентификатор профиля в формате StoryId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDemographicsById(_id: String, completion: @escaping ((_ data: StoryDemographics?,_ error: Error?) -> Void)) {
        getDemographicsByIdWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Получение личных данных
     - GET /profiles/{id}/demographics

     - examples: [{contentType=application/json, example={
  "birthday" : "2000-01-23T04:56:07.000+00:00",
  "patronymic" : "patronymic",
  "gender" : true,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "surname" : "surname",
  "verified" : true,
  "verifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "name" : "name",
  "modifiedBy" : "modifiedBy",
  "verifiedBy" : "verifiedBy"
}}]
     - parameter _id: (path) Уникальный идентификатор профиля в формате StoryId 

     - returns: RequestBuilder<StoryDemographics> 
     */
    open class func getDemographicsByIdWithRequestBuilder(_id: String) -> RequestBuilder<StoryDemographics> {
        var path = "/profiles/{id}/demographics"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<StoryDemographics>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Изменение личных данных

     - parameter _id: (path) Уникальный идентификатор профиля в формате StoryId 
     - parameter body: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func setDemographics(_id: String, body: StoryDemographicsDTO? = nil, completion: @escaping ((_ data: StoryDemographics?,_ error: Error?) -> Void)) {
        setDemographicsWithRequestBuilder(_id: _id, body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Изменение личных данных
     - PUT /profiles/{id}/demographics

     - examples: [{contentType=application/json, example={
  "birthday" : "2000-01-23T04:56:07.000+00:00",
  "patronymic" : "patronymic",
  "gender" : true,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "surname" : "surname",
  "verified" : true,
  "verifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "name" : "name",
  "modifiedBy" : "modifiedBy",
  "verifiedBy" : "verifiedBy"
}}]
     - parameter _id: (path) Уникальный идентификатор профиля в формате StoryId 
     - parameter body: (body)  (optional)

     - returns: RequestBuilder<StoryDemographics> 
     */
    open class func setDemographicsWithRequestBuilder(_id: String, body: StoryDemographicsDTO? = nil) -> RequestBuilder<StoryDemographics> {
        var path = "/profiles/{id}/demographics"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<StoryDemographics>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Подтверждение личных данных

     - parameter _id: (path) Уникальный идентификатор профиля в формате StoryId 
     - parameter verified: (query)  (optional, default to false)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func verifyDemographics(_id: String, verified: Bool? = nil, completion: @escaping ((_ data: StoryDemographics?,_ error: Error?) -> Void)) {
        verifyDemographicsWithRequestBuilder(_id: _id, verified: verified).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Подтверждение личных данных
     - PUT /profiles/{id}/demographics/verify

     - examples: [{contentType=application/json, example={
  "birthday" : "2000-01-23T04:56:07.000+00:00",
  "patronymic" : "patronymic",
  "gender" : true,
  "profileId" : "profileId",
  "modifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "surname" : "surname",
  "verified" : true,
  "verifiedAt" : "2000-01-23T04:56:07.000+00:00",
  "name" : "name",
  "modifiedBy" : "modifiedBy",
  "verifiedBy" : "verifiedBy"
}}]
     - parameter _id: (path) Уникальный идентификатор профиля в формате StoryId 
     - parameter verified: (query)  (optional, default to false)

     - returns: RequestBuilder<StoryDemographics> 
     */
    open class func verifyDemographicsWithRequestBuilder(_id: String, verified: Bool? = nil) -> RequestBuilder<StoryDemographics> {
        var path = "/profiles/{id}/demographics/verify"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
                        "verified": verified
        ])

        let requestBuilder: RequestBuilder<StoryDemographics>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
