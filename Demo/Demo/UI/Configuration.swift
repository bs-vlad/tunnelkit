//
//  Configuration.swift
//  Demo
//
//  Created by Davide De Rosa on 6/13/20.
//  Copyright (c) 2024 Davide De Rosa. All rights reserved.
//
//  https://github.com/keeshux
//
//  This file is part of TunnelKit.
//
//  TunnelKit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  TunnelKit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with TunnelKit.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import TunnelKitCore
import TunnelKitOpenVPN
import TunnelKitWireGuard

#if os(macOS)
let appGroup = "DTDYD63ZX9.group.com.algoritmico.TunnelKit.Demo"
private let bundleComponent = "macos"
#elseif os(iOS)
let appGroup = "group.com.algoritmico.TunnelKit.Demo"
private let bundleComponent = "ios"
#else
let appGroup = "group.com.algoritmico.TunnelKit.Demo"
private let bundleComponent = "tvos"
#endif

enum TunnelIdentifier {
    static let openVPN = "com.test.tunnelkit.mac.OpenVPN-Tunnel"

    static let wireGuard = "com.test.tunnelkit.mac.WireGuard-Tunnel"
}

extension OpenVPN {
    struct DemoConfiguration {
        static let ca = OpenVPN.CryptoContainer(pem: """
-----BEGIN CERTIFICATE-----
MIIDMzCCAhugAwIBAgIUBXXX6Ae9hmxFj+4ATeyx1dCkR7EwDQYJKoZIhvcNAQEL
BQAwDjEMMAoGA1UEAwwDeWVzMB4XDTI0MDMwNDE0MDQwMloXDTM0MDMwMjE0MDQw
MlowDjEMMAoGA1UEAwwDeWVzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAr3xUQsuNf1bSqIjbX39kPFDUnOuxS3M8j+fx/fqEi2iAvwWgy9GFreirnPhq
d2tuX7KSQCdOlXPjWf8FOIHgyCIgoigyb9it6z9KIhiRnew+5GEhb5GI4OrNp3u4
5ygiQBUQ8vAy4ov+M4Xjb+mTHhrOEFKd3ljUXtaBEyA/UeA0vokkln9JdKHXz7EE
5JTcFDs9QNDBNlCpIbdvwg+CGk05X+Zmf2vQX7KZHNEW63Ca4IapU6VpQjsMADWI
pk4dEUqfUsY9b9k0NYwvXaxlEB3Q/xO3M0jR4LUaBMq/pSAYV78RPV7GE66x2P46
M1NntdgpZjz6y7EY6bHkIxbFdQIDAQABo4GIMIGFMB0GA1UdDgQWBBSjPoDLxTl2
nOmKVk0/VRhW8Q1t2jBJBgNVHSMEQjBAgBSjPoDLxTl2nOmKVk0/VRhW8Q1t2qES
pBAwDjEMMAoGA1UEAwwDeWVzghQFddfoB72GbEWP7gBN7LHV0KRHsTAMBgNVHRME
BTADAQH/MAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOCAQEAkkEOcQbv2t+m
+y9aqo3wDi9MLvrorjBX4g/mM+gkADUfmxcxs/BnBXxF9gfYvKX98eHEWZnzNrk5
4G01M5Xav2DZzrwoDSbnBrTCxktaSewlQdWKz6UgC8ZEQeutLes3rJQc9bMYtV98
bGHS83GuSxYtwL3BjDd6KRmsz5Lj/tPPutD8c9E3sZHANsFvA4kIClOeYISEVjEZ
M5wbhSzToV6odjInzyrvXraUG2AvurBR/rjTYylWu5dgEBAlIA0yMOzY7PPXxO2K
PXJEEBsfz/a8SLs++oL7L3YXRoXf0lt26JJX3HQP5DLOMAbfHZ2VxCIYfxiopDTZ
+CBk+7c7Ig==
-----END CERTIFICATE-----
""")

        static let tlsKey = OpenVPN.StaticKey(file: """
# 2048 bit OpenVPN static key
-----BEGIN OpenVPN Static key V1-----
e6d3247c006b9d4f9ff405a3afcbd5f7
14f2e30978dd36e4ba368da9d40c1a27
ba923eda7b51f6773b29deac8ceded36
952f14d93730aa874f60eaced967c48d
5795d0d81984a1e8cc01bd68bd85bef3
11edb02d4d1eeda04720ea45950276e1
82307ee9901575b3530accfd65209908
44af7e55199a91be4d6c5b9e98c3305d
fb51032b0bb6cae25c46754d51e662c7
a5d8ba625986b6b9575032691c4605ab
31edfd153b3804219ed6574bb6c15567
26fe5604f07cc60d88038cafd7028879
27b1099866d4bb5752b1b459185657fb
06b536a487ac769ac645d1fc19208e0c
f84bd71cf562d61a0d86e3dcab724f8e
78882541b59f148008ca34801c8bf552
-----END OpenVPN Static key V1-----
""", direction: .client)!

        struct Parameters {
            let title: String

            let appGroup: String

            let hostname: String

            let port: UInt16

            let socketType: SocketType
        }

        static func make(params: Parameters) -> OpenVPN.ProviderConfiguration {
            var builder = OpenVPN.ConfigurationBuilder()
            builder.ca = ca
            builder.cipher = .aes256cbc
            builder.digest = .sha512
            builder.compressionFraming = .compLZO
            builder.renegotiatesAfter = nil
            builder.remotes = [Endpoint(params.hostname, EndpointProtocol(params.socketType, params.port))]
            builder.tlsWrap = TLSWrap(strategy: .auth, key: tlsKey)
            builder.mtu = 1350
            builder.routingPolicies = [.IPv4, .IPv6]
            let cfg = builder.build()

            var providerConfiguration = OpenVPN.ProviderConfiguration(params.title, appGroup: params.appGroup, configuration: cfg)
            providerConfiguration.shouldDebug = true
            providerConfiguration.masksPrivateData = false
            return providerConfiguration
        }
    }
}

extension WireGuard {
    struct Parameters {
        let title: String

        let appGroup: String

        let clientPrivateKey: String

        let clientAddress: String

        let serverPublicKey: String

        let serverAddress: String

        let serverPort: String
    }

    struct DemoConfiguration {
        static func make(params: Parameters) -> WireGuard.ProviderConfiguration? {
            var builder: WireGuard.ConfigurationBuilder
            do {
                builder = try WireGuard.ConfigurationBuilder(params.clientPrivateKey)
            } catch {
                print(">>> \(error)")
                return nil
            }
            builder.addresses = [params.clientAddress]
            builder.dnsServers = ["1.1.1.1", "1.0.0.1"]
            do {
                try builder.addPeer(params.serverPublicKey, endpoint: "\(params.serverAddress):\(params.serverPort)")
            } catch {
                print(">>> \(error)")
                return nil
            }
            builder.addDefaultGatewayIPv4(toPeer: 0)
            let cfg = builder.build()

            return WireGuard.ProviderConfiguration(params.title, appGroup: params.appGroup, configuration: cfg)
        }
    }
}
