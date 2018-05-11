
import UIKit
public typealias BaseTableLoadedDataBlock = ([Any]?, Bool) -> Swift.Void
@objcMembers
open class BaseTableView : UITableView {
    open var dataArray = NSMutableArray()
    open var urlString = ""
    var curPage = 0
    //MARK: 初始化
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    deinit {
    }
}


