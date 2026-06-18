//
//  HomeKitRepository.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation
import HomeKit

/// Repository for live HK objects (isolates from app-facing models).
///
/// DI w/ HomeStore: create HomeStore => give to HomeKitRepository => HomeKitRepository updates
///  & SwiftUI observes that HomeStore.
///
/// NSObject is inherited to provide Objective-C interop for HK delegates (HMHomeManagerDelegate).
final class HomeKitRepository: NSObject, HMHomeManagerDelegate {
    
    // MARK: Properties
    
    // External callers can interact w/ homeManager + store *only indirectly* through repo's
    // public functions.
    private let homeManager: HMHomeManager
    private let store: HomeStore
    
    // MARK: Init
    
    /// Configures the repository for use.
    init(store: HomeStore,
         homeManager: HMHomeManager = HMHomeManager()) {
        self.store = store
        self.homeManager = homeManager
        
        super.init() // initialize NSObject; now we can use "self"
        
        homeManager.delegate = self // assign this repo as manager's delegate
    }
    
    // MARK: Delegate Callbacks
    
    /// Fired when the manager has loaded / changed its list of Homes.
    /// "manager" parameter is the exact manager who triggered this callback.
    ///
    /// Required by HMHomeManagerDelegate
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        // Publish updated homes to our HomeStore instance
        let mappedHomes: [HomeModel] = manager.homes.map { home in
            HomeKitMapper.homeModel(from: home)
        }
        
        store.homes = mappedHomes
    }
}
