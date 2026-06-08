import SwiftUI
import SwiftData

struct WishlistView: View {
    @Environment(WishlistViewModel.self) private var wishlistVM
    @Environment(CartViewModel.self) private var cartVM
    @Query private var items: [WishlistItem]
    @State private var path = NavigationPath()

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if items.isEmpty {
                    ContentUnavailableView("No items wishlisted", systemImage: "heart.slash", description: Text("Tap the heart on any product to save it."))
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(items, id: \.productId) { item in
                                WishlistItemCard(item: item)
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Wishlist")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
        }
    }
}

private struct WishlistItemCard: View {
    let item: WishlistItem
    @Environment(WishlistViewModel.self) private var wishlistVM
    @Environment(CartViewModel.self) private var cartVM

    private var discountedPrice: Double { item.price * (1 - item.discountPercentage / 100) }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: item.thumbnail)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.appSurfaceVariant
                }
                .frame(height: 130)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Button {
                    wishlistVM.removeItem(productId: item.productId)
                } label: {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(Color.appSecondary)
                        .padding(8)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                }
                .padding(8)
            }

            Text(item.title)
                .font(AppFont.subheadline())
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(2)

            Text(String(format: "$%.2f", discountedPrice))
                .font(AppFont.price())
                .foregroundStyle(Color.appPrice)

            HStack(spacing: 2) {
                Image(systemName: "star.fill").font(.system(size: 10)).foregroundStyle(Color.appWarning)
                Text(String(format: "%.1f", item.rating)).font(AppFont.caption1()).foregroundStyle(Color.appTextSecondary)
            }

            Button("Add to Cart") {
                cartVM.addToCartFromWishlist(item: item)
            }
            .font(AppFont.footnote())
            .foregroundStyle(Color.appOnPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(Color.appPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(10)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    WishlistView()
        .environment(WishlistViewModel(repository: AppDependencies.shared.wishlistRepository))
        .environment(CartViewModel(
            repository: AppDependencies.shared.cartRepository,
            orderRepository: AppDependencies.shared.orderRepository
        ))
        .withPreviewContainer()
}
