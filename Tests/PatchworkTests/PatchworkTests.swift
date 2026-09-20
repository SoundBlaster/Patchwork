#if canImport(UIKit) && canImport(SwiftUI)
import SwiftUI
import UIKit
import XCTest
@testable import Patchwork
import ScreenKit

@MainActor
final class PatchworkTests: XCTestCase {
    private struct Item: Identifiable, Sendable {
        let id: Int
    }

    private final class LegacyCell: UICollectionViewCell {}

    func testRendererFactoriesProduceScreenKitRenderers() {
        let item = Item(id: 1)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        let legacy: ScreenCellRenderer<Item> = Patchwork.legacyCell(LegacyCell.self) { _, _ in }
        let configured: ScreenCellRenderer<Item> = Patchwork.configuration { _, _ in UIListContentConfiguration.cell() }
        let swiftUI: ScreenCellRenderer<Item> = Patchwork.swiftUI { item in Text("Item \(item.id)") }
        let uiView: ScreenCellRenderer<Item> = Patchwork.uiView(make: { UILabel() }) { label, item in label.text = "Item \(item.id)" }

        XCTAssertTrue(legacy.cell(in: collection, at: IndexPath(item: 0, section: 0), item: item) is LegacyCell)
        XCTAssertNotNil(configured.cell(in: collection, at: IndexPath(item: 1, section: 0), item: item))
        XCTAssertNotNil(swiftUI.cell(in: collection, at: IndexPath(item: 2, section: 0), item: item))
        XCTAssertNotNil(uiView.cell(in: collection, at: IndexPath(item: 3, section: 0), item: item))
    }
}
#endif
