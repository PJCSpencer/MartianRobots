//
//  REDWorld.swift
//  Robots
//
//  Created by Peter Spencer on 15/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


protocol REDWorldNavigation
{
    func navigate(using instruction: REDNaviagteInstruction,
                  boundedGrid: REDBoundedGrid)
}

class REDWorld
{
    // MARK: - Property(s)
    
    var boundedGrid: REDBoundedGrid?
    
    var robot: REDRobot?
    {
        didSet
        {
            if let oldValue = oldValue
            { print(oldValue.description as Any) }
        }
    }
}

// MARK: - REDInputHandler
extension REDWorld: REDInputHandler
{
    func read(standardInput string: String)
    {
        guard let instruction = REDInstruction(string: string) else
        { return }
        
        if self.boundedGrid == nil,
            let size = REDSize(instruction: instruction)
        {
            self.boundedGrid = REDBoundedGrid(size: size)
            // print(self.boundedGrid?.description as Any)
            
            return
        }
        
        if self.robot == nil,
            let instruction = REDInstruction(string: string),
            let robot = REDRobot(instruction: instruction)
        {
            self.robot = robot
            // print(self.robot?.description as Any)
            
            return
        }
        
        guard let navigate = REDNaviagteInstruction(string: string),
            let grid = self.boundedGrid else
        { return }
        
        self.robot?.navigate(using: navigate, boundedGrid: grid)
        self.robot = nil
    }
}

