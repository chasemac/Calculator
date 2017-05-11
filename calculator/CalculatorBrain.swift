//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Chase McElroy on 5/2/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import Foundation

func createFloat(op1: Double, op2: Double) -> Double {
    return op1 + Double("0.\(Int(op2))")!
    
}

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    var accumValue: Double? {
        return accumulator
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
//        case float((Double,Double) -> Double)
        case equals
    }
    

    
    private var operations: Dictionary<String,Operation> =
    [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),
        "x" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
//        "." : Operation.float(createFloat),
        "=" : Operation.equals
        
    ]
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
                
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
//            case .float(let function):
//                if accumulator != nil {
//                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
// //                   accumulator = nil
//                }
                
            case .equals:
                performPendingBinaryOperation()
                accumulator = nil

            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
