// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Network
import Observation

@Observable public class NetworkMonitor {
    @ObservationIgnored private let monitor = NWPathMonitor()
    @ObservationIgnored private let queue = DispatchQueue(label: "NWMonitor")
    
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
        }
        
        monitor.start(queue: queue)
    }
    
}
