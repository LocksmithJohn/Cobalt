//
//  ExpandingTextView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 01/04/2022.
//

import SwiftUI

struct ExpandingTextView: View {
    @Binding var text: String
    let minHeight: CGFloat = 40
    @State private var textViewHeight: CGFloat?
    @State var height: CGFloat = 40
    let charsLimit: Int

    var body: some View {
        WrappedTextView(text: $text, textDidChange: self.textDidChange,
                        charsLimit: charsLimit)
            .frame(height: height ?? minHeight)
    }

    private func textDidChange(_ textView: UITextView) {
        self.height = max(textView.contentSize.height, minHeight)
    }
}

struct WrappedTextView: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    let textDidChange: (UITextView) -> Void
    let charsLimit: Int

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 30)
        textView.textColor = .white
        textView.textContainer.maximumNumberOfLines = 10
        textView.textContainer.lineBreakMode = .byTruncatingTail
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        print(text.count)
        if text.count > charsLimit {
            text = String(text.prefix(charsLimit))
        } else {
            uiView.text = self.text
            DispatchQueue.main.async {
                self.textDidChange(uiView)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, textDidChange: textDidChange)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let textDidChange: (UITextView) -> Void

        init(text: Binding<String>, textDidChange: @escaping (UITextView) -> Void) {
            self._text = text
            self.textDidChange = textDidChange
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            self.textDidChange(textView)
        }
    }
}
