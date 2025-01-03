//
//  SidebarItemDropDelegate.swift
//  NavSplitViewItemDragAndDrop
//
//  Created by Eric Kampman on 10/11/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct SidebarItemDropDelegate: DropDelegate {
	let itemID: String?
//	@Binding var draggedID: String?
	@Binding var highlight: Bool
	@Binding var itemManager: ItemManager
	
	func performDrop(info: DropInfo) -> Bool {
		guard let itemID = itemID else {
			print("SidebarItemDropDelegate itemID is nil")
			print("<<<  SidebarItemDropDelegate performDrop EXIT")
			return false
		}
		
		guard let _ = itemManager.sidebarItemIndexForID(itemID) else {
			print("SidebarItemDropDelegate \(itemID) performDrop -- sidebar index problem")
			print("<<<  SidebarItemDropDelegate performDrop EXIT")
			return false
		}
		
		if let item = itemManager.originalItem {
			if let index = itemManager.sidebarItemIndexForID(item.id) {
				print("SidebarItemDropDelegate \(itemID) performDrop -- item is at \(index)")
			} else {
				// is the item already inserted?
				if let index = itemManager.sidebarItemIndexForID(item.id) {
					print("SidebarItemDropDelegate \(itemID) performDrop -- insert \(item.id) at \(index)")
					itemManager.insertForID(item.id, at: index, location: .sidebar)
				} else {
					print("SidebarItemDropDelegate \(itemID) performDrop -- index is nil")
					if let index = itemManager.sidebarItemIndexForID(itemID) { // find OUR item index
						itemManager.insertForID(item.id, at: index, location: .sidebar)
					}

				}
			}
		} else {
			print("SidebarItemDropDelegate \(itemID) performDrop -- originalItem is nil")
		}

		// anything else to do?
		itemManager.clearOriginalPosition()
		itemManager.clearCurrentPosition()
		print("SidebarItemDropDelegate \(itemID) performDrop -- return true")
		print("SidebarItemDropDelegate -------------------------------------------------------------")
		print("<<<  SidebarItemDropDelegate performDrop EXIT")
		return true
	}
	
	func dropExited(info: DropInfo) {
		print("SidebarItemDropDelegate \(String(describing: itemID)) dropExited")
		// probably should itemManager.clearAllOriginals() FIXME
		highlight = false
	}
	
	func dropEntered(info: DropInfo) {
		print(">>>  SidebarItemDropDelegate dropEntered ENTRYPOINT")
		print("SidebarItemDropDelegate \(String(describing: itemID)) dropEntered")
		highlight = true
		
		guard let itemID = itemID else {
			print("SidebarItemDropDelegate dropEntered no itemID")
			print("<<<  SidebarItemDropDelegate dropEntered EXIT")
			return
		}
		
		// this doesn't need to be calculated every time. FIXME
		guard let sidebarIndex = itemManager.sidebarItemIndexForID(itemID) else {
			// sidebar Index not found for itemID. Should not happen.
			print("SidebarItemDropDelegate \(itemID) dropEntered -- sidebar index problem")
			print("<<<  SidebarItemDropDelegate dropEntered EXIT")
			return
		}

		if itemManager.isDragging {
			if itemManager.currentPositionIsSet {
				if itemManager.isCurrentPositionForID(itemID) {
					// avoid thrashing
					print("SidebarItemDropDelegate \(itemID) dropEntered -- current position, avoid thrashing")
					print("<<<  SidebarItemDropDelegate dropEntered EXIT")
					return
				} else {
					itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
					itemManager.setCurrentPosition(.sidebar, index: sidebarIndex)	// bookkeeping
					print("SidebarItemDropDelegate \(itemID) adjusting current position at \(sidebarIndex)")
					withAnimation {
						itemManager.insertOriginalItem(at: sidebarIndex, location: .sidebar) 	// actual change of item
					}
				}
			} else { // current position is not yet set
				itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
				itemManager.setCurrentPosition(.sidebar, index: sidebarIndex)	// bookkeeping
				print("SidebarItemDropDelegate \(itemID) setting position at \(sidebarIndex)")
				withAnimation {
					itemManager.insertOriginalItem(at: sidebarIndex, location: .sidebar)	// actual change of item
				}
			}
		} else {
			// Drag is beginning. Save in originalXXX values in itemManager.
			print("SidebarItemDropDelegate +++++++++++++++++++++++++++++++++++++++++++++++++++++")
			itemManager.setOriginalPosition(.sidebar, index: sidebarIndex, item: Item(id: itemID)) // bookkeeping
			itemManager.setCurrentPosition(.sidebar, index: sidebarIndex)	// bookkeeping
			print("SidebarItemDropDelegate \(itemID) \(itemManager.positionInfo) begginning drag")
			withAnimation {
				itemManager.removeForID(itemID)  // TEMP -- need much more to get this right
				// itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
			}
		}
		
		print("<<<  SidebarItemDropDelegate dropEntered EXIT")
		// Maybe we don't need to look at DropInfo. That would be good. It's a pain to use.
	}

}
