import SwiftData
import Foundation

@Model
final class WishlistItem {
    @Attribute(.unique) var productId: Int
    var addedAt: Date
    var title: String
    var price: Double
    var discountPercentage: Double
    var thumbnail: String
    var rating: Double

    init(productId: Int, title: String, price: Double, discountPercentage: Double, thumbnail: String, rating: Double) {
        self.productId = productId
        self.addedAt = Date()
        self.title = title
        self.price = price
        self.discountPercentage = discountPercentage
        self.thumbnail = thumbnail
        self.rating = rating
    }
}
