//
//  GroupsLoader.swift
//  test-gu
//
//  Created by Денис Сизов on 13.10.2021.
//


// Возвращаем какой-то массив данных, тут могла бы быть подгрузка из API
class GroupsLoader {
    static func iNeedGroups() -> [GroupModel] {
        return [GroupModel(name: "В душе пираты", image: "pepe-pirate"),
                GroupModel(name: "Дворник это призвание", image: "pepe-yard-keeper"),
                GroupModel(name: "Лайфхаки из Тиктока", image: "pepe-dunno"),
                GroupModel(name: "Годнота", image: "pepe-like"),
        ]
    }
}
