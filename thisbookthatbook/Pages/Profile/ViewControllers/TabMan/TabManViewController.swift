//
//  TabManViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

final class TabManViewController: TabmanViewController {
    private let bar = TMBar.ButtonBar()
    private let viewControllers = [
        ProfilePostsViewController(vm: ProfilePostsViewModel(), viewIdx: 0), 
        ProfilePostsViewController(vm: ProfilePostsViewModel(), viewIdx: 1),
        ProfilePostsViewController(vm: ProfilePostsViewModel(), viewIdx: 2)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        addBar(bar, dataSource: self, at: .custom(view: self.view, layout: { bar in
            bar.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide)
                make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(24)
               
                make.height.equalTo(44)
            }
        }))
        
        setupUI()
    }
    
    func setupUI() {
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .leading
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 24
    
        bar.buttons.customize { button in
            button.tintColor = Resource.Colors.lightGray
            button.selectedTintColor = Resource.Colors.black
            button.font = Resource.Fonts.regular15
            button.selectedFont = Resource.Fonts.bold15
        }
   
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.overscrollBehavior = .compress
        bar.indicator.tintColor = Resource.Colors.primaryColor
    }
}

extension TabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: any TMBar, at index: Int) -> any TMBarItemable {
        let title = UserContentsType.allCases[index].rawValue.localized
        return TMBarItem(title: title)
    }
}
