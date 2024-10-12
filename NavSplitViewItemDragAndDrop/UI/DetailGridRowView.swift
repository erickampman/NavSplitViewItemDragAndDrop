//
//  DetailGridRowView.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/7/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DetailGridRowView: View {
	@State var draggedItem: String?
	@Binding var itemManager: ItemManager
	@State var highlight: Bool = false

    var body: some View {
		GridRow {
			ForEach(itemManager.trailingItems) { item in
				DetailItemView(item: item, itemManager: $itemManager)
					.draggable(item)
					.border(Color.blue, width: 4)
			}
			Spacer()
		}
//		.background(highlight ? .white : .gray)
		.background(.white)
		.onDrop(of: [UTType.item],
				delegate: DetailRowDropDelegate(highlight: $highlight, itemManager: $itemManager))
    }
}

#Preview {
	@Previewable @State var itemManager = ItemManager()
	DetailGridRowView(itemManager: $itemManager)
}
