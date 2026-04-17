//
//  Project.swift
//  UserDomain
//
//  Created by Seulki Lee on 2025/07/20.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDomain(
    name: Modules.Domain.User.rawValue,
    dependencies: [
        .shared,
        .SPM.dependenciesMacros
    ]
)
