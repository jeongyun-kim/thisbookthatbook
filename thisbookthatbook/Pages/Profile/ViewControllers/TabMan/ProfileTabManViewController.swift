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

final class ProfileTabManViewController: TabmanViewController {
    private let bar = TabmanBar()
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
            }
        }))
    }
}

extension ProfileTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
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
