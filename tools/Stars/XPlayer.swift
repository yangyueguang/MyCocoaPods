//
//  XPlayer.swift
import UIKit
import SnapKit
import CoreMedia
import CoreGraphics
import QuartzCore
import MediaPlayer
import AVFoundation

let kOffset = "contentOffset"
let SliderFillColorAnim = "fillColor"
// playerLayer的填充模式
enum XPlayerFillMode : Int {
    case resize
    case aspect
    case aspectFill
}

enum PanDirection: Int {
    case horizontal = 0
    case vertical = 1
}

// 播放器的几种状态
enum XPlayerState: Int {
    case failed = 0 // 播放失败
    case buffering  // 缓冲中
    case playing    // 播放中
    case stopped    // 停止播放
    case pause      // 暂停播放
}

enum XPImage: String {
    case play = "play"
    case pause = "pause"
    case back = "back_full"
    case close = "close"
    case lock = "lock-nor"
    case unlock = "unlock-nor"
    case full = "fullscreen"
    case slider = "slider"
    case download = "download"
    case play_btn = "play_btn"
    case loading = "loading_bgView"
    case brightness = "brightness"
    case management = "management_mask"
    case not_download = "not_download"
    case repeat_video = "repeat_video"
    case shrinkscreen = "shrinkscreen"
    case top_shadow = "top_shadow"
    case bottom_shadow = "bottom_shadow"

    var img: UIImage? {
        return UIImage(named: rawValue)
    }
}

extension CALayer {
    func animateKey(_ animationName: String, fromValue: Any?, toValue: Any?, customize block: ((_ animation: CABasicAnimation?) -> Void)?) {
        setValue(toValue, forKey: animationName)
        let anim = CABasicAnimation(keyPath: animationName)
        anim.fromValue = fromValue ?? presentation()?.value(forKey: animationName)
        anim.toValue = toValue
        block?(anim)
        add(anim, forKey: animationName)
    }
}

// 私有类
class ASValuePopUpView: UIView, CAAnimationDelegate {
    var currentValueOffset: (() -> CGFloat)?
    var colorDidUpdate:((UIColor) -> Void)?
    var arrowLength: CGFloat = 8
    var widthPaddingFactor: CGFloat = 1.15
    var heightPaddingFactor: CGFloat = 1.1
    private var shouldAnimate = false
    private var animDuration: TimeInterval = 0
    private var arrowCenterOffset: CGFloat = 0
    var imageView = UIImageView()
    var timeLabel = UILabel()
    private var colorAnimLayer = CAShapeLayer()
    private lazy var pathLayer = CAShapeLayer(layer: layer)
    var cornerRadius: CGFloat = 0 {
         didSet {
             if oldValue != self.cornerRadius {
                 pathLayer.path = path(for: bounds, withArrowOffset: arrowCenterOffset)?.cgPath
             }
         }
     }
    var color: UIColor? {
        get {
            if let fill = pathLayer.presentation()?.fillColor {
                return UIColor(cgColor: fill)
            }
            return nil
        }
        set(newValue) {
            pathLayer.fillColor = newValue?.cgColor
            colorAnimLayer.removeAnimation(forKey: SliderFillColorAnim)
        }
    }
    var opaqueColor: UIColor? {
        let a = colorAnimLayer.presentation()
        let co = a?.fillColor ?? pathLayer.fillColor
        if let components = co?.components {
         if (components.count == 2) {
             return UIColor(white: components[0], alpha: 1)
         } else {
             return UIColor(red: components[0], green: components[1], blue: components[2], alpha: 1)
         }
        } else {
            return nil
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        cornerRadius = 4.0
        shouldAnimate = false
        self.layer.anchorPoint = CGPoint(x:0.5, y: 1)
        self.isUserInteractionEnabled = false
        layer.addSublayer(colorAnimLayer)
        timeLabel.text = "10:00"
        timeLabel.textAlignment = .center
        timeLabel.textColor = UIColor.white
        addSubview(timeLabel)
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if shouldAnimate {
            let anim = CABasicAnimation(keyPath: event)
            anim.beginTime = CACurrentMediaTime()
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            anim.fromValue = layer.presentation()?.value(forKey: event)
            anim.duration = animDuration
            return anim
        } else {
            return nil
        }
    }

    func setAnimatedColors(animatedColors: [UIColor], withKeyTimes keyTimes:[NSNumber]) {
        var cgColors:[CGColor] = []
        for col in animatedColors {
            cgColors.append(col.cgColor)
        }
        let colorAnim = CAKeyframeAnimation(keyPath:SliderFillColorAnim)
        colorAnim.keyTimes = keyTimes
        colorAnim.values = cgColors
        colorAnim.fillMode = .both
        colorAnim.duration = 1.0
        colorAnim.delegate = self
        colorAnimLayer.speed = Float.leastNormalMagnitude
        colorAnimLayer.timeOffset = 0.0
        colorAnimLayer.add(colorAnim, forKey: SliderFillColorAnim)
    }

    func setAnimationOffset(animOffset: CGFloat, returnColor:((UIColor?) -> Void)) {
        if  (colorAnimLayer.animation(forKey: SliderFillColorAnim) != nil) {
            colorAnimLayer.timeOffset = CFTimeInterval(animOffset)
            pathLayer.fillColor = colorAnimLayer.presentation()?.fillColor
            returnColor(opaqueColor)
        }
    }

    func setFrame(frame:CGRect, arrowOffset:CGFloat) {
        if arrowOffset != arrowCenterOffset || !frame.size.equalTo(self.frame.size) {
            let a = path(for: frame, withArrowOffset: arrowOffset)
            pathLayer.path = a?.cgPath
        }
        arrowCenterOffset = arrowOffset
        let anchorX = 0.5+(arrowOffset/frame.size.width)
        self.layer.anchorPoint = CGPoint(x:anchorX, y:1)
        self.layer.position = CGPoint(x:frame.origin.x + frame.size.width*anchorX,y: 0)
        self.layer.bounds = CGRect(origin: CGPoint.zero, size: frame.size)
    }

    func animateBlock(block:((TimeInterval) -> Void)) {
        shouldAnimate = true
        animDuration = 0.5
        let anim = layer.animation(forKey: "position")
            if let anim = anim {
            let elapsedTime = min(CACurrentMediaTime() - anim.beginTime, anim.duration)
            animDuration = animDuration * elapsedTime / anim.duration
        }
        block(animDuration)
        shouldAnimate = false
    }

    func showAnimated(animated: Bool){
        if (!animated) {
            self.layer.opacity = 1.0
            return
        }
        CATransaction.begin()
        let anim = self.layer.animation(forKey: "transform")
        let a = layer.presentation()?.value(forKey: "transform")
        let b = NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1))
        let fromValue = (anim == nil ? b : a)
        layer.animateKey("transform", fromValue: fromValue, toValue: NSValue(caTransform3D: CATransform3DIdentity)) { (animation) in
            animation?.duration = 0.4
            animation?.timingFunction = CAMediaTimingFunction(controlPoints:0.8 ,2.5 ,0.35 ,0.5)
        }
        layer.animateKey("opacity", fromValue: nil, toValue: 1.0) { (animation) in
            animation?.duration = 0.1
        }
        CATransaction.commit()
    }

    func hideAnimated(animated: Bool, completionBlock block:@escaping(() -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {[weak self] in
            block()
            self?.layer.transform = CATransform3DIdentity
        }
        if (animated) {
            layer.animateKey("transform", fromValue: nil, toValue: NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1)), customize: { (animation) in
                animation?.duration = 0.55
                animation?.timingFunction = CAMediaTimingFunction(controlPoints: 0.1 ,-2 ,0.3 ,3)
            })
            layer.animateKey("opacity", fromValue: nil, toValue: 0, customize: { (animation) in
                animation?.duration = 0.75
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.layer.opacity = 0.0
            })
        }
        CATransaction.commit()
    }

    func animationDidStart(_ anim: CAAnimation) {
        colorAnimLayer.speed = 0.0
        colorAnimLayer.timeOffset = CFTimeInterval(currentValueOffset?() ?? 0)
        pathLayer.fillColor = colorAnimLayer.presentation()?.fillColor
        colorDidUpdate?(opaqueColor ?? .red)
    }

   func path(for rect: CGRect, withArrowOffset arrowOffset: CGFloat) -> UIBezierPath? {
       var rect = rect
       if rect.equalTo(CGRect.zero) { return nil }
       rect = CGRect(origin: CGPoint.zero, size: rect.size)
       var roundedRect = rect
       roundedRect.size.height -= arrowLength
       let popUpPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius)
       let maxX = roundedRect.maxX
       let arrowTipX = rect.midX + arrowOffset
       let tip = CGPoint(x: arrowTipX, y: rect.maxY)
       let arrowLength = roundedRect.height / 2.0
       let x = arrowLength * tan(45.0 * .pi / 180)
       let arrowPath = UIBezierPath()
       arrowPath.move(to: tip)
       arrowPath.addLine(to: CGPoint(x: max(arrowTipX - x, 0), y: roundedRect.maxY - arrowLength))
       arrowPath.addLine(to: CGPoint(x: min(arrowTipX + x, maxX), y: roundedRect.maxY - arrowLength))
       arrowPath.close()
       popUpPath.append(arrowPath)
       return popUpPath
   }

    override func layoutSubviews() {
        super.layoutSubviews()
        let textRect = CGRect(x:self.bounds.origin.x, y:0, width:self.bounds.size.width,height: 13)
        timeLabel.frame = textRect
        let imageReact = CGRect(x:self.bounds.origin.x+5, y:textRect.size.height+textRect.origin.y, width:self.bounds.size.width-10, height:56)
        imageView.frame = imageReact
    }
}
/// 亮度类 私有类
class XBrightnessView: UIView {
    static let shared = XBrightnessView()
    // 调用单例记录播放状态是否锁定屏幕方向
    var isLockScreen = false
    // cell上添加player时候，不允许横屏,只运行竖屏状态状态
    var isAllowLandscape = false
    var backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 79, height: 76))
    lazy var title = UILabel(frame: CGRect(x: 0, y: 5, width: bounds.size.width, height: 30))
    lazy var longView = UIView(frame: CGRect(x: 13, y: 132, width: bounds.size.width - 26, height: 7))
    var tipArray: [UIImageView] = []
    var orientationDidChange = false
    var timer: Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backImage.image = XPImage.brightness.img
        self.frame = CGRect(x: APPW * 0.5, y: APPH * 0.5, width: 155, height: 155)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        let toolbar = UIToolbar(frame: bounds)
        toolbar.alpha = 0.97
        addSubview(toolbar)
        addSubview(backImage)
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor(red: 0.25, green: 0.22, blue: 0.21, alpha: 1.00)
        title.textAlignment = .center
        title.text = "亮度"
        addSubview(title)
        longView.backgroundColor = UIColor(red: 0.25, green: 0.22, blue: 0.21, alpha: 1.00)
        addSubview(longView)
        let tipW: CGFloat = (longView.bounds.size.width - 17) / 16
        for i in 0..<16 {
            let tipX = CGFloat(i) * (tipW + 1) + 1
            let image = UIImageView()
            image.backgroundColor = UIColor.white
            image.frame = CGRect(x: tipX, y: 1, width: tipW, height: 5)
            longView.addSubview(image)
            tipArray.append(image)
        }
        updateLongView(sound: UIScreen.main.brightness)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayer(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        UIScreen.main.addObserver(self, forKeyPath: "brightness", options: .new, context: nil)
        alpha = 0.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let ab = change?[NSKeyValueChangeKey(rawValue: "new")] as? NSNumber
        let sound = CGFloat(ab?.floatValue ?? 0)
        if self.alpha == 0 {
           self.alpha = 1.0
           timer?.invalidate()
           timer = Timer(timeInterval: 3, target: self, selector: #selector(disAppearSoundView), userInfo: nil, repeats: false)
           RunLoop.main.add(timer!, forMode: .default)
        }
        updateLongView(sound: sound)
    }

    @objc func updateLayer(_ notify: Notification?) {
        orientationDidChange = true
        setNeedsLayout()
    }

    @objc func disAppearSoundView() {
        if (self.alpha == 1.0) {
            UIView.animate(withDuration: 0.8) {
                self.alpha = 0
            }
        }
    }
    func updateLongView(sound: CGFloat) {
        let stage = CGFloat( 1 / 15.0)
        let level = Int(sound / stage)
        for i in 0..<self.tipArray.count {
            let img = tipArray[i]
            img.isHidden = i > level
        }
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let orien = UIDevice.current.orientation
        if orientationDidChange {
            UIView.animate(withDuration: 0.25, animations: {
                if orien == .portrait || orien == .faceUp {
                    self.center = CGPoint(x: APPW * 0.5, y: (APPH - 10) * 0.5)
                } else {
                    self.center = CGPoint(x: APPW * 0.5, y: APPH * 0.5)
                }
            }) { (finished) in
                self.orientationDidChange = false
            }
        } else {
            if orien == .portrait {
                self.center = CGPoint(x: APPW * 0.5, y: (APPH - 10) * 0.5)
            } else {
                self.center = CGPoint(x: APPW * 0.5, y: APPH * 0.5)
            }
        }
        backImage.center = CGPoint(x: 155 * 0.5, y: 155 * 0.5)
    }
    deinit {
        UIScreen.main.removeObserver(self, forKeyPath: "brightness")
        NotificationCenter.default.removeObserver(self)
    }
}
/// 滑块 私有类
class ASValueTrackingSlider: UISlider {
    var popUpView = ASValuePopUpView()
    var popUpViewAlwaysOn = false
    var keyTimes: [NSNumber] = []
    var valueRange: Float {return maximumValue - minimumValue}
    var popUpViewAnimatedColors: [UIColor] = []
    var sliderWillDisplayPopUpView: (() -> Void)?
    var sliderDidHidePopUpView: (() -> Void)?
    var tempOffset: CGFloat {return CGFloat((self.value - self.minimumValue) / self.valueRange)}
    override var value: Float {
        didSet {
            popUpView.setAnimationOffset(animOffset: tempOffset) { (color) in
                super.minimumTrackTintColor = color
            }
        }
    }
    var autoAdjustTrackColor = true {
        didSet {
            if (autoAdjustTrackColor != oldValue) {
                super.minimumTrackTintColor = oldValue ? popUpView.opaqueColor: nil
            }
        }
    }
    var popUpViewColor: UIColor? {
        didSet {
            popUpViewAnimatedColors = []
            popUpView.color = self.popUpViewColor
            if (autoAdjustTrackColor) {
                super.minimumTrackTintColor = popUpView.opaqueColor
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        autoAdjustTrackColor = true
        popUpViewAlwaysOn = false
        self.popUpViewColor = UIColor(hue: 0.6, saturation: 0.6, brightness: 0.5, alpha: 0.8)
        self.popUpView.alpha = 0.0
        popUpView.colorDidUpdate = {[weak self] color in
            guard let `self` = self else { return }
            let temp = self.autoAdjustTrackColor
            self.minimumTrackTintColor = color
            self.autoAdjustTrackColor = temp
        }
        popUpView.currentValueOffset = { [weak self] in
            return self?.tempOffset ?? 0
        }
        addSubview(self.popUpView)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setPopUpViewAnimatedColors(colors: [UIColor], withPositions positions: [NSNumber] = []) {
        if (positions.count <= 0) { return }
        popUpViewAnimatedColors = colors
        keyTimes = []
        for num in positions.sorted(by: { (a, b) -> Bool in
        return a.floatValue < b.floatValue
        }) {
        keyTimes.append(NSNumber(value: (num.floatValue - minimumValue) / valueRange))
        }
        if (colors.count >= 2) {
            self.popUpView.setAnimatedColors(animatedColors: colors, withKeyTimes: keyTimes)
        } else {
            self.popUpViewColor = colors.last != nil ? nil : popUpView.color
        }
    }

    @objc func didBecomeActiveNotification(note: NSNotification) {
        if !self.popUpViewAnimatedColors.isEmpty {
            self.popUpView.setAnimatedColors(animatedColors: popUpViewAnimatedColors, withKeyTimes: keyTimes)
        }
    }

    func showPopUpViewAnimated(_ animated: Bool) {
        sliderWillDisplayPopUpView?()
        popUpView.showAnimated(animated: animated)
    }

    func hidePopUpViewAnimated(_ animated: Bool) {
        sliderWillDisplayPopUpView?()
        popUpView.hideAnimated(animated: animated) {
            self.sliderDidHidePopUpView?()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let popUpViewSize = CGSize(width: 100, height: 56 + self.popUpView.arrowLength + 18)
       let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        let thumbW = thumbRect.size.width
        let thumbH = thumbRect.size.height
        var popUpRect = CGRect(x: 0,
                               y: thumbRect.origin.y - popUpViewSize.height,
                               width: (thumbW - popUpViewSize.width)/2,
                               height: (thumbH - popUpViewSize.height)/2)
        let minOffsetX = popUpRect.minX
        let maxOffsetX = popUpRect.maxX - self.bounds.width
        let offset = minOffsetX < 0.0 ? minOffsetX : (maxOffsetX > 0.0 ? maxOffsetX : 0.0)
        popUpRect.origin.x -= offset
        popUpView.setFrame(frame: popUpRect, arrowOffset: offset)
    }

    override func didMoveToWindow() {
        if self.window == nil {
            NotificationCenter.default.removeObserver(self)
        } else {
            if !popUpViewAnimatedColors.isEmpty {
                popUpView.setAnimatedColors(animatedColors: popUpViewAnimatedColors, withKeyTimes: keyTimes)
            }
            NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification(note:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }

    override func setValue(_ value: Float, animated: Bool) {
        if animated {
            func anim() {
                super.setValue(value, animated: animated)
                self.popUpView.setAnimationOffset(animOffset: tempOffset) { (color) in
                    self.minimumTrackTintColor = color
                }
                self.layoutIfNeeded()
            }
            popUpView.animateBlock {(duration) in
                UIView.animate(withDuration: duration) {
                    anim()
                }
            }
        } else {
            super.setValue(value, animated: animated)
        }
    }

    override var minimumTrackTintColor: UIColor? {
        willSet {
            autoAdjustTrackColor = false
        }
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let begin = super.beginTracking(touch, with: event)
        if begin && !self.popUpViewAlwaysOn {
            self.popUpViewAlwaysOn = true
            self.showPopUpViewAnimated(false)
        }
        return begin
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let conti = super.continueTracking(touch, with: event)
        if conti {
            popUpView.setAnimationOffset(animOffset: tempOffset) { (color) in
                super.minimumTrackTintColor = color
            }
        }
        return conti
    }

    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        if !popUpViewAlwaysOn {
            hidePopUpViewAnimated(false)
        }
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if !popUpViewAlwaysOn {
            hidePopUpViewAnimated(false)
        }
    }
}
/// 播放控制类 私有类
class XPlayerControlView: UIView {
    @IBOutlet weak var videoSlider: ASValueTrackingSlider!  // 滑杆
    @IBOutlet weak var titleLabel: UILabel!                 // 标题
    @IBOutlet weak var startBtn: UIButton!                  // 开始播放按钮
    @IBOutlet weak var currentTimeLabel: UILabel!           // 当前播放时长label
    @IBOutlet weak var totalTimeLabel: UILabel!             // 视频总时长label
    @IBOutlet weak var progressView: UIProgressView!        // 缓冲进度条
    @IBOutlet weak var fullScreenBtn: UIButton!             // 全屏按钮
    @IBOutlet weak var lockBtn: UIButton!                   // 锁定屏幕方向按钮
    @IBOutlet weak var horizontalLabel: UILabel!            // 快进快退label
    @IBOutlet weak var activity: UIActivityIndicatorView!   // 系统菊花
    @IBOutlet weak var backBtn: UIButton!                   // 返回按钮
    @IBOutlet weak var repeatBtn: UIButton!                 // 重播按钮
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topImageView: UIImageView!           // 顶部渐变
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomImageView: UIImageView!        // 底部渐变
    @IBOutlet weak var downLoadBtn: UIButton!               // 缓存按钮
    @IBOutlet weak var resolutionBtn: UIButton!             // 切换分辨率按钮
    @IBOutlet weak var playeBtn: UIButton!                  // 播放按钮
    // 切换分辨率的block
    var resolutionBlock: ((UIButton?) -> Void)?
    // slidertap事件Block
    var tapBlock: ((CGFloat) -> Void)?
    // 分辨率的View
    var resolutionView = UIView()
    // 分辨率的名称
    var resolutionArray: [String] = [] {
        didSet {
            resolutionBtn.setTitle(resolutionArray.first, for: .normal)
            resolutionView.isHidden = true
            resolutionView.backgroundColor = UIColor(white: 0.7, alpha: 1)
            addSubview(resolutionView)
            resolutionView.snp.makeConstraints { (make) in
                make.width.equalTo(40)
                make.height.equalTo(CGFloat(resolutionArray.count * 30))
                make.leading.equalTo(resolutionBtn.snp.leading)
                make.top.equalTo(resolutionBtn.snp.bottom)
            }
            for i in 0..<resolutionArray.count {
                let btn = UIButton(type: .custom)
                btn.tag = 200 + i
                resolutionView.addSubview(btn)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.frame = CGRect(x: 0, y: CGFloat(30 * i), width: 40, height: 30)
                btn.setTitle(resolutionArray[i], for: .normal)
                btn.addTarget(self, action: #selector(changeResolution(_:)), for: .touchUpInside)
            }
        }
    }
    class func xibView() -> XPlayerControlView {
        let xib = UINib(nibName: "XPlayerControlView", bundle: nil)
        let controlView = xib.instantiate(withOwner: nil, options: nil).first as! XPlayerControlView
        return controlView
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initial()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func initial() {
        videoSlider.popUpViewColor = .red
        videoSlider.setThumbImage(XPImage.slider.img, for: .normal)
        resolutionBtn.addTarget(self, action: #selector(resolutionAction(_:)), for: .touchUpInside)
        let sliderTap = UITapGestureRecognizer(target: self, action: #selector(tapSliderAction(_:)))
        videoSlider.addGestureRecognizer(sliderTap)
        activity.stopAnimating()
        resetControlView()
    }
    
    // 点击topView上的按钮
    @objc func resolutionAction(_ sender: UIButton?) {
        sender?.isSelected = !(sender?.isSelected ?? false)
        resolutionView.isHidden = !(sender?.isSelected)!
    }

    // 点击切换分别率按钮
    @objc func changeResolution(_ sender: UIButton?) {
        resolutionView.isHidden = true
        resolutionBtn.isSelected = false
        resolutionBtn.setTitle(sender?.titleLabel?.text, for: .normal)
        resolutionBlock?(sender)
    }

    // UISlider TapAction
    @objc func tapSliderAction(_ tap: UITapGestureRecognizer?) {
        if (tap?.view is UISlider) {
            let slider = tap?.view as? UISlider
            let point = tap?.location(in: slider)
            let length = slider?.frame.size.width
            // 视频跳转的value
            let tapValue = (point?.x ?? 0.0) / (length ?? 0.0)
            tapBlock?(tapValue)
        }
    }

    // MARK: - Public Method
    func resetControlView() {
        videoSlider.value = 0
        progressView.progress = 0
        currentTimeLabel.text = "00:00"
        totalTimeLabel.text = "00:00"
        horizontalLabel.isHidden = true
        repeatBtn.isHidden = true
        playeBtn.isHidden = true
        resolutionView.isHidden = true
        backgroundColor = UIColor.clear
        downLoadBtn.isEnabled = true
    }

    func resetControlViewForResolution() {
        horizontalLabel.isHidden = true
        repeatBtn.isHidden = true
        resolutionView.isHidden = true
        playeBtn.isHidden = true
        downLoadBtn.isEnabled = true
        backgroundColor = UIColor.clear
    }

    func showControlView() {
        topView.alpha = 1
        bottomView.alpha = 1
        lockBtn.alpha = 1
    }

    func hideControlView() {
        topView.alpha = 0
        bottomView.alpha = 0
        lockBtn.alpha = 0
        resolutionBtn.isSelected = true
        resolutionAction(resolutionBtn)
    }
}

class XPlayer: UIView {
    static let shared = XPlayer()
    let nessView = XBrightnessView.shared
    // 视频URL
    var videoURL: URL? {
        didSet {
            if (self.placeholderImageName.isEmpty) {
                let image = XPImage.loading.img
                self.layer.contents = image?.cgImage
            }
            self.repeatToPlay = false
            self.playDidEnd   = false
            self.addNotifications()
            self.onDeviceOrientationChange()
            self.isPauseByUser = true
            self.controlView.playeBtn.isHidden = false
            self.controlView.hideControlView()
        }
    }
    // 视频标题
    var title = "" {didSet {self.controlView.titleLabel.text = title}}
    // 视频URL的数组
    var videoURLArray: [String] = []
    // 返回按钮Block
    var goBackBlock: (() -> Void)?
    var downloadBlock: ((String?) -> Void)?
    // 从xx秒开始播放视频跳转
    var seekTime = 0
    // 是否自动播放
    var isAutoPlay = false { didSet {if isAutoPlay {self.configZFPlayer()}}}
    // 是否有下载功能(默认是关闭)
    var hasDownload = false {didSet {self.controlView.downLoadBtn.isHidden = !hasDownload}}
    // 是否被用户暂停
    private(set) var isPauseByUser = false
    // 播放属性
    private var player: AVPlayer?
    private lazy var urlAsset = AVURLAsset(url: videoURL!)
    private lazy var imageGenerator = AVAssetImageGenerator(asset: self.urlAsset)
    // playerLayer
    private var playerLayer: AVPlayerLayer?
    private var timeObserve: Any?
    // 用来保存快进的总时长
    private var sumTime: CGFloat = 0.0
    // 定义一个实例变量，保存枚举值
    private var panDirection: PanDirection = .horizontal
    // 是否为全屏
    private var isFullScreen = false
    // 是否锁定屏幕方向
    private var isLocked = false
    // 是否在调节音量
    private var isVolume = false
    // 是否显示controlView
    private var isMaskShowing = false
    // 是否播放本地文件
    private var isLocalVideo = false
    // slider上次的值
    private var sliderLastValue: Float = 0.0
    // 是否再次设置URL播放视频
    private var repeatToPlay = false
    // 播放完了
    private var playDidEnd = false
    // 进入后台
    private var didEnterBackground = false
    private var tap: UITapGestureRecognizer?
    private var doubleTap: UITapGestureRecognizer?
    // player所在cell的indexPath
    private var indexPath = IndexPath(row: 0, section: 0)
    // cell上imageView的tag
    private var cellImageViewTag = 0
    // ViewController中页面是否消失
    private var viewDisappear = false
    // 是否在cell上播放video
    private var isCellVideo = false
    // 是否缩小视频在底部
    private var isBottomVideo = false
    // 是否切换分辨率
    private var isChangeResolution = false
    // 播发器的几种状态
    private var state: XPlayerState = .failed {
        didSet {
            if (state == .playing) {
                self.layer.contents = XPImage.management.img?.cgImage
            } else if (state == .failed) {
                self.controlView.downLoadBtn.isEnabled = false
            }
            // 控制菊花显示、隐藏
            if state == .buffering {
                controlView.activity.startAnimating()
            } else {
                controlView.activity.stopAnimating()
            }
        }
    }
    // 播放前占位图片的名称，不设置就显示默认占位图（需要在设置视频URL之前设置）
    var placeholderImageName = "" {
        didSet {
            let image = UIImage(named:placeholderImageName) ?? XPImage.loading.img
            self.layer.contents = image?.cgImage
        }
    }
    // 设置playerLayer的填充模式
    var playerLayerGravity: XPlayerFillMode = .aspectFill {
        didSet {
            switch (playerLayerGravity) {
            case .resize: self.playerLayer?.videoGravity = .resizeAspect
            case .aspect: self.playerLayer?.videoGravity = .resizeAspect
            case .aspectFill: self.playerLayer?.videoGravity = .resizeAspectFill
            }
        }
    }
    // 切换分辨率传的字典(key:分辨率名称，value：分辨率url)
    var resolutionDic: [String : String] = [:] {
        didSet {
            self.controlView.resolutionBtn.isHidden = false
            self.videoURLArray = []
            self.controlView.resolutionArray = []
            resolutionDic.forEach {[weak self] (key,value) in
                self?.videoURLArray.append(value)
                self?.controlView.resolutionArray.append(key)
            }
        }
    }
    private var playerItem: AVPlayerItem? {
        didSet {
            if (oldValue == playerItem) {return}
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: oldValue)
            oldValue?.removeObserver(self, forKeyPath: "status")
            oldValue?.removeObserver(self, forKeyPath: "loadedTimeRanges")
            oldValue?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            oldValue?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            NotificationCenter.default.addObserver(self, selector: #selector(moviePlayDidEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            // 缓冲区空了，需要等待数据
            playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            // 缓冲区有足够数据可以播放了
            playerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }

    // 滑杆
    private var volumeViewSlider: UISlider?
    // 控制层View
    private var controlView = XPlayerControlView.xibView()
    // palyer加到tableView
    private var tableView: UITableView? {
        didSet {
            if oldValue == self.tableView { return }
            oldValue?.removeObserver(self, forKeyPath: kOffset)
            self.tableView?.addObserver(self, forKeyPath: kOffset, options: NSKeyValueObservingOptions.new, context: nil)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeThePlayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeThePlayer()
    }
    func initializeThePlayer() {
        unLockTheScreen()
        self.addSubview(controlView)
        controlView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        controlView.layoutSubviews()
    }
    deinit {
        self.playerItem = nil
        self.tableView = nil
        NotificationCenter.default.removeObserver(self)
        if let time = self.timeObserve {
            player?.removeTimeObserver(time)
            self.timeObserve = nil
        }
    }

    // 重置player
    public func resetPlayer() {
        self.playDidEnd         = false
        self.playerItem         = nil
        self.didEnterBackground = false
        self.seekTime           = 0
        self.isAutoPlay         = false
        player?.removeTimeObserver(timeObserve!)
        self.timeObserve = nil
        NotificationCenter.default.removeObserver(self)
        pause()
        playerLayer?.removeFromSuperlayer()
//        self.imageGenerator = nil
        self.player?.replaceCurrentItem(with: nil)
        self.player = nil
        if (self.isChangeResolution) {
            self.controlView.resetControlViewForResolution()
            self.isChangeResolution = false
        }else {
            self.controlView.resetControlView()
        }
        if (!self.repeatToPlay) { removeFromSuperview() }
        self.isBottomVideo = false
        if (self.isCellVideo && !self.repeatToPlay) {
            self.viewDisappear = true
            self.isCellVideo   = false
            self.tableView     = nil
            self.indexPath     = IndexPath(row: 0, section: 0)
        }
    }
    // 在当前页面，设置新的Player的URL调用此方法
    public func resetToPlayNewURL() {
        self.repeatToPlay = true
        self.resetPlayer()
    }
    // 添加观察者、通知
    func addNotifications() {
        let not = NotificationCenter.default
        // app退到后台
        not.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        // app进入前台
        not.addObserver(self, selector: #selector(appDidEnterPlayGround), name: UIApplication.didBecomeActiveNotification, object: nil)
        // slider开始滑动事件
        controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchBegan), for: .touchDown)
        // slider滑动中事件
        controlView.videoSlider.addTarget(self, action: #selector(progressSliderValueChanged), for: .valueChanged)
        // slider结束滑动事件
        controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), for: .touchUpInside)
        controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), for: .touchCancel)
        controlView.videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded), for: .touchUpOutside)
        // 播放按钮点击事件
        controlView.startBtn.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        // cell上播放视频的话，该返回按钮为×
        if (self.isCellVideo) {
            controlView.backBtn.setImage(XPImage.close.img, for: .normal)
        }else {
            controlView.backBtn.setImage(XPImage.back.img, for: .normal)
        }
        // 返回按钮点击事件
        controlView.backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        // 全屏按钮点击事件
        controlView.fullScreenBtn.addTarget(self, action: #selector(fullScreenAction), for: .touchUpInside)
        // 锁定屏幕方向点击事件
        controlView.lockBtn.addTarget(self, action: #selector(lockScreenAction), for: .touchUpInside)
        // 重播
        controlView.repeatBtn.addTarget(self, action: #selector(repeatPlay), for: .touchUpInside)
        // 中间按钮播放
        controlView.playeBtn.addTarget(self, action: #selector(configZFPlayer), for: .touchUpInside)
        controlView.downLoadBtn.addTarget(self, action: #selector(downloadVideo), for: .touchUpInside)
        controlView.resolutionBlock = {btn in
            let currentTime = CMTimeGetSeconds(self.player!.currentTime())
            let videoStr = self.videoURLArray[(btn?.tag ?? 0)-200]
            let videoURL = URL(string: videoStr)
            if videoStr == self.videoURL?.absoluteString { return }
            self.isChangeResolution = true
            self.resetToPlayNewURL()
            self.videoURL = videoURL
            self.seekTime = Int(currentTime)
            self.isAutoPlay = true
        }
        controlView.tapBlock = { value in
            self.pause()
            let duration = self.playerItem!.duration
            let total = Int32(duration.value) / duration.timescale
            let dragedSeconds = floorf(Float(CGFloat(total) * value))
            self.controlView.startBtn.isSelected = true
            self.seekToTime(Int(dragedSeconds))
        }
        // 监测设备方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    //pragma mark - layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
        UIApplication.shared.isStatusBarHidden = false
        self.isMaskShowing = false
        self.animateShow()
        self.layoutIfNeeded()
    }
    //pragma mark - 设置视频URL
    // 用于cell上播放player
    public func setVideoURL(videoURL: URL, tableView: UITableView, indexPath: IndexPath, tag: Int) {
        if (!self.viewDisappear && (self.playerItem != nil)) { self.resetPlayer() }
        self.isCellVideo      = true
        self.viewDisappear    = false
        self.cellImageViewTag = tag
        self.tableView        = tableView
        self.indexPath        = indexPath
        self.videoURL = videoURL
    }

    // 设置Player相关参数
    @objc func configZFPlayer() {
        self.playerItem = AVPlayerItem(asset: urlAsset)
        self.player = AVPlayer(playerItem: playerItem)
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        self.layer.insertSublayer(playerLayer!, at: 0)
        self.isMaskShowing = true
        self.autoFadeOutControlBar()
        self.createGesture()
        self.createTimer()
        self.configureVolume()
        if self.videoURL?.scheme == "file" {
            self.state = .playing
            self.isLocalVideo = true
            self.controlView.downLoadBtn.isEnabled = false
        } else {
            self.state = .buffering
            self.isLocalVideo = false
        }
        self.play()
        self.controlView.startBtn.isSelected = true
        self.isPauseByUser                 = false
        self.controlView.playeBtn.isHidden   = true
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    // 创建手势
    func createGesture() {
        self.tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.tap?.delegate = self
        self.addGestureRecognizer(self.tap!)
        self.doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        self.doubleTap?.numberOfTapsRequired = 2
        self.addGestureRecognizer(self.doubleTap!)
        self.tap?.delaysTouchesBegan = true
        self.tap?.require(toFail: self.doubleTap!)
    }
    func createTimer() {
        self.timeObserve = self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: nil, using: { (time) in
            let currentItem = self.playerItem
            if let item = currentItem, item.seekableTimeRanges.count > 0,  item.duration.timescale != 0 {
                let currentTime = Int(CMTimeGetSeconds(item.currentTime()))
                let proMin = currentTime / 60
                let proSec = currentTime % 60
                let totalTime = Int(item.duration.value) / Int(item.duration.timescale)
                let durMin = totalTime / 60
                let durSec = totalTime % 60
                self.controlView.videoSlider.value = Float(currentTime) / Float(totalTime)
                self.controlView.currentTimeLabel.text = String(format: "%02zd:%02zd", proMin, proSec)
                self.controlView.totalTimeLabel.text  = String(format:"%02zd:%02zd", durMin, durSec)
            }
        })
    }
    // 获取系统音量
    func configureVolume() {
        let volumeView = MPVolumeView()
        volumeViewSlider = nil
        for view in volumeView.subviews {
            if view.description == "MPVolumeSlider"{
                volumeViewSlider = view as? UISlider
                break
            }
        }
        // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
        let se = AVAudioSession.sharedInstance()
        try? se.setCategory(.playback)
        // 监听耳机插入和拔掉通知
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListenerCallback(notification:)), name: NSNotification.Name(rawValue: AVAudioSessionRouteChangeReasonKey), object: nil)
    }
    // 耳机插入、拔出事件
    @objc func audioRouteChangeListenerCallback(notification: NSNotification) {
        let interuptionDict = notification.userInfo
        let routeChangeReason = interuptionDict?[AVAudioSessionRouteChangeReasonKey] as! AVAudioSession.RouteChangeReason
        switch (routeChangeReason) {
        case .newDeviceAvailable: break
        case .oldDeviceUnavailable: self.play()
        case .categoryChange:
            print("AVAudioSessionRouteChangeReasonCategoryChange")
        default: break
        }
    }
    //pragma mark - ShowOrHideControlView
    func autoFadeOutControlBar() {
        if (!self.isMaskShowing) { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideControlView), object: nil)
        self.perform(#selector(hideControlView), with: nil, afterDelay: TimeInterval(7))
    }
    // 取消延时隐藏controlView的方法
    public func cancelAutoFadeOutControlBar() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    // 隐藏控制层
    @objc func hideControlView() {
        if (!self.isMaskShowing) { return }
        UIView.animate(withDuration: TimeInterval(0.35), animations: {
            self.controlView.hideControlView()
            if (self.isFullScreen) {
            self.controlView.backBtn.alpha = 0
            UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
            }else if (self.isBottomVideo && !self.isFullScreen) {
            self.controlView.backBtn.alpha = 1
            }else {
            self.controlView.backBtn.alpha = 0
            }
        }) { finished in
            self.isMaskShowing = false
        }
    }
    // 显示控制层
    func animateShow() {
        if (self.isMaskShowing) { return }
        UIView.animate(withDuration: TimeInterval(0.35), animations: {
            self.controlView.backBtn.alpha = 1
            if (self.isBottomVideo && !self.isFullScreen) { self.controlView.hideControlView()
            }else if (self.playDidEnd) {
                self.controlView.hideControlView()
            }else {
                self.controlView.showControlView()
            }
            UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
        }) { (finished) in
            self.isMaskShowing = true
            self.autoFadeOutControlBar()
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if object as? AVPlayerItem == player?.currentItem {
                if keyPath == "status" {
                    if player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
                    self.state = .playing
                    let pan = UIPanGestureRecognizer(target: self, action: #selector(panDirection(_:)))
                    pan.delegate = self
                    self.addGestureRecognizer(pan)
                    self.seekToTime(seekTime)
                    } else if player?.currentItem?.status == AVPlayerItem.Status.failed {
                    self.state = .failed
                    self.controlView.horizontalLabel.isHidden = false
                    self.controlView.horizontalLabel.text = "视频加载失败"
                }
            } else if keyPath == "loadedTimeRanges" {
                let totalDuration = CMTimeGetSeconds(self.playerItem!.duration)
                    let progres = self.availableDuration() / totalDuration
                    let progressView = controlView.progressView
                    progressView?.setProgress(Float(progres), animated: false)
                    let tiaojian = ((progressView?.progress ?? 0) - controlView.videoSlider.value > 0.05)
                if !self.isPauseByUser && !self.didEnterBackground && tiaojian {
                    self.play()
                }
            } else if keyPath == "playbackBufferEmpty" {
                    if (self.playerItem?.isPlaybackBufferEmpty ?? false) {
                    self.state = .buffering
                    self.bufferingSomeSecond()
                }
            } else if keyPath == "playbackLikelyToKeepUp" {
                    if (self.playerItem?.isPlaybackLikelyToKeepUp ?? false) && self.state == .buffering {
                    self.state = .playing
                }
            }
        }else if (object as? UITableView == self.tableView) {
            if keyPath == kOffset {
                let orien = UIDevice.current.orientation
                if orien == .landscapeLeft || orien == .landscapeRight {
                    return
                }
                // 当tableview滚动时处理playerView的位置
                self.handleScrollOffsetWithDict(change ?? [:])
            }
        }
    }
    // KVO TableViewContentOffset
    func handleScrollOffsetWithDict(_ dict: [NSKeyValueChangeKey : Any]) {
        let cell = self.tableView?.cellForRow(at: indexPath)
        let visableCells = self.tableView?.visibleCells
        if visableCells?.contains(cell!) ?? false {
            self.updatePlayerViewToCell()
        }else {
            self.updatePlayerViewToBottom()
        }
    }
    // 缩小到底部，显示小视频
    func updatePlayerViewToBottom() {
        if (self.isBottomVideo) { return  }
        self.isBottomVideo = true
        if (self.playDidEnd) { //如果播放完了，滑动到小屏bottom位置时，直接resetPlayer
            self.repeatToPlay = false
            self.playDidEnd   = false
            self.resetPlayer()
            return
        }
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.width.equalTo(APPW * 0.5 - 20)
            make.rightMargin.equalTo(10)
            make.bottom.equalTo(tableView?.snp.bottom ?? self.snp.bottom).offset(-10)
            make.height.equalTo(self.snp.width).multipliedBy(9.0 / 16)
        }
        // 不显示控制层
        controlView.hideControlView()
    }
    // 回到cell显示
    func updatePlayerViewToCell() {
        if (!self.isBottomVideo) { return }
        self.isBottomVideo     = false
        self.controlView.alpha = 1
        self.setOrientationPortrait()
        controlView.showControlView()
    }
    // 设置横屏的约束
    func setOrientationLandscape() {
        if (self.isCellVideo) {
            tableView?.removeObserver(self, forKeyPath: kOffset)
            UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
            UIApplication.shared.keyWindow?.insertSubview(self, belowSubview: XBrightnessView.shared)
            self.snp.remakeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
    // 设置竖屏的约束
    func setOrientationPortrait() {
        if (self.isCellVideo) {
            UIApplication.shared.setStatusBarStyle(.default, animated: true)
            self.removeFromSuperview()
            let cell = self.tableView?.cellForRow(at: indexPath)
            let visableCells = self.tableView?.visibleCells
            self.isBottomVideo = false
            if !(visableCells?.contains(cell!) ?? false) {
                self.updatePlayerViewToBottom()
            }else {
                let cellImageView = cell?.viewWithTag(self.cellImageViewTag)
                self.addPlayerToCellImageView(cellImageView as! UIImageView)
            }
        }
    }
    // pragma mark 屏幕转屏相关
    // 强制屏幕转屏
    func interfaceOrientation(_ orientation: UIInterfaceOrientation) {
        if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
            self.setOrientationLandscape()
        }else if (orientation == UIInterfaceOrientation.portrait) {
            self.setOrientationPortrait()
        }
        // 直接调用这个方法通不过apple上架审核
        // UIDevice.current.orientation = UIDeviceOrientation.landscapeRight
    }
    // 全屏按钮事件
    @objc func fullScreenAction(_ sender: UIButton?) {
        if (self.isLocked) {
            self.unLockTheScreen()
            return
        }
        if (self.isCellVideo && sender?.isSelected == true) {
            self.interfaceOrientation(.portrait)
            return
        }
        let orientation = UIDevice.current.orientation
        let interfaceOrientation = UIInterfaceOrientation(rawValue: orientation.rawValue) ?? .portrait
        switch (interfaceOrientation) {
        case .portraitUpsideDown:
            nessView.isAllowLandscape = false
            self.interfaceOrientation(.portrait)
        case .portrait:
            nessView.isAllowLandscape = true
            self.interfaceOrientation(.landscapeRight)
        case .landscapeLeft:
            if (self.isBottomVideo || !self.isFullScreen) {
                    nessView.isAllowLandscape = true
                    self.interfaceOrientation(.landscapeRight)
            } else {
                nessView.isAllowLandscape = false
                    self.interfaceOrientation(.portrait)
            }
        case .landscapeRight:
            if (self.isBottomVideo || !self.isFullScreen) {
                nessView.isAllowLandscape = true
                self.interfaceOrientation(.landscapeRight)
            } else {
                nessView.isAllowLandscape = false
                self.interfaceOrientation(.portrait)
            }
        default:
            if (self.isBottomVideo || !self.isFullScreen) {
                nessView.isAllowLandscape = true
                self.interfaceOrientation(.landscapeRight)
            } else {
                nessView.isAllowLandscape = false
                self.interfaceOrientation(.portrait)
            }
        }
    }
    // 屏幕方向发生变化会调用这里
    @objc func onDeviceOrientationChange() {
        if (self.isLocked) {
            self.isFullScreen = true
            return
        }
        let orientation = UIDevice.current.orientation
        let interfaceOrientation = UIInterfaceOrientation(rawValue:orientation.rawValue) ?? .portrait
        switch (interfaceOrientation) {
        case .portraitUpsideDown:
            self.controlView.fullScreenBtn.isSelected = true
            if (self.isCellVideo) {
                controlView.backBtn.setImage(XPImage.back.img, for: .normal)
            }
            self.isFullScreen = true
        case .portrait:
            self.isFullScreen = !self.isFullScreen
            self.controlView.fullScreenBtn.isSelected = false
            if (self.isCellVideo) {
                // 改为只允许竖屏播放
                nessView.isAllowLandscape = false
                controlView.backBtn.setImage(XPImage.close.img, for: .normal)
                // 点击播放URL时候不会调用次方法
                if (!self.isFullScreen) {
                    // 竖屏时候table滑动到可视范围
                    tableView?.scrollToRow(at: indexPath, at: .middle, animated: false)
                    // 重新监听tableview偏移量
                    tableView?.addObserver(self, forKeyPath: kOffset, options: .new, context: nil)
                }
                // 当设备转到竖屏时候，设置为竖屏约束
                self.setOrientationPortrait()
            }else {
            }
            self.isFullScreen = false
        case .landscapeLeft:
            self.controlView.fullScreenBtn.isSelected = true
            if (self.isCellVideo) {
                controlView.backBtn.setImage(XPImage.back.img, for: .normal)
            }
            self.isFullScreen = true
        case .landscapeRight:
            self.controlView.fullScreenBtn.isSelected = true
            if (self.isCellVideo) {
                controlView.backBtn.setImage(XPImage.back.img, for: .normal)
            }
            self.isFullScreen = true
            default:break
        }
        // 设置显示or不显示锁定屏幕方向按钮
        self.controlView.lockBtn.isHidden = !self.isFullScreen
        // 在cell上播放视频 && 不允许横屏（此时为竖屏状态,解决自动转屏到横屏，状态栏消失bug）
        if (self.isCellVideo && !nessView.isAllowLandscape) {
            controlView.backBtn.setImage(XPImage.close.img, for: .normal)
            self.controlView.fullScreenBtn.isSelected = false
            self.controlView.lockBtn.isHidden = true
            self.isFullScreen = false
        }
    }
    // 锁定屏幕方向按钮
    @objc func lockScreenAction(_ sender: UIButton) {
            sender.isSelected = !sender.isSelected
        self.isLocked = sender.isSelected
        nessView.isLockScreen = sender.isSelected
    }
    // 解锁屏幕方向锁定
    func unLockTheScreen() {
        // 调用AppDelegate单例记录播放状态是否锁屏
        nessView.isLockScreen       = false
        self.controlView.lockBtn.isSelected = false
        self.isLocked = false
        self.interfaceOrientation(.portrait)
    }
    // player添加到cellImageView上
    public func addPlayerToCellImageView(_ imageView: UIImageView) {
            imageView.addSubview(self)
        self.snp.remakeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    // pragma mark - 缓冲较差时候
    // 缓冲较差时候回调这里
    func bufferingSomeSecond() {
        self.state = .buffering
        var isBuffering = false
        if (isBuffering) { return }
        isBuffering = true
        self.player?.pause()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            if (self.isPauseByUser) {
               isBuffering = false
               return
            }
            self.play()
            isBuffering = false
            if !(self.playerItem?.isPlaybackLikelyToKeepUp ?? false) {
                self.bufferingSomeSecond()
            }
        }
    }
    // 计算缓冲进度
    func availableDuration() -> TimeInterval {
        let loadedTimeRanges = player?.currentItem?.loadedTimeRanges
        let timeRange = loadedTimeRanges?.first?.timeRangeValue
            let startSeconds = CMTimeGetSeconds(timeRange!.start)
            let durationSeconds = CMTimeGetSeconds(timeRange!.duration)
        let result = startSeconds + durationSeconds// 计算缓冲总进度
        return result
    }
    //  轻拍方法
    @objc func tapAction(_ gesture: UITapGestureRecognizer) {
        if (gesture.state == .recognized) {
            if (self.isBottomVideo && !self.isFullScreen) {
                self.fullScreenAction(self.controlView.fullScreenBtn)
                return
            }
            if isMaskShowing {
                self.hideControlView()
            } else {
                self.animateShow()
            }
        }
    }
    // 双击播放/暂停
    @objc func doubleTapAction(_ gesture: UITapGestureRecognizer) {
        self.animateShow()
        self.startAction(self.controlView.startBtn)
    }
    // 播放、暂停按钮事件
    @objc func startAction(_ button: UIButton?) {
        button?.isSelected = !(button?.isSelected ?? false)
        self.isPauseByUser = !self.isPauseByUser
        if button?.isSelected ?? false {
            self.play()
            if (self.state == .pause) {
                self.state = .playing
            }
        } else {
            self.pause()
            if (self.state == .playing) {
                self.state = .pause
            }
        }
    }
    // 播放
    public func play() {
        self.controlView.startBtn.isSelected = true
        self.isPauseByUser = false
        player?.play()
    }
    // 暂停
    public func pause() {
        self.controlView.startBtn.isSelected = false
        self.isPauseByUser = true
        player?.pause()
    }
    // 返回按钮事件
    @objc func backButtonAction() {
        if (self.isLocked) {
            self.unLockTheScreen()
            return
        }else {
            if (!self.isFullScreen) {
                if (self.isCellVideo) {
                    self.resetPlayer()
                    self.removeFromSuperview()
                    return
                }
                self.pause()
                self.goBackBlock?()
            }else {
                self.interfaceOrientation(.portrait)
            }
        }
    }
    // 重播点击事件
    @objc func repeatPlay(_ sender: UIButton) {
        self.playDidEnd    = false
        self.repeatToPlay  = false
        self.isMaskShowing = false
        self.animateShow()
        self.controlView.resetControlView()
        self.seekToTime(0)
    }
    @objc func downloadVideo(_ sender: UIButton) {
        let urlStr = self.videoURL?.absoluteString
        self.downloadBlock?(urlStr)
    }
    // pragma mark - NSNotification Action
    // 播放完了
    @objc func moviePlayDidEnd(notification: NSNotification) {
        self.state = .stopped
        if (self.isBottomVideo && !self.isFullScreen) {
            self.repeatToPlay = false
            self.playDidEnd   = false
            self.resetPlayer()
        } else {
            self.controlView.backgroundColor  = UIColor(white: 0.6, alpha: 1)
            self.playDidEnd = true
            self.controlView.repeatBtn.isHidden = false
            self.isMaskShowing = false
            self.animateShow()
        }
    }
    // 应用退到后台
    @objc func appDidEnterBackground() {
        self.didEnterBackground = true
        player?.pause()
        self.state = .pause
        self.cancelAutoFadeOutControlBar()
        self.controlView.startBtn.isSelected = false
    }
    // 应用进入前台
    @objc func appDidEnterPlayGround() {
        self.didEnterBackground = false
        self.isMaskShowing = false
        self.animateShow()
        if (!self.isPauseByUser) {
            self.state = .playing
            self.controlView.startBtn.isSelected = true
            self.isPauseByUser = false
            self.play()
        }
    }
    // pragma mark - slider事件
    // slider开始滑动事件
    @objc func progressSliderTouchBegan(slider: ASValueTrackingSlider) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    // slider滑动中事件
    @objc func progressSliderValueChanged(_ slider: ASValueTrackingSlider) {
        if (self.player?.currentItem?.status == .readyToPlay) {
            let value = slider.value - self.sliderLastValue
            if (value == 0) { return }
            self.sliderLastValue = slider.value
            self.pause()
                let total = Float(Int32(playerItem!.duration.value) / (playerItem!.duration.timescale))
                let dragedSeconds = floorf(total * slider.value)
                let dragedCMTime = CMTimeMake(value: Int64(dragedSeconds), timescale: 1)
            let proMin = Int(CMTimeGetSeconds(dragedCMTime)) / 60
            let proSec = Int(CMTimeGetSeconds(dragedCMTime)) % 60
            let durMin = Int(total) / 60//总秒
            let durSec = Int(total) % 60//总分钟
            let currentTime = String(format:"%02zd:%02zd", proMin, proSec)
            let totalTime = String(format:"%02zd:%02zd", durMin, durSec)
            if (total > 0) {
                self.controlView.videoSlider.popUpView.isHidden = !self.isFullScreen
                self.controlView.currentTimeLabel.text  = currentTime
                if (self.isFullScreen) {
                    self.controlView.videoSlider.popUpView.timeLabel.text = currentTime
                    let queue = DispatchQueue(label: "com.playerPic.queue")
                    queue.async {
                        let cgImage = try? self.imageGenerator.copyCGImage(at: dragedCMTime, actualTime: nil)
                        var image = XPImage.loading.img
                        if let cg = cgImage {
                            image = UIImage(cgImage: cg)
                        }
                        DispatchQueue.main.async {
                            self.controlView.videoSlider.setThumbImage(image, for: .normal)
                        }
                    }
                } else {
                    self.controlView.horizontalLabel.isHidden = false
                    self.controlView.horizontalLabel.text = "\(currentTime) / \(totalTime)"
                }
            }else {
                slider.value = 0
            }
        }else {
            slider.value = 0
        }
    }
    // slider结束滑动事件
    @objc func progressSliderTouchEnded(_ slider: ASValueTrackingSlider) {
        if (self.player?.currentItem?.status == .readyToPlay) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.controlView.horizontalLabel.isHidden = true
            }
            self.controlView.startBtn.isSelected = true
            self.isPauseByUser = false
            self.autoFadeOutControlBar()
            let total = CGFloat(Int32(playerItem!.duration.value) / playerItem!.duration.timescale)
            let dragedSeconds = floorf(Float(total) * slider.value)
            self.seekToTime(Int(dragedSeconds))
        }
    }
    // 从xx秒开始播放视频跳转
    func seekToTime(_ dragedSeconds: NSInteger, completionHandler:((Bool) -> Void)? = nil) {
        if (self.player?.currentItem?.status == .readyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
            let dragedCMTime = CMTimeMake(value: Int64(dragedSeconds), timescale: 1)
            player?.seek(to: dragedCMTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (finished) in
          // 视频跳转回调
             completionHandler?(finished)
            self.play()
            self.seekTime = 0
                if (!(self.playerItem?.isPlaybackLikelyToKeepUp ?? false) && !self.isLocalVideo) { self.state = .buffering
                }
            })
        }
    }
    // pragma mark - UIPanGestureRecognizer手势方法
    // pan手势事件
    @objc func panDirection(_ pan: UIPanGestureRecognizer) {
        let locationPoint = pan.location(in: self)
        let veloctyPoint = pan.velocity(in: self)
        switch (pan.state) {
        case .began:
            let x = abs(veloctyPoint.x)
            let y = abs(veloctyPoint.y)
            if (x > y) {
                self.controlView.horizontalLabel.isHidden = false
                self.panDirection = .horizontal
                let time = self.player!.currentTime()
                self.sumTime = CGFloat(time.value)/CGFloat(time.timescale)
                self.pause()
            } else if (x < y){
                self.panDirection = .vertical
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = true
                }else {
                    self.isVolume = false
                }
            }
        case .changed:
            switch (self.panDirection) {
            case .horizontal:
                self.controlView.horizontalLabel.isHidden = false
                self.horizontalMoved(veloctyPoint.x)
            case .vertical: self.verticalMoved(veloctyPoint.y)
            }
        case .ended:
            switch (self.panDirection) {
            case .horizontal:
                self.play()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.controlView.horizontalLabel.isHidden = true
                }
                self.controlView.startBtn.isSelected = true
                self.isPauseByUser = false
                self.seekToTime(NSInteger(self.sumTime))
                self.sumTime = 0
            case .vertical:
                self.isVolume = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.controlView.horizontalLabel.isHidden = true
                }
            }
        default: break
        }
    }
    // pan垂直移动的方法
    func verticalMoved(_ value: CGFloat) {
        if self.isVolume {
            let v = volumeViewSlider?.value ?? 0
            self.volumeViewSlider?.value = v - Float(value) / 10000
        } else {
            UIScreen.main.brightness -= value / 10000
        }
    }
    // pan水平移动的方法
    func horizontalMoved(_ value: CGFloat) {
        if (value == 0) { return }
        self.sumTime += value / 200
        let totalTime = self.playerItem!.duration
        let totalMovieDuration = CGFloat(Int32(totalTime.value)/totalTime.timescale)
        if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration}
        if (self.sumTime < 0) { self.sumTime = 0 }
        let nowTime = self.durationStringWithTime(Int(self.sumTime))
        let durationTime = self.durationStringWithTime(Int(totalMovieDuration))
        self.controlView.horizontalLabel.text  = "\(nowTime) / \(durationTime)"
        self.controlView.videoSlider.value = Float(self.sumTime/totalMovieDuration)
        self.controlView.currentTimeLabel.text = nowTime
    }
    // 根据时长求出字符串
    func durationStringWithTime(_ time: Int) -> String {
        // 获取分钟
        let min = String(format: "%02d",time / 60)
        // 获取秒数
        let sec = String(format: "%02d",time % 60)
        return "\(min):\(sec)"
    }
}

extension XPlayer: UIGestureRecognizerDelegate, UIAlertViewDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let point = touch.location(in: self.controlView)
        // （屏幕下方slider区域） || （在cell上播放视频 && 不是全屏状态） || (播放完了) =====>  不响应pan手势
        if ((point.y > self.bounds.size.height-40) || (self.isCellVideo && !self.isFullScreen) || self.playDidEnd) { return false }
            return true
        }
        // 在cell上播放视频 && 不是全屏状态 && 点在控制层上
        if (self.isBottomVideo && !self.isFullScreen && touch.view == self.controlView) {
            self.fullScreenAction(self.controlView.fullScreenBtn)
            return false
        }
        if (self.isBottomVideo && !self.isFullScreen && touch.view == self.controlView.backBtn) {
            // 关闭player
            self.resetPlayer()
            self.removeFromSuperview()
            return false
        }
        return true
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex:NSInteger) {
        if (alertView.tag == 1000 ) {
            if (buttonIndex == 0) { self.backButtonAction()} // 点击取消，直接调用返回函数
            if (buttonIndex == 1) { self.configZFPlayer()}   // 点击确定，设置player相关参数
        }
    }
}
