//
//  EventCellVM.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 06/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Pharos

struct EventCellVM: EventCellViewModel {
    @Subject var event: Event?
    
    var bannerImageObservable: Observable<UIImage?> {
        $event.mapped { $0?.image }
    }
    var eventNameObservable: Observable<String?> {
        $event.mapped { $0?.name }
    }
    var eventDetailsObservable: Observable<String?> {
        $event.mapped { $0?.details }
    }
    var eventDateObservable: Observable<String?> {
        $event.mapped { event in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            guard let date = event?.date else {
                return nil
            }
            return dateFormatter.string(from: date)
        }
    }
}
