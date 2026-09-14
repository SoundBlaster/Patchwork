#if canImport(UIKit) && canImport(SwiftUI)
import ScreenKit
import SwiftUI
import UIKit

/// Native adapters for ScreenKit's cell-provider seam; no second data source.
@MainActor
public enum Patchwork {
    /// Preserves custom UICollectionViewCell subclasses and their reuse behavior.
    public static func legacyCell<Item, Cell: UICollectionViewCell>(
        _ cellType: Cell.Type,
        nib: UINib? = nil,
        configure: @escaping (Cell, Item) -> Void
    ) -> ScreenCellRenderer<Item> {
        let bindings = NSMapTable<Cell, LegacyBinding<Item>>.weakToStrongObjects()
        let handler: UICollectionView.CellRegistration<Cell, Item>.Handler = { cell, _, item in
            let binding: LegacyBinding<Item>
            if let existing = bindings.object(forKey: cell) {
                binding = existing
                binding.item = item
            } else {
                binding = LegacyBinding(item: item, originalHandler: cell.configurationUpdateHandler)
                bindings.setObject(binding, forKey: cell)
            }
            cell.configurationUpdateHandler = { cell, state in
                binding.originalHandler?(cell, state)
                guard let cell = cell as? Cell else { return }
                configure(cell, binding.item)
            }
            configure(cell, item)
        }
        let registration: UICollectionView.CellRegistration<Cell, Item>
        if let nib { registration = .init(cellNib: nib, handler: handler) }
        else { registration = .init(handler: handler) }
        return ScreenCellRenderer { collection, indexPath, item in
            collection.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
    }

    public static func configuration<Item, Configuration: UIContentConfiguration>(
        _ content: @escaping (Item, UICellConfigurationState) -> Configuration
    ) -> ScreenCellRenderer<Item> {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, _, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = content(item, state)
            }
            cell.contentConfiguration = content(item, cell.configurationState)
        }
        return ScreenCellRenderer { collection, indexPath, item in
            collection.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
    }

    /// Domain identity resets transient SwiftUI state only when a different item is reused.
    /// Durable editing state belongs to the model, not the recycled view.
    public static func swiftUI<Item: Identifiable, Content: View>(
        margins: NSDirectionalEdgeInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16),
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> ScreenCellRenderer<Item> {
        configuration { item, _ in
            UIHostingConfiguration { content(item).id(item.id) }
                .margins(.top, margins.top)
                .margins(.leading, margins.leading)
                .margins(.bottom, margins.bottom)
                .margins(.trailing, margins.trailing)
        }
    }
}

@MainActor
private final class LegacyBinding<Item> {
    var item: Item
    let originalHandler: ((UICollectionViewCell, UICellConfigurationState) -> Void)?

    init(item: Item, originalHandler: ((UICollectionViewCell, UICellConfigurationState) -> Void)?) {
        self.item = item
        self.originalHandler = originalHandler
    }
}
#endif
