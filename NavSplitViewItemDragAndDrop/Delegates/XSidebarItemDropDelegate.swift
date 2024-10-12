//
//  SidebarItemDropDelegate.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/8/24.
//

import SwiftUI


struct XSidebarItemDropDelegate: DropDelegate {
	let itemID: String?
	@Binding var draggedID: String?
	@Binding var highlight: Bool
	@Binding var itemManager: ItemManager

	func performDrop(info: DropInfo) -> Bool {
		print("SidebarItemDropDelegate \(String(describing: itemID)) performDrop")
		let myIndex = itemManager.leadingItemIndexForID(itemID!)
		
		if let draggedID {
			switch itemManager.location(for: draggedID) {
			case .leading:
				if let leadingIndex = itemManager.leadingItemIndexForID(draggedID) {
					itemManager.removeForID(draggedID)
					var updatedIndex = myIndex!
					if updatedIndex > leadingIndex {
						updatedIndex -= 1
					}
					itemManager.insertForID(draggedID, at: updatedIndex, location: .leading)
				}
			case .trailing:
				if let trailingIndex = itemManager.trailingItemIndexForID(draggedID) {
					itemManager.removeAtIndex(trailingIndex, location: .trailing)
					itemManager.insertForID(draggedID, at: myIndex!, location: .leading)
				}
			default:
				print("SidebarItemDropDelegate performDrop -- draggedID is nil")
			}
		} else {
			print("SidebarItemDropDelegate performDrop -- draggedID is nil")
			return false
		}
		highlight = false
		if itemManager.isDragging {
//			itemManager.restoreToOriginalPosition()
			itemManager.clearOriginalPosition()
		}
		print("SidebarItemDropDelegate \(String(describing: itemID)) performDrop exit")
		return true
	}
	
	func dropExited(info: DropInfo) {
		highlight = false
	}
	
	func dropEntered(info: DropInfo) {
		print("SidebarItemDropDelegate \(String(describing: itemID)) dropEntered")
		highlight = true
		
		if let itemID {
			if itemManager.isDragging {
				if let leadingIndex = itemManager.leadingItemIndexForID(itemID) {
					itemManager.clearAllOriginals()
					print("DetailItemDropDelegate \(itemID) inserting at \(leadingIndex)")
					withAnimation {
						itemManager.insertOriginalItem(at: leadingIndex, location: .leading)
					}
				} else {
					print("DetailItemDropDelegate \(itemID) dropEntered -- why are we here?")
				}
			} else { // dragging not set up yet
				if let leadingIndex = itemManager.leadingItemIndexForID(itemID) {
					print("SidebarItemDropDelegate \(String(describing: itemID))  \(itemManager.positionInfo)")
					withAnimation {
						itemManager.removeForID(itemID)  // TEMP --
					}
					itemManager.setOriginalPosition(.leading, index: leadingIndex, item: Item(id: itemID))
				} else if let trailingIndex = itemManager.trailingItemIndexForID(itemID) {
					print("SidebarItemDropDelegate \(String(describing: itemID)) index is nil")
					itemManager.insertOriginalItem(at: trailingIndex, location: .leading)
					return
				}
			}
		}
		
		let provider = info.itemProviders(for: [.text])
		guard let draggedItem = provider.first else {
			return
		}
		let _ = draggedItem.loadObject(ofClass: String.self) { str, err in
			guard let str else { return }
			self.draggedID = str
		
//			print("SidebarItemDropDelegate draggedItem: \(String(describing: self.draggedItem))")
		}
	}

	
}
