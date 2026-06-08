import SwiftData
import Foundation

final class LocalDataSource {
    private let context: ModelContext

    init(container: ModelContainer) {
        self.context = container.mainContext
    }

    // MARK: - CachedProduct

    func cacheProducts(_ products: [Product]) throws {
        for product in products {
            let id = product.id
            let descriptor = FetchDescriptor<CachedProduct>(predicate: #Predicate { $0.id == id })
            if (try? context.fetch(descriptor))?.first != nil { continue }
            context.insert(CachedProduct(from: product))
        }
        try context.save()
    }

    func fetchCachedProducts() throws -> [CachedProduct] {
        try context.fetch(FetchDescriptor<CachedProduct>())
    }

    // MARK: - Cart

    func fetchCartItems() throws -> [CartItem] {
        try context.fetch(FetchDescriptor<CartItem>())
    }

    func addToCart(product: Product) throws {
        let id = product.id
        let descriptor = FetchDescriptor<CartItem>(predicate: #Predicate { $0.productId == id })
        if let existing = try context.fetch(descriptor).first {
            existing.quantity += 1
        } else {
            context.insert(CartItem(productId: product.id, title: product.title, price: product.discountedPrice, thumbnail: product.thumbnail))
        }
        try context.save()
    }

    func addToCartFromWishlist(item: WishlistItem) throws {
        let id = item.productId
        let descriptor = FetchDescriptor<CartItem>(predicate: #Predicate { $0.productId == id })
        if let existing = try context.fetch(descriptor).first {
            existing.quantity += 1
        } else {
            let discountedPrice = item.price * (1 - item.discountPercentage / 100)
            context.insert(CartItem(productId: item.productId, title: item.title, price: discountedPrice, thumbnail: item.thumbnail))
        }
        try context.save()
    }

    func incrementCartItem(productId: Int) throws {
        let descriptor = FetchDescriptor<CartItem>(predicate: #Predicate { $0.productId == productId })
        if let item = try context.fetch(descriptor).first {
            item.quantity += 1
            try context.save()
        }
    }

    func decrementCartItem(productId: Int) throws {
        let descriptor = FetchDescriptor<CartItem>(predicate: #Predicate { $0.productId == productId })
        if let item = try context.fetch(descriptor).first {
            if item.quantity > 1 { item.quantity -= 1 } else { context.delete(item) }
            try context.save()
        }
    }

    func removeCartItem(productId: Int) throws {
        let descriptor = FetchDescriptor<CartItem>(predicate: #Predicate { $0.productId == productId })
        if let item = try context.fetch(descriptor).first {
            context.delete(item)
            try context.save()
        }
    }

    func clearCart() throws {
        let items = try context.fetch(FetchDescriptor<CartItem>())
        items.forEach { context.delete($0) }
        try context.save()
    }

    // MARK: - Wishlist

    func fetchWishlistItems() throws -> [WishlistItem] {
        try context.fetch(FetchDescriptor<WishlistItem>())
    }

    func toggleWishlist(product: Product) throws {
        let id = product.id
        let descriptor = FetchDescriptor<WishlistItem>(predicate: #Predicate { $0.productId == id })
        if let existing = try context.fetch(descriptor).first {
            context.delete(existing)
        } else {
            context.insert(WishlistItem(productId: product.id, title: product.title, price: product.price, discountPercentage: product.discountPercentage, thumbnail: product.thumbnail, rating: product.rating))
        }
        try context.save()
    }

    func removeWishlistItem(productId: Int) throws {
        let descriptor = FetchDescriptor<WishlistItem>(predicate: #Predicate { $0.productId == productId })
        if let item = try context.fetch(descriptor).first {
            context.delete(item)
            try context.save()
        }
    }

    func isWishlisted(productId: Int) throws -> Bool {
        let descriptor = FetchDescriptor<WishlistItem>(predicate: #Predicate { $0.productId == productId })
        return try !context.fetch(descriptor).isEmpty
    }

    // MARK: - Orders

    func fetchOrders() throws -> [Order] {
        let descriptor = FetchDescriptor<Order>(sortBy: [SortDescriptor(\.placedAt, order: .reverse)])
        return try context.fetch(descriptor)
    }

    func placeOrder(from cartItems: [CartItem]) throws {
        let lineItems = cartItems.map { OrderLineItem(productId: $0.productId, price: $0.price, quantity: $0.quantity, title: $0.title) }
        let order = Order(lineItems: lineItems)
        context.insert(order)
        cartItems.forEach { context.delete($0) }
        try context.save()
    }
}
