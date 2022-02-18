//
//  Combine+Ext.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Combine
import Foundation

public typealias MYAnyPublisher<T> = AnyPublisher<T, Never>
public typealias MYPassthroughSubject<T> = PassthroughSubject<T, Never>
public typealias MYCurrentValueSubject<T> = CurrentValueSubject<T, Never>
public typealias MYFuture<T> = Future<T, Never>
