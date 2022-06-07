//
//  EventCollectionCellVM.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 06/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Pharos

struct EventCollectionCellVM: EventCollectionCellViewModel {
    @Subject var event: Event?
    
    var bannerImageObservable: Observable<UIImage?> {
        $event.mapped { $0?.image }
    }
    var eventNameObservable: Observable<String?> {
        $event.mapped { $0?.name }
    }
}
