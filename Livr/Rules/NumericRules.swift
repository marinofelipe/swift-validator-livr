//
//  Integer.swift
//  Livr
//
//  Created by Felipe Lefèvre Marino on 9/23/18.
//  Copyright © 2018 Felipe Marino. All rights reserved.
//

typealias DecimalNum = Decimal

struct NumericRules {
    
    // must be integer
    struct Integer: LivrRule, PreDefinedRule {
        static var name = "integer"
        var errorCode: LIVR.ErrorCode = .notInteger
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value {
                if !Utils.isPrimitive(value) { return (LIVR.ErrorCode.format.rawValue, nil) }
                if !Utils.isNumber(value) {
                    if let stringValue = value as? String, let intValue = Int(stringValue) {
                        return (nil, intValue as AnyObject)
                    }
                    return (errorCode.rawValue, nil)
                }
                if !(value is Int) { return (errorCode.rawValue, nil) }
            }
            
            return (nil, nil)
        }
    }
    
    // must be a positive integer
    struct PositiveInteger: LivrRule, PreDefinedRule {
        static var name = "positive_integer"
        var errorCode: LIVR.ErrorCode = .notPositiveInteger
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value {
                if !Utils.isPrimitive(value) { return (LIVR.ErrorCode.format.rawValue, nil) }
                if !Utils.isNumber(value) {
                    if let stringValue = value as? String, let intValue = Int(stringValue), intValue > 0 {
                        return (nil, intValue as AnyObject)
                    }
                    return (errorCode.rawValue, nil)
                }
                if let value = value as? Int, value < 1 { return (errorCode.rawValue, nil) }
            }
            
            return (nil, nil)
        }
    }
    
    // must be decimal
    struct Decimal: LivrRule, PreDefinedRule {
        static var name = "decimal"
        var errorCode: LIVR.ErrorCode = .notDecimal
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value {
                if !Utils.isPrimitive(value) { return (LIVR.ErrorCode.format.rawValue, nil) }
                if !Utils.isNumber(value) {
                    if let stringValue = value as? String {
                        if let intValue = Int(stringValue) {
                            return (nil, DecimalNum(intValue) as AnyObject)
                        } else if let doubleValue = Double(stringValue) {
                            return (nil, doubleValue as AnyObject)
                        }
                    }
                    return (errorCode.rawValue, nil)
                }
                if !(value is Double) { return (errorCode.rawValue, nil) }
            }
            return (nil, nil)
        }
    }
    
    // must be a positive decimal
    struct PositiveDecimal: LivrRule, PreDefinedRule {
        static var name = "positive_decimal"
        var errorCode: LIVR.ErrorCode = .notPositiveDecimal
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value {
                if !Utils.isPrimitive(value) { return (LIVR.ErrorCode.format.rawValue, nil) }
                if !Utils.isNumber(value) {
                    if let stringValue = value as? String {
                        if let intValue = Int(stringValue), intValue > 0 {
                            return (nil, DecimalNum(intValue) as AnyObject)
                        } else if let doubleValue = Double(stringValue), doubleValue > 0 {
                            return (nil, doubleValue as AnyObject)
                        }
                    }
                    return (errorCode.rawValue, nil)
                }
                if let value = value as? Double, value < 1 { return (errorCode.rawValue, nil) }
            }
            return (nil, nil)
        }
    }
    
    struct MaxNumber: LivrRule, PreDefinedRule {
        static var name = "max_number"
        var errorCode: LIVR.ErrorCode = .tooHigh
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value, let arguments = arguments {
                if !Utils.isPrimitive(value) { return (LIVR.ErrorCode.format.rawValue, nil) }
                if !Utils.canBeCoercedToNumber(value) { return (LIVR.ErrorCode.notNumber.rawValue, nil) }
                
                let maxValueAsString = String(describing: arguments)
                let inputedValueAsString = String(describing: value)
                
                if let valueAsInt = value as? Int, let maxValueAsInt = Int(maxValueAsString) {
                    if valueAsInt > maxValueAsInt {
                        return (errorCode.rawValue, nil)
                    }
                    return (nil, nil)
                } else if let valueAsDouble = value as? Double, let maxValueAsDouble = Double(maxValueAsString) {
                    if valueAsDouble > maxValueAsDouble {
                        return (errorCode.rawValue, nil)
                    }
                    return (nil, nil)
                } else if let inputedValueAsDouble = Double(inputedValueAsString), let maxValueAsDouble = Double(maxValueAsString) {
                    
                    if inputedValueAsDouble > maxValueAsDouble {
                        return (errorCode.rawValue, nil)
                    }
                    
                    if inputedValueAsDouble.truncatingRemainder(dividingBy: 1) == 0 {
                        return (nil, Int(inputedValueAsDouble) as AnyObject)
                    }
                    return (nil, inputedValueAsDouble as AnyObject)
                }
                return (nil, nil)
            }
            return (nil, nil)
        }
    }
    
    struct MinNumber: LivrRule, PreDefinedRule {
        static var name = "min_number"
        var errorCode: LIVR.ErrorCode = .tooLow
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value, let arguments = arguments {
                if !Utils.isPrimitive(value) { return (LIVR.ErrorCode.format.rawValue, nil) }
                if !Utils.canBeCoercedToNumber(value) { return (LIVR.ErrorCode.notNumber.rawValue, nil) }
                
                let minValueAsString = String(describing: arguments)
                let inputedValueAsString = String(describing: value)
                
                if let valueAsInt = value as? Int, let minValueAsInt = Int(minValueAsString) {
                    if valueAsInt < minValueAsInt {
                        return (errorCode.rawValue, nil)
                    }
                    return (nil, nil)
                } else if let valueAsDouble = value as? Double, let minValueAsDouble = Double(minValueAsString) {
                    if valueAsDouble < minValueAsDouble {
                        return (errorCode.rawValue, nil)
                    }
                    return (nil, nil)
                } else if let inputedValueAsDouble = Double(inputedValueAsString), let minValueAsDouble = Double(minValueAsString) {
                    
                    if inputedValueAsDouble < minValueAsDouble {
                        return (errorCode.rawValue, nil)
                    }
                    
                    if inputedValueAsDouble.truncatingRemainder(dividingBy: 1) == 0 {
                        return (nil, Int(inputedValueAsDouble) as AnyObject)
                    }
                    return (nil, inputedValueAsDouble as AnyObject)
                }
                return (nil, nil)
            }
            return (nil, nil)
        }
    }
    
    struct NumberBetween: LivrRule, PreDefinedRule {
        static var name = "number_between"
        var errorCode: LIVR.ErrorCode = .format
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value, let arguments = arguments {
                if !Utils.isPrimitive(value) { return (LIVR.ErrorCode.format.rawValue, nil) }
                if !Utils.canBeCoercedToNumber(value) { return (LIVR.ErrorCode.notNumber.rawValue, nil) }
                
                let valueAsString = StringType(describing: value)
                
                if let arrayOfArguments = arguments as? [Any], let minAllowedValueArgument = arrayOfArguments.first, arrayOfArguments.count > 1 {
                    
                    let maxAllowedValueArgument = arrayOfArguments[1]
                    
                    let minAllowedValueAsString = String(describing: minAllowedValueArgument)
                    let maxAllowedValueAsString = String(describing: maxAllowedValueArgument)
                    
                    if let valueAsInt = value as? Int, let minAllowedValueAsInt = Int(minAllowedValueAsString),
                        let maxAllowedValueAsInt = Int(maxAllowedValueAsString) {
                        if valueAsInt < minAllowedValueAsInt {
                            return (LIVR.ErrorCode.tooLow.rawValue, nil)
                        } else if valueAsInt > maxAllowedValueAsInt {
                            return (LIVR.ErrorCode.tooHigh.rawValue, nil)
                        }
                        return (nil, nil)
                    } else if let valueAsDouble = value as? Double, let minAllowedValueAsDouble = Double(minAllowedValueAsString), let maxAllowedValueAsDouble = Double(maxAllowedValueAsString) {
                        if valueAsDouble < minAllowedValueAsDouble {
                            return (LIVR.ErrorCode.tooLow.rawValue, nil)
                        } else if valueAsDouble > maxAllowedValueAsDouble {
                            return (LIVR.ErrorCode.tooHigh.rawValue, nil)
                        }
                        return (nil, nil)
                    } else if let inputedValueAsDouble = Double(valueAsString), let minAllowedValueAsDouble = Double(minAllowedValueAsString), let maxAllowedValueAsDouble = Double(maxAllowedValueAsString) {
                        
                        if inputedValueAsDouble < minAllowedValueAsDouble {
                            return (LIVR.ErrorCode.tooLow.rawValue, nil)
                        } else if inputedValueAsDouble > maxAllowedValueAsDouble {
                            return (LIVR.ErrorCode.tooHigh.rawValue, nil)
                        }
                        
                        if inputedValueAsDouble.truncatingRemainder(dividingBy: 1) == 0 {
                            return (nil, Int(inputedValueAsDouble) as AnyObject)
                        }
                        return (nil, inputedValueAsDouble as AnyObject)
                    }
                    
                    return (nil, nil)
                }
            }
            return (nil, nil)
        }
    }
}
