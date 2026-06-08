import Foundation

enum APIEndpoint {
    case products(limit: Int, skip: Int)
    case product(id: Int)
    case categories
    case productsByCategory(slug: String, limit: Int, skip: Int)
    case searchProducts(query: String, limit: Int, skip: Int)

    private static let baseURL = "https://dummyjson.com"

    var url: URL? {
        var components = URLComponents(string: Self.baseURL)
        switch self {
        case .products(let limit, let skip):
            components?.path = "/products"
            components?.queryItems = queryItems(limit: limit, skip: skip)
        case .product(let id):
            components?.path = "/products/\(id)"
        case .categories:
            components?.path = "/products/categories"
        case .productsByCategory(let slug, let limit, let skip):
            components?.path = "/products/category/\(slug)"
            components?.queryItems = queryItems(limit: limit, skip: skip)
        case .searchProducts(let query, let limit, let skip):
            components?.path = "/products/search"
            var items = queryItems(limit: limit, skip: skip)
            items.append(URLQueryItem(name: "q", value: query))
            components?.queryItems = items
        }
        return components?.url
    }

    private func queryItems(limit: Int, skip: Int) -> [URLQueryItem] {
        [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip",  value: "\(skip)")
        ]
    }
}
