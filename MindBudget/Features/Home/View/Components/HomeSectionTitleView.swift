//
//  HomeSectionTitleView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct HomeSectionTitleView<ActionContent: View>: View {
    let title: String
    let actionContent: ActionContent

    init(title: String, @ViewBuilder content: () -> ActionContent) {
        self.title = title
        self.actionContent = content()
    }

    var body: some View {
        HStack {
            Text(title.capitalized)
                .font(.title2)

            Spacer()

            actionContent
        }
    }
}

// Backward compatibility with closure-based action
extension HomeSectionTitleView where ActionContent == Button<Image> {
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.actionContent = Button(action: action) {
            Image(systemName: "ellipsis.circle")
        }
    }
}
