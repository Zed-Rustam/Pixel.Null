import UIKit

class ColorSelectorController : UIViewController, NavigationProtocol {
    private var bgView : UIView = UIView()
    
    lazy private var topNavigation : NavigationView = {
        let navig = NavigationView(ics: [#imageLiteral(resourceName: "color_selector_1_icon"),#imageLiteral(resourceName: "color_selector_2_icon"),#imageLiteral(resourceName: "pallete_collection_item")])
        navig.translatesAutoresizingMaskIntoConstraints = false
        navig.iconSize = 28
        navig.setShadow(color: .clear, radius: 0, opasity: 0)
        navig.listener = self
        return navig
    }()
    
    private var dialog1 : ColorSelectDialog1 = ColorSelectDialog1(frame: .zero)

    private var dialog2 : ColorSelectDialog2 = ColorSelectDialog2(frame: .zero)

    private var dialog3 : PalletesDialog = PalletesDialog()

    lazy private var selectButton : CircleButton = {
        let btn  = CircleButton(icon: #imageLiteral(resourceName: "select_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.delegate = {[weak self] in
        if(!self!.dialog1.isHidden) {
            self!.delegate(self!.dialog1.selectedColorShow.color)
        }
        if(!self!.dialog2.isHidden) {
            self!.delegate(self!.dialog2.result.color)
        }
        self!.dismiss(animated: true)
        }
        
        return btn
    }()
    lazy private var cancelButton : CircleButton = {
        let btn = CircleButton(icon: #imageLiteral(resourceName: "cancel_icon"), frame: .zero)
        btn.setShadowColor(color: .clear)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.delegate = {[weak self] in
            self!.dismiss(animated: true)
        }
        return btn
    }()
    
    private var startcolor : UIColor = UIColor(r: 0, g: 0, b: 0, a: 1)
    
    lazy private var topBar : UIView = {
        let mainView = UIView()
        mainView.setShadow(color: ProjectStyle.uiShadowColor, radius: 8, opasity: 0.25)
        mainView.translatesAutoresizingMaskIntoConstraints = false
       

        let view = UIView()
        view.setCorners(corners: 12)
        view.backgroundColor = ProjectStyle.uiBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false

        mainView.addSubview(view)
        view.addSubview(topNavigation)
        view.addSubview(selectButton)
        view.addSubview(cancelButton)
        
        view.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true

        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 36).isActive = true

        selectButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6).isActive = true
        selectButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 36).isActive = true

        topNavigation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 64).isActive = true
        topNavigation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -64).isActive = true
        topNavigation.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topNavigation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        return mainView
    }()
    
    var delegate : (UIColor)->() = {color in}
    
    func setColor(clr : UIColor) {
        startcolor = clr
        dialog1.setColor(color: clr)
        dialog2.setValues(color: clr)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func onSelectChange(select: Int, lastSelect: Int) {
        if(select == 0) {
            dialog1.setColor(color: dialog2.result.color)
            dialog1.isHidden = false
            dialog2.isHidden = true
            dialog3.isHidden = true
        } else if select == 1 {
            dialog2.setValues(color: dialog1.selectedColorShow.color)
            dialog2.isHidden = false
            dialog1.isHidden = true
            dialog3.isHidden = true
        } else if select == 2 {
            dialog2.isHidden = true
            dialog1.isHidden = true
            dialog3.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ProjectStyle.uiBackgroundColor

       

        view.addSubview(topBar)
        view.addSubview(dialog1)
        view.addSubview(dialog2)
        view.addSubview(dialog3)

        topBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        topBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        dialog1.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        dialog1.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        dialog1.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 12).isActive = true
        dialog1.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        
        dialog2.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        dialog2.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        dialog2.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 12).isActive = true
        dialog2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        
        dialog3.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 6).isActive = true
        dialog3.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -6).isActive = true
        dialog3.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 12).isActive = true
        dialog3.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        //dialog1.setColor(color: startcolor)
        //dialog2.setValues(color: startcolor)
        dialog1.layoutIfNeeded()
        dialog2.layoutIfNeeded()
        dialog3.layoutIfNeeded()

        dialog1.setColor(color: startcolor)
        dialog1.lastSelectedColorShow.color = startcolor
        
        dialog2.setValues(color: startcolor)
        dialog2.isHidden = true
        dialog3.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(view.frame.height - (dialog2.hexText.frame.origin.y + dialog2.hexText.frame.height))
            print(keyboardSize.height)
            let size = keyboardSize.origin.y + keyboardSize.height - view.frame.height
            print(size)
                if view.frame.height - (dialog2.hexText.frame.origin.y + dialog2.hexText.frame.height) <= keyboardSize.height + size && dialog2.hexText.filed.isEditing {
                self.view.frame.origin.y -= (self.view.frame.height - keyboardSize.height) - (dialog2.hexText.frame.origin.y)
                } else {
                    self.view.frame.origin.y = 0
                }
        
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
