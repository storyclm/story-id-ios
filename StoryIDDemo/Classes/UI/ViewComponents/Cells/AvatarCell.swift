//
//  AvatarCell.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import Former

final class AvatarCell: FormCell {

    // MARK: - Public

    let avatarView = UIButton(type: UIButton.ButtonType.custom)
    let smallImageView = UIImageView(image: UIImage(named: "icn_camera"))

    var avatarImage: UIImage?

    override func setup() {
        super.setup()

        avatarView.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)

        avatarView.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
        avatarView.setTitleColor(UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1.0), for: UIControl.State.normal)
        avatarView.titleLabel?.textAlignment = NSTextAlignment.center
        avatarView.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        avatarView.layer.masksToBounds = true
        self.contentView.addSubview(avatarView)

        self.smallImageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.avatarView.addSubview(self.smallImageView)

        self.avatarView.translatesAutoresizingMaskIntoConstraints = false
        self.smallImageView.translatesAutoresizingMaskIntoConstraints = false

        self.addConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarView.layer.cornerRadius = 8.0
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            self.avatarView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2.0),
            self.avatarView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2.0),
            self.avatarView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            self.avatarView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0),

            self.smallImageView.trailingAnchor.constraint(equalTo: self.avatarView.trailingAnchor, constant: -16.0),
            self.smallImageView.topAnchor.constraint(equalTo: self.avatarView.topAnchor, constant: 16.0),
            self.smallImageView.heightAnchor.constraint(equalToConstant: 20.0),
            self.smallImageView.widthAnchor.constraint(equalToConstant: 20.0),
        ])
    }
}

class AvatarlRowFormer<T: AvatarCell>: BaseRowFormer<T>, Formable {

    // MARK: Public

    open var avatarImage: UIImage?

    public required init(instantiateType: Former.InstantiateType = .Class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }

    open override func update() {
        super.update()

        let avatarView = cell.avatarView
        let image = self.avatarImage
        avatarView.setImage(image, for: UIControl.State.normal)

        if image != nil {
            avatarView.setTitle(nil, for: UIControl.State.normal)
        } else {
            avatarView.setTitle("profile_main_photo_load_title".loco, for: UIControl.State.normal)
        }
    }
}
