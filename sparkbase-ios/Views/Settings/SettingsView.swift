import SwiftUI

struct SettingsView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(CartViewModel.self) private var cartVM
    @Environment(WishlistViewModel.self) private var wishlistVM

    var body: some View {
        NavigationStack {
            List {
                appearanceSection
                colorPaletteSection
                dataSection
                aboutSection
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Settings")
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            ForEach(ColorSchemePreference.allCases) { preference in
                Button {
                    withAnimation { themeManager.preference = preference }
                } label: {
                    HStack {
                        Image(systemName: preference.icon)
                            .foregroundStyle(Color.appPrimary)
                            .frame(width: 24)
                        Text(preference.label)
                            .foregroundStyle(Color.appTextPrimary)
                        Spacer()
                        if themeManager.preference == preference {
                            Image(systemName: "checkmark").foregroundStyle(Color.appPrimary)
                        }
                    }
                }
            }
        }
    }

    private var colorPaletteSection: some View {
        Section("Color Palette") {
            colorSwatchRow(swatches: [
                ("Primary",   Color.appPrimary),
                ("Secondary", Color.appSecondary),
                ("Surface",   Color.appSurface)
            ])
            colorSwatchRow(swatches: [
                ("Success",    Color.appSuccess),
                ("Warning",    Color.appWarning),
                ("Error",      Color.appError)
            ])
            colorSwatchRow(swatches: [
                ("Background", Color.appBackground),
                ("Variant",    Color.appSurfaceVariant),
                ("Divider",    Color.appDivider)
            ])
        }
    }

    private func colorSwatchRow(swatches: [(String, Color)]) -> some View {
        HStack(spacing: 10) {
            ForEach(swatches, id: \.0) { name, color in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(height: 36)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appDivider, lineWidth: 1))
                    Text(name)
                        .font(AppFont.caption2())
                        .foregroundStyle(Color.appTextSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var dataSection: some View {
        Section("Data") {
            HStack {
                Text("Cart items").foregroundStyle(Color.appTextPrimary)
                Spacer()
                Text("\(cartVM.itemCount)").foregroundStyle(Color.appTextSecondary)
            }
            HStack {
                Text("Wishlist items").foregroundStyle(Color.appTextPrimary)
                Spacer()
                Text("\(wishlistVM.itemCount)").foregroundStyle(Color.appTextSecondary)
            }
            Button("Clear Cart", role: .destructive) {
                cartVM.clear()
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("API")
                Spacer()
                Text("DummyJSON").foregroundStyle(Color.appTextSecondary)
            }
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0").foregroundStyle(Color.appTextSecondary)
            }
            HStack {
                Text("Storage")
                Spacer()
                Text("SwiftData").foregroundStyle(Color.appTextSecondary)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(ThemeManager())
        .environment(CartViewModel(
            repository: AppDependencies.shared.cartRepository,
            orderRepository: AppDependencies.shared.orderRepository
        ))
        .environment(WishlistViewModel(repository: AppDependencies.shared.wishlistRepository))
        .withPreviewContainer()
}
