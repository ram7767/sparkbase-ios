import Foundation

@Observable final class OrderHistoryViewModel {
    var orders: [Order] = []
    var errorMessage: String?

    @ObservationIgnored private let repository: OrderRepository

    init(repository: OrderRepository) {
        self.repository = repository
    }

    func load() {
        do { orders = try repository.fetchOrders() }
        catch { errorMessage = error.localizedDescription }
    }
}
