//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
   
    public var amount : Int
    public var currency : currencies
    
    public enum currencies {
        case USD
        case GBP
        case CAN
        case EUR
    }
    
    private func converttoCommon(_ amount : Int, _ type: currencies) -> Int{
        switch currency {
        case currencies.USD:
            return (amount * 1)
        case currencies.GBP:
            return (amount * 2)
        case currencies.CAN:
            return (amount * 4/5)
        case currencies.EUR:
            return (amount * 2/3)
        }
    }

    public func convert(_ to: currencies) -> Money {
        let rawValue = converttoCommon(self.amount, self.currency)
        switch to {
        case currencies.USD:
            return Money(amount : rawValue, currency : to)
        case currencies.GBP:
            return Money(amount : (rawValue / 2), currency : to)
        case currencies.CAN:
            return Money(amount : (rawValue * 5 / 4), currency : to)
        case currencies.EUR:
            return Money(amount : (rawValue * 3 / 2), currency : to)
        }
        
    }
    
    public func add(_ to: Money) -> Money {
        var total = to.amount
        total += self.convert(to.currency).amount
        
        return Money(amount : total, currency: to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        var result = from.amount
        result -= self.convert(from.currency).amount
 
        return Money(amount : result, currency : from.currency)
    }

}
////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        
        switch type{
            case .Hourly(let rate):
                return Int(Double(hours) * rate)
            case .Salary(let rate):
                return rate
        }
    }
    
    open func raise(_ amt : Double) {
        switch type{
            case JobType.Hourly(let rate):
                type = JobType.Hourly(rate + amt)
            case JobType.Salary(let rate):
                type = JobType.Salary(rate + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { return self._job }
        set(value) {
            if self.age > 16 {
                self._job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return self._spouse}
        set(value) {
            if self.age > 18{
                self._spouse = value
            }
            
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if (spouse1._spouse == nil && spouse2._spouse == nil){
            spouse1._spouse = spouse2
            spouse2._spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        } else {
            print("Please insert two unmarried people for this family")
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        var legal = false;
        for index in 0...members.count - 1 {
            if members[index].age > 21{
                legal = true;
            }
        }
        if legal {
            members.append(child)
            return true
        }
        return false;
    
    }
    
    open func householdIncome() -> Int {
        var total = 0
        for index in 0...(members.count - 1){
            if members[index]._job != nil {
                total += members[index]._job!.calculateIncome(2000)
            }
        }
        return total
    }
}



