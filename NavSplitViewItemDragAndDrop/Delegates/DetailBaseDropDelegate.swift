//
//  DetailBaseDropDelegate.swift
//  NavSplitViewItemDragAndDrop
//
//  Created by Eric Kampman on 10/10/24.
//

import SwiftUI

struct DetailBaseDropDelegate: DropDelegate {
	@Binding var highlight: Bool
	@Binding var draggedID: String?
	@Binding var itemManager: ItemManager
	
	let id = UUID()
	
	func performDrop(info: DropInfo) -> Bool {
		print("DetailBaseDropDelegate \(id.description) performDrop")
		
		if itemManager.isDragging {
			itemManager.restoreToOriginalPosition()
			itemManager.clearOriginalPosition()
		}
		return false
	}
	
	func dropEntered(info: DropInfo) {
		print("DetailBaseDropDelegate \(id.description) dropEntered")
		if itemManager.isDragging {
			withAnimation {
				itemManager.clearAllOriginals()
			}
		}
		highlight = true
	}
	
}
