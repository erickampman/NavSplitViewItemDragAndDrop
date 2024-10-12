//
//  ItemManager.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/8/24.
//

import SwiftUI

@Observable
class ItemManager {
	var leadingItems = [Item]()
	var trailingItems = [Item]()
	
	enum Location: String {
		case leading
		case trailing
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
			if let index = leadingItemIndexForID(originalItem.id) {
				leadingItems.remove(at: index)
			}
			if let index = trailingItemIndexForID(originalItem.id) {
				trailingItems.remove(at: index)
			}
		}
	}
	
	func restoreToOriginalPosition() {
		guard let originalPosition, let originalIndex, let originalItem else { return }
		
		switch originalPosition {
		case .leading:
			leadingItems.insert(originalItem, at: originalIndex)
		case .trailing:
			trailingItems.insert(originalItem, at: originalIndex)
		default:
			print("Unknown original position: \(originalPosition)")
		}
	}
	
	func insertOriginalItem(at index: Int, location: Location) {
		if let originalItem {
			switch location {
			case .leading:
				leadingItems.insert(originalItem, at: index)
			case .trailing:
				trailingItems.insert(originalItem, at: index)
			default:
				break
			}
		}
	}
	
	func appendOriginalItem(at location: Location) {
		if let originalItem {
			switch location {
			case .leading:
				leadingItems.append(originalItem)
			case .trailing:
				trailingItems.append(originalItem)
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
		if let index = leadingItemIndexForID(id) {
			return currentPosition == .leading && currentIndex == index
		} else if let index = trailingItemIndexForID(id) {
			return currentPosition == .trailing && currentIndex == index
		}
		
		return false
	}
	
	var currentPositionIsLast: Bool {
		guard let currentPosition, let currentIndex else { return false }
		
		switch currentPosition {
		case .leading:
			return currentIndex == leadingItems.count - 1
		case .trailing:
			return currentIndex == trailingItems.count - 1
		default:
			return false
		}
	}
	 var currenPositionIsLastInLeading: Bool {
		 guard let currentPosition, let currentIndex else { return false }
		 print("currenPositionIsLastInLeading \(currentPosition):\(currentIndex) count: \(leadingItems.count)")
		 return currentPosition == .leading && currentIndex == leadingItems.count - 1
	}
	
	var currenPositionIsLastInTrailing: Bool {
		guard let currentPosition, let currentIndex else { return false }
		print("currenPositionIsLastInTrailing \(currentPosition):\(currentIndex) count: \(trailingItems.count)")
		return currentPosition == .trailing && currentIndex == trailingItems.count - 1
	}
	
	var draggedItemInLeading: Int? {
		guard let originalItem else { return nil }
		return leadingItems.firstIndex(where: {
			$0.id == originalItem.id
		})
	}
	var draggedItemInTrailing: Int? {
		guard let originalItem else { return nil }
		return trailingItems.firstIndex(where: {
			$0.id == originalItem.id
		})
	}

	init() {
		leadingItems = Item.sidebarItems
		trailingItems = Item.detailItems
	}

	func leadingItemIndexForID(_ id: String) -> Int? {
		leadingItems.firstIndex { $0.id == id }
	}
	
	func trailingItemIndexForID(_ id: String) -> Int? {
		trailingItems.firstIndex { $0.id == id }
	}
	
	func location(for id: String) -> Location {
		if let _ = leadingItemIndexForID(id) {
			return .leading
		} else if let _ = trailingItemIndexForID(id) {
			return .trailing
		} else {
			return .missing
		}
	}
	
	func itemFromID(_ id: String) -> Item? {
		if let index = leadingItemIndexForID(id) {
			return leadingItems[index]
		} else if let index = trailingItemIndexForID(id) {
			return trailingItems[index]
		} else {
			return nil
		}
	}
	
	func appendForID(_ id: String, to location: Location) {
		switch location {
		case .leading:
			leadingItems.append(Item(id: id))
		case .trailing:
			trailingItems.append(Item(id: id))
		default:
			print("appendForID -- Unknown location")
//			fatalError("Unknown location: \(location)")
		}
	}
	
	func removeForID(_ id: String) {
		if let index = leadingItemIndexForID(id) {
			leadingItems.remove(at: index)
		} else if let index = trailingItemIndexForID(id) {
			trailingItems.remove(at: index)
		} else {
			print("removeForID -- Unknown location")
		}
	}
	
	func removeForID(_ id: String, location: Location) {
		switch location {
		case .leading:
			if let index = leadingItemIndexForID(id) {
				leadingItems.remove(at: index)
			} else {
				print("removeForID -- missing id in leadingItems")
			}
		case .trailing:
			if let index = trailingItemIndexForID(id) {
				trailingItems.remove(at: index)
			} else {
				print("removeForID -- missing id in trailing items")
			}
		default :
			print("removeForID -- Unknown location")
		}
	}
	
	func removeAtIndex(_ index: Int, location: Location) {
		switch location {
		case .leading:
			leadingItems.remove(at: index)
		case .trailing:
			trailingItems.remove(at: index)
		default:
			print("removeAtIndex -- Unknown location")
		}
	}
	
	func insertForID(_ id: String, at index: Int, location: Location) {
		switch location {
		case .leading:
			leadingItems.insert(Item(id: id), at: index)
		case .trailing:
			trailingItems.insert(Item(id: id), at: index)
		default:
			print("insertForID -- Unknown location")
		}
	}
	
}
