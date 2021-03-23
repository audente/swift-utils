import Foundation
import SwiftUI

public struct CellView: View {
    public let title: String
    public let value: String
    
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.secondary)
            TextField("", text: .constant(value))
                .padding(5)
        }
    }
}
