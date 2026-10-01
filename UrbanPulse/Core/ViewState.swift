//
//  ViewState.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 23/09/26.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(NetworkError)
}
