# Patchwork

Patchwork adapts heterogeneous content to ScreenKit's collection renderer:
legacy `UICollectionViewCell` subclasses, UIKit content configurations, existing
`UIView` views, and SwiftUI views can coexist in one typed screen.

```swift
import Patchwork
import ScreenKit

let screen = Screen(items) { item in
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
```

ScreenKit remains the sole owner of the collection view and diffable data source;
Patchwork only supplies renderer values. This keeps legacy migration incremental
and prevents competing snapshot or reuse lifecycles.

The package targets iOS 18 and later. It is intentionally a rendering adapter,
not a domain model, navigation layer, or state manager.

## Development

UIKit and SwiftUI tests run from an iOS simulator. The app-level mixed-content
probe currently lives in the Puzzle workspace while this package is extracted
from the prototype.

## License

MIT. See [LICENSE](LICENSE).
