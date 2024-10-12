//
//  DetailBaseView.swift
//  NavSplitViewItemDragAndDrop
//
//  Created by Eric Kampman on 10/10/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DetailBaseView: View {
	@Binding var itemManager: ItemManager
	@State var draggedItem: String?
	@State var highlight: Bool = false

    var body: some View {
		ZStack {
			DetailGridView(itemManager: $itemManager)
		}
		.onDrop(of: [UTType.text],
				delegate: DetailBaseDropDelegate(highlight: $highlight, draggedID: $draggedItem, itemManager: $itemManager))

    }
}

#Preview {
	@Previewable @State var itemManager = ItemManager()
    DetailBaseView(itemManager: $itemManager)
}
