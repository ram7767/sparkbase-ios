import SwiftData
import Foundation

@Model
final class Order {
    var id: UUID
    var placedAt: Date
    var status: String
    @Relationship(deleteRule: .cascade) var lineItems: [OrderLineItem]

    var total: Double { lineItems.reduce(0) { $0 + $1.price * Double($1.quantity) } }

    init(id: UUID = UUID(), placedAt: Date = Date(), status: String = "Placed", lineItems: [OrderLineItem] = []) {
        self.id = id
        self.placedAt = placedAt
        self.status = status
        self.lineItems = lineItems
    }
}
