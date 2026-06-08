import SwiftUI
import SwiftData

struct CartView: View {
    @Environment(CartViewModel.self) private var cartVM
    @Environment(OrderHistoryViewModel.self) private var orderHistoryVM
    @Query private var items: [CartItem]
    @State private var showOrderConfirm = false
    @State private var orderPlaced = false

    private var total: Double { items.reduce(0) { $0 + $1.totalPrice } }

    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty {
                    ContentUnavailableView("Your cart is empty", systemImage: "cart", description: Text("Add some products to get started."))
                } else {
                    cartList
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Cart")
            .toolbar {
                if !items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Place Order") { showOrderConfirm = true }
                            .font(AppFont.headline())
                            .foregroundStyle(Color.appPrimary)
                    }
                }
            }
            .alert("Place Order", isPresented: $showOrderConfirm) {
                Button("Confirm") {
                    cartVM.placeOrder()
                    orderHistoryVM.load()
                    orderPlaced = true
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Total: \(String(format: "$%.2f", total))\nConfirm your order?")
            }
            .alert("Order placed!", isPresented: $orderPlaced) {
                Button("OK") {}
            }
        }
    }

    private var cartList: some View {
        List {
            ForEach(items, id: \.productId) { item in
                CartItemRow(item: item)
                    .listRowBackground(Color.appSurface)
            }
            .onDelete { indexSet in
                indexSet.forEach { cartVM.remove(productId: items[$0].productId) }
            }

            Section {
                HStack {
                    Text("Total").font(AppFont.headline()).foregroundStyle(Color.appTextPrimary)
                    Spacer()
                    Text(String(format: "$%.2f", total)).font(AppFont.price()).foregroundStyle(Color.appPrice)
                }
            }
            .listRowBackground(Color.appSurface)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
}

private struct CartItemRow: View {
    let item: CartItem
    @Environment(CartViewModel.self) private var cartVM

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.thumbnail)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.appSurfaceVariant
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(AppFont.subheadline()).lineLimit(2).foregroundStyle(Color.appTextPrimary)
                Text(String(format: "$%.2f", item.price)).font(AppFont.footnote()).foregroundStyle(Color.appTextSecondary)
            }

            Spacer()

            HStack(spacing: 8) {
                Button {
                    cartVM.decrement(productId: item.productId)
                } label: {
                    Image(systemName: "minus.circle.fill").foregroundStyle(Color.appPrimary)
                }
                Text("\(item.quantity)").font(AppFont.headline()).frame(minWidth: 20)
                Button {
                    cartVM.increment(productId: item.productId)
                } label: {
                    Image(systemName: "plus.circle.fill").foregroundStyle(Color.appPrimary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CartView()
        .environment(CartViewModel(
            repository: AppDependencies.shared.cartRepository,
            orderRepository: AppDependencies.shared.orderRepository
        ))
        .environment(OrderHistoryViewModel(repository: AppDependencies.shared.orderRepository))
        .withPreviewContainer()
}
