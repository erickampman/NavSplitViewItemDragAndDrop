//
//  DetailGridView.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/7/24.
//

import SwiftUI

struct DetailGridView: View {
	@Binding var itemManager: ItemManager

    var body: some View {
		ScrollView {
			Grid(horizontalSpacing: 0, verticalSpacing: 0) {
				DetailGridRowView(itemManager: $itemManager)
			}
			.border(Color.green, width: 2)
		}
    }
}

#Preview {
	@Previewable @State var itemManager = ItemManager()
	DetailGridView(itemManager: $itemManager)
}
