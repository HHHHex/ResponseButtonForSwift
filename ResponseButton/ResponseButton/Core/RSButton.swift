//
//  RSButton.swift
//  ResponseButton
//
//  Created by Heinz on 2017/11/16.
//  Copyright © 2017年 Heinz. All rights reserved.
//

import UIKit

class RSButton: UIButton {
    /**状态，可以外部改变，也可以内部主动改变
     *@ normal 正常状态，允许点击
     *@ waiting 等待状态，没有超时时间
     *@ disable 不可用状态，没有超时时间
     *@ runing 执行状态，遵循超时时间，超时时间过后会将按钮置为正常状态执行闭包或
     */
    enum ResponseState {
        case normal
        case waiting
        case disable
        case runing
    }
    
    /**响应的方式*/
    enum ResponseStyle {
        case count
        case active
    }
    
    var rsState: ResponseState = .normal {
        willSet {
            if newValue == .normal {
                self.isEnabled = true
                self.stopRun()
            } else if newValue == .waiting {
                self.isEnabled = false
                self.setTitle(t_waiting, for: .disabled)
                self.stopRun()
            } else if newValue == .disable {
                self.isEnabled = false
                self.setTitle(t_disable, for: .disabled)
                self.stopRun()
            } else if newValue == .runing {
                self.isEnabled = false
                self.startRun()
            }
        }
    }
    /**超时时间默认时间是60秒，可以自己设置*/
    private var timeOut: UInt = 60
    private var count: UInt = 60
    private var rsStyle: ResponseStyle = .count
    private var t_normal: String = ""
    private var t_waiting: String = ""
    private var t_disable: String = ""
    private var block: ((_ sender: RSButton)->())?
    
    private lazy var active: UIActivityIndicatorView? = {
        let view = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        view.hidesWhenStopped = true
        view.frame = self.frame
        return view
    }()
    
    private var timer: Timer?
    
    convenience init(style: ResponseStyle = .count, standColor: UIColor, frame: CGRect) {
        self.init(type: .custom)
        self.rsStyle = style
        self.frame = frame
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .disabled)
        self.setBackgroundImage(colorImage(color: standColor), for: .normal)
        self.setBackgroundImage(colorImage(color: UIColor.lightGray), for: .disabled)
        self.setBackgroundImage(colorImage(color: UIColor.gray), for: .highlighted)
        self.setTitle(t_normal, for: .normal)
        if style == .active {
            self.addSubview(self.active!)
        }
    }
    /**设置超时时间和超时执行*/
    func setTimeOut(_ time: UInt, complet: ((_ sender: RSButton)->())?) {
        self.timeOut = time
        self.count = time
        self.block = complet
    }
    
    /**对每个对应的状态设置标题*/
    func setTitlesFor(normal: String?, waiting: String?, disable: String?) {
        t_normal = normal ?? ""
        t_waiting = waiting ?? ""
        t_disable = disable ?? ""
        self.setTitle(t_normal, for: .normal)
    }
}

private extension RSButton {
    // MARK: - Actions
    @objc private func countTime() {
        if count == 0 {
            self.stopRun()
            self.rsState = .normal
            self.block?(self)
        } else {
            count -= 1
            if rsStyle == .count {
                self.setTitle("\(count)s", for: .disabled)
            }
        }
    }
    
    private func startRun() {
        if count != 0 {//不设置超时时间则不执行超时数秒
            self.countTime()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTime), userInfo: nil, repeats: true)
        }
        if self.rsStyle == .active {
            self.setTitle("", for: .disabled)
            self.active?.startAnimating()
        }
    }
    
    private func stopRun() {
        if self.rsStyle == .active {
            self.active?.stopAnimating()
        }
        if timer != nil {
            count = timeOut
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func colorImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}


