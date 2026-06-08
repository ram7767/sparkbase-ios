import SwiftData
import SwiftUI

final class AppDependencies {
    static let shared = AppDependencies()

    static let previewContainer: ModelContainer = {
        let schema = Schema([CachedProduct.self, CartItem.self, WishlistItem.self, Order.self, OrderLineItem.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    let modelContainer: ModelContainer
    let apiClient: APIClient
    let localDataSource: LocalDataSource
    let productRemoteDataSource: ProductRemoteDataSource
    let productRepository: ProductRepository
    let cartRepository: CartRepository
    let wishlistRepository: WishlistRepository
    let orderRepository: OrderRepository

    private init() {
        let schema = Schema([CachedProduct.self, CartItem.self, WishlistItem.self, Order.self, OrderLineItem.self])
        let config = ModelConfiguration(schema: schema)
        modelContainer = try! ModelContainer(for: schema, configurations: [config])
        apiClient = APIClient()
        localDataSource = LocalDataSource(container: modelContainer)
        productRemoteDataSource = ProductRemoteDataSource(apiClient: apiClient)
        productRepository = ProductRepository(remoteDataSource: productRemoteDataSource, localDataSource: localDataSource)
        cartRepository = CartRepository(localDataSource: localDataSource)
        wishlistRepository = WishlistRepository(localDataSource: localDataSource)
        orderRepository = OrderRepository(localDataSource: localDataSource)
    }
}

extension View {
    func withPreviewContainer() -> some View {
        self.modelContainer(AppDependencies.previewContainer)
    }
}
