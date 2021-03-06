//
//  ButtonRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/23/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation

// MARK: ButtonCell

open class ButtonCellOf<T: Equatable>: Cell<T>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func update() {
        super.update()
        selectionStyle = row.isDisabled ? .none : .default
        accessoryType = .none
        editingAccessoryType = accessoryType
        textLabel?.textAlignment = .center
        textLabel?.textColor = tintColor
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        textLabel?.textColor  = UIColor(red: red, green: green, blue: blue, alpha: row.isDisabled ? 0.3 : 1.0)
    }
    
    open override func didSelect() {
        super.didSelect()
        row.deselect()
    }
}

public typealias ButtonCell = ButtonCellOf<String>


//MARK: ButtonRow

open class _ButtonRowOf<T: Equatable> : Row<T, ButtonCellOf<T>> {
    open var presentationMode: PresentationMode<UIViewController>?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .default
    }
    
    open override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let presentationMode = presentationMode {
                if let controller = presentationMode.createController(){
                    presentationMode.presentViewController(controller, row: self, presentingViewController: self.cell.formViewController()!)
                }
                else{
                    presentationMode.presentViewController(nil, row: self, presentingViewController: self.cell.formViewController()!)
                }
            }
        }
    }
    
    open override func customUpdateCell() {
        super.customUpdateCell()
        let leftAligmnment = presentationMode != nil
        cell.textLabel?.textAlignment = leftAligmnment ? .left : .center
        cell.accessoryType = !leftAligmnment || isDisabled ? .none : .disclosureIndicator
        cell.editingAccessoryType = cell.accessoryType
        if (!leftAligmnment){
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            cell.tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            cell.textLabel?.textColor  = UIColor(red: red, green: green, blue: blue, alpha:isDisabled ? 0.3 : 1.0)
        }
        else{
            cell.textLabel?.textColor = nil
        }
    }
    
    open override func prepareForSegue(_ segue: UIStoryboardSegue) {
        super.prepareForSegue(segue)
        let rowVC = segue.destination as? RowControllerType
        rowVC?.completionCallback = self.presentationMode?.completionHandler
    }
}

/// A generic row with a button. The action of this button can be anything but normally will push a new view controller
public final class ButtonRowOf<T: Equatable> : _ButtonRowOf<T>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

/// A row with a button and String value. The action of this button can be anything but normally will push a new view controller
public typealias ButtonRow = ButtonRowOf<String>
