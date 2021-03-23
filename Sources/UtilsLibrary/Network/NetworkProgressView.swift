import SwiftUI
import Combine


public struct NetworkProgressView<V: NetworkViewResult, B: Encodable>: View {
    @State var status: NetworkRequestor<V.NetworkResult>.Status = .new
    let service: [String:String]
    let network: NetworkManagerProtocol
    let bodyData: B
    let onResult: (V.NetworkResult) -> Void
    let onError: (String) -> Void
    
    public init(network: NetworkManagerProtocol, service: [String:String], body: B, onResult: @escaping (V.NetworkResult) -> Void, onError: @escaping (String) -> Void) {
        self.service = service
        self.network = network
        self.bodyData = body
        self.onResult = onResult
        self.onError = onError
    }
    
    public var body: some View {
        
        ProgressView(label: { 
            Text("Connecting...")
                .bold()
                .font(.title)
                .multilineTextAlignment(.center)
        }).progressViewStyle(CircularProgressViewStyle())
        .padding(40)
        .background(Color.accentColor)
        .cornerRadius(20)
        .onReceive(Just(status), perform: { (newStatus) in
            switch newStatus {
            case .new:
                let requestor = NetworkRequestor(configuration: network, status: self.$status)
                requestor.get(service: service, body: self.bodyData)
                
            case .loaded(let response):
                switch response {
                case .success(let result):
                    self.onResult(result)
                case .failure(let message):
                    self.onError(message)
                }
            }
        })

    }
}


