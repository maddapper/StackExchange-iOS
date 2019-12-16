/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import FSAdSDK
import PrebidMobileFS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // method to initialize the Freestar SDK
    initializeFreestar()
    return true
  }
  
  // MARK: Freestar SDK initialization
  func initializeFreestar() {
    print("[Freestar_Validation]: Initializing SDK.")
    // Prebid logging
    PBLogManager.setPBLogLevel(PBLogLevel.debug)

    // Freestar Mobile SDK setup
    PBAnalyticsManager.sharedInstance()?.enabled = true
    FSAdSDK.overrideBundleIdentifier("com.stocktwits.StockTwits")

    
    print("[Freestar_Validation]: Begin ad unit registration.")
    FSRegistration.register { (status, adUnits) in
      // optional for first ad load
      if (status == .success) {
        // status or informational
        for adUnit in adUnits! {
          print("[Freestar_Validation]: \(adUnit.identifier!) | \(adUnit.adSizes!)")
        }
        print("[Freestar_Validation]: SUCCESS.")
      } else {
        print("[Freestar_Validation]: FAILURE.")
      }
    }
  }
    
}

