//
//  PreViewTool.swift
import UIKit
import QuickLook
import SnapKit
@objcMembers
class PreviewItem: NSObject,QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle:String?
    init(url:URL,title itemTitle:String?){
        previewItemURL = url
        previewItemTitle = itemTitle!;
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
@objcMembers
class PreviewController: QLPreviewController,UIDocumentInteractionControllerDelegate ,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIWebViewDelegate{
    let documentController = UIDocumentInteractionController()
    let webView = UIWebView()
    var containerVC :UIViewController!
    var previewRecorces = [CRResource]()
    static let service = PreviewController()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    deinit {
        print("销毁预览")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let res = previewRecorces.first{
            self.title = res.name
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearAllNotice()
    }
    @objc private func tapGesture(){
        self.navigationController?.isNavigationBarHidden = !(self.navigationController?.isNavigationBarHidden)!
    }
    ///除了quickView，其它的都只能打开一个文件
    func preView(_ sources:[CRResource],_ vc:UIViewController,quickView isQuick:Bool,inMenu isInMenu:Bool){
        self.previewRecorces = sources
        self.containerVC = vc
        webView.isHidden = true
        let res = sources.first!
        if !FileManager.default.fileExists(atPath: res.path){//本地没有则选用网络webview加载方式
            if res.type == .pdf || res.type == .unknown{
                noticeInfo("该文件不支持预览\n请先下载")
                return
            }
            guard let _ = webView.superview else{
                webView.delegate = self
                webView.scrollView.bounces = false
                webView.scalesPageToFit = true
                webView.scrollView.isScrollEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
                tap.numberOfTapsRequired = 1
                tap.numberOfTouchesRequired = 2
                webView.isUserInteractionEnabled = true
                webView.addGestureRecognizer(tap);
                view.addSubview(webView)
                webView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                return
            }
            self.previewRecorces.removeAll()
            self.reloadData()
            webView.loadRequest(URLRequest(url:URL(string: res.url)!))
            if let nav = vc.navigationController{
                nav.pushViewController(self, animated: true)
            }else{
                vc.present(self, animated: true) {
                }
            }
        }else if isQuick && res.type != .unknown{//快速预览模式
            self.dataSource = self
            self.delegate = self
            self.reloadData()
            if let nav = vc.navigationController{
                nav.pushViewController(self, animated: true)
            }else{
                vc.present(self, animated: true) {}
            }
        }else{
            documentController.url = URL(fileURLWithPath:res.path)
            documentController.delegate = self
            documentController.name = res.name
            documentController.uti = res.type.UTI().1
            if isInMenu || res.type == .unknown{//用文档打开的按钮选择模式
                documentController.presentOptionsMenu(from: CGRect(x: 0, y: 0, width: APPW, height: 100), in: containerVC.view, animated: true)
            }else{//用文档直接打开模式
                documentController.presentPreview(animated: true)
            }
        }
    }
    ///FIXME: QuickViewDelegate
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewRecorces.count
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let res = previewRecorces[index]
        return PreviewItem(url:URL(fileURLWithPath: res.path), title: res.name)
    }
    func previewController(_ controller: QLPreviewController, frameFor item: QLPreviewItem, inSourceView view: AutoreleasingUnsafeMutablePointer<UIView?>) -> CGRect {
        return CGRect(x: 0, y: 0, width: APPW, height: 200)
    }
    ///FIXME: UIDocumentDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return containerVC
    }
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return containerVC.view
    }
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return containerVC.view.frame
    }
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
    }
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
    }
    func documentInteractionControllerWillPresentOpenInMenu(_ controller: UIDocumentInteractionController) {
    }
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
    }
    func documentInteractionControllerWillPresentOptionsMenu(_ controller: UIDocumentInteractionController) {
    }
    func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
    }
    func documentInteractionController(_ controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        noticeInfo("正在加载...")
    }
    func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        clearAllNotice()
    }
    ///FIXME: webViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        noticeInfo("正在加载...")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.isHidden = false
        clearAllNotice()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        noticeInfo("加载失败，请稍后重试")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.containerVC.navigationController != nil else {
            self.dismiss(animated: true) {}
            return;
        }
    }
}
