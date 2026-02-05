import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
    case incorrectRequest(String)

    var isNoInternet: Bool {
        guard case .urlRequestError(let error) = self,
              let urlError = error as? URLError else { return false }
        return urlError.code == .notConnectedToInternet
            || urlError.code == .networkConnectionLost
            || urlError.code == .cannotFindHost
            || urlError.code == .cannotConnectToHost
    }

    var isTimedOut: Bool {
        guard case .urlRequestError(let error) = self,
              let urlError = error as? URLError else { return false }
        return urlError.code == .timedOut
    }
}

protocol URLEncodable {
    func urlEncodedData() -> Data?
}

protocol NetworkClient {
    func send(request: NetworkRequest) async throws -> Data
    func send<T: Decodable>(request: NetworkRequest) async throws -> T
}

actor DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func send(request: NetworkRequest) async throws -> Data {
        let urlRequest = try create(request: request)

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkClientError.urlSessionError
            }
            guard 200 ..< 300 ~= response.statusCode else {
                throw NetworkClientError.httpStatusCode(response.statusCode)
            }

            return data
        } catch let urlError as URLError {
            throw NetworkClientError.urlRequestError(urlError)
        } catch {
            throw NetworkClientError.urlRequestError(error)
        }
    }
    
    func send<T: Decodable>(request: NetworkRequest) async throws -> T {
        let data = try await send(request: request)
        return try await parse(data: data)
    }
    
    // MARK: - Private
    
    private func create(request: NetworkRequest) throws -> URLRequest {
        guard let endpoint = request.endpoint else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue

        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if let body = request.body {
            urlRequest.httpBody = body
        } else if let dto = request.dto {
            let contentType = request.contentType ?? "application/json"

            if contentType == "application/x-www-form-urlencoded" {
                guard let urlEncodedDTO = dto as? URLEncodable else {
                    throw NetworkClientError.incorrectRequest(
                        "DTO must conform to URLEncodable for urlencoded content type"
                    )
                }
                urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = urlEncodedDTO.urlEncodedData()
            } else {
                let dtoEncoded = try encoder.encode(dto)
                urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = dtoEncoded
            }
        }

        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return urlRequest
    }
    
    private func parse<T: Decodable>(data: Data) async throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkClientError.parsingError
        }
    }
}
