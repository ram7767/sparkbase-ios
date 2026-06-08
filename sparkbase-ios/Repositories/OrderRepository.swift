import Foundation

final class OrderRepository {
    private let localDataSource: LocalDataSource

    init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchOrders() throws -> [Order] {
        try localDataSource.fetchOrders()
    }

    func placeOrder(from cartItems: [CartItem]) throws {
        try localDataSource.placeOrder(from: cartItems)
    }
}
