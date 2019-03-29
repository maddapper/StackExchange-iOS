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
import GoogleMobileAds
import SnapKit

class ModeratorsListViewController: UIViewController {
  private enum CellIdentifiers {
    static let list = "List"
  }
  
  @IBOutlet var indicatorView: UIActivityIndicatorView!
  @IBOutlet var tableView: UITableView!
  
  var site: String!
  
  private var viewModel: ModeratorsViewModel!
  
  private var shouldShowLoadingCell = false
  
  // MARK: Begin Freestar props
  // note: only one instance of each banner can be shown at a time,
  // so max 3 will be visible on the screen
  
  private lazy var adUnitID1 = {
    return "/\(FreestarConstants.dfpAccountId)/\(FreestarConstants.adPlacement1)"
  }()
  private lazy var adUnitID2 = {
    return "/\(FreestarConstants.dfpAccountId)/\(FreestarConstants.adPlacement2)"
  }()
  private lazy var adUnitID3 = {
    return "/\(FreestarConstants.dfpAccountId)\(FreestarConstants.adPlacement3)"
  }()

  lazy var bannerView1: (UIView & FSBanner)? = {
    return FSAdProvider.createBanner(withIdentifier: FreestarConstants.adPlacement2, size: kGADAdSizeMediumRectangle, adUnitId: adUnitID2, rootViewController: self, registrationDelegate: nil, eventHandler: { [weak self]
      (methodName: String!, params: [ String : Any]) in
      // custom behavior here
    })
  }()
  
  lazy var bannerView2: (UIView & FSBanner)? = {
    return FSAdProvider.createBanner(withIdentifier: FreestarConstants.adPlacement3, size: kGADAdSizeLargeBanner, adUnitId: adUnitID3, rootViewController: self, registrationDelegate: nil, eventHandler: { [weak self]
      (methodName: String!, params: [ String : Any]) in
      // custom behavior here
    })
  }()
  
  lazy var bannerView3: (UIView & FSBanner)? = {
    return FSAdProvider.createBanner(withIdentifier: FreestarConstants.adPlacement1, size: kGADAdSizeBanner, adUnitId: adUnitID1, rootViewController: self, registrationDelegate: nil, eventHandler: { [weak self]
      (methodName: String!, params: [ String : Any]) in
      // custom behavior here
    })
  }()
  // MARK: End Freestar props
  
  override func viewWillDisappear(_ animated: Bool) {
    // Freestar banner refresh pause
    bannerView1?.pauseRefresh()
    bannerView2?.pauseRefresh()
    bannerView3?.pauseRefresh()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // Freestar banner refresh resume
    bannerView1?.resumeRefresh()
    bannerView2?.resumeRefresh()
    bannerView3?.resumeRefresh()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    indicatorView.color = ColorPalette.RWGreen
    indicatorView.startAnimating()
    
    tableView.isHidden = true
    tableView.separatorColor = ColorPalette.RWGreen
    tableView.dataSource = self
    tableView.delegate = self
    tableView.prefetchDataSource = self
    tableView.snp.makeConstraints { (make) -> Void in
      make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        .offset(-(bannerView3!.bounds.height + FreestarConstants.bannerContainerTopMargin))
    }
    
    self.view.addSubview(bannerView3!)
    bannerView3!.snp.makeConstraints { (make) -> Void in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.centerX.equalTo(bannerView3!.superview!)
    }
    
    let request = ModeratorRequest.from(site: site)
    viewModel = ModeratorsViewModel(request: request, delegate: self)
    
    viewModel.fetchModerators()
    
    // Freestar load banners
    loadBannerRequests()
  }
}

extension ModeratorsListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 1
    return viewModel.totalCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! ModeratorTableViewCell
    
    // Freestar check if row is banner
    if isBannerRow(indexPath.row) {
      cell.removeFromSuperview()
      // setup banner cell
      let bannerCell: UITableViewCell = UITableViewCell()
      bannerCell.backgroundColor = UIColor.groupTableViewBackground
      let banner: (UIView & FSBanner)? = bannerForIndex(indexPath.row)
      bannerCell.contentView.addSubview(banner!)
      anchorBanner(banner, size: banner!.fsAdSize)
      return bannerCell
    } else {
      // 2
      if isLoadingCell(for: indexPath) {
        cell.configure(with: .none)
      } else {
        cell.configure(with: viewModel.moderator(at: indexPath.row))
      }
    }
    return cell
  }
  
  // Freestar banner height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if isBannerRow(indexPath.row) {
      return sizeForBannerIndex(indexPath.row).height
    } else {
      // non-banner row
      return FreestarConstants.listCellHeight
    }
  }
}

extension ModeratorsListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      viewModel.fetchModerators()
    }
  }
}

extension ModeratorsListViewController: ModeratorsViewModelDelegate {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
    // 1
    guard let newIndexPathsToReload = newIndexPathsToReload else {
      indicatorView.stopAnimating()
      tableView.isHidden = false
      tableView.reloadData()
      return
    }
    
    // 2
    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
    tableView.reloadRows(at: indexPathsToReload, with: .automatic)
  }

  func onFetchFailed(with reason: String) {
    indicatorView.stopAnimating()
    print("StackExchange Fetch error: \(reason)")
  }
}

private extension ModeratorsListViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
