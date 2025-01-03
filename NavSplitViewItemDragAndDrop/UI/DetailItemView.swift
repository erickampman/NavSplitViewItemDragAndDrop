//
//  DetailItemView.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/7/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DetailItemView: View {
	let item: Item
	@Binding var itemManager: ItemManager
	@State private var highlight = false
	@State private var showEditView = false

	var body: some View {
		ZStack(alignment: .leading) {
			Text("\(item.title) \(item.instance)")
				.font(.title3)
				.frame(width: 100, height: 40)
//				.background(.white)
				.cornerRadius(10)
				.onDrop(of: [UTType.item],
						delegate: DetailItemDropDelegate(itemID: item.id,
														 highlight: $highlight,
														 itemManager: $itemManager))
				.onLongPressGesture {
					showEditView.toggle()
				}
//			if highlight {
//				Image(systemName: "lessthan")
//					.resizable()
//					.frame(width: 20, height: 36)
//					.offset(x: 5)
//			}
		}
		.sheet(isPresented: $showEditView) {
			DetailEditView()
		}
    }
}

#Preview {
	@Previewable @State var itemManager = ItemManager()
	DetailItemView(item: Item(title: "Foobar", instance: 1), itemManager: $itemManager)
}
