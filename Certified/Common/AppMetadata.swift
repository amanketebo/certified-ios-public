import Foundation

enum AppMetadata {
    
    static var formattedVersionAndBuildNumber: String? {
        var versionInfo: String?
        var buildInfo: String?
        
        if let versionNumber = versionNumber {
            versionInfo = versionNumber
        }
        
        if let buildNumber = buildNumber {
            buildInfo = "(\(buildNumber))"
        }
        
        return [versionInfo, buildInfo].compactMap { $0 }.joined(separator: " ")
    }
    
    private static var versionNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: "MarketingVersion") as? String
    }
    
    private static var buildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: "BuildNumber") as? String
    }
}
