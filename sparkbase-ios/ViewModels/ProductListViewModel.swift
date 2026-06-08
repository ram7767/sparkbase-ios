import Foundation

@Observable final class ProductListViewModel {
    var products: [Product] = []
    var categories: [ProductCategory] = []
    var selectedCategory: ProductCategory?
    var isLoading = false
    var isLoadingMore = false
    var errorMessage: String?
    var hasMore = true

    @ObservationIgnored private var currentPage = 0
    @ObservationIgnored private var total = 0
    @ObservationIgnored private var hasLoadedInitial = false
    @ObservationIgnored private var cachedAllProducts: [Product] = []
    @ObservationIgnored private var cachedAllTotal = 0
    @ObservationIgnored private var cachedAllPage = 0
    @ObservationIgnored private var cachedAllHasMore = true
    @ObservationIgnored private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func loadInitial() async {
        if hasLoadedInitial { return }
        isLoading = true
        errorMessage = nil
        currentPage = 0
        hasMore = true

        do {
            async let productsTask = repository.fetchProducts(page: 0)
            async let categoriesTask = repository.fetchCategories()
            let (response, cats) = try await (productsTask, categoriesTask)
            products = response.products
            total = response.total
            categories = cats
            hasMore = products.count < response.total
            cachedAllProducts = products
            cachedAllTotal = total
            cachedAllPage = currentPage
            cachedAllHasMore = hasMore
            hasLoadedInitial = true
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    func loadMore() async {
        guard !isLoadingMore, hasMore else { return }
        isLoadingMore = true
        currentPage += 1

        do {
            let response: ProductsResponse
            if let cat = selectedCategory {
                response = try await repository.fetchProductsByCategory(slug: cat.slug, page: currentPage)
            } else {
                response = try await repository.fetchProducts(page: currentPage)
            }
            products.append(contentsOf: response.products)
            hasMore = products.count < response.total
            if selectedCategory == nil {
                cachedAllProducts = products
                cachedAllTotal = response.total
                cachedAllPage = currentPage
                cachedAllHasMore = hasMore
            }
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
            currentPage -= 1
        }
        isLoadingMore = false
    }

    func loadByCategory(_ category: ProductCategory?) async {
        selectedCategory = category

        if category == nil, !cachedAllProducts.isEmpty {
            products = cachedAllProducts
            total = cachedAllTotal
            currentPage = cachedAllPage
            hasMore = cachedAllHasMore
            errorMessage = nil
            return
        }

        isLoading = true
        errorMessage = nil
        currentPage = 0
        hasMore = true

        do {
            let response: ProductsResponse
            if let cat = category {
                response = try await repository.fetchProductsByCategory(slug: cat.slug, page: 0)
            } else {
                response = try await repository.fetchProducts(page: 0)
            }
            products = response.products
            total = response.total
            hasMore = products.count < response.total
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}
