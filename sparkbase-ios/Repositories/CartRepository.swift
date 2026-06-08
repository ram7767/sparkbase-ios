import Foundation

final class CartRepository {
    private let localDataSource: LocalDataSource

    init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchItems() throws -> [CartItem] {
        try localDataSource.fetchCartItems()
    }

    func addToCart(product: Product) throws {
        try localDataSource.addToCart(product: product)
    }

    func addToCartFromWishlist(item: WishlistItem) throws {
        try localDataSource.addToCartFromWishlist(item: item)
    }

    func increment(productId: Int) throws {
        try localDataSource.incrementCartItem(productId: productId)
    }

    func decrement(productId: Int) throws {
        try localDataSource.decrementCartItem(productId: productId)
    }

    func remove(productId: Int) throws {
        try localDataSource.removeCartItem(productId: productId)
    }

    func clear() throws {
        try localDataSource.clearCart()
    }
}
