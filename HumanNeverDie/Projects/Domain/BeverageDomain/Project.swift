//
//  Project.swift
//  BeverageDomain
//
//  Created by 김규철 on 2025/07/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDomain(
    name: Modules.Domain.Beverage.rawValue,
    dependencies: [
        .shared,
        .SPM.dependenciesMacros
    ]
)
