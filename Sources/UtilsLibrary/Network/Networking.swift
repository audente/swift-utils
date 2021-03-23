
import SwiftUI
import Foundation

extension String: Error {
}

public protocol NetworkManagerProtocol {
    func endPoint<I: Encodable>(service: [String:String], body: I) -> URLRequest?
}


public struct NetworkRequestor<OUT: Decodable> {
    public enum Status {
        case new
        case loaded(Result<OUT, String>)
    }
    
    let configuration: NetworkManagerProtocol
    @Binding public var status: Status
    
    func get<I: Encodable>(service: [String:String], body: I) {
        
        guard let request = configuration.endPoint(service: service, body: body) else {
            status = .loaded(.failure("Invalid endpoint settings for \(String(describing: service))"))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var r: Result<OUT, String> = .failure("Not run")
            
            if let e = error {
                r = .failure(e.localizedDescription)
            } else {
                if let resp: HTTPURLResponse = response as? HTTPURLResponse {
                    if resp.statusCode == 200 {
                        if let data = data {
                            if let decodedResponse: OUT = try? JSONDecoder().decode(OUT.self, from: data) {
                                r = .success(decodedResponse)
                            } else {
                                print(String(describing: data))
                                r = .failure("Couldn't decode fetched data")
                            }
                        } else {
                            r = .failure("Didn't fetch data")
                        }
                    } else {
                        r = .failure("Server Error \(resp.statusCode) [\( HTTPURLResponse.localizedString(forStatusCode: resp.statusCode).capitalized(with: nil))]")
                    }
                } else {
                    r = .failure("Invalid Server Response")
                }
            }
            
            DispatchQueue.main.async {
                self.status = .loaded(r)
            }
            
        }.resume()
        
    }
}
