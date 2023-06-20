import Foundation

enum NetworkConstants {
    static let baseUrl = URL(string: "https://648cbbf38620b8bae7ed510b.mockapi.io/api/v1")!
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var queryParameters: [String: String]? { get }
    var httpMethod: HttpMethod { get }
}

// default values
extension NetworkRequest {
    var queryParameters: [String: String]? { nil }
    var httpMethod: HttpMethod { .get }
}
