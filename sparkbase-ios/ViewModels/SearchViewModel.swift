import Foundation

@Observable final class SearchViewModel {
    var query = "" {
        didSet { scheduleSearch() }
    }
    var results: [Product] = []
    var isLoading = false
    var isLoadingMore = false
    var errorMessage: String?
    var hasMore = true

    @ObservationIgnored var currentPage = 0
    @ObservationIgnored var total = 0
    @ObservationIgnored var searchTask: Task<Void, Never>?
    @ObservationIgnored let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func scheduleSearch() {
        searchTask?.cancel()
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            results = []
            return
        }
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }
            await self?.performSearch(reset: true)
        }
    }

    private func performSearch(reset: Bool) async {
        if reset {
            currentPage = 0
            hasMore = true
            results = []
        }
        isLoading = true
        errorMessage = nil

        do {
            let response = try await repository.searchProducts(query: query, page: currentPage)
            guard !Task.isCancelled else { return }
            if reset {
                results = response.products
            } else {
                results.append(contentsOf: response.products)
            }
            total = response.total
            hasMore = results.count < response.total
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    func loadMore() async {
        guard !isLoading, hasMore else { return }
        isLoadingMore = true
        currentPage += 1
        await performSearch(reset: false)
        isLoadingMore = false
    }

    func resetSearch() {
        searchTask?.cancel()
        query = ""
        results = []
        errorMessage = nil
        currentPage = 0
        hasMore = true
    }
}
