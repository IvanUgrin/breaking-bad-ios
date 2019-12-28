//
import Alamofire
//  BaseService.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/27/19.
//
import Foundation
import SwiftyJSON

class BaseService {
    typealias Parameters = Alamofire.Parameters
    typealias Method = Alamofire.HTTPMethod
    typealias Result<T: ModelSerializable> = ([T]?) -> Void
    typealias JSONResult = (JSON?) -> Void

    internal let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Networking.headerFields
        configuration.waitsForConnectivity = true

        return SessionManager(configuration: configuration)
    }()

    internal func url(fromRelative: Networking.Endpoints) -> URLConvertible {
        return Networking.baseUrl + fromRelative.rawValue
    }

    internal func request(_ urlString: Networking.Endpoints, parameters: Parameters, method: Method = .get, completion: @escaping JSONResult) {
        sessionManager.request(url(fromRelative: urlString), method: method, parameters: parameters, encoding: BBEncoding(), headers: nil)
            .validate()
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data): do {
                    do {
                        completion(try JSON(data: data))
                    } catch {
                        completion(nil)
                        debugPrint("Parse error: \(error).")
                    }
                }
                case let .failure(error): do {
                    completion(nil)
                    debugPrint(error)
                }
                }
            })
    }

    internal func parseObject<T: ModelSerializable>(json: JSON) -> T {
        return T(json)
    }
}
