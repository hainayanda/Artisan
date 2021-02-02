//
//  MultiOperationHandler.swift
//  Artisan
//
//  Created by Nayanda Haberty (ID) on 02/09/20.
//

import Foundation

protocol OperationHandler {
    func addOperation(_ closure: @escaping () -> Void)
}

class ObservableOperationHandler: OperationHandler {
    lazy var operationQueue: OperationQueue = {
        let opQueue = OperationQueue()
        opQueue.name = uniqueKey
        opQueue.maxConcurrentOperationCount = 1
        opQueue.underlyingQueue = dispatcher
        return opQueue
    }()
    var dispatcher: DispatchQueue
    var syncIfPossible: Bool
    
    init(dispatcher: DispatchQueue, syncIfPossible: Bool) {
        self.dispatcher = dispatcher
        self.syncIfPossible = syncIfPossible
    }
    
    var uniqueKey: String {
        let address = Int(bitPattern: Unmanaged.passUnretained(self).toOpaque())
        return NSString(format: "%p", address) as String
    }
    
    func addOperation(_ closure: @escaping () -> Void) {
        operationQueue.cancelAllOperations()
        guard syncIfPossible && couldbeSynchronized else {
            operationQueue.addOperation(SyncOperation(closure))
            return
        }
        closure()
    }
    
    var couldbeSynchronized: Bool {
        operationAndCurrentIsMain || OperationQueue.current?.underlyingQueue == dispatcher
    }
    
    var operationAndCurrentIsMain: Bool {
        Thread.isMainThread && OperationQueue.current?.underlyingQueue == DispatchQueue.main
    }
    
    enum OperationState {
        case idle
        case running
        case completed
        case cancelled
    }
    
    class SyncOperation: Operation {
        var closure: () -> Void
        var state: OperationState = .idle
        override var isAsynchronous: Bool { false }
        override var isConcurrent: Bool { false }
        override var isReady: Bool { state == .idle }
        override var isExecuting: Bool { state == .running }
        override var isCancelled: Bool { state == .cancelled }
        override var isFinished: Bool { state == .completed }
        
        init(_ closure: @escaping () -> Void) {
            self.closure = closure
            super.init()
        }
        
        override func start() {
            defer {
                state = .completed
            }
            guard !isCancelled else {
                return
            }
            state = .running
            main()
        }
        
        override func main() {
            closure()
        }
        
        override func cancel() {
            state = .cancelled
        }
    }
}

