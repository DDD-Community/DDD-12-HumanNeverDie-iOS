//
// Project.swift
// BeverageRecordList
//
// Created by 김규철 on 2025.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: Modules.Feature.BeverageRecordList.rawValue,
    dependencies: [
        .commonFeature
    ]
)
