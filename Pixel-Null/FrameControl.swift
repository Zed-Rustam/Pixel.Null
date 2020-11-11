import UIKit

class FrameControl : UIViewController, UIGestureRecognizerDelegate,FrameControlUpdate {
    
    var delegate: ToolsActionDelegate {
        return editorDelegate!
    }
    
    func setLayerSettings(isMode: Bool) {
        layers.setIsSettings(ismode: isMode)
    }
    
    func isLayerSettings() -> Bool {
        return layers.isSettingsMode
    }
    
    func changeLayerSettingsMode(isMode: Bool) {
        layerSettings.updateInfo()
        
        if isMode {
            
            self.layers.list.contentInset.bottom += 30
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.frames.alpha = 0
                self.frames.transform = CGAffineTransform(translationX: 0, y: 0)
                self.layerSettings.view.transform = CGAffineTransform(translationX: 0, y: 194)
                self.layers.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        } else {
            self.layers.list.contentInset.bottom -= 30
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.frames.alpha = 1
                self.frames.transform = CGAffineTransform(translationX: 0, y: 0)
                self.layerSettings.view.transform = CGAffineTransform(translationX: 0, y: 0)
                self.layers.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    func changeFrameSettingsMode(isMode: Bool) {
        if isMode {
            frameSettings.setInfo(project: project)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.layers.alpha = 0
                self.frames.transform = CGAffineTransform(translationX: 0, y: 158)
                self.frameSettings.view.transform = CGAffineTransform(translationX: 0, y: 194)
                self.layers.transform = CGAffineTransform(translationX: 0, y: 158)
            })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.layers.alpha = 1
                self.frames.transform = CGAffineTransform(translationX: 0, y: 0)
                self.frameSettings.view.transform = CGAffineTransform(translationX: 0, y: 0)
                self.layers.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    func recheckLayersCount() {
        layers.unpdateAddButton()
    }
    
    func updatePreview() {
        
    }
    
    func onRenameLayerModeStart(isStart: Bool){
        
        if !isStart {
            recheckLayersCount()
        } else {
            self.layers.addButton.isEnabled = false
        }
        
        self.layers.settingsButton.isEnabled = !isStart
        
        UIView.animate(withDuration: 0.2, animations: {
            self.frames.alpha = isStart ? 0 : 1
            self.frames.transform = CGAffineTransform(translationX: 0, y: isStart ? -self.frames.frame.size.height : 0)
            self.layers.transform = CGAffineTransform(translationX: 0, y: isStart ? -self.frames.frame.size.height : 0)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func addFrame(at: Int) {
         UIView.animate(withDuration: 0.2, animations: {
            self.frames.list.performBatchUpdates({
                self.frames.list.insertItems(at: [IndexPath(item: at, section: 0)])
            },completion: nil)
         })
        
        editorDelegate?.addFrame(frame: at)
    }
    
    func setProject(proj: ProjectWork) {
        project = proj
        frameSettings.project = proj
        layerSettings.project = proj
    }
    
    func changeFrame(from: Int, to: Int) {
        editorDelegate?.updateFrameSelect(lastFrame: from, newFrame: to)
        
        layers.list.reloadData()
        layers.checkFrame()
        layers.list.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        
        //;frames.list.reloadItems(at: [IndexPath(item: to, section: 0), IndexPath(item: to, section: 0)])
        frames.list.selectItem(at: IndexPath(item: to, section: 0), animated: false, scrollPosition: .top)
        
        frameSettings.setInfo(project: project)
        
     }
    
    func deleteFrame(frame: Int) {
        if(project.information.frames.count > 1){
            project.deleteFrame(frame: frame)
            
            editorDelegate?.deleteFrame(frame: frame)
            
            editorDelegate?.updateCanvas()
            
            self.frames.list.performBatchUpdates({
                self.frames.list.deleteItems(at: [IndexPath(item: frame, section: 0)])
            },completion: {isEnd in
                if isEnd {
                    self.frames.list.selectItem(at: IndexPath(item: self.project.FrameSelected, section: 0), animated: false, scrollPosition: .top)
                    (self.frames.list.cellForItem(at: IndexPath(item: self.project.FrameSelected, section: 0)) as? FramePreviewCell)?.setSelect(isSelect: true, animate: true)
                }
            })
            
            layers.list.reloadData()
            layers.list.selectItem(at: IndexPath(item: project.LayerSelected, section: 0), animated: true, scrollPosition: .left)

            layers.checkFrame()
        }
        frameSettings.setInfo(project: project)
    }
    
    func cloneFrame(original: Int) {
        project.cloneFrame(frame: original)
        editorDelegate?.addFrame(frame: original + 1)

       self.frames.list.performBatchUpdates({
           self.frames.list.insertItems(at: [IndexPath(item: original + 1, section: 0)])
       },completion: nil)
        
    }
    
    func updateFramePosition(from: Int, to: Int) {
        project.replaceFrame(from: from, to: to)
        
        editorDelegate?.replaceFrame(from: from, to: to)
    }
    
    func changeLayerVisible(frame: Int, layer: Int) {
        project.changeLayerVisible(layer: layer, isVisible: !project.layerVisible(layer: layer))
        
        self.layers.list.performBatchUpdates({
            self.layers.list.reloadItems(at: [IndexPath(item: layer, section: 0)])
        },completion: {isEnd in
            self.layers.list.selectItem(at: IndexPath(item: self.project.LayerSelected, section: 0), animated: false, scrollPosition: .left)
        })
        
        UIView.performWithoutAnimation {
            self.frames.list.performBatchUpdates({
                self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
            }, completion: {isEnd in
                if isEnd {
                    self.frames.list.selectItem(at: IndexPath(item: self.project!.FrameSelected, section: 0), animated: false, scrollPosition: .left)
                }
            })
        }
        
        editorDelegate?.updateFrame(frame: project.FrameSelected)
        editorDelegate?.updateLayer(frame: layer)
    }

    func changeLayer(newLayer: Int) {
        let lastSelect = project.LayerSelected
            
        project.LayerSelected = newLayer

        layerSettings.updateInfo()
        editorDelegate?.updateLayerSelect(lastFrame: lastSelect, newFrame: newLayer)
    }
    
    func updateLayerPosition(frame: Int, from: Int, to: Int) {
        project.replaceLayer(frame: frame, from: from, to: to)
        
        UIView.animate(withDuration: 0, animations: {
            self.frames.list.performBatchUpdates({
                self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
            }, completion: nil)
        })
        
        editorDelegate?.replaceLayer(from: from, to: to)
        editorDelegate?.updateCanvas()
    }
    
    func updateLayerSettings(target: Int) {
        UIView.animate(withDuration: 0, animations: {
            self.layers.list.performBatchUpdates({
                self.layers.list.reloadItems(at: [IndexPath(item: target, section: 0)])
            }, completion: {isEnd in
                self.layers.list.selectItem(at: IndexPath(item: self.project!.LayerSelected, section: 0), animated: true, scrollPosition: .left)
            })
        })
                
        editorDelegate?.updateLayer(frame: target)
        editorDelegate?.updateFrame(frame: project.FrameSelected)
    }
    
    func updateFrameSettings(target: Int) {
        UIView.animate(withDuration: 0, animations: {
           self.frames.list.performBatchUpdates({
               self.frames.list.reloadItems(at: [IndexPath(item: target, section: 0)])

           }, completion: {isEnd in
               self.frames.list.selectItem(at: IndexPath(item: self.project!.FrameSelected, section: 0), animated: true, scrollPosition: .top)
           })
       })
    }
 
    func deleteLayer(frame: Int, layer: Int) {
        if(project.information.frames[frame].layers.count > 1){
            project.deleteLayer(frame: frame, layer: layer)

            editorDelegate?.deleteLayer(frame: layer)
            editorDelegate?.updateCanvas()
            
            self.layers.list.performBatchUpdates({
                self.layers.list.deleteItems(at: [IndexPath(item: layer, section: 0)])
            },completion: {isEnd in
                self.layers.list.selectItem(at: IndexPath(item: self.project.LayerSelected, section: 0), animated: true, scrollPosition: .left)
                (self.layers.list.cellForItem(at: IndexPath(item: self.project.LayerSelected, section: 0)) as? LayersTableCell)?.setSelected(isSelect: true, anim: true)
            })
            
            UIView.performWithoutAnimation {
                self.frames.list.performBatchUpdates({
                    self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
                }, completion: {isEnd in
                    if isEnd {
                        self.frames.list.selectItem(at: IndexPath(item: self.project.FrameSelected, section: 0), animated: false, scrollPosition: .left)
                    }
                })
            }
        }
        
        layerSettings.updateInfo()
    }

    func cloneLayer(frame : Int, original: Int) {
        project.cloneLayer(frame: frame, layer: original)
        
        editorDelegate?.addLayer(frame: original + 1)

        UIView.animate(withDuration: 0.2, animations: {
            self.layers.list.performBatchUpdates({
                self.layers.list.insertItems(at: [IndexPath(item: original + 1, section: 0)])
            },completion: nil)
        })
        
        UIView.performWithoutAnimation {
            self.frames.list.performBatchUpdates({
                self.frames.list.reloadItems(at: [IndexPath(item: self.project!.FrameSelected, section: 0)])
            }, completion: {isEnd in
                if isEnd {
                    self.frames.list.selectItem(at: IndexPath(item: self.project.FrameSelected, section: 0), animated: false, scrollPosition: .left)
                }
            })
        }

        editorDelegate?.updateCanvas()
    }
    
    func addLayer(frame : Int, layer: Int) {
        UIView.animate(withDuration: 0.2) {
            self.layers.list.insertItems(at: [IndexPath(item: layer, section: 0)])
        }
        
        editorDelegate?.addLayer(frame: layer)
    }
    
    func margeLayers(frame : Int, layer: Int) {
        editorDelegate?.deleteLayer(frame: layer + 1)
 
        UIView.animate(withDuration: 0.2, animations: {
            self.layers.list.performBatchUpdates({
                self.layers.list.deleteItems(at: [IndexPath(item: layer + 1, section: 0)])
                self.layers.list.reloadItems(at: [IndexPath(item: layer, section: 0)])
            },completion: {isEnd in
                if isEnd {
                    self.layers.list.selectItem(at: IndexPath(item: self.project.LayerSelected, section: 0), animated: true, scrollPosition: .left)
                }
            })
        })
        
        layerSettings.updateInfo()
    }
        
    lazy private var frames : FramesCollectionView = {
        let frm = FramesCollectionView(proj: project)
        frm.list.frameDelegate = self

        frm.translatesAutoresizingMaskIntoConstraints = false
        frm.heightAnchor.constraint(equalToConstant: 136).isActive = true
        return frm
    }()
    
    lazy private var layers : LayersCollectionView = {
        let lays = LayersCollectionView(frame : .zero,proj: project)
        lays.translatesAutoresizingMaskIntoConstraints = false
        return lays
    }()
    
    lazy private var frameSettings: FrameSettings = {
        let settings = FrameSettings()
        
        settings.view.translatesAutoresizingMaskIntoConstraints = false
        return settings
    }()
    
    lazy private var layerSettings: LayerSettings = {
        let settings = LayerSettings()
        
        settings.view.translatesAutoresizingMaskIntoConstraints = false
        return settings
    }()
    
    var editorDelegate : (FrameActionDelegate & LayerActionDelegate & ToolsActionDelegate)? = nil

    weak var project : ProjectWork!
    
    override func viewDidLoad() {
        self.view.backgroundColor = getAppColor(color: .background)
        view.setCorners(corners: 24)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(frames)
        view.addSubview(layers)
        
        view.addSubview(frameSettings.view)

        frameSettings.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        frameSettings.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        frameSettings.view.topAnchor.constraint(equalTo: view.topAnchor, constant: -194).isActive = true
        frameSettings.view.heightAnchor.constraint(equalToConstant: 194).isActive = true
        
        view.addSubview(layerSettings.view)

        layerSettings.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        layerSettings.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        layerSettings.view.topAnchor.constraint(equalTo: view.topAnchor, constant: -194).isActive = true
        layerSettings.view.heightAnchor.constraint(equalToConstant: 194).isActive = true
        
        layerSettings.delegate = self
        
        frames.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        frames.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        frames.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true

        frames.list.frameDelegate = self
        
        layers.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        layers.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        layers.topAnchor.constraint(equalTo: frames.bottomAnchor, constant: 24).isActive = true
        layers.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        layers.list.frameDelegate = self
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        frames.list.selectItem(at: IndexPath(item: project.FrameSelected, section: 0), animated: true, scrollPosition: .top)
        layers.list.selectItem(at: IndexPath(item: project.LayerSelected, section: 0), animated: true, scrollPosition: .left)
    }
}

protocol FrameControlUpdate : class {
    
    var delegate: ToolsActionDelegate {get}
    
    func addFrame(at : Int)
    func deleteFrame(frame : Int)
    func cloneFrame(original : Int)
    func changeFrame(from : Int, to : Int)
    func updateFrameSettings(target : Int)
    func changeFrameSettingsMode(isMode: Bool)
    func updateFramePosition(from : Int, to : Int)
    
    func addLayer(frame : Int, layer : Int)
    func changeLayer(newLayer : Int)
    func updateLayerPosition(frame : Int,from : Int, to : Int)
    func updateLayerSettings(target : Int)
    func deleteLayer(frame : Int, layer : Int)
    func cloneLayer(frame : Int, original : Int)
    func changeLayerVisible(frame : Int,layer : Int)
    func margeLayers(frame : Int,layer : Int)
    func onRenameLayerModeStart(isStart: Bool)
    func recheckLayersCount()
    func changeLayerSettingsMode(isMode: Bool)
    func isLayerSettings() -> Bool
    func setLayerSettings(isMode: Bool)
    
    func updatePreview()

}
