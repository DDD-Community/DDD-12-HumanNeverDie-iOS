//
// Project.swift
// Auth
//
// Created by 김규철 on 2025.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: Modules.Feature.Auth.rawValue,
    dependencies: [
        .commonFeature
    ]
)
