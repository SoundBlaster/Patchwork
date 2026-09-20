import Patchwork
import ScreenKit
import SwiftUI

struct CatalogItem: Hashable, Identifiable, Sendable {
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

@MainActor
func makeCatalogController(_ items: [CatalogItem]) -> ScreenViewController<Int, CatalogItem> {
    let swiftUIRenderer: ScreenCellRenderer<CatalogItem> = Patchwork.swiftUI { item in
        CatalogSummary(item: item)
    }

    return #screen(items) { _ in swiftUIRenderer }
        .title { "Catalog" }
        .makeViewController()
}
