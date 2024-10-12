//
//  Item.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/7/24.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
	static var item = UTType(exportedAs: "com.unlikelyware.item")
}

final class Item: Codable, Identifiable {
	let title: String
	let instance: Int64
	
	var id: String {
		"\(title)_\(instance)"
	}
	
	init(id: String) {
		let components = id.split(separator: "_")
		guard components.count == 2 else {
			fatalError("Invalid id: \(id)")
		}
		
		self.title = String(components[0])
		self.instance = Int64(components[1]) ?? 0
	}
		
	init(title: String, instance: Int64) {
		self.title = title
		self.instance = instance
	}
	
	static var sidebarItems: [Item] {
		[
			.init(title: "Available", instance: 1),
			.init(title: "Available", instance: 2),
			.init(title: "Available", instance: 3),
		]
	}
	
	static var detailItems: [Item] {
		[
			.init(title: "Active", instance: 1),
			.init(title: "Active", instance: 2),
			.init(title: "Active", instance: 3),
		]
	}
}

extension Item: Transferable {
	static var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(contentType: .item)
	}
}
		

