//
//  EnumSet.swift
//  AboutAK_V3.0
//
//  Created by XYoung on 2019/5/22.
//  Copyright © 2019 timedomAIn. All rights reserved.
//

import UIKit
import SwiftyGif

class EnumSet: NSObject {
    
}

// MARK: - 图片类型 ==============================
extension EnumSet {
    enum ImageTpye: String {
        /// 圆圈
        case circle = "circle"
        /// 圆环
        case ring = "ring"
        
        /// 继续_横
        case continue_L = "continue_L"
        /// 继续_竖
        case continue_P = "continue_P"
        /// 练习
        case exercise = "exercise"
        /// 暂停_横
        case pause_L = "pause_L"
        /// 暂停_竖
        case pause_P = "pause_P"
        /// 重录
        case reRecord = "reRecord"
        /// 开始_横
        case start_L = "start_L"
        /// 开始_竖
        case start_P = "start_P"
        /// 停止
        case stop = "stop"
        /// 提交
        case submit = "submit"
        /// 音色
        case tone = "guitar"
        /// 相册
        case album = "album"
        /// 快进
        case fast_forward = "fast_forward"
        /// 快退
        case rewind = "rewind"
        /// 暂停
        case pause = "pause"
        /// 播放
        case play = "play"
        /// 换角色
        case changePart = "changePart"
        /// 引导圈
        case guideCircle = "guideCircle"
        /// 引导滑动
        case guideMove = "guideMove"
        /// 更多操作
        case more_operation = "more_operation"
        /// 整页占位图
        case page_placeholder = "song_list_background"
        /// 去发布
        case to_submit = "to_submit"
        
    }
    
    static func image(type: ImageTpye) -> UIImage {
        return UIImage.init(named: type.rawValue)!
        
    }
}

// MARK: - Gif类型 ==============================
extension EnumSet {
    enum GifTpye: String {
        /// 单手指
        case oneFinger = "oneFinger.gif"
        /// 三手指
        case threeFingers = "threeFingers.gif"
        /// 滑动手指
        case moveFinger = "moveFinger.gif"
    }
    
    static func gifImage(type: GifTpye) -> UIImage {
        let gifImage = try! UIImage.init(gifName: type.rawValue)
        
        return gifImage
    }
    
}

// MARK: - 外部跳转动作类型 ==============================
extension EnumSet {
    enum OpenURLActionType: String {
        /// 跳转房间页面
        case JumpToRoom = "JumpToRoom"
        /// 跳转系统通知页面
        case JumpToSysNotice = "JumpToSysNotice"
        /// 跳转到与我相关的作品页
        case JumpToAboutMe = "JumpToAboutMe"
        /// 跳转到消息界面
        case JumpToMessage = "JumpToMessage"
        
        /// 他人的关注
        case OthersFollow = "OthersFollow"
        /// 他人的点赞
        case OthersLike = "OthersLike"
        /// 他人的评论
        case OthersComment = "OthersComment"
        /// 他人的私信
        case OthersLetters = "OthersLetters"
        /// 他人的评论回复
        case OthersReply = "OthersReply"
    }
    
}

// MARK: - 引导类型 ==============================
extension EnumSet {
    enum GuideTpye: String {
        /// 功能
        case feature = "feature"
        /// 操作
        case operation = "operation"
        
    }
    
}

// MARK: - 字体类型 ==============================
extension EnumSet {
    enum FontType: String {
        /// 普通字体
        case Normal = "FZJunHeiS-M-GB"
        
        /// 粗体
        case Bold = "FZJunHeiS-DB-GB"
        
    }
    
    static let fontTypes: [FontType] = [.Normal, .Bold]
    
    static func font(type: FontType, size: CGFloat) -> UIFont {
        return UIFont.init(name: type.rawValue, size: size)!
        
    }
    
    @objc static func font(index: Int, size: CGFloat) -> UIFont {
        let type = fontTypes[index]
        return UIFont.init(name: type.rawValue, size: size)!
    }
    
}

// MARK: - iPhone屏幕类型 ==============================
extension EnumSet {
    enum iPhoneType: String {
        case iPhone = "{375, 667}"
        case iPhonePlus = "{414, 736}"
        case iPhoneX = "{375, 812}"
        case iPhoneXsMax = "{414, 896}"
        
    }
    
    static func screenSize(type: iPhoneType) -> CGSize {
        let screenSize = NSCoder.cgSize(for: type.rawValue)
        
        return screenSize
        
    }
}

// MARK: - 基本数据类型 ==============================
extension EnumSet {
    enum TimeIntervalUnit: Int {
        /// 秒
        case second = 1
        /// 毫秒
        case millisecond = 1000
        /// 微秒
        case microsecond = 1000000
        
    }
    
}
