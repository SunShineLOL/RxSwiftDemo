//
//  SharedSequenceConvertibleType.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import Foundation
import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType where Self.Element: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Driver` of source `Driver`'s elements, with `nil` elements filtered out.
     */
    
    func filterNil() -> SharedSequence<SharingStrategy, Self.Element.Wrapped> {
        return flatMap { element -> SharedSequence<SharingStrategy, Self.Element.Wrapped> in
            guard let value = element.value else {
                return SharedSequence<SharingStrategy, Self.Element.Wrapped>.empty()
            }
            return SharedSequence<SharingStrategy, Self.Element.Wrapped>.just(value)
        }
    }

    /**
     Unwraps optional elements and replaces `nil` elements with `valueOnNil`.
     - parameter valueOnNil: value to use when `nil` is encountered.
     - returns: `Driver` of the source `Driver`'s unwrapped elements, with `nil` elements replaced by `valueOnNil`.
     */
    
    func replaceNilWith(_ valueOnNil: Self.Element.Wrapped) -> SharedSequence<SharingStrategy, Self.Element.Wrapped> {
        return map { element -> Self.Element.Wrapped in
            guard let value = element.value else {
                return valueOnNil
            }
            return value
        }
    }

    /**
     Unwraps optional elements and replaces `nil` elements with result returned by `handler`.
     - parameter handler: `nil` handler function that returns `Driver` of non-`nil` elements.
     - returns: `Driver` of the source `Driver`'s unwrapped elements, with `nil` elements replaced by the handler's returned non-`nil` elements.
     */
    
    func catchOnNil(_ handler: @escaping () -> SharedSequence<SharingStrategy, Self.Element.Wrapped>) -> SharedSequence<SharingStrategy, Self.Element.Wrapped> {
        return flatMap { element -> SharedSequence<SharingStrategy, Self.Element.Wrapped> in
            guard let value = element.value else {
                return handler()
            }
            return SharedSequence<SharingStrategy, Self.Element.Wrapped>.just(value)
        }
    }
}

