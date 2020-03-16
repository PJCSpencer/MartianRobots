//
//  main.swift
//  Robots
//
//  Created by Peter Spencer on 15/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


let world: REDWorld = REDWorld()

while true
{
    if let line: String = readLine() /* Type in the output log. */
    { world.read(standardInput: line) }
}

