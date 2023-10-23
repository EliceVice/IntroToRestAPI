//
//  UserModel.swift
//  IntroToRestAPI
//
//  Created by Andrei Isayenka on 14/10/2023.
//

import Foundation

/// 1) подписываемся под Codable
/// 2) если вы предпологаете что данные могут не прийти делаем опцитонал "?"
/// 3) имена свойств точно совпадают с именами параметров

struct User: Codable {
    let id: Int
    let name: String?
    let username: String?
    let email: String?
    let phone: String?
    let website: String?
    let address: Address?
    let company: Company?
}

struct Address: Codable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo?
}

struct Geo: Codable {
    let lat: String?
    let lng: String?
}

struct Company: Codable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}


/*
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
},
*/
