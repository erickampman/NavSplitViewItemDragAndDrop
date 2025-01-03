//
//  ItemManager.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/8/24.
//

import SwiftUI

@Observable
class ItemManager {
	var sidebarItems = [Item]()
	var detailItems = [Item]()
	
	enum Location: String {
		case sidebar
		case detail
		case missing
		
		var description: String {
			rawValue
		}
	}
	
	/*
		Original Position/Index/Item
	 
		item info for where it was originally prior to drag
	 */
	var originalItem: Item?
	
	var originalPosition: Location?
	var originalIndex: Int?

	func setOriginalPosition(_ location: Location, index: Int, item: Item) {
		originalPosition = location
		originalIndex = index
		originalItem = item
	}
	
	func clearOriginalPosition() {
		print("ItemManager.clearOriginalPosition")
		originalPosition = nil
		originalIndex = nil
		originalItem = nil
	}
	
	func clearAllOriginals() {
		// just in case it's in both? If so probably should have been caught earlier
		if let originalItem {
			if let index = sidebarItemIndexForID(originalItem.id) {
				sidebarItems.remove(at: index)
			}
			if let index = detailItemIndexForID(originalItem.id) {
				detailItems.remove(at: index)
			}
		}
	}
	
	func restoreToOriginalPosition() {
		guard let originalPosition, let originalIndex, let originalItem else { return }
		
		switch originalPosition {
		case .sidebar:
			sidebarItems.insert(originalItem, at: originalIndex)
		case .detail:
			detailItems.insert(originalItem, at: originalIndex)
		default:
			print("Unknown original position: \(originalPosition)")
		}
	}
	
	func insertOriginalItem(at index: Int, location: Location) {
		if let originalItem {
			switch location {
			case .sidebar:
				sidebarItems.insert(originalItem, at: index)
			case .detail:
				detailItems.insert(originalItem, at: index)
			default:
				break
			}
		}
	}
	
	func appendOriginalItem(at location: Location) {
		if let originalItem {
			switch location {
			case .sidebar:
				sidebarItems.append(originalItem)
			case .detail:
				detailItems.append(originalItem)
			default:
				break
			}
		}
	}
	
	var isDragging: Bool {
		originalPosition != nil
	}
	
	var positionInfo: String {
		let loc = originalPosition?.description ?? "??"
		var idx: String = ""
		if let originalIndex {
			idx = "\(originalIndex)"
		} else {
			idx = "??"
		}
		return "\(loc):\(idx)"
	}
	
	/*
		current Position/Index
	 
		When deposited somewhere prior to the drop, this
		info is updated.
	 */
	var currentPosition: Location?
	var currentIndex: Int?
	
	func setCurrentPosition(_ location: Location, index: Int) {
		print("setCurrentPosition \(location):\(index)")
		currentPosition = location
		currentIndex = index
	}
	
	func clearCurrentPosition() {
		currentPosition = nil
		currentIndex = nil
	}
	
	 var currentPositionIsSet: Bool {
		currentPosition != nil
	}
	
	func isCurrentPositionForID(_ id: String) -> Bool {
		guard let currentPosition, let currentIndex else { return false }
		
		print("isCurrentPositionForID \(id) -- \(currentPosition):\(currentIndex)")
		if let index = sidebarItemIndexForID(id) {
			return currentPosition == .sidebar && currentIndex == index
		} else if let index = detailItemIndexForID(id) {
			return currentPosition == .detail && currentIndex == index
		}
		
		return false
	}
	
	var currentPositionIsLast: Bool {
		guard let currentPosition, let currentIndex else { return false }
		
		switch currentPosition {
		case .sidebar:
			return currentIndex == sidebarItems.count - 1
		case .detail:
			return currentIndex == detailItems.count - 1
		default:
			return false
		}
	}
	 var currenPositionIsLastInSidebar: Bool {
		 guard let currentPosition, let currentIndex else { return false }
		 print("currenPositionIsLastInSidebar \(currentPosition):\(currentIndex) count: \(sidebarItems.count)")
		 return currentPosition == .sidebar && currentIndex == sidebarItems.count - 1
	}
	
	var currenPositionIsLastInDetail: Bool {
		guard let currentPosition, let currentIndex else { return false }
		print("currenPositionIsLastInDetail \(currentPosition):\(currentIndex) count: \(detailItems.count)")
		return currentPosition == .detail && currentIndex == detailItems.count - 1
	}
	
	var draggedItemInSidebar: Int? {
		guard let originalItem else { return nil }
		return sidebarItems.firstIndex(where: {
			$0.id == originalItem.id
		})
	}
	var draggedItemInDetail: Int? {
		guard let originalItem else { return nil }
		return detailItems.firstIndex(where: {
			$0.id == originalItem.id
		})
	}

	init() {
		sidebarItems = Item.sidebarItems
		detailItems = Item.detailItems
	}

	func sidebarItemIndexForID(_ id: String) -> Int? {
		sidebarItems.firstIndex { $0.id == id }
	}
	
	func detailItemIndexForID(_ id: String) -> Int? {
		detailItems.firstIndex { $0.id == id }
	}
	
	func location(for id: String) -> Location {
		if let _ = sidebarItemIndexForID(id) {
			return .sidebar
		} else if let _ = detailItemIndexForID(id) {
			return .detail
		} else {
			return .missing
		}
	}
	
	func itemFromID(_ id: String) -> Item? {
		if let index = sidebarItemIndexForID(id) {
			return sidebarItems[index]
		} else if let index = detailItemIndexForID(id) {
			return detailItems[index]
		} else {
			return nil
		}
	}
	
	func appendForID(_ id: String, to location: Location) {
		switch location {
		case .sidebar:
			sidebarItems.append(Item(id: id))
		case .detail:
			detailItems.append(Item(id: id))
		default:
			print("appendForID -- Unknown location")
//			fatalError("Unknown location: \(location)")
		}
	}
	
	func removeForID(_ id: String) {
		if let index = sidebarItemIndexForID(id) {
			sidebarItems.remove(at: index)
		} else if let index = detailItemIndexForID(id) {
			detailItems.remove(at: index)
		} else {
			print("removeForID -- Unknown location")
		}
	}
	
	func removeForID(_ id: String, location: Location) {
		switch location {
		case .sidebar:
			if let index = sidebarItemIndexForID(id) {
				sidebarItems.remove(at: index)
			} else {
				print("removeForID -- missing id in sidebar Items")
			}
		case .detail:
			if let index = detailItemIndexForID(id) {
				detailItems.remove(at: index)
			} else {
				print("removeForID -- missing id in detail items")
			}
		default :
			print("removeForID -- Unknown location")
		}
	}
	
	func removeAtIndex(_ index: Int, location: Location) {
		switch location {
		case .sidebar:
			sidebarItems.remove(at: index)
		case .detail:
			detailItems.remove(at: index)
		default:
			print("removeAtIndex -- Unknown location")
		}
	}
	
	func insertForID(_ id: String, at index: Int, location: Location) {
		switch location {
		case .sidebar:
			sidebarItems.insert(Item(id: id), at: index)
		case .detail:
			detailItems.insert(Item(id: id), at: index)
		default:
			print("insertForID -- Unknown location")
		}
	}
	
}
