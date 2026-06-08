import Foundation

final class ProductRepository {
    private let remoteDataSource: ProductRemoteDataSource
    private let localDataSource: LocalDataSource
    private let pageSize = 20

    init(remoteDataSource: ProductRemoteDataSource, localDataSource: LocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetchProducts(page: Int) async throws -> ProductsResponse {
        let skip = page * pageSize
        let response = try await remoteDataSource.fetchProducts(limit: pageSize, skip: skip)
        try? localDataSource.cacheProducts(response.products)
        return response
    }

    func fetchProduct(id: Int) async throws -> Product {
        try await remoteDataSource.fetchProduct(id: id)
    }

    func fetchCategories() async throws -> [ProductCategory] {
        try await remoteDataSource.fetchCategories()
    }

    func fetchProductsByCategory(slug: String, page: Int) async throws -> ProductsResponse {
        let skip = page * pageSize
        return try await remoteDataSource.fetchProductsByCategory(slug: slug, limit: pageSize, skip: skip)
    }

    func searchProducts(query: String, page: Int) async throws -> ProductsResponse {
        let skip = page * pageSize
        return try await remoteDataSource.searchProducts(query: query, limit: pageSize, skip: skip)
    }
}
