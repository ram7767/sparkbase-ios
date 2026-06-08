import Foundation

struct ProductsResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ProductCategory: Codable, Identifiable, Hashable {
    let slug: String
    let name: String
    let url: String
    var id: String { slug }
}
