//
// Project.swift
// Setting
//
// Created by Seulki Lee on 2025.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: Modules.Feature.Setting.rawValue,
    dependencies: [
        .commonFeature
    ]
)
