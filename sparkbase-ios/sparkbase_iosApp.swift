import SwiftUI
import SwiftData

@main
struct sparkbase_iosApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(AppDependencies.shared.modelContainer)
    }
}
