import SwiftData
import Foundation

@Model
final class CachedProduct {
    @Attribute(.unique) var id: Int
    var title: String
    var productDescription: String
    var category: String
    var price: Double
    var discountPercentage: Double
    var rating: Double
    var stock: Int
    var thumbnail: String

    init(from product: Product) {
        self.id = product.id
        self.title = product.title
        self.productDescription = product.description
        self.category = product.category
        self.price = product.price
        self.discountPercentage = product.discountPercentage
        self.rating = product.rating
        self.stock = product.stock
        self.thumbnail = product.thumbnail
    }
}
