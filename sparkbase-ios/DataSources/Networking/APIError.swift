import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkFailure(Error)
    case invalidResponse(statusCode: Int)
    case decodingFailure(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid."
        case .networkFailure(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse(let statusCode):
            return "Server returned status \(statusCode)."
        case .decodingFailure(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
