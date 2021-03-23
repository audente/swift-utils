import SwiftUI


public protocol NetworkViewResult: View {
    associatedtype NetworkResult: Decodable
    init(networkManager: NetworkManagerProtocol, result: NetworkResult, refresh: @escaping () -> Void)
    var result: NetworkResult {get set}
}

public struct NetworkView<V: NetworkViewResult, B: Encodable>: View {
    @State var status: NetworkRequestor<V.NetworkResult>.Status = .new
    let title: String
    let service: [String:String]
    let networkManager: NetworkManagerProtocol
    let bodyData: B
    
    public init(networkManager: NetworkManagerProtocol, service: [String:String], title: String, body: B) {
        self.title = title
        self.service = service
        self.networkManager = networkManager
        self.bodyData = body
    }
    
    public var body: some View {
        switch status {
        case .new:
            return AnyView(Text("Connecting...")
                            .foregroundColor(.secondary)
                            .font(.title)
                            .onAppear { 
                                let network = NetworkRequestor(configuration: networkManager, status: self.$status)
                                network.get(service: service, body: self.bodyData)
                            }
            )
        
        case .loaded(let result):
            switch result {
            case .failure(let message):
                return AnyView(Text(message)
                                .foregroundColor(Color.red)
                                .font(.title)
                                .padding(50.0)
                                .multilineTextAlignment(.center)
                                .navigationTitle("Error")
                                .navigationBarItems(
                                    trailing:
                                        Button(action: {
                                            status = .new
                                        }) { 
                                            Image(systemName: "arrow.clockwise")
                                        }
                                )
                )
                
            case .success(let result):
                return AnyView(V(networkManager: self.networkManager, result: result, refresh: { status = .new }
                                 ).navigationTitle(title))
            }
        }
    }
}

extension NetworkView where B == String {
    public init(networkManager: NetworkManagerProtocol, service: [String:String], title: String) {
        self.init(networkManager: networkManager, service: service, title: title, body: "")
    }
}


