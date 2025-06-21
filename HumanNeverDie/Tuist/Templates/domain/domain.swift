//
//  domain.swift
//  BaseDomainManifests
//
//  Created by 김규철 on 5/26/25.
//

import Foundation

import ProjectDescription
import ProjectDescriptionHelpers

private let nameAttribute: Template.Attribute = .required("name")
private let yearAttribute: Template.Attribute = .optional("year", default: .string(.defaultYear))
private let dateAttribute: Template.Attribute = .optional("date", default: .string(.defaultDate))
private let authorAttribute: Template.Attribute = .optional("author", default: .string(.defaultAuthor))

let domainTemplate = Template(
    description: "신규 domain 모듈 생성",
    attributes: [
        nameAttribute,
        yearAttribute,
        dateAttribute,
        authorAttribute,
    ],
    items: [
        .file(
            path: "Projects/Domain/\(nameAttribute)Domain/Project.swift",
            templatePath: "Project.stencil"),
        .file(
            path: "Projects/Domain/\(nameAttribute)Domain/Sources/UseCases/\(nameAttribute)UseCase.swift",
            templatePath: "UseCase.stencil"),
        .file(
            path: "Projects/Domain/\(nameAttribute)Domain/Sources/RepositoryInterface/\(nameAttribute)RepositoryInterface.swift",
            templatePath: "Repository.stencil"),
        .file(
            path: "Projects/Domain/\(nameAttribute)Domain/Tests/Sources/\(nameAttribute)UseCaseTest.swift",
            templatePath: "UseCaseTest.stencil")
    ]
)
