//
//  GitHubGitHubRepositoryPresenter.swift
//  ios-clean-architecture-sample
//
//  Created by KAGE on 1/8/17.
//  Copyright © 2017 KAGE. All rights reserved.
//

import Foundation

protocol GitHubRepositoryPresenter: class {
    func didTapClearButton()
    func didTapSearchButton(text: String?)
    func didSelectRepository(repositoryModel: GitHubRepositoryModel)
}

protocol GitHubRepositoryPresenterInput: class {
    func setRepositoriesModel(_ repositoriesModel: GitHubRepositoriesModel)
    func setSearchBarText(_ text: String)
    func endSearching()
    func showLoadingView()
    func hideLoadingView()
}

final class GitHubRepositoryPresenterImpl: GitHubRepositoryPresenter {
    fileprivate let useCase: GitHubRepositoryUseCase
    fileprivate let wireframe: GitHubRepositoryWireframe
    fileprivate weak var viewController: GitHubRepositoryPresenterInput?

    init(useCase: GitHubRepositoryUseCase, wireframe: GitHubRepositoryWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }

    func inject(viewController: GitHubRepositoryPresenterInput) {
        self.viewController = viewController
    }

    func didTapClearButton() {
        self.viewController?.setRepositoriesModel(GitHubRepositoriesModel())
        self.viewController?.setSearchBarText("")
        self.viewController?.endSearching()
    }

    func didTapSearchButton(text: String?) {
        self.viewController?.showLoadingView()
        self.useCase.searchRepositories(repositoryName: text)
    }

    func didSelectRepository(repositoryModel: GitHubRepositoryModel) {
        self.viewController?.endSearching()
        self.wireframe.showDetail(repositoryModel: repositoryModel)
    }
}

// MARK: - GitHubRepositoryUseCasePresentationInput
extension GitHubRepositoryPresenterImpl: GitHubRepositoryUseCasePresentationInput {
    func useCase(_ useCase: GitHubRepositoryUseCase, didSearchRepositories repositories: GitHubRepositoriesModel) {
        self.viewController?.setRepositoriesModel(repositories)
        self.viewController?.hideLoadingView()
    }
}
