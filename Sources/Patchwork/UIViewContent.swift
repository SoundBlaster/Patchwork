#if canImport(UIKit)
import ScreenKit
import UIKit

extension Patchwork {
    /// Wraps an existing UIView factory in UIKit's content configuration lifecycle.
    public static func uiView<Item, Content: UIView>(
        make: @escaping @MainActor () -> Content,
        update: @escaping @MainActor (Content, Item) -> Void
    ) -> ScreenCellRenderer<Item> {
        configuration { item, _ in ViewConfiguration(item: item, make: make, update: update) }
    }
}

private struct ViewConfiguration<Item, Content: UIView>: UIContentConfiguration {
    let item: Item
    let make: @MainActor () -> Content
    let update: @MainActor (Content, Item) -> Void

    @MainActor func makeContentView() -> UIView & UIContentView {
        ContentHost(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self { self }
}

@MainActor
private final class ContentHost<Item, Content: UIView>: UIView, UIContentView {
    private var current: ViewConfiguration<Item, Content>
    private let hosted: Content

    var configuration: UIContentConfiguration {
        get { current }
        set {
            guard let value = newValue as? ViewConfiguration<Item, Content> else { return }
            current = value
            value.update(hosted, value.item)
        }
    }

    init(configuration: ViewConfiguration<Item, Content>) {
        current = configuration
        hosted = configuration.make()
        super.init(frame: .zero)
        hosted.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hosted)
        NSLayoutConstraint.activate([
            hosted.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            hosted.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            hosted.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            hosted.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
        configuration.update(hosted, configuration.item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("Use a content configuration") }
}
#endif
