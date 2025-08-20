//
//  Project.swift
//  AuthDomain
//
//  Created by Claude on 8/20/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDomain(
    name: Modules.Domain.Auth.rawValue,
    dependencies: [
        .shared
    ]
)