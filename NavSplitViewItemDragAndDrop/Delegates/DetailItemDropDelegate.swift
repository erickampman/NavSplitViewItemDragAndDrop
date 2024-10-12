//
//  DetailItemDropDelegate.swift
//  NavSplitViewItemDragAndDrop
//
//  Created by Eric Kampman on 10/11/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DetailItemDropDelegate: DropDelegate {
	let itemID: String?
//	@Binding var draggedID: String?
	@Binding var highlight: Bool
	@Binding var itemManager: ItemManager
	
	func performDrop(info: DropInfo) -> Bool {
		print(">>>  DetailItemDropDelegate performDrop ENTRYPOINT")
		guard let itemID = itemID else {
			print("DetailItemDropDelegate itemID is nil")
			print("<<<  DetailItemDropDelegate performDrop EXIT")
			return false
		}
		
		if let item = itemManager.originalItem {
			if let index = itemManager.trailingItemIndexForID(item.id) {
				print("DetailItemDropDelegate \(itemID) performDrop -- item is at \(index)")
			} else {
				// is the item already inserted?
				if let index = itemManager.trailingItemIndexForID(item.id) {
					print("DetailItemDropDelegate \(itemID) performDrop -- insert \(item.id) at \(index)")
					itemManager.insertForID(item.id, at: index, location: .trailing)
				} else {
					print("DetailItemDropDelegate \(itemID) performDrop -- index is nil")
					if let index = itemManager.trailingItemIndexForID(itemID) { // find OUR item index
						itemManager.insertForID(item.id, at: index, location: .trailing)
					}
				}
			}
		} else {
			print("DetailItemDropDelegate \(itemID) performDrop -- originalItem is nil")
		}
		
		// anything else to do?
		itemManager.clearOriginalPosition()
		itemManager.clearCurrentPosition()
		print("DetailItemDropDelegate \(itemID) performDrop -- return true")
		print("DetailItemDropDelegate -------------------------------------------------------------")
		print("<<<  DetailItemDropDelegate performDrop EXIT")
		return true
	}
	
	func dropExited(info: DropInfo) {
		print("DetailItemDropDelegate \(String(describing: itemID)) dropExited")
		// probably should itemManager.clearAllOriginals() FIXME
		highlight = false
	}
	
	func dropEntered(info: DropInfo) {
		print(">>>  DetailItemDropDelegate dropEntered ENTRYPOINT")
		print("DetailItemDropDelegate \(String(describing: itemID)) dropEntered")
		highlight = true
		
		guard let itemID = itemID else {
			print("DetailItemDropDelegate dropEntered no itemID")
			print("<<<  DetailItemDropDelegate dropEntered EXIT")
			return
		}
		
		// this doesn't need to be calculated every time. FIXME
		guard let trailingIndex = itemManager.trailingItemIndexForID(itemID) else {
			// trailing Index not found for itemID. Should not happen.
			print("DetailItemDropDelegate \(itemID) dropEntered -- trailing index problem")
			print("<<<  DetailItemDropDelegate dropEntered EXIT")
			return
		}
		
		if itemManager.isDragging {
			if itemManager.currentPositionIsSet {
				if itemManager.isCurrentPositionForID(itemID) {
					// avoid thrashing
					print("DetailItemDropDelegate \(itemID) dropEntered -- current position, avoid thrashing")
					print("<<<  DetailItemDropDelegate dropEntered EXIT")
					return
				} else {
					itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
					itemManager.setCurrentPosition(.trailing, index: trailingIndex)	// bookkeeping
					print("DetailItemDropDelegate \(itemID) adjusting current position at \(trailingIndex)")
					withAnimation {
						itemManager.insertOriginalItem(at: trailingIndex, location: .trailing) 	// actual change of item
					}
				}
			} else { // current position is not yet set
				itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
				itemManager.setCurrentPosition(.trailing, index: trailingIndex)	// bookkeeping
				print("DetailItemDropDelegate \(itemID) setting position at \(trailingIndex)")
				withAnimation {
					itemManager.insertOriginalItem(at: trailingIndex, location: .trailing)	// actual change of item
				}
			}
		} else {
			// Drag is beginning. Save in originalXXX values in itemManager.
			print("DetailItemDropDelegate +++++++++++++++++++++++++++++++++++++++++++++++++++++")
			print("DetailItemDropDelegate \(itemID) \(itemManager.positionInfo) begginning drag")
			itemManager.setOriginalPosition(.trailing, index: trailingIndex, item: Item(id: itemID)) // bookkeeping
			itemManager.setCurrentPosition(.trailing, index: trailingIndex)	// bookkeeping
			withAnimation {
				itemManager.removeForID(itemID)  // TEMP -- need much more to get this right
				// itemManager.clearAllOriginals() // should be at most 1, FIXME -- add check
			}
		}
		
		print("<<<  DetailItemDropDelegate dropEntered EXIT")
		// Maybe we don't need to look at DropInfo. That would be good. It's a pain to use.
	}
	
}
		
