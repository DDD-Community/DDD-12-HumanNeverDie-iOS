//
// Project.swift
// Home
//
// Created by 김규철 on 2025.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: Modules.Feature.Home.rawValue,
    dependencies: [
        .commonFeature
    ]
)
