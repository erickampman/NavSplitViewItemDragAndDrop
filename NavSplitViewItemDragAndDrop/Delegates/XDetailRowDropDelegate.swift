//
//  DetailRowDropDelegate.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/8/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct XDetailRowDropDelegate: DropDelegate {
	@Binding var highlight: Bool
	@Binding var draggedID: String?
	@Binding var itemManager: ItemManager
	let id = UUID()
	
	func performDrop(info: DropInfo) -> Bool {
		print("DetailRowDropDelegate \(id.description) performDrop")
		
		if let draggedID {
			switch itemManager.location(for: draggedID) {
			case .leading:
				// append to trailing items,
				// delete the original that's in the leading items
				if let _ = itemManager.leadingItemIndexForID(draggedID) {
					itemManager.appendForID(draggedID, to: .trailing)
					itemManager.removeForID(draggedID, location: .leading)
				}
			case .trailing:
				// determine original index (in trailing items)
				// Move from there
				// append to trailingItems
				if let _ = itemManager.trailingItemIndexForID(draggedID) {
					itemManager.appendForID(draggedID, to: .trailing)
					itemManager.removeForID(draggedID, location: .trailing)
				}
			case .missing:
				print("DetailRowDropDelegate performDrop location missing")
			}
		}
		if itemManager.isDragging && draggedID != nil {
			itemManager.clearOriginalPosition()
			itemManager.appendForID(draggedID!, to: .trailing)
		}
		
		return true
	}
	
	/*
		See comments for LeadingContainerDropDelegate.dropEntered
	 */
	func dropEntered(info: DropInfo) {
		print("DetailRowDropDelegate \(id.description) dropEntered")
		highlight = true

		let provider = info.itemProviders(for: [.text])
		guard let draggedItem = provider.first else {
			return
		}
		let _ = draggedItem.loadObject(ofClass: String.self) { str, err in
			guard let str else { return }
			self.draggedID = str
		}
	}

}
