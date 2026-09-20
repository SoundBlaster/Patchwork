# ``Patchwork``

Patchwork provides cell renderers that let one ScreenKit screen host legacy UIKit
cells, UIKit content configurations, existing `UIView` content, and SwiftUI
views. It adapts rendering only: ScreenKit remains the owner of the collection
view, diffable data source, and snapshot lifecycle.

The package targets iOS 18 and later. Add both packages to an app target, then
return a Patchwork renderer from ScreenKit's `#screen` macro (see the
[ScreenKit API documentation](https://soundblaster.github.io/ScreenKit/)):

```swift
import Patchwork
import ScreenKit

let screen = #screen(items) { item in
    switch item.kind {
    case .legacy:
        Patchwork.legacyCell(LegacyCell.self) { cell, item in
            cell.title = item.title
        }
    case .swiftUI:
        Patchwork.swiftUI { item in
            ItemSummary(item: item)
        }
    }
}
    .title { "Products" }

let controller = screen.makeViewController()
```

Keep business state in the feature or model layer. Patchwork receives each item
when ScreenKit configures a cell and does not introduce another data source or
snapshot owner.

## Choose an adapter

- Use ``Patchwork/legacyCell(_:nib:configure:)`` to preserve an existing
  `UICollectionViewCell` subclass and its reuse behavior.
- Use ``Patchwork/configuration(_:)`` when the app already renders through a
  `UIContentConfiguration`.
- Use ``Patchwork/uiView(make:update:)`` to host an existing `UIView` in the
  content-configuration lifecycle.
- Use ``Patchwork/swiftUI(margins:content:)`` to host a SwiftUI `View` with
  `UIHostingConfiguration`.

A renderer is a value that describes cell creation and configuration. Keep it
stable across updates so ScreenKit can preserve the existing cell registrations.

## Topics

### Render UIKit and SwiftUI content

- ``Patchwork``
