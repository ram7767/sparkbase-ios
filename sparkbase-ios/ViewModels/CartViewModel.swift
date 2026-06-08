import Foundation

@Observable final class CartViewModel {
    var items: [CartItem] = []
    var errorMessage: String?

    var total: Double { items.reduce(0) { $0 + $1.totalPrice } }
    var itemCount: Int { items.reduce(0) { $0 + $1.quantity } }

    @ObservationIgnored private let repository: CartRepository
    @ObservationIgnored private let orderRepository: OrderRepository

    init(repository: CartRepository, orderRepository: OrderRepository) {
        self.repository = repository
        self.orderRepository = orderRepository
        load()
    }

    func load() {
        do { items = try repository.fetchItems() }
        catch { errorMessage = error.localizedDescription }
    }

    func addToCart(product: Product) {
        do { try repository.addToCart(product: product); load() }
        catch { errorMessage = error.localizedDescription }
    }

    func addToCartFromWishlist(item: WishlistItem) {
        do { try repository.addToCartFromWishlist(item: item); load() }
        catch { errorMessage = error.localizedDescription }
    }

    func increment(productId: Int) {
        do { try repository.increment(productId: productId); load() }
        catch { errorMessage = error.localizedDescription }
    }

    func decrement(productId: Int) {
        do { try repository.decrement(productId: productId); load() }
        catch { errorMessage = error.localizedDescription }
    }

    func remove(productId: Int) {
        do { try repository.remove(productId: productId); load() }
        catch { errorMessage = error.localizedDescription }
    }

    func clear() {
        do { try repository.clear(); load() }
        catch { errorMessage = error.localizedDescription }
    }

    func placeOrder() {
        do { try orderRepository.placeOrder(from: items); load() }
        catch { errorMessage = error.localizedDescription }
    }
}
