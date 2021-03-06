//
//  PickerInlineRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/23/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation

open class PickerInlineCell<T: Equatable> : Cell<T>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        accessoryType = .none
        editingAccessoryType =  .none
    }
    
    open override func update() {
        super.update()
        selectionStyle = row.isDisabled ? .none : .default
    }
    
    open override func didSelect() {
        super.didSelect()
        row.deselect()
    }
}

//MARK: PickerInlineRow

open class _PickerInlineRow<T> : Row<T, PickerInlineCell<T>>, NoValueDisplayTextConformance where T: Equatable {
    
    public typealias InlineRow = PickerRow<T>
    open var options = [T]()
    open var noValueDisplayText: String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

/// A generic inline row where the user can pick an option from a picker view
public final class PickerInlineRow<T> : _PickerInlineRow<T>, RowType, InlineRowType where T: Equatable {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        onExpandInlineRow { cell, row, _ in
            let color = cell.detailTextLabel?.textColor
            row.onCollapseInlineRow { cell, _, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            toggleInlineRow()
        }
    }
    
    public func setupInlineRow(_ inlineRow: InlineRow) {
        inlineRow.options = self.options
        inlineRow.displayValueFor = self.displayValueFor
    }
}

