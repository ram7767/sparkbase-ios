import Foundation

@Observable final class WishlistViewModel {
    var items: [WishlistItem] = []
    var errorMessage: String?

    var itemCount: Int { items.count }

    @ObservationIgnored private let repository: WishlistRepository

    init(repository: WishlistRepository) {
        self.repository = repository
        load()
    }

    func load() {
        do { items = try repository.fetchItems() }
        catch { errorMessage = error.localizedDescription }
    }

    func toggle(product: Product) {
        do { try repository.toggle(product: product); load() }
        catch { errorMessage = error.localizedDescription }
    }

    func removeItem(productId: Int) {
        do { try repository.remove(productId: productId); load() }
        catch { errorMessage = error.localizedDescription }
    }

    func isWishlisted(productId: Int) -> Bool {
        items.contains { $0.productId == productId }
    }
}
