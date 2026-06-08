import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel(repository: AppDependencies.shared.productRepository)
    @State private var path = NavigationPath()

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack(path: $path) {
            Group {
                if viewModel.isLoading && viewModel.results.isEmpty {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.results.isEmpty && !viewModel.query.trimmingCharacters(in: .whitespaces).isEmpty {
                    ContentUnavailableView.search(text: viewModel.query)
                } else if !viewModel.results.isEmpty {
                    resultsList
                } else {
                    ContentUnavailableView("Search Products", systemImage: "magnifyingglass", description: Text("Enter a term to find products."))
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Search")
            .searchable(text: $viewModel.query, prompt: "Search products…")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .onAppear { viewModel.resetSearch() }
        }
    }

    private var resultsList: some View {
        List {
            ForEach(viewModel.results) { product in
                ProductCardView(product: product)
                    .listRowBackground(Color.appBackground)
                    .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                    .onTapGesture { path.append(product) }
                    .onAppear {
                        if product.id == viewModel.results.last?.id {
                            Task { await viewModel.loadMore() }
                        }
                    }
            }
            if viewModel.isLoadingMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.appBackground)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchView()
        .environment(CartViewModel(
            repository: AppDependencies.shared.cartRepository,
            orderRepository: AppDependencies.shared.orderRepository
        ))
        .withPreviewContainer()
}
