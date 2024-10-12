//
//  SidebarListView.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/7/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct SidebarListView: View {
	@Binding var itemManager: ItemManager
	@State var draggedItem: String?
	@State var highlight: Bool = false

	var body: some View {
		List {
			ForEach(itemManager.leadingItems) { item in
				SidebarItemView(item: item, itemManager: $itemManager)
					.draggable(item.id)
					.border(Color.blue, width: 4)
			}
		}
		.background(.white)
		.border(.blue)
		.onDrop(of: [UTType.text],
				delegate: SidebarContainerDropDelegate(highlight: $highlight, draggedID: $draggedItem, itemManager: $itemManager))
    }
}

#Preview {
	@Previewable @State var itemManager = ItemManager()
	SidebarListView(itemManager: $itemManager)
}
