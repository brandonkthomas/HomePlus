//
//  HomeKitLoadState.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/20/26.
//

enum HomeKitLoadState: Equatable {
    case loading
    /// Ready = lifecycle load is completed; does not describe non-empty data
    case ready
    case unauthorized
}
