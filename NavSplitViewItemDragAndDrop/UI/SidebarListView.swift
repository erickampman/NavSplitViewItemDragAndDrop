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
	@State var highlight: Bool = false

	var body: some View {
		List {
			ForEach(itemManager.leadingItems) { item in
				SidebarItemView(item: item, itemManager: $itemManager)
					.draggable(item.id)
					.border(Color.blue, width: 4)
			}
			SidebarSpaceAppendView(itemManager: $itemManager)
		}
		.background(.white)
		.border(.blue)
    }
}

#Preview {
	@Previewable @State var itemManager = ItemManager()
	SidebarListView(itemManager: $itemManager)
}
