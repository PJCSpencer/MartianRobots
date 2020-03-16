//
//  REDInput.swift
//  Robots
//
//  Created by Peter Spencer on 15/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


protocol REDInputHandler
{
    func read(standardInput string: String)
}

protocol REDInstructionInitialiser
{
    init?(instruction: REDInstruction)
}

struct REDInstructionComponent
{
    let value: String
}

struct REDInstruction
{
    // MARK: - Constant(s)
    
    static let maximumLength: Int = 100
    
    let components: [REDInstructionComponent]
    
    
    // MARK: - Initialisation
    
    init(components: [REDInstructionComponent])
    { self.components = components }
    
    init?(string: String)
    {
        guard string.count <= REDInstruction.maximumLength,
            let result = string.components(separatedBy: CharacterSet.whitespaces)
                .compactMap({ REDInstructionComponent(value: $0) }) as [REDInstructionComponent]? else
        { return nil }
        
        self.components = result
    }
}

protocol REDNaviagteCommandResponder
{
    associatedtype ReturnType
    
    func respond(to command: REDNaviagteCommand) -> ReturnType?
}

enum REDNaviagteCommand: String
{
    case left       = "L"
    case right      = "R"
    case forward    = "F"
    
    
    // MARK: - Constant(s)
    
    static let support: [REDNaviagteCommand] = [.left, .right, .forward]
    
    static let regex: String = "[\(REDNaviagteCommand.support.map({ $0.rawValue.lowercased() }).joined())]" // TODO:Support protocol ..?
}

struct REDNaviagteInstruction // TODO:Support protocol ...
{
    // MARK: - Constant(s)
    
    static let maximumLength: Int = 100
    
    
    // MARK: - Property(s)
    
    let commands: [REDNaviagteCommand]
    
    
    // MARK: - Initialisation
    
    init?(string: String)
    {
        guard string.count <= REDNaviagteInstruction.maximumLength,
            string.replacingOccurrences(of: REDNaviagteCommand.regex, with: "", options: [.regularExpression]).count == 0,
            let result = string.map({ String($0) })
                .compactMap({ REDNaviagteCommand(rawValue: $0.capitalized) }) as [REDNaviagteCommand]? else
        { return nil }
        
        self.commands = result
    }
}

