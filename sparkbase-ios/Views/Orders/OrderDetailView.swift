import SwiftUI

struct OrderDetailView: View {
    let order: Order

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.id.uuidString.prefix(8).uppercased())")
                        .font(AppFont.title3())
                        .foregroundStyle(Color.appTextPrimary)
                    Text(order.placedAt.formatted(date: .complete, time: .shortened))
                        .font(AppFont.footnote())
                        .foregroundStyle(Color.appTextSecondary)
                    HStack(spacing: 4) {
                        Circle().fill(Color.appSuccess).frame(width: 7, height: 7)
                        Text(order.status).font(AppFont.footnote()).foregroundStyle(Color.appSuccess)
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 0) {
                    ForEach(order.lineItems) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title).font(AppFont.subheadline()).foregroundStyle(Color.appTextPrimary)
                                Text("Qty: \(item.quantity)").font(AppFont.footnote()).foregroundStyle(Color.appTextSecondary)
                            }
                            Spacer()
                            Text(String(format: "$%.2f", item.price * Double(item.quantity)))
                                .font(AppFont.callout())
                                .foregroundStyle(Color.appPrice)
                        }
                        .padding()
                        Divider().padding(.horizontal)
                    }

                    HStack {
                        Text("Total").font(AppFont.headline()).foregroundStyle(Color.appTextPrimary)
                        Spacer()
                        Text(String(format: "$%.2f", order.total)).font(AppFont.price()).foregroundStyle(Color.appPrice)
                    }
                    .padding()
                }
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.appBackground)
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
