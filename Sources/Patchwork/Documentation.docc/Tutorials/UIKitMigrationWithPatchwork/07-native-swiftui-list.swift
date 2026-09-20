import SwiftUI

struct CatalogItem: Identifiable, Sendable {
    let id: String
    let title: String
    let detail: String
}

struct CatalogSummary: View {
    let item: CatalogItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title).font(.headline)
            Text(item.detail).font(.subheadline).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CatalogScreen: View {
    let items: [CatalogItem]

    var body: some View {
        NavigationStack {
            List(items) { item in
                CatalogSummary(item: item)
            }
            .navigationTitle("Catalog")
        }
    }
}
