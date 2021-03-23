import Foundation
import SwiftUI

public struct ResultContent<D: Codable>: Codable {
    var success: String
    var failure: String
    
    var data: D? {
        if failure == "" {
            return try? JSONDecoder().decode(D.self, from: self.success.data(using: .utf8) ?? Data())
        } else {
            return nil
        }
    }
}

public struct ResultView: NetworkViewResult {
    
    public var result: ResultContent<String>
    public init(networkManager: NetworkManagerProtocol, result: ResultContent<String>, refresh:@escaping () -> Void) {
        self.result = result
    }
    
    public var body: some View {
        Group {
            if result.failure != "" {
                Label(result.failure, systemImage: "xmark.diamond.fill")
                    .accentColor(Color.red)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.red)
                    .font(.largeTitle)
                    .padding(50.0)
                
            } else {
                Label(result.data ?? "OK", systemImage: "checkmark.circle.fill")
                    .accentColor(Color.green)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.green)
                    .font(.largeTitle)
                    .padding(50.0)
            }
            
        }
    }
}
