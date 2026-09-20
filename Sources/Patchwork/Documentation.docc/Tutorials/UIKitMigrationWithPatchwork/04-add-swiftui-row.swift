import Patchwork
import ScreenKit
import SwiftUI
import UIKit

struct CatalogItem: Hashable, Identifiable, Sendable {
    enum Style: Hashable, Sendable {
        case legacy
        case configuration
        case uiView
        case swiftUI
    }

    let id: String
    let title: String
    let detail: String
    let style: Style
}

@MainActor
final class LegacyProductCell: UICollectionViewCell {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use the collection view registration")
    }

    func configure(with item: CatalogItem) {
        titleLabel.text = item.title
    }
}

@MainActor
final class CatalogBadgeView: UIView {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use the Patchwork view factory")
    }

    override var intrinsicContentSize: CGSize {
        let size = label.intrinsicContentSize
        return CGSize(width: size.width + 24, height: size.height + 20)
    }

    func configure(with item: CatalogItem) {
        label.text = "Featured · \(item.detail)"
    }
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
    let legacyRenderer: ScreenCellRenderer<CatalogItem> = Patchwork.legacyCell(LegacyProductCell.self) { cell, item in
        cell.configure(with: item)
    }
    let configurationRenderer: ScreenCellRenderer<CatalogItem> = Patchwork.configuration { (item: CatalogItem, _: UICellConfigurationState) in
        var content = UIListContentConfiguration.subtitleCell()
        content.text = item.title
        content.secondaryText = item.detail
        return content
    }
    let viewRenderer: ScreenCellRenderer<CatalogItem> = Patchwork.uiView(make: { CatalogBadgeView() }) { view, item in
        view.configure(with: item)
    }
    let swiftUIRenderer: ScreenCellRenderer<CatalogItem> = Patchwork.swiftUI { item in
        CatalogSummary(item: item)
    }

    return #screen(items) { item in
        switch item.style {
        case .legacy:
            legacyRenderer
        case .configuration:
            configurationRenderer
        case .uiView:
            viewRenderer
        case .swiftUI:
            swiftUIRenderer
        }
    }
    .title { "Catalog" }
    .makeViewController()
}
