//
//  XDetailItemDropDelegate.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/8/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct XDetailItemDropDelegate: DropDelegate {
	let itemID: String?
	@Binding var draggedID: String?
	@Binding var highlight: Bool
	@Binding var itemManager: ItemManager
	
	func performDrop(info: DropInfo) -> Bool {
		print("DetailItemDropDelegate \(String(describing: itemID)) performDrop")
		
		let myIndex = itemManager.trailingItemIndexForID(itemID!)
		if nil == myIndex {
			print("DetailItemDropDelegate \(String(describing: itemID)) performDrop: No index for itemID")
			return false
		}
		if let draggedID {
			switch itemManager.location(for: draggedID) {
			case .leading:
				// get the index in the leading items
				// insert in trailing items before this item
				// remove the item from leading items
				itemManager.insertForID(draggedID, at: myIndex!, location: .trailing)
				if let _ = itemManager.leadingItemIndexForID(draggedID) {
					itemManager.removeForID(draggedID, location: .leading)
				}
			case .trailing:
				// get the index in the trailing items
				if let trailingIndex = itemManager.trailingItemIndexForID(draggedID) {
					itemManager.removeForID(draggedID, location: .trailing)
					var updatedIndex = myIndex!
					if updatedIndex > trailingIndex {
						updatedIndex -= 1
					}
					itemManager.insertForID(draggedID, at: updatedIndex, location: .trailing)
				}
			default:
				break
			}
		} else {
			print("DetailItemDropDelegate performDrop -- draggedID is nil")
			return false
		}
		if itemManager.isDragging {
//			itemManager.restoreToOriginalPosition()
//			itemManager.clearAllOriginals()
			itemManager.clearOriginalPosition()
		}
		highlight = false
		return true
	}
	
	func dropExited(info: DropInfo) {
		highlight = false
	}
	
	func dropEntered(info: DropInfo) {
		print("DetailItemDropDelegate \(String(describing: itemID)) dropEntered")
		highlight = true
		
		if let itemID {
			if itemManager.isDragging {
				if let trailingIndex = itemManager.trailingItemIndexForID(itemID) {
					itemManager.clearAllOriginals()
					print("DetailItemDropDelegate \(itemID) inserting at \(trailingIndex)")
					withAnimation {
						itemManager.insertOriginalItem(at: trailingIndex, location: .trailing)
					}
				} else {
					print("DetailItemDropDelegate \(itemID) dropEntered -- why are we here?")
				}
			} else {  // dragging not set up yet
				if let trailingIndex = itemManager.trailingItemIndexForID(itemID) {
					print("DetailItemDropDelegate \(itemID) \(itemManager.positionInfo)")
					itemManager.setOriginalPosition(.trailing, index: trailingIndex, item: Item(id: itemID))
					withAnimation {
						itemManager.removeForID(itemID)  // TEMP -- need much more to get this right
					}
				} else {
					print("DetailItemDropDelegate \(String(describing: itemID)) no action")
					return
				}
			}
		} else {
			print("DetailItemDropDelegate dropEntered no itemID")
		}
	
		let provider = info.itemProviders(for: [.text])
		guard let draggedItem = provider.first else {
			return
		}
		let _ = draggedItem.loadObject(ofClass: String.self) { str, err in
			guard let str else { return }
			
			self.draggedID = str
			print("DetailItemDropDelegate draggedItem: \(String(describing: self.draggedID))")
		}
	}
}
