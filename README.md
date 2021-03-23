# UtilsLibrary

Personal library.


## View with integrated networking

```
NetworkView<NetworkViewResult, RequestBody>(
    networkManager: NetworkManagerProtocol, 
    service: ["service":name, "id": additionalOptionalArgs], 
    title: ViewTitle
)
```

`NetworkProgressView` offers a similar functionality with callbacks.

Sample services code: 

```
        let serviceID = service["service"]!
        
        switch serviceID {
        
        case "song":
            let artist = service["artist"]!
            return URLRequest(url: URL(string: "https://itunes.apple.com/search?term=\(artist)&entity=song")!)
            
        case "ping":
            let id = service["id"]!
            var request = URLRequest(url: URL(string: "\(baseURL)/api/portal/ping/\(id)")!)
            return request.injectSecurity(key: self.key, claims: self.claims, body: body)
            
        case "verification":
            let id = service["id"]!
            guard let url = URL(string: "\(baseURL)/api/portal/verification/\(id)") else {
                return nil
            }
            var request = URLRequest(url: url)
            return request.injectSecurity(key: self.key, claims: self.claims, body: body)
```
