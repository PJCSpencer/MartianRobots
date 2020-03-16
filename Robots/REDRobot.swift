//
//  REDRobot.swift
//  Robots
//
//  Created by Peter Spencer on 15/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


let REDRobotMaximumComponentCount: Int = 3

class REDRobot: REDInstructionInitialiser
{
    // MARK: - Property(s)
    
    var position: REDPosition
    
    var orientation: REDOrientation
    
    
    // MARK - Initialisation
    
    required init?(instruction: REDInstruction) // Using stepped guard to highlight context.
    {
        guard instruction.components.count == REDRobotMaximumComponentCount else
        { return nil }
        
        guard let components = Array(instruction.components[0..<2]) as [REDInstructionComponent]?, /* TODO:Support range ... */
            let start = REDInstruction(components: components) as REDInstruction?,
            let position = REDPosition(instruction: start) else
        { return nil }
        
        guard let component = instruction.components.last as REDInstructionComponent?,
            let end = REDInstruction(components: [component]) as REDInstruction?,
            let orientation = REDOrientation(instruction: end) else
        { return nil }
        
        self.position = position
        self.orientation = orientation
    }
}

// MARK: - CustomStringConvertible
extension REDRobot: CustomStringConvertible
{
    var description: String
    { return "\(self.position.description) \(self.orientation.description)" }
}

// MARK: - REDWorldNavigation
extension REDRobot: REDWorldNavigation
{
    func navigate(using instruction: REDNaviagteInstruction,
                  boundedGrid: REDBoundedGrid)
    {
        instruction.commands.forEach
        { (command) in
            
            switch command
            {
            case .forward:
                self.position = self.position.move(orientation: self.orientation)
                
            case .left, .right:
                if let result = self.orientation.respond(to: command)
                { self.orientation = result }
            }
        }
        
        // TOOD:Bounds checking ...
        
    }
}

