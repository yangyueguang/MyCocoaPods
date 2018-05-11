
import UIKit
@objcMembers
open class BaseCollectionViewCell : UICollectionViewCell {
    open var icon: UIImageView!
    open var line: UIView!
    open var title: UILabel!
    open var script: UILabel!
    class func getColloctionCellIdentifier() -> String {
        return "\(NSStringFromClass(self))Identifier"
    }
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        loadBaseTableCellSubviews()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadBaseTableCellSubviews()
    }
    func loadBaseTableCellSubviews() {
        initUI()
        loadSubViews()
    }
    func loadSubViews() {
            for obj: Any in subviews {
                if ("UITableViewCellScrollView" == NSStringFromClass(obj as! AnyClass)) {
//                UITableViewCell—>UITableViewCellScrollView—>UITableCellContentView   cell.contentView.superview 获得。
                    let scrollView = obj as? UIScrollView
                    scrollView?.delaysContentTouches = false
                    scrollView?.isExclusiveTouch = true
                    break
                }
            }
            isUserInteractionEnabled = true
            contentView.isUserInteractionEnabled = true
    }
    //MARK: 以下子类重写
    open func initUI() {
        backgroundColor = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
        icon = UIImageView()
        icon.contentMode = .scaleToFill
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15)
        title.numberOfLines = 0
        script = UILabel()
        script.font = UIFont.systemFont(ofSize: 13)
        title.textColor = UIColor(red: 33, green: 34, blue: 35, alpha: 1)
        script.textColor = title.textColor
        line = UIView()
        print("请子类重写这个方法")
    }
    override open func prepareForReuse() {
        super.prepareForReuse()
    }
    deinit {
    }
}


