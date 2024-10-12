//
//  ContentView.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/7/24.
//

import SwiftUI

struct OuterSplitView: View {
	@State var itemManager = ItemManager()
	
	var body: some View {
		NavigationSplitView {
			SidebarListView(itemManager: $itemManager)
		} detail: {
			DetailBaseView(itemManager: $itemManager)
		}
	}
}

#Preview {
	ContentView()
}
