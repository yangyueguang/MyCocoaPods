
import UIKit
class BaseViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @objc open var userInfo: Any!
    open var otherInfo: Any!
    open var tableView: BaseTableView!
    open var collectionView: BaseCollectionView!
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white ,NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func push(_ controller: BaseViewController=BaseViewController(), withInfo info: Any="", withTitle title: String, withOther other: Any="", tabBarHid abool: Bool=true) -> BaseViewController {
        print("跳转到 \(title) 页面Base UserInfo:\(info)Base OtherInfo:\(String(describing: other))")
        if controller.responds(to: #selector(setter: userInfo)) {
            controller.userInfo = info
            controller.otherInfo = other
        }
        controller.title = title
        controller.hidesBottomBarWhenPushed = abool
        navigationController?.pushViewController(controller, animated: true)
        return controller
    }
    func pop(toControllerNamed controllerstr: String, withSel sel: Selector?, withObj info: Any?) {
        print("返回到 \(controllerstr) 页面")
        for controller: UIViewController in (navigationController?.viewControllers)! {
            if (String(describing: controller) == controllerstr) {
                if controller.responds(to: sel) {
                    controller.perform(sel!, with: info, afterDelay: 0.01)
                }
                navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    func goback() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
    //MARK: UItableViewDelegagte
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BaseTableViewCell
        if cell == nil {
            cell = BaseTableViewCell.getInstance() as? BaseTableViewCell
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    //MARK: 子类重写
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("请子类重写这个方法")
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 1 添加一个删除按钮
        let deleteRowAction = UITableViewRowAction(style: .destructive, title: "删除", handler: {(_ action: UITableViewRowAction, _ indexPath: IndexPath) -> Void in
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        deleteRowAction.backgroundColor = .lightGray
        return [deleteRowAction]
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }else {
            tableView.insertRows(at: [indexPath], with: .left)
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("请子类重写这个方法")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
