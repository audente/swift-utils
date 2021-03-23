import Foundation
import CryptoKit

public extension URLRequest {
    public mutating func injectSecurity<I: Encodable>(key: String, claims: String, body: I?) -> URLRequest{
        let salted = claims + key
        let data = salted.data(using: .utf8)!
        let hash256 = SHA256.hash(data: data).compactMap{ String(format: "%02x", $0) }.joined()
        self.setValue(hash256, forHTTPHeaderField: "Authorization")
        self.setValue(claims, forHTTPHeaderField: "Claims")
        return self
    } 
}
