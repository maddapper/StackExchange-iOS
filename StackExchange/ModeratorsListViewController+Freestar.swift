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
import SnapKit

// MARK: Freestar Ad extension
extension ModeratorsListViewController {
  
  // load banners
  func loadBannerRequests() {
    for banner in allBanners {
      banner?.load(DFPRequest())
    }
  }
  
  // banner layout
  func anchorBanners() {
    for banner in allBanners {
      anchorBanner(banner, size: CGSize(width: 320, height: 50))
    }
  }
  
  // layout helper
  func anchorBanner(_ banner: UIView?, size: CGSize) {
    banner!.snp.makeConstraints { (make) in
      make.centerY.centerX.equalTo(banner!.superview!)
      make.size.equalTo(size)
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
        return bannerView2
      case 1:
        return bannerView3
      case 2:
        return bannerView4
      case 3:
        return bannerView5
      case 4:
        return bannerView6
      case 5:
        return bannerView7
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
      return CGSize(width: 320, height: 52)
    case 1:
      return CGSize(width: 320, height: 52)
    case 2:      
      return CGSize(width: 320, height: 52)
    case 3:
      return CGSize(width: 320, height: 52)
    case 4:
      return CGSize(width: 320, height: 52)
    case 5:
      return CGSize(width: 320, height: 52)
    default:
      preconditionFailure("Freestar banner index is not being calculated correctly.")
    }
  }
}
