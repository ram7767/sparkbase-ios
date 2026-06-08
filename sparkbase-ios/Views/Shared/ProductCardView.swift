import SwiftUI
import SwiftData

struct ProductCardView: View {
    let product: Product
    @Environment(CartViewModel.self) private var cartVM
    @Environment(WishlistViewModel.self) private var wishlistVM
    @Query private var wishlistItems: [WishlistItem]
    @Query private var cartItems: [CartItem]

    private var isWishlisted: Bool {
        wishlistItems.contains { $0.productId == product.id }
    }

    private var isInCart: Bool {
        cartItems.contains { $0.productId == product.id }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: product.thumbnail)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.appSurfaceVariant
                }
                .frame(height: 140)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Button {
                    wishlistVM.toggle(product: product)
                } label: {
                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.appSecondary)
                        .padding(7)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(6)
            }

            Text(product.title)
                .font(AppFont.subheadline())
                .foregroundStyle(Color.appTextPrimary)
                .lineLimit(2)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(String(format: "$%.2f", product.discountedPrice))
                    .font(AppFont.price())
                    .foregroundStyle(Color.appPrice)
                if product.discountPercentage > 0 {
                    Text("-\(Int(product.discountPercentage))%")
                        .font(AppFont.badge())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.appDiscount)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }

            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.appWarning)
                Text(String(format: "%.1f", product.rating))
                    .font(AppFont.caption1())
                    .foregroundStyle(Color.appTextSecondary)
            }

            Button {
                cartVM.addToCart(product: product)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: isInCart ? "checkmark" : "cart.badge.plus")
                        .font(.system(size: 11, weight: .semibold))
                    Text(isInCart ? "In Cart" : "Add to Cart")
                        .font(AppFont.footnote())
                }
                .foregroundStyle(Color.appOnPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 7)
                .background(isInCart ? Color.appSuccess : Color.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}
