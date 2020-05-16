import UIKit

class ColorSelectorController : UIViewController, NavigationProtocol {
    
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
        if(!self!.dialog3.isHidden) {
            self!.delegate(self!.dialog3.colorSelected)
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
        mainView.translatesAutoresizingMaskIntoConstraints = false
       

        let view = UIView()
        view.setCorners(corners: 12)
        view.backgroundColor = UIColor(named: "backgroundColor")
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

    func onSelectChange(select: Int, lastSelect: Int) {
        if(select == 0) {
            switch lastSelect {
            case 1:
                dialog1.setColor(color: dialog2.result.color)
            case 2:
                dialog1.setColor(color: dialog3.colorSelected)
            default:
                break
            }
            dialog1.isHidden = false
            dialog2.isHidden = true
            dialog3.isHidden = true
            
        } else if select == 1 {
            switch lastSelect {
            case 0:
                dialog2.setValues(color: dialog1.selectedColorShow.color)
            case 2:
                dialog2.setValues(color: dialog3.colorSelected)
            default:
                break
            }
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
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")

       

        view.addSubview(dialog1)
        view.addSubview(dialog2)
        view.addSubview(dialog3)
        view.addSubview(topBar)

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
        dialog2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        dialog3.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 6).isActive = true
        dialog3.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -6).isActive = true
        dialog3.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 12).isActive = true
        dialog3.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        dialog3.controller = self
        
        //dialog1.setColor(color: startcolor)
        //dialog2.setValues(color: startcolor)
        dialog1.layoutIfNeeded()
        dialog2.layoutIfNeeded()
        dialog3.layoutIfNeeded()

        dialog1.setColor(color: startcolor)
        dialog1.lastSelectedColorShow.color = startcolor
        
        dialog2.lastresult.color = startcolor
        dialog2.setValues(color: startcolor)
        
        dialog2.isHidden = true
        dialog3.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        topBar.setShadow(color: UIColor(named: "shadowColor")!, radius: 8, opasity: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dialog3.collection.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
}
