import Foundation

public struct Environment {
    
    /**
     Getter for application semantic verion.
     
     Reads and returns `CFBundleShortVersionString` from info dictionary.
    */
    static public var appVersionShort: String {
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return versionString
    }
    
    /**
     Getter for full application version (version + build number).
     
     Combines both appVersionShort` and `buildNumber` into **1.2.3+99**
    */
    static public var appVersion: String {
        return "\(appVersionShort)+\(buildNumber)"
    }
    
    /**
     Getter for application bundle version.
     
     Reads and returns `CFBundleVersion` from info dictionary.
    */
    static public var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    /**
     Getter for current operating system semantic version.
    */
    static public var osVersion: String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
        
    /**
     Getter for the harware type.
     
     Reads harware line from `sysctl`.
     */
    static public var hardwareString: String {
        var name: [Int32] = [CTL_HW, HW_MACHINE]
        var size: Int = 2
        sysctl(&name, 2, nil, &size, nil, 0)
        var hw_machine = [CChar](repeating: 0, count: Int(size))
        sysctl(&name, 2, &hw_machine, &size, nil, 0)

        var hardware: String = String(cString: hw_machine)

        // Check for simulator
        if hardware == "x86_64" || hardware == "i386" {
            if let deviceID = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] {
                hardware = deviceID
            }
        }

        return hardware
    }
    
    public enum Platform {
        case iPhone
        case iPodTouch
        case iPad
        case appleWatch
        case appleTV
        case unknown
    }

    /**
     Getter for `Platform` enum depending upon harware string.
    */
    static public var platform: Platform {

        let hardware = hardwareString

        if (hardware.hasPrefix("iPhone"))    { return .iPhone }
        if (hardware.hasPrefix("iPod"))      { return .iPodTouch }
        if (hardware.hasPrefix("iPad"))      { return .iPad }
        if (hardware.hasPrefix("Watch"))     { return .appleWatch }
        if (hardware.hasPrefix("AppleTV"))   { return .appleTV }
        
        return .unknown
    }
    
    /**
     Getter for current device time zone.
     
     Returns the geopolitical region identifier that identifies the time zone.
    */
    static public var timeZone: String {
        return TimeZone.current.identifier
    }
    
    /**
     Getter for current device locale.
     */
    static public var locale: String {
        return Locale.current.identifier
    }
    
    /**
     Getter for user country code.
     */
    static public var countryCode: String {
        return Locale.current.regionCode ?? ""
    }
}


public extension Environment {
    enum DeploymentTarget: String {
        case debug = "DEBUG"
        case testFlight = "TESTFLIGHT"
        case appStore = "APPSTORE"
        case unitTest = "UNITTEST"
    }
        
    static var deploymentTarget: DeploymentTarget {
        if isDebug {
            if isUnitTest {
                return .unitTest
            }
            return .debug
        } else if isTestFlight {
            return .testFlight
        } else {
            return .appStore
        }
    }
    
    private static let isAppStore = Environment.deploymentTarget == .appStore

    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

    private static let isUnitTest = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil ? true : false

    static let isDebug: Bool = {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }()
}

public extension Environment {
    enum Build: String {
        case release = "release"
        case test = "test"
        case debug = "debug"
    }
    
    static var build: Build {
        if isAppStore { return .release }
        if isTestFlight { return .test }
        return .debug
    }
}

// MARK: - API Environemnt
public extension Environment {
    
    enum APIEnvironment: String {
        case production
        case test
    }
    
    static func apiEnvironment() -> APIEnvironment {
        guard let savedKey = UserDefaults.standard.string(forKey: "EssentialKit.APIEnvironment") else {
            return .production
        }
        
        guard let environemnt = APIEnvironment.init(rawValue: savedKey) else {
            return .production
        }
        
        return environemnt
    }
    
    static func setApiEnvironment(_ env: APIEnvironment) {
        UserDefaults.standard.setValue(env.rawValue, forKey: "EssentialKit.APIEnvironment")
    }
}

// MARK: - Debug Overrides
public extension Environment {
    
}
