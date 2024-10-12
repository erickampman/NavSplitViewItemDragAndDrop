//
//  SidebarContainerDropDelegate.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/8/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct SidebarContainerDropDelegate: DropDelegate {
	@Binding var highlight: Bool
	@Binding var draggedID: String?
	@Binding var itemManager: ItemManager

	let id = UUID()
	
	func dropUpdated(info: DropInfo) {
		print("SidebarContainerDropDelegate \(id.description) dropUpdated")
	}
	
	func performDrop(info: DropInfo) -> Bool {
		print("SidebarContainerDropDelegate \(id.description) performDrop")
		
		itemManager.clearOriginalPosition()
		itemManager.clearCurrentPosition()

		highlight = false
		return true
	}
	
	func dropExited(info: DropInfo) {
		print("SidebarContainerDropDelegate \(id.description) dropExited")
		highlight = false
	}
		
	func dropEntered(info: DropInfo) {
		print(">>>  SidebarContainerDropDelegate dropEntered ENTRYPOINT")
		print("SidebarContainerDropDelegate \(id.description) dropEntered")
		highlight = true

		if itemManager.isDragging {
			if itemManager.currentPositionIsSet {
				if itemManager.currenPositionIsLastInLeading {
					// overly complicated -- FIXME
					if let index = itemManager.draggedItemInLeading {
						print("SidebarContainerDropDelegate \(id.description) dropEntered -- original at \(index)")
						print("SidebarContainerDropDelegate \(id.description) dropEntered -- current position, avoid thrashing")
					} else {
						print("SidebarContainerDropDelegate \(id.description) original item missing, appending")
						itemManager.appendOriginalItem(at: .leading)
					}
				} else {
					print("SidebarContainerDropDelegate \(id.description) current position set, appending")
					itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
					itemManager.appendOriginalItem(at: .leading)
				}
			} else {
				print("SidebarContainerDropDelegate \(id.description) no current position, appending")
				itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
				itemManager.appendOriginalItem(at: .leading)
			}
		} else {
			// is not dragging already??? Error
			print("SidebarContainerDropDelegate \(id.description) dropEntered, dragging not set")
		}
	}

}
