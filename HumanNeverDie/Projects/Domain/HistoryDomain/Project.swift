//
//  Project.swift
//  HistoryDomain
//
//  Created by Seulki Lee on 2025/07/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDomain(
    name: Modules.Domain.History.rawValue,
    dependencies: [
        .shared
    ]
) 
