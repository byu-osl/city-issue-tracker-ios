//
//  Subscriber.swift
//  City Issue Tracker
//
//  Created by Joshua Cockrell on 4/8/15.
//  Copyright (c) 2015 BYU Open Source Lab. All rights reserved.
//

import Foundation

protocol Subscriber
{
    var mediator: Mediator { get }
    func notify(event: Event)
}