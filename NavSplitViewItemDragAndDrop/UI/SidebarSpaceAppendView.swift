//
//  SidebarSpaceAppendView.swift
//  NavSplitViewItemDragAndDrop
//
//  Created by Eric Kampman on 10/12/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct SidebarSpaceAppendView: View {
	@Binding var itemManager: ItemManager
	@State var highlight: Bool = false

    var body: some View {
		ZStack {
			Spacer()
		}
		.onDrop(of: [UTType.item],
				delegate: SidebarContainerDropDelegate(highlight: $highlight, itemManager: $itemManager))
		.border(.orange, width: 2)
    }
}

#Preview {
	@Previewable @State var itemManager = ItemManager()
	SidebarSpaceAppendView(itemManager: $itemManager)
}
