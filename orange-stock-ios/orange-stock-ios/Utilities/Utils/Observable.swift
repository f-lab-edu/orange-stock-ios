//
//  Observable.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/20.
//

import Foundation

/// Observer: View에 ViewModel의 데이터를 바인딩
class Observable<T> {
    
    /// 클로저를 통해 동작을 저장
    private var listener: ((T) -> Void)?
    
    /// value가 변하면 didSet에 의해 변경된 value의 값을 갖고 listner 동작을 실행
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    /// bind 실행 시, 클로저 안쪽의 동작들을 listner에 저장
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
