//
//  StreamTrask.swift
//  next_ble
//
//  Created by Vu Dinh Hoc on 27/09/2022.
//

import Foundation

struct StreamTask<T> {
    let parameters: T
    let sink: EventSink?

    init(parameters: T) {
        self.parameters = parameters
        self.sink = nil
    }

    private init(parameters: T, sink: EventSink?) {
        self.parameters = parameters
        self.sink = sink
    }

    func with(sink: EventSink?) -> StreamTask {
        return StreamTask(parameters: parameters, sink: sink)
    }
}
