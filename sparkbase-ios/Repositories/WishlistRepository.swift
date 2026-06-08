import Foundation

final class WishlistRepository {
    private let localDataSource: LocalDataSource

    init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource
    }

    func fetchItems() throws -> [WishlistItem] {
        try localDataSource.fetchWishlistItems()
    }

    func toggle(product: Product) throws {
        try localDataSource.toggleWishlist(product: product)
    }

    func remove(productId: Int) throws {
        try localDataSource.removeWishlistItem(productId: productId)
    }

    func isWishlisted(productId: Int) throws -> Bool {
        try localDataSource.isWishlisted(productId: productId)
    }
}
