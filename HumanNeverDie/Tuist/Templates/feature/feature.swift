//
//  feature.swift
//  BaseDomainManifests
//
//  Created by 김규철 on 5/15/25.
//

import Foundation

import ProjectDescription
import ProjectDescriptionHelpers

private let nameAttribute: Template.Attribute = .required("name")
private let yearAttribute: Template.Attribute = .optional("year", default: .string(.defaultYear))
private let dateAttribute: Template.Attribute = .optional("date", default: .string(.defaultYear))
private let authorAttribute: Template.Attribute = .optional("author", default: .string(.defaultAuthor))

let featureTemplate = Template(
    description: "신규 feature 모듈 생성",
    attributes: [
        nameAttribute,
        yearAttribute,
        dateAttribute,
        authorAttribute,
    ],
    items: [
        .file(
            path: "Projects/Features/\(nameAttribute)Feature/Project.swift",
            templatePath: "Project.stencil"),
        .file(
            path: "Projects/Features/\(nameAttribute)Feature/Sources/\(nameAttribute)View.swift",
            templatePath: "View.stencil"),
        .file(
            path: "Projects/Features/\(nameAttribute)Feature/Sources/\(nameAttribute)ViewModel.swift",
            templatePath: "ViewModel.stencil"),
        .file(
            path: "Projects/Features/\(nameAttribute)Feature/Sources/\(nameAttribute)ViewFactory.swift",
            templatePath: "ViewFactory.stencil"),
        .file(
            path: "Projects/Features/\(nameAttribute)Feature/Tests/Sources/\(nameAttribute)ViewModelTest.swift",
            templatePath: "ViewModelTest.stencil")
    ]
)
