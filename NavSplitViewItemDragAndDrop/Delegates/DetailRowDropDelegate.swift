//
//  DetailRowDropDelegate.swift
//  NavSplitViewItemDragAndDrop
//
//  Created by Eric Kampman on 10/11/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DetailRowDropDelegate: DropDelegate {
	@Binding var highlight: Bool
	@Binding var itemManager: ItemManager
	let id = UUID()
	
	func performDrop(info: DropInfo) -> Bool {
		print("DetailRowDropDelegate \(id.description) performDrop")
		
		itemManager.clearOriginalPosition()
		itemManager.clearCurrentPosition()
		highlight = false
		return true
	}
	
	func dropExited(info: DropInfo) {
		print("DetailRowDropDelegate \(id.description) dropExited")
		highlight = false
	}
	
	func dropEntered(info: DropInfo) {
		print(">>>  DetailRowDropDelegate dropEntered ENTRYPOINT")
		print("DetailRowDropDelegate \(id.description) dropEntered")
	
		highlight = true

		if itemManager.isDragging {
			if itemManager.currentPositionIsSet {
				if itemManager.currenPositionIsLastInTrailing {
					// overly complicated -- FIXME
					if let index = itemManager.draggedItemInTrailing {
						print("DetailRowDropDelegate \(id.description) dropEntered -- original at \(index)")
						print("DetailRowDropDelegate \(id.description) dropEntered -- current position, avoid thrashing")
					} else {
						print("DetailRowDropDelegate \(id.description) original item missing, appending")
						itemManager.appendOriginalItem(at: .trailing)
					}
				} else {
					print("DetailRowDropDelegate \(id.description) current position set, appending")
					itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
					itemManager.appendOriginalItem(at: .trailing)
				}
			} else {
				print("DetailRowDropDelegate \(id.description) no current position, appending")
				itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
				itemManager.appendOriginalItem(at: .trailing)
			}
		} else {
			// is not dragging already??? Error
			print("DetailRowDropDelegate \(id.description) dropEntered, dragging not set")
		}
	}
}
