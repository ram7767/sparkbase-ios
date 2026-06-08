import SwiftUI

struct OrderHistoryView: View {
    @Environment(OrderHistoryViewModel.self) private var orderHistoryVM

    var body: some View {
        NavigationStack {
            Group {
                if orderHistoryVM.orders.isEmpty {
                    ContentUnavailableView("No orders yet", systemImage: "bag", description: Text("Place an order from your cart."))
                } else {
                    List(orderHistoryVM.orders) { order in
                        NavigationLink {
                            OrderDetailView(order: order)
                        } label: {
                            OrderRowView(order: order)
                        }
                        .listRowBackground(Color.appSurface)
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Orders")
            .onAppear { orderHistoryVM.load() }
        }
    }
}

private struct OrderRowView: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Order #\(order.id.uuidString.prefix(8).uppercased())")
                .font(AppFont.subheadline())
                .foregroundStyle(Color.appTextPrimary)
            Text(order.placedAt.formatted(date: .abbreviated, time: .shortened))
                .font(AppFont.footnote())
                .foregroundStyle(Color.appTextSecondary)
            Text(String(format: "$%.2f", order.total))
                .font(AppFont.callout())
                .foregroundStyle(Color.appPrice)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    OrderHistoryView()
        .environment(OrderHistoryViewModel(repository: AppDependencies.shared.orderRepository))
        .withPreviewContainer()
}
