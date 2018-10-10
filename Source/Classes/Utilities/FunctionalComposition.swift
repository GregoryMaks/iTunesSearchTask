//
//  FunctionalComposition.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//


precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}


infix operator • : CompositionPrecedence


func •<A, B, C>(lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}
