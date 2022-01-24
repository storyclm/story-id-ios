//
//  AttributedStringBuilder.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 04.06.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class AttributedStringBuilder {

    private var attributedString = NSMutableAttributedString()

    private var paragraphStyle: NSMutableParagraphStyle = {
        let v = NSMutableParagraphStyle()
        v.lineBreakMode = NSLineBreakMode.byWordWrapping
        v.alignment = NSTextAlignment.center
        return v
    }()

    private var font = UIFont.boldSystemFont(ofSize: 14)
    private var color = UIColor.black
    private var kern: CGFloat = 0

    init(font: UIFont? = nil, color: UIColor? = nil, alignment: NSTextAlignment = NSTextAlignment.left, kern: CGFloat = 0) {
        self.paragraphStyle.alignment = alignment
        if let x = color { self.color = x }
        if let x = font { self.font = x }
        self.kern = kern
    }

    func result() -> NSMutableAttributedString {
        return attributedString
    }

    @discardableResult
    func minimumLineHeight(_ minimumLineHeight: CGFloat) -> AttributedStringBuilder {
        return self.changeParagraphStyle(minimumLineHeight: minimumLineHeight)
    }

    @discardableResult
    func changeParagraphStyle(_ alignment: NSTextAlignment? = nil,
                              lineSpacing: CGFloat? = nil,
                              lineHeightMultiple: CGFloat? = nil,
                              firstLineHeadIndent: CGFloat? = nil,
                              headIndent: CGFloat? = nil,
                              tailIndent: CGFloat? = nil,
                              paragraphSpacing: CGFloat? = nil,
                              paragraphSpacingBefore: CGFloat? = nil,
                              lineBreakMode: NSLineBreakMode? = nil,
                              minimumLineHeight: CGFloat? = nil) -> AttributedStringBuilder
    {

        self.paragraphStyle = self.paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
        if let x = alignment { self.paragraphStyle.alignment = x }
        if let x = lineSpacing { self.paragraphStyle.lineSpacing = x }
        if let x = lineHeightMultiple { self.paragraphStyle.lineHeightMultiple = x }
        if let x = firstLineHeadIndent { self.paragraphStyle.firstLineHeadIndent = x }
        if let x = headIndent { self.paragraphStyle.headIndent = x }
        if let x = tailIndent { self.paragraphStyle.tailIndent = x }
        if let x = paragraphSpacing { self.paragraphStyle.paragraphSpacing = x }
        if let x = paragraphSpacingBefore { self.paragraphStyle.paragraphSpacingBefore = x }
        if let x = lineBreakMode { self.paragraphStyle.lineBreakMode = x }
        if let x = minimumLineHeight { self.paragraphStyle.minimumLineHeight = x }
        return self
    }

    @discardableResult
    func add(_ text: String?, color: UIColor? = nil, font: UIFont? = nil, kern: CGFloat? = nil, isUnderline: Bool = false, link: String? = nil) -> AttributedStringBuilder {
        if let x = color { self.color = x }
        if let x = font { self.font = x }
        if let x = kern { self.kern = x }

        if text != nil {
            attributedString.append(NSAttributedString(string: text!,
                                                       attributes: [
                                                           NSAttributedString.Key.font: self.font,
                                                           NSAttributedString.Key.foregroundColor: self.color,
                                                           NSAttributedString.Key.paragraphStyle: self.paragraphStyle,
                                                           NSAttributedString.Key.kern: self.kern,
                                                       ]))
            if isUnderline {
                let string = attributedString.string as NSString
                let underlineRange = string.range(of: text! as String)
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single, range: underlineRange)
            }
            if let link = link {
                let string = attributedString.string as NSString
                let linkRange = string.range(of: text! as String)
                attributedString.addAttribute(NSAttributedString.Key.link, value: link, range: linkRange)
            }
        }

        return self
    }

    @discardableResult
    func add(imageNamed imageName: String, fixPosition: Bool = true, additionalOffset: CGFloat = 0) -> AttributedStringBuilder {
        return self.add(UIImage(named: imageName)!, fixPosition: fixPosition, additionalOffset: additionalOffset)
    }

    @discardableResult
    func add(_ image: UIImage, fixPosition: Bool = true, additionalOffset: CGFloat = 0) -> AttributedStringBuilder {
        let attachment = NSTextAttachment()
        attachment.image = image
        if fixPosition {
            let offsetToCenter: CGFloat = font.descender - attachment.image!.size.height * 0.5 + (font.descender + font.capHeight) + 2 + additionalOffset
            attachment.bounds = CGRect(x: 0, y: offsetToCenter, width: attachment.image!.size.width, height: attachment.image!.size.height)
        }
        attributedString.append(NSAttributedString(attachment: attachment))
        return self
    }

    @discardableResult
    func underlinedString(_ string: NSString, term: NSString) -> NSMutableAttributedString {
        let output = NSMutableAttributedString(string: string as String)
        let underlineRange = string.range(of: term as String)
        output.addAttribute(NSAttributedString.Key.underlineStyle, value: [], range: NSRange(location: 0, length: string.length))
        output.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single, range: underlineRange)

        return output
    }
}
