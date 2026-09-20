import Patchwork
import ScreenKit
import UIKit

struct CatalogItem: Hashable, Identifiable, Sendable {
    enum Style: Hashable, Sendable {
        case legacy
        case configuration
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

    return #screen(items) { item in
        switch item.style {
        case .legacy:
            legacyRenderer
        case .configuration:
            configurationRenderer
        }
    }
    .title { "Catalog" }
    .makeViewController()
}
