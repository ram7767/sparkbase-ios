import SwiftData
import Foundation

@Model
final class CartItem {
    @Attribute(.unique) var productId: Int
    var quantity: Int
    var title: String
    var price: Double
    var thumbnail: String

    var totalPrice: Double { price * Double(quantity) }

    init(productId: Int, quantity: Int = 1, title: String, price: Double, thumbnail: String) {
        self.productId = productId
        self.quantity = quantity
        self.title = title
        self.price = price
        self.thumbnail = thumbnail
    }
}
