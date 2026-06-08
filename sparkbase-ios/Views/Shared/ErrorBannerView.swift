import SwiftUI

struct ErrorBannerView: View {
    let message: String
    var retry: (() -> Void)?

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.appError)
            Text(message)
                .font(AppFont.footnote())
                .foregroundStyle(Color.appTextPrimary)
                .multilineTextAlignment(.leading)
            Spacer()
            if let retry {
                Button("Retry", action: retry)
                    .font(AppFont.footnote())
                    .foregroundStyle(Color.appPrimary)
            }
        }
        .padding()
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}
