import SwiftData
import Foundation

@Model
final class OrderLineItem {
    var productId: Int
    var price: Double
    var quantity: Int
    var title: String

    init(productId: Int, price: Double, quantity: Int, title: String) {
        self.productId = productId
        self.price = price
        self.quantity = quantity
        self.title = title
    }
}
