import SwiftUI

struct ProductListView: View {
    @State private var viewModel = ProductListViewModel(repository: AppDependencies.shared.productRepository)
    @State private var path = NavigationPath()
    @Environment(CartViewModel.self) private var cartVM
    @Environment(WishlistViewModel.self) private var wishlistVM

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                if let error = viewModel.errorMessage {
                    ErrorBannerView(message: error) {
                        Task { await viewModel.loadInitial() }
                    }
                    .padding(.top)
                }

                categoryChips
                    .padding(.horizontal)

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.products) { product in
                            ProductCardView(product: product)
                                .onTapGesture { path.append(product) }
                                .onAppear {
                                    if product.id == viewModel.products.last?.id {
                                        Task { await viewModel.loadMore() }
                                    }
                                }
                        }
                        if viewModel.isLoadingMore {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .gridCellColumns(2)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Products")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .task { await viewModel.loadInitial() }
        }
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                categoryChip(nil, label: "All")
                ForEach(viewModel.categories) { cat in
                    categoryChip(cat, label: cat.name)
                }
            }
            .padding(.vertical, 8)
        }
    }

    private func categoryChip(_ category: ProductCategory?, label: String) -> some View {
        let isSelected = viewModel.selectedCategory?.slug == category?.slug
        return Button(label) {
            Task { await viewModel.loadByCategory(category) }
        }
        .font(AppFont.subheadline())
        .foregroundStyle(isSelected ? Color.appOnPrimary : Color.appTextPrimary)
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(isSelected ? Color.appPrimary : Color.appSurfaceVariant)
        .clipShape(Capsule())
    }
}

#Preview {
    ProductListView()
        .environment(CartViewModel(
            repository: AppDependencies.shared.cartRepository,
            orderRepository: AppDependencies.shared.orderRepository
        ))
        .environment(WishlistViewModel(repository: AppDependencies.shared.wishlistRepository))
        .withPreviewContainer()
}
