//
//  Array+Extensions.swift
//  Artisan
//
//  Created by Nayanda Haberty on 28/05/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
import DiffableDataSources
import Draftsman

extension Array where Element: Hashable {
    
    func toCellItems<CellType: ContentCellCompatible>(
        using cellProvider: (Int, Element) -> [Cell<CellType>]
    ) -> [Cell<CellType>] where CellType.Container: ContainerCellCompatible, CellType.Container.Cell == CellType {
        enumerated().reduce([]) { partialResult, item in
            var result = partialResult
            let cells: [Cell<CellType>] = cellProvider(item.offset, item.element).compactMap { cell in
                cell.addForHash(item: item.element, andIndex: item.offset)
                return cell
            }
            result.append(contentsOf: cells)
            return result
        }
    }
    
    func toSnapShot<CellType: ContentCellCompatible>(
        using provider: (Int, Element) -> [Section<CellType>]
    ) -> DiffableDataSourceSnapshot<Section<CellType>, Cell<CellType>> {
        var snapshot = DiffableDataSourceSnapshot<Section<CellType>, Cell<CellType>>()
        enumerated().forEach { sectionItemIndex, sectionItem in
            provider(sectionItemIndex, sectionItem).enumerated().forEach { sectionIndex, section in
                section.addForHash(itemIndex: sectionItemIndex, index: sectionIndex)
                snapshot.appendSections([section])
                snapshot.appendItems(section.cellItems)
            }
        }
        return snapshot
    }
}
#endif
