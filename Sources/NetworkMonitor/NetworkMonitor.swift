// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Network

@Observable
public class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NWMonitor")
    var isConnected = false
    var isExpensive = false
    var isConstrained = false
    var connectionType = NWInterface.InterfaceType.other
    
    init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            self.isExpensive = path.isExpensive
            self.isConstrained = path.isConstrained // Low Data Mode
            
            let connectionTypes: [NWInterface.InterfaceType] = [
                .cellular,
                .wifi,
                .wiredEthernet]
            self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
        
        monitor.start(queue: queue)
    }
    
}
