//
//  APIManager.swift
//  Weather forecast
//
//  Created by Anand t on 13/06/21.
//

import Foundation

class APIManager {
    
    // MARK: - Properties
    
    var requestHttpHeaders = APIEntity()
    var urlQueryParameters = APIEntity()
    var httpBodyParameters = APIEntity()
    var httpBody: Data?

    // MARK: - Public Methods
    
    func makeAPIRequest(toURL url: URL,
                     withHttpMethod httpMethod: HttpMethod,
                     completion: @escaping (_ result: Results) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let targetURL = self?.addAPIURLQueryParameters(toURL: url)
            let httpBody = self?.getHttpBody()
            guard let request = self?.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else {
                completion(Results(withError: CustomError.failedToCreateRequest))
                return
            }
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            sessionConfiguration.timeoutIntervalForResource = APIClientConstants.reqTimeOutSeconds
            let task = session.dataTask(with: request) { (data, response, error) in
                completion(Results(withData: data,
                                   response: Response(fromURLResponse: response),
                                   error: error))
            }
            task.resume()
        }
    }
    
    // MARK: - Private Methods
    
    private func addAPIURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters.allValues() {
                let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                queryItems.append(item)
            }
            urlComponents.queryItems = queryItems
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        return url
    }

    private func getHttpBody() -> Data? {
        guard let contentType = requestHttpHeaders.value(forKey: APIHeadersType.content) else { return nil }
        if contentType.contains(APIHeadersType.json) {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted, .sortedKeys])
        } else if contentType.contains(APIHeadersType.urlEncoded) {
            let bodyString = httpBodyParameters.allValues().map { "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return httpBody
        }
    }
    private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        for (header, value) in requestHttpHeaders.allValues() {
            request.setValue(value, forHTTPHeaderField: header)
        }
        request.httpBody = httpBody
        return request
    }
}


// MARK: - RestManager Custom Types
extension APIManager {
    struct APIEntity {
        private var values: [String: String] = [:]
        mutating func add(value: String, forKey key: String) {
            values[key] = value
        }
        func value(forKey key: String) -> String? {
            return values[key]
        }
        func allValues() -> [String: String] {
            return values
        }
        func totalItems() -> Int {
            return values.count
        }
    }

    struct Response {
        var response: URLResponse?
        var httpStatusCode: Int = 0
        var headers = APIEntity()
        init(fromURLResponse response: URLResponse?) {
            guard let response = response else { return }
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
                for (key, value) in headerFields {
                    headers.add(value: "\(value)", forKey: "\(key)")
                }
            }
        }
    }

    struct Results {
        var data: Data?
        var response: Response?
        var error: Error?
        init(withData data: Data?, response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        init(withError error: Error) {
            self.error = error
        }
    }

    enum CustomError: Error {
        case failedToCreateRequest
    }
}
