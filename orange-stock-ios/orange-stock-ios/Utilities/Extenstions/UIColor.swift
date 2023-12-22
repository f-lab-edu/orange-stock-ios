//
//  UIColor.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/01.
//

import UIKit

/// 자주 사용하는 색상
extension UIColor {
    // 백그라운드 색상
    static let background = UIColor.systemBackground
    // 기본색상
    static let basic = UIColor.label
    // 메인 tint color
    static let mainTint = UIColor.init(hexCode: "FF7F00")
    
    // 설정 백그라운드 색상
    static let settingBackground = systemGroupedBackground
    // 설정 틴트 색상
    static let settingTint = UIColor.systemBlue
    
    // 전일 대비 상승 색상
    static let stockUp = UIColor.red
    // 전일 대비 하락 색상
    static let stockDown = UIColor.blue
}
