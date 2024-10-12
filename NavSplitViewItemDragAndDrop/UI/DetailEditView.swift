//
//  DetailEditView.swift
//  ItemAsStringDragAndDrop
//
//  Created by Eric Kampman on 10/9/24.
//

import SwiftUI

struct DetailEditView: View {
	@Environment(\.dismiss) private var dismiss
	
    var body: some View {
		VStack {
			Text("Maybe some editing can happen here")
			
			Button("OK") {
				dismiss()
			}
		}
		.padding()
    }
}

#Preview {
    DetailEditView()
}
