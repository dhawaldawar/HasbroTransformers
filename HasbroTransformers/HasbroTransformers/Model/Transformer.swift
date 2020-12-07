//
//  Transformer.swift
//  HasbroTransformers
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

struct Transformer {

    enum Team: String, Codable {
        case autobot = "A"
        case decepticon = "D"

        var string: String {
            switch self {
            case .autobot:
                return "Autobot"

            case .decepticon:
                return "Decepticon"
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case team
        case strength
        case intelligence
        case speed
        case endurance
        case rank
        case courage
        case firepower
        case skill
        case teamIcon = "team_icon"
    }
    
    let id: String
    let name: String
    let team: Team
    let strength: Int
    let intelligence: Int
    let speed: Int
    let endurance: Int
    let rank: Int
    let courage: Int
    let firepower: Int
    let skill: Int
    let teamIcon: URL?
    
    var overallRating: Int { strength + intelligence + speed + endurance + firepower }
    
    init(
        name: String,
        team: Team,
        strength: Int,
        intelligence: Int,
        speed: Int,
        endurance: Int,
        rank: Int,
        courage: Int,
        firepower: Int,
        skill: Int
    ) {
        self.id = ""
        self.name = name
        self.team = team
        self.strength = strength
        self.intelligence = intelligence
        self.speed = speed
        self.endurance = endurance
        self.rank = rank
        self.courage = courage
        self.firepower = firepower
        self.skill = skill
        self.teamIcon = nil
    }
}

extension Transformer: Codable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        team = try container.decode(Team.self, forKey: .team)
        strength = try container.decode(Int.self, forKey: .strength)
        intelligence = try container.decode(Int.self, forKey: .intelligence)
        speed = try container.decode(Int.self, forKey: .speed)
        endurance = try container.decode(Int.self, forKey: .endurance)
        rank = try container.decode(Int.self, forKey: .rank)
        courage = try container.decode(Int.self, forKey: .courage)
        firepower = try container.decode(Int.self, forKey: .firepower)
        skill = try container.decode(Int.self, forKey: .skill)
        if let urlString = try container.decodeIfPresent(String.self, forKey: .teamIcon), let url = URL(string: urlString) {
            teamIcon = url
        } else {
            teamIcon = nil
        }
    }
}

extension Transformer: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
            lhs.team == rhs.team &&
            lhs.strength == rhs.strength &&
            lhs.intelligence == rhs.intelligence &&
            lhs.speed == rhs.speed &&
            lhs.endurance == rhs.endurance &&
            lhs.rank == rhs.rank &&
            lhs.courage == rhs.courage &&
            lhs.firepower == rhs.firepower &&
            lhs.skill == rhs.skill
    }

}
