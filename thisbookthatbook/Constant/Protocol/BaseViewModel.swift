//
//  BaseViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
