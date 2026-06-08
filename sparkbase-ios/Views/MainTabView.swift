import SwiftUI

struct MainTabView: View {
    @State private var themeManager = ThemeManager()
    @State private var cartVM = CartViewModel(
        repository: AppDependencies.shared.cartRepository,
        orderRepository: AppDependencies.shared.orderRepository
    )
    @State private var wishlistVM = WishlistViewModel(repository: AppDependencies.shared.wishlistRepository)
    @State private var orderHistoryVM = OrderHistoryViewModel(repository: AppDependencies.shared.orderRepository)

    var body: some View {
        TabView {
            Tab("Products", systemImage: "square.grid.2x2.fill") {
                ProductListView()
            }
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
            }
            Tab("Cart", systemImage: "cart.fill") {
                CartView()
            }
            .badge(cartVM.itemCount > 0 ? Text("\(cartVM.itemCount)") : nil)
            Tab("Wishlist", systemImage: "heart.fill") {
                WishlistView()
            }
            .badge(wishlistVM.itemCount > 0 ? Text("\(wishlistVM.itemCount)") : nil)
            Tab("Orders", systemImage: "list.bullet.rectangle.fill") {
                OrderHistoryView()
            }
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
        }
        .tint(Color.appPrimary)
        .environment(themeManager)
        .environment(cartVM)
        .environment(wishlistVM)
        .environment(orderHistoryVM)
        .preferredColorScheme(themeManager.preference.colorScheme)
    }
}

#Preview {
    MainTabView()
        .withPreviewContainer()
}
