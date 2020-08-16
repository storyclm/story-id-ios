//
//  BaseFormViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former

class BaseFormViewController: FormViewController {

    private var titleLabel: UILabel?

    private(set) var isLoadViewModelCompleted: Bool = false
    private var isLoadViewModelStarted: Bool = false

    let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)

    let imagePicker = ImagePickerController()
    let imagePreview = ImagePreviewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createTitleLabel()

        self.view.backgroundColor = UIColor.idWhite

        if isCancelButtonVisible {
            let cancelButton = UIBarButtonItem(title: "global_cancel".loco, style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelButtonAction(_:)))
            cancelButton.tintColor = UIColor.idWhite
            self.navigationItem.leftBarButtonItem = cancelButton
        }

        if isSaveButtonVisible {
            let saveButton = UIBarButtonItem(title: "global_save".loco, style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonAction(_:)))
            saveButton.tintColor = UIColor.idWhite
            self.navigationItem.rightBarButtonItem = saveButton
        }

        self.activityIndicatorView.hidesWhenStopped = true
        self.activityIndicatorView.color = UIColor.black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isLoadViewModelStarted == false {
            isLoadViewModelStarted = true

            self.showActivityIndicator()
            self.loadViewModel()
        }
    }

    // MARK: - Abstract

    func loadViewModel() {
        self.completeLoadViewModel()
    }

    func completeLoadViewModel() {
        self.isLoadViewModelCompleted = true
        self.hideActivityIndicator()
        self.setupTableView()
    }
    
    func setupTableView() {}
    func onSave(success: Bool) {}

    var isSaveButtonVisible: Bool { true }
    var isCancelButtonVisible: Bool { true }

    // MARK: - Title label

    private func createTitleLabel() {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.idWhite

        self.navigationItem.titleView = label
        self.titleLabel = label
    }

    override var title: String? {
        set { self.titleLabel?.text = newValue }
        get { self.titleLabel?.text }
    }

    // MARK: - Action

    @objc private func saveButtonAction(_ sender: UIBarButtonItem) {
        self.onSave(success: self.isLoadViewModelCompleted)
    }

    @objc func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Activity indicator

    private func showActivityIndicator() {
        self.activityIndicatorView.center = self.view.center
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.startAnimating()
    }

    private func hideActivityIndicator() {
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.removeFromSuperview()
    }
}
