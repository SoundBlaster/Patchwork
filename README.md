# Patchwork

[![DocC](https://github.com/SoundBlaster/Patchwork/actions/workflows/documentation.yml/badge.svg?branch=main)](https://github.com/SoundBlaster/Patchwork/actions/workflows/documentation.yml)
[![Documentation](https://img.shields.io/badge/Documentation-DocC-blue)](https://soundblaster.github.io/Patchwork/)
![Swift 6.2+](https://img.shields.io/badge/Swift-6.2%2B-orange?logo=swift)
![iOS 18+](https://img.shields.io/badge/iOS-18%2B-lightgrey?logo=apple)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Patchwork adapts heterogeneous content to ScreenKit's collection renderer:
legacy `UICollectionViewCell` subclasses, UIKit content configurations, existing
`UIView` views, and SwiftUI views can coexist in one typed screen.

ScreenKit owns screen creation and exports the `#screen` macro. Patchwork supplies
the renderer values returned from the macro's body:

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

ScreenKit remains the sole owner of the collection view and diffable data source;
Patchwork only supplies renderer values. This keeps legacy migration incremental
and prevents competing snapshot or reuse lifecycles.

The package targets iOS 18 and later. It is intentionally a rendering adapter,
not a domain model, navigation layer, or state manager.

## Documentation

Browse the [Patchwork API documentation](https://soundblaster.github.io/Patchwork/).

## Development

UIKit and SwiftUI tests run from an iOS simulator. The app-level mixed-content
probe currently lives in the Puzzle workspace while this package is extracted
from the prototype.

## License

MIT. See [LICENSE](LICENSE).
