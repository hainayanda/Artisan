//
//  Methods.swift
//  Artisan
//
//  Created by Nayanda Haberty on 30/05/22.
//

import Foundation

public typealias VoidProcedure = () -> Void
public typealias VoidAProcedure<Argument> = (Argument) -> Void
public typealias VoidBiAProcedure<Arg1, Arg2> = (Arg1, Arg2) -> Void
public typealias VoidTriAProcedure<Arg1, Arg2, Arg3> = (Arg1, Arg2, Arg3) -> Void
public typealias VoidQuadAProcedure<Arg1, Arg2, Arg3, Arg4> = (Arg1, Arg2, Arg3, Arg4) -> Void

public func method<Object: AnyObject>(of object: Object, _ methodCompatible: @escaping (Object) -> VoidProcedure) -> VoidProcedure {
    { [weak object] in
        guard let object = object else { return }
        methodCompatible(object)()
    }
}

public func method<Object: AnyObject, Argument>(of object: Object, _ methodCompatible: @escaping (Object) -> VoidAProcedure<Argument>) -> VoidAProcedure<Argument> {
    { [weak object] argument in
        guard let object = object else { return }
        methodCompatible(object)(argument)
    }
}

public func method<Object: AnyObject, Arg1, Arg2>(of object: Object, _ methodCompatible: @escaping (Object) -> VoidBiAProcedure<Arg1, Arg2>) -> VoidBiAProcedure<Arg1, Arg2> {
    { [weak object] arg1, arg2 in
        guard let object = object else { return }
        methodCompatible(object)(arg1, arg2)
    }
}

public func method<Object: AnyObject, Arg1, Arg2, Arg3>(of object: Object, _ methodCompatible: @escaping (Object) -> VoidTriAProcedure<Arg1, Arg2, Arg3>) -> VoidTriAProcedure<Arg1, Arg2, Arg3> {
    { [weak object] arg1, arg2, arg3 in
        guard let object = object else { return }
        methodCompatible(object)(arg1, arg2, arg3)
    }
}

public func method<Object: AnyObject, Arg1, Arg2, Arg3, Arg4>(of object: Object, _ methodCompatible: @escaping (Object) -> VoidQuadAProcedure<Arg1, Arg2, Arg3, Arg4>) -> VoidQuadAProcedure<Arg1, Arg2, Arg3, Arg4> {
    { [weak object] arg1, arg2, arg3, arg4 in
        guard let object = object else { return }
        methodCompatible(object)(arg1, arg2, arg3, arg4)
    }
}
