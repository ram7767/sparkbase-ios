import SwiftUI
import SwiftData

struct ProductDetailView: View {
    let product: Product
    @Environment(CartViewModel.self) private var cartVM
    @Environment(WishlistViewModel.self) private var wishlistVM
    @Query private var wishlistItems: [WishlistItem]
    @Query private var cartItems: [CartItem]
    @State private var selectedImageIndex = 0
    @State private var addedToCart = false

    private var isWishlisted: Bool {
        wishlistItems.contains { $0.productId == product.id }
    }

    private var cartQuantity: Int {
        cartItems.first { $0.productId == product.id }?.quantity ?? 0
    }

    private var stockColor: Color {
        if product.stock > 10 { return .appSuccess }
        if product.stock > 0  { return .appWarning }
        return .appError
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                imageCarousel

                VStack(alignment: .leading, spacing: 12) {
                    Text(product.title)
                        .font(AppFont.title2())
                        .foregroundStyle(Color.appTextPrimary)

                    priceSection

                    Text(product.description)
                        .font(AppFont.body())
                        .foregroundStyle(Color.appTextSecondary)

                    stockBadge
                    specSection
                    reviewsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .background(Color.appBackground)
        .navigationTitle(product.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    wishlistVM.toggle(product: product)
                } label: {
                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                        .foregroundStyle(Color.appSecondary)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            addToCartBar
        }
    }

    private var imageCarousel: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(Array(product.images.enumerated()), id: \.offset) { index, url in
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.appSurfaceVariant
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .frame(height: 280)
        .background(Color.appSurfaceVariant)
    }

    private var priceSection: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(String(format: "$%.2f", product.discountedPrice))
                .font(AppFont.price())
                .foregroundStyle(Color.appPrice)
            Text(String(format: "$%.2f", product.price))
                .font(AppFont.callout())
                .strikethrough()
                .foregroundStyle(Color.appTextSecondary)
            if product.discountPercentage > 0 {
                Text("-\(Int(product.discountPercentage))%")
                    .font(AppFont.badge())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.appDiscount)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }

    private var stockBadge: some View {
        HStack {
            Circle().fill(stockColor).frame(width: 8, height: 8)
            Text(product.availabilityStatus)
                .font(AppFont.footnote())
                .foregroundStyle(stockColor)
            Spacer()
            HStack(spacing: 2) {
                Image(systemName: "star.fill").font(.system(size: 11)).foregroundStyle(Color.appWarning)
                Text(String(format: "%.1f", product.rating)).font(AppFont.footnote()).foregroundStyle(Color.appTextSecondary)
            }
        }
    }

    private var specSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Specifications").font(AppFont.headline()).foregroundStyle(Color.appTextPrimary)
            specRow("Brand",       product.brand ?? "N/A")
            specRow("SKU",         product.sku)
            specRow("Weight",      "\(product.weight)g")
            specRow("Dimensions",  String(format: "%.1f × %.1f × %.1f cm", product.dimensions.width, product.dimensions.height, product.dimensions.depth))
            specRow("Warranty",    product.warrantyInformation)
            specRow("Shipping",    product.shippingInformation)
            specRow("Return",      product.returnPolicy)
        }
        .padding()
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func specRow(_ key: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(key).font(AppFont.footnote()).foregroundStyle(Color.appTextSecondary).frame(width: 90, alignment: .leading)
            Text(value).font(AppFont.footnote()).foregroundStyle(Color.appTextPrimary)
        }
    }

    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Reviews (\(product.reviews.count))")
                .font(AppFont.headline())
                .foregroundStyle(Color.appTextPrimary)
            ForEach(product.reviews, id: \.reviewerEmail) { review in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(review.reviewerName).font(AppFont.subheadline()).foregroundStyle(Color.appTextPrimary)
                        Spacer()
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: i <= review.rating ? "star.fill" : "star")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Color.appWarning)
                            }
                        }
                    }
                    Text(review.comment).font(AppFont.footnote()).foregroundStyle(Color.appTextSecondary)
                }
                .padding()
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    private var addToCartBar: some View {
        Button {
            cartVM.addToCart(product: product)
            addedToCart = true
            Task {
                try? await Task.sleep(for: .seconds(2))
                addedToCart = false
            }
        } label: {
            Text(addedToCart ? "Added!" : "Add to Cart")
                .font(AppFont.headline())
                .foregroundStyle(Color.appOnPrimary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(addedToCart ? Color.appSuccess : Color.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding()
        .background(.regularMaterial)
    }
}
