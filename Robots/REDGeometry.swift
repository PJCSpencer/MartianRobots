//
//  REDGeometry.swift
//  Robots
//
//  Created by Peter Spencer on 15/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


struct REDCoordinate
{
    // MARK: - Constant(s)
    
    static let maximumValue: Int = 50
    
    
    // MARK: - Property(s)
    
    let value: Int
    
    
    // MARK - Initialisation
    
    init(_ value: Int? = nil)
    { self.value = value ?? 0 }
    
    init?(string: String,
          maximumValue: Int = REDCoordinate.maximumValue)
    {
        guard let number = Int(string),
            number <= maximumValue else
        { return nil }
        
        self.value = number
    }
}

// MARK: - Custom Operator(s)
extension REDCoordinate
{
    static func + (left: REDCoordinate,
                   right: REDCoordinate) -> REDCoordinate
    {
        return REDCoordinate(left.value + right.value)
    }
    
    static func - (left: REDCoordinate,
                   right: REDCoordinate) -> REDCoordinate
    {
        return REDCoordinate(left.value - right.value)
    }
}

// MARK: - CustomStringConvertible
extension REDCoordinate: CustomStringConvertible
{
    var description: String
    { return "\(self.value)" }
}

enum REDOrientation: String
{
    case north  = "N"
    case east   = "E"
    case south  = "S"
    case west   = "W"
    
    
    // MARK: - Constant(s)
    
    static let support: [REDOrientation] = [.north, .east, .south, .west]
}

// MARK: - REDInstructionInitialiser
extension REDOrientation: REDInstructionInitialiser
{
    init?(instruction: REDInstruction)
    {
        guard instruction.components.count == 1,
            let component = instruction.components.first?.value.capitalized,
            let result = REDOrientation.support.compactMap({ (_) in REDOrientation(rawValue: component) }).first else
        { return nil }
        
        self = result
    }
}

// MARK: - REDNaviagteCommandResponder
extension REDOrientation: REDNaviagteCommandResponder
{
    func respond(to command: REDNaviagteCommand) -> REDOrientation?
    {
        var index = REDOrientation.support.firstIndex(of: self) ?? 0
        
        switch command
        {
        case .left:
            index -= 1
            index = index < 0 ? REDOrientation.support.count-1 : index
        case .right:
            index += 1
            index = index >= REDOrientation.support.count ? 0 : index
        default:
            break
        }
        
        return REDOrientation.support[index]
    }
}

// MARK: - CustomStringConvertible
extension REDOrientation: CustomStringConvertible
{
    var description: String
    { return "\(self.rawValue)" }
}

struct REDPosition
{
    // MARK: - Property(s)
    
    let x: REDCoordinate
    
    let y: REDCoordinate
    
    
    // MARK - Initialisation
    
    init(x: REDCoordinate? = nil,
         y: REDCoordinate? = nil)
    {
        self.x = x ?? REDCoordinate()
        self.y = y ?? REDCoordinate()
    }
    
    
    // MARK: - Moving
    
    func move(orientation: REDOrientation) -> REDPosition
    {
        switch orientation
        {
        case .north, .south:
            let value: Int = orientation == .north ? 1 : -1
            return REDPosition(x: self.x, y: self.y + REDCoordinate(value))
            
        case .east, .west:
            let value: Int = orientation == .east ? 1 : -1
            return REDPosition(x: self.x + REDCoordinate(value), y: self.y)
        }
    }
}

// MARK: - REDInstructionInitialiser
extension REDPosition: REDInstructionInitialiser
{
    init?(instruction: REDInstruction)
    {
        guard instruction.components.count == 2,
            let result = instruction.components.compactMap({ REDCoordinate(string: $0.value) }) as [REDCoordinate]?,
            let x = result.first,
            let y = result.last else
        { return nil }
        
        self.x = x
        self.y = y
    }
}

// MARK: - CustomStringConvertible
extension REDPosition: CustomStringConvertible
{
    var description: String
    { return "\(self.x.description) \(self.y.description)" }
}

struct REDSize
{
    // MARK: - Property(s)
    
    let width: REDCoordinate
    
    let height: REDCoordinate
}

// MARK: - REDInstructionInitialiser
extension REDSize: REDInstructionInitialiser
{
    init?(instruction: REDInstruction)
    {
        guard instruction.components.count == 2,
            let result = instruction.components.compactMap({ REDCoordinate(string: $0.value) }) as [REDCoordinate]?,
            let width = result.first,
            let height = result.last else
        { return nil }
        
        self.width = width
        self.height = height
    }
}

// MARK: - CustomStringConvertible
extension REDSize: CustomStringConvertible
{
    var description: String
    { return "\(self.width.description) \(self.height.description)" }
}

struct REDBoundedGrid
{
    // MARK: - Property(s)
    
    let origin: REDPosition = REDPosition()
    
    let size: REDSize
    
    
    // MARK - Initialisation
    
    init(size: REDSize)
    { self.size = size }
    
    
    // MARK: - Utility
    
    var upperRightCoordinates: [REDCoordinate]
    { return [self.size.width, self.size.height] }
    
    var lowerLeftCoordinates: [REDCoordinate]
    { return [self.origin.x, self.origin.y] }
}

// MARK: - CustomStringConvertible
extension REDBoundedGrid: CustomStringConvertible
{
    var description: String
    { return "\(self.origin.description) \(self.size.description)" }
}

