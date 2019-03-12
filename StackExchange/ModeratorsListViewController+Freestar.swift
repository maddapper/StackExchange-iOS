/// Copyright (c) 2019 Razeware LLC
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

import Foundation
import CoreGraphics
import FSAdSDK
import GoogleMobileAds

// MARK: Freestar Ad extension
extension ModeratorsListViewController {
  
  // load banners
  func loadBannerRequests() {
    bannerView1?.load(DFPRequest())
    bannerView2?.load(DFPRequest())
    bannerView3?.load(DFPRequest())
  }
  
  // banner layout
  func anchorBanners() {
    anchorBanner(bannerView1, size: CGSize(width: 320, height: 50))
    anchorBanner(bannerView2, size: CGSize(width: 300, height: 250))
    anchorBanner(bannerView3, size: CGSize(width: 320, height: 100))
  }
  
  // layout helper
  func anchorBanner(_ banner: UIView?, size: CGSize) {
    DispatchQueue.main.async {
      if #available(iOS 9.0, *) {
        banner?.translatesAutoresizingMaskIntoConstraints = false
        banner?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        banner?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        if (banner!.superview != nil) {
          banner?.centerXAnchor.constraint(equalTo: banner!.superview!.centerXAnchor).isActive = true
          banner?.centerYAnchor.constraint(equalTo: banner!.superview!.centerYAnchor).isActive = true
        }
      }
    }
  }
  
  // determine if row index should be a banner row based on modulo
  func isBannerRow(_ row: Int) -> Bool {
    if (row % FreestarConstants.listViewModulus) == 0 {
      return true
    }
    return false
  }
  
  func bannerForIndex(_ row: Int) -> (UIView & FSBanner)? {
    guard isBannerRow(row) else {
      return nil
    }
    let divisor = row / FreestarConstants.listViewModulus
    let bannerIndex = divisor % FreestarConstants.bannerCount
    switch bannerIndex {
      case 0:
        return bannerView1
      case 1:
        return bannerView2
      case 2:
        return bannerView3
      default:
        preconditionFailure("Freestar banner index is not being calculated correctly.")
    }
  }
  
  func sizeForBannerIndex(_ row: Int) -> CGSize {
    guard isBannerRow(row) else {
      return CGSize.zero
    }
    let divisor = row / FreestarConstants.listViewModulus
    let bannerIndex = divisor % FreestarConstants.bannerCount
    switch bannerIndex {
    case 0:
      return CGSize(width: 320, height: 50)
    case 1:
      return CGSize(width: 300, height: 250)
    case 2:
      return CGSize(width: 320, height: 100)
    default:
      preconditionFailure("Freestar banner index is not being calculated correctly.")
    }
  }
}
