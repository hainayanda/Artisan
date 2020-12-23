//
//  MockEventService.swift
//  Artisan_Example
//
//  Created by Nayanda Haberty on 22/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

protocol EventService {
    func searchEvent(withSearchPhrase searchPhrase: String, then: ([Event]) -> Void)
}

class MockEventService: EventService {
    var mockData: [Event] = [
        .init(
            image: #imageLiteral(resourceName: "dwp2020"),
            name: "Djakarta Warehouse Project",
            details: "Djakarta Warehouse Project is a dance music festival held in Jakarta, Indonesia. It is one of the largest annual dance music festivals in Asia, featuring dance music artists from around the world.",
            date: .init(timeIntervalSince1970: 1608422400)
        ),
        .init(
            image: #imageLiteral(resourceName: "ipa2020"),
            name: "Indonesia Property Awards",
            details: "PropertyGuru Indonesia Property Awards are the most respected and most sought-after real estate industry honours.",
            date: .init(timeIntervalSince1970: 1604966400)
        ),
        .init(
            image: #imageLiteral(resourceName: "javajazz2020"),
            name: "Java Jazz Festival",
            details: "Java Jazz Festival is One of the largest jazz festivals in the world.",
            date: .init(timeIntervalSince1970: 1603929600)
        ),
        .init(
            image: #imageLiteral(resourceName: "hammersonic2020"),
            name: "Hammersonic",
            details: "Hammersonic Festival is a metal and rock festival, held annually in Jakarta, Indonesia since 2012. It is the biggest metal and rock festival in Southeast Asia even in Asia Pacific.",
            date: .init(timeIntervalSince1970: 1579219200)
        ),
        .init(
            image: #imageLiteral(resourceName: "dwp2020"),
            name: "Djakarta Warehouse Project 2",
            details: "Djakarta Warehouse Project is a dance music festival held in Jakarta, Indonesia. It is one of the largest annual dance music festivals in Asia, featuring dance music artists from around the world.",
            date: .init(timeIntervalSince1970: 1608422400)
        ),
        .init(
            image: #imageLiteral(resourceName: "ipa2020"),
            name: "Indonesia Property Awards 2",
            details: "PropertyGuru Indonesia Property Awards are the most respected and most sought-after real estate industry honours.",
            date: .init(timeIntervalSince1970: 1604966400)
        ),
        .init(
            image: #imageLiteral(resourceName: "javajazz2020"),
            name: "Java Jazz Festival 2",
            details: "Java Jazz Festival is One of the largest jazz festivals in the world.",
            date: .init(timeIntervalSince1970: 1603929600)
        ),
        .init(
            image: #imageLiteral(resourceName: "hammersonic2020"),
            name: "Hammersonic 2",
            details: "Hammersonic Festival is a metal and rock festival, held annually in Jakarta, Indonesia since 2012. It is the biggest metal and rock festival in Southeast Asia even in Asia Pacific.",
            date: .init(timeIntervalSince1970: 1579219200)
        ),
        .init(
            image: #imageLiteral(resourceName: "dwp2020"),
            name: "Djakarta Warehouse Project 3",
            details: "Djakarta Warehouse Project is a dance music festival held in Jakarta, Indonesia. It is one of the largest annual dance music festivals in Asia, featuring dance music artists from around the world.",
            date: .init(timeIntervalSince1970: 1608422400)
        ),
        .init(
            image: #imageLiteral(resourceName: "ipa2020"),
            name: "Indonesia Property Awards 3",
            details: "PropertyGuru Indonesia Property Awards are the most respected and most sought-after real estate industry honours.",
            date: .init(timeIntervalSince1970: 1604966400)
        ),
        .init(
            image: #imageLiteral(resourceName: "javajazz2020"),
            name: "Java Jazz Festival 3",
            details: "Java Jazz Festival is One of the largest jazz festivals in the world.",
            date: .init(timeIntervalSince1970: 1603929600)
        ),
        .init(
            image: #imageLiteral(resourceName: "hammersonic2020"),
            name: "Hammersonic 3",
            details: "Hammersonic Festival is a metal and rock festival, held annually in Jakarta, Indonesia since 2012. It is the biggest metal and rock festival in Southeast Asia even in Asia Pacific.",
            date: .init(timeIntervalSince1970: 1579219200)
        )
    ]
    func searchEvent(withSearchPhrase searchPhrase: String, then: ([Event]) -> Void) {
        then(mockData.filter {
            searchPhrase.isEmpty ||
                $0.name.lowercased().contains(searchPhrase.lowercased()) ||
                $0.details.lowercased().contains(searchPhrase.lowercased())
        })
    }
}
