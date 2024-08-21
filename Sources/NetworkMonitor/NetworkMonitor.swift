// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Network
import Observation

/**
 Network monitor to observe changes to network connection.
 
 - Returns
    - isConnected: status of connection to Internet (true/false)
    - isExpensive: connection is via cellular or hotspot wifi (true/false)
    - isConstrained: connection is Low Data Mode (true/false)
    - connectionType: type of connection (cellular/wifi/wiredEthernet)
 */
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
            self.isConstrained = path.isConstrained
            
            let connectionTypes: [NWInterface.InterfaceType] = [
                .cellular,
                .wifi,
                .wiredEthernet]
            self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
        }
        
        monitor.start(queue: queue)
    }
    
}
