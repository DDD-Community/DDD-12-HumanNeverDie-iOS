//
// Project.swift
// Onboarding
//
// Created by Seulki Lee on 2025.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: Modules.Feature.Onboarding.rawValue,
    dependencies: [
        .commonFeature
    ]
)
