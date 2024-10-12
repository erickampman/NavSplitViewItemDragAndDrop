//
//  DetailGridRowView.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/7/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DetailGridRowView: View {
	@State var dropDelegate = XDetailRowDropDelegate?.none
	@State var draggedItem: String?
	@Binding var itemManager: ItemManager
	@State var highlight: Bool = false

    var body: some View {
		GridRow {
			ForEach(itemManager.trailingItems) { item in
				DetailItemView(item: item, itemManager: $itemManager)
					.draggable(item.id)
					.border(Color.blue, width: 4)
			}
			Spacer()
		}
//		.background(highlight ? .white : .gray)
		.background(.white)
		.onDrop(of: [UTType.text],
				delegate: DetailRowDropDelegate(highlight: $highlight, draggedID: $draggedItem, itemManager: $itemManager))
    }
}

#Preview {
	@Previewable @State var itemManager = ItemManager()
	DetailGridRowView(itemManager: $itemManager)
}
