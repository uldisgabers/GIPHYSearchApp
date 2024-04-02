//
//  DebounceTextField.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 28/03/2024.
//

import SwiftUI
import Combine

struct DebounceTextField: View {
    
    @State var publisher = PassthroughSubject<String, Never>()
    
    @State var label: String
    @Binding var value: String
    var valueChanged: ((_ value: String) -> Void)?
    
    @State var debounceSeconds = 1.110
    
    var body: some View {
        TextField(label, text: $value,  axis: .vertical)
            .disableAutocorrection(true)
            .onChange(of: value) { value in
                publisher.send(value)
            }
            .onReceive(
                publisher.debounce(
                    for: .seconds(debounceSeconds),
                    scheduler: DispatchQueue.main
                )
            ) { value in
                if let valueChanged = valueChanged {
                    valueChanged(value)
                }
            }
    }
}
