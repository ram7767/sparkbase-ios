import Foundation

protocol ProductRemoteDataSourceProtocol {
    func fetchProducts(limit: Int, skip: Int) async throws -> ProductsResponse
    func fetchProduct(id: Int) async throws -> Product
    func fetchCategories() async throws -> [ProductCategory]
    func fetchProductsByCategory(slug: String, limit: Int, skip: Int) async throws -> ProductsResponse
    func searchProducts(query: String, limit: Int, skip: Int) async throws -> ProductsResponse
}

final class ProductRemoteDataSource: ProductRemoteDataSourceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchProducts(limit: Int, skip: Int) async throws -> ProductsResponse {
        try await apiClient.fetch(.products(limit: limit, skip: skip))
    }

    func fetchProduct(id: Int) async throws -> Product {
        try await apiClient.fetch(.product(id: id))
    }

    func fetchCategories() async throws -> [ProductCategory] {
        try await apiClient.fetch(.categories)
    }

    func fetchProductsByCategory(slug: String, limit: Int, skip: Int) async throws -> ProductsResponse {
        try await apiClient.fetch(.productsByCategory(slug: slug, limit: limit, skip: skip))
    }

    func searchProducts(query: String, limit: Int, skip: Int) async throws -> ProductsResponse {
        try await apiClient.fetch(.searchProducts(query: query, limit: limit, skip: skip))
    }
}
