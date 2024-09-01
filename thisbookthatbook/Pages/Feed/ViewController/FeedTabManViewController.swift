//
//  FeedTabManViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

final class FeedTabManViewController: TabmanViewController {
    enum FeedTitle: String, CaseIterable {
        case give = "tab_give_recommend"
        case receive = "tab_recieve_recommend"
    }
    
    private let bar = TabmanBar()
    
    private let viewControllers = [
        FeedViewController(vm: FeedViewModel(), feedType: .give_recommend),
        FeedViewController(vm: FeedViewModel(), feedType: .recieve_recommended),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        addBar(bar, dataSource: self, at: .custom(view: view, layout: { [weak self] bar in
            guard let self else { return }
            bar.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide)
                make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            }
        }))
        
        navigationItem.title = "navigation_title_feed".localized
        navigationItem.backButtonDisplayMode = .minimal
    }
}

extension FeedTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
        let title = FeedTitle.allCases[index].rawValue.localized
        return TMBarItem(title: title)
    } 
}
