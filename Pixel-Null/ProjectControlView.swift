//
//  ProjectControlView.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 31.10.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class ProjectControlView: UIView {
    
    private unowned var project: ProjectWork
    
    private var isPlay: Bool = false
    
    lazy private var swipeDownGesture: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(gesture:)))
        swipe.direction = .down
        
        return swipe
    }()
    
    lazy private var swipeUpGesture: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(gesture:)))
        swipe.direction = .up
        
        return swipe
    }()
    
    lazy private var swipeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 4),
            view.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        view.setCorners(corners: 2)
        view.backgroundColor = getAppColor(color: .enable)
        
        return view
    }()
    
    lazy private var playButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btn.heightAnchor.constraint(equalToConstant: 36),
            btn.widthAnchor.constraint(equalToConstant: 36)
        ])
        
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12,curveType: .continuous)
        
        btn.setImage(UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), for: .normal)
        btn.tintColor = getAppColor(color: .enable)
        
        btn.addTarget(self, action: #selector(onPlay), for: .touchUpInside)
        return btn
    }()
    
    lazy private var settingsButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btn.heightAnchor.constraint(equalToConstant: 36),
            btn.widthAnchor.constraint(equalToConstant: 36)
        ])
        
        btn.backgroundColor = getAppColor(color: .background)
        btn.setCorners(corners: 12,curveType: .continuous)
        
        btn.setImage(UIImage(systemName: "gearshape.fill",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), for: .normal)
        btn.tintColor = getAppColor(color: .enable)
        
        btn.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        
        return btn
    }()
    
    lazy private var frames: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 42, height: 42)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let frm = UICollectionView(frame: .zero, collectionViewLayout: layout)
        frm.register(LayerCellNew.self, forCellWithReuseIdentifier: "frame")
        
        frm.dataSource = self
        frm.delegate = self
        frm.allowsMultipleSelection = false
        frm.isPrefetchingEnabled = false
        
        frm.contentInset = UIEdgeInsets(top: 3, left: 12, bottom: 3, right: 12)
        frm.translatesAutoresizingMaskIntoConstraints = false
        
        frm.backgroundColor = .clear
        return frm
    }()
    
    lazy private var layers: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 42, height: 42)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let lrs = UICollectionView(frame: .zero, collectionViewLayout: layout)
        lrs.register(LayerCellNew.self, forCellWithReuseIdentifier: "layer")
        
        lrs.dataSource = self
        lrs.delegate = self
        lrs.allowsMultipleSelection = false
        lrs.isPrefetchingEnabled = false
        
        lrs.contentInset = UIEdgeInsets(top: 3, left: 12, bottom: 3, right: 12)
        lrs.translatesAutoresizingMaskIntoConstraints = false
        
        lrs.backgroundColor = .clear
        return lrs
    }()
    
    private var delegate: (FrameActionDelegate & LayerActionDelegate & AnimationDelegate & ToolsActionDelegate)
    
    private var frameHide: Bool = false

    @objc func onSwipe(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            if !frameHide {
                frameHide = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: -48)
                    self.frames.alpha = 0
                    self.playButton.alpha = 0
                })
            }
        default:
            if frameHide {
                frameHide = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.frames.alpha = 1
                    self.playButton.alpha = 1
                })
            }
        }
    }
    
    @objc func onPlay() {
        isPlay.toggle()
        
        if isPlay {
            playButton.setImage(UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), for: .normal)
            
            settingsButton.isEnabled = false
            
            UIView.animate(withDuration: 0.2, animations: {
                self.layers.alpha = 0
            })
            
            delegate.onStartAnimation()
        } else {
            playButton.setImage(UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration.init(weight: .bold)), for: .normal)
            
            settingsButton.isEnabled = true

            UIView.animate(withDuration: 0.2, animations: {
                self.layers.alpha = 1
            })
            
            delegate.onStopAnimation()
        }
    }
    
    func moveFrameToCenter() {
        UIView.performWithoutAnimation {
            frames.selectItem(at: IndexPath(row: project.FrameSelected, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    func updateAll() {
        frames.reloadData()
        layers.reloadData()
        
        frames.selectItem(at: IndexPath(row: project.FrameSelected, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        layers.selectItem(at: IndexPath(row: project.LayerSelected, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func setupView() {
        addSubview(swipeView)
        addSubview(frames)
        addSubview(layers)
        addSubview(playButton)
        addSubview(settingsButton)
        
        addGestureRecognizer(swipeUpGesture)
        addGestureRecognizer(swipeDownGesture)

        NSLayoutConstraint.activate([
            swipeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            swipeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            playButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
            playButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 6),
            
            settingsButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
            settingsButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 12),
            
            frames.heightAnchor.constraint(equalToConstant: 48),
            frames.leftAnchor.constraint(equalTo: leftAnchor),
            frames.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -12),
            frames.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            layers.heightAnchor.constraint(equalToConstant: 48),
            layers.leftAnchor.constraint(equalTo: leftAnchor),
            layers.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -12),
            layers.topAnchor.constraint(equalTo: frames.bottomAnchor),
        ])
        
        frames.selectItem(at: IndexPath(row: project.FrameSelected, section: 0), animated: false, scrollPosition: .left)
        layers.selectItem(at: IndexPath(row: project.LayerSelected, section: 0), animated: false, scrollPosition: .left)

    }
    
    func updateFrame(index: Int) {
        UIView.performWithoutAnimation {
            frames.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func replaceFrame(from: Int, to: Int) {
        if from < project.FrameSelected && to >= project.FrameSelected {
            project.FrameSelected -= 1
        } else if from == project.FrameSelected {
            project.FrameSelected = to
        } else if from > project.FrameSelected && to <= project.FrameSelected {
            project.FrameSelected += 1
        }
        
        UIView.performWithoutAnimation {
            frames.moveItem(at: IndexPath(row: from, section: 0), to: IndexPath(item: to, section: 0))
        }
    }
    
    func replaceLayer(from: Int, to: Int) {
        if from < project.LayerSelected && to >= project.LayerSelected {
            project.LayerSelected -= 1
        } else if from == project.LayerSelected {
            project.LayerSelected = to
        } else if from > project.LayerSelected && to <= project.LayerSelected {
            project.LayerSelected += 1
        }
        
        UIView.performWithoutAnimation {
            layers.moveItem(at: IndexPath(row: from, section: 0), to: IndexPath(item: to, section: 0))
        }
    }
    
    func reloadLayers() {
        UIView.performWithoutAnimation {
            layers.reloadData()
        }
    }
    
    func updateLayer(index: Int) {
        UIView.performWithoutAnimation {
            layers.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func updateFrameSelect(last: Int, now: Int) {
        UIView.performWithoutAnimation {
            frames.reloadItems(at: [IndexPath(row: last, section: 0),IndexPath(row: now, section: 0)])
        }
        
        reloadLayers()
    }
    
    func updateLayerSelect(last: Int, now: Int) {
        UIView.performWithoutAnimation {
            layers.reloadItems(at: [IndexPath(row: last, section: 0),IndexPath(row: now, section: 0)])
        }
    }
    
    func addFrame(at: Int) {
        project.FrameSelected = (at <= project.FrameSelected) ? project.FrameSelected + 1 : project.FrameSelected

        UIView.performWithoutAnimation {
            frames.insertItems(at: [IndexPath(item: at, section: 0)])
            frames.reloadItems(at: [IndexPath(item: project.FrameSelected, section: 0)])
        }
    }
    
    func addLayer(at: Int) {
        print(at)
        project.LayerSelected = (at <= project.LayerSelected || project.LayerSelected == project.layerCount) ? project.LayerSelected + 1 : project.LayerSelected

        UIView.performWithoutAnimation {
            layers.insertItems(at: [IndexPath(item: at, section: 0)])
            layers.reloadItems(at: [IndexPath(item: project.LayerSelected, section: 0)])
        }
                
        updateFrame(index: project.FrameSelected)
    }
    
    func deleteFrame(at: Int) {
        if project.FrameSelected == at {
            project.FrameSelected = ((at < project.FrameSelected || project.FrameSelected == project.frameCount) && project.FrameSelected != 0) ? project.FrameSelected - 1 : project.FrameSelected

            project.LayerSelected = 0
            reloadLayers()
        } else {
            project.FrameSelected = ((at < project.FrameSelected || project.FrameSelected == project.frameCount) && project.FrameSelected != 0) ? project.FrameSelected - 1 : project.FrameSelected
        }
        
        UIView.performWithoutAnimation {
            frames.deleteItems(at: [IndexPath(item: at, section: 0)])
            frames.reloadItems(at: [IndexPath(item: project.FrameSelected, section: 0)])

        }
    }
    
    func deleteLayer(at: Int) {
        project.LayerSelected = ((at <= project.LayerSelected || project.LayerSelected == project.layerCount) && project.LayerSelected != 0) ? project.LayerSelected - 1 : project.LayerSelected
        
        UIView.performWithoutAnimation {
            layers.deleteItems(at: [IndexPath(item: at, section: 0)])
            layers.reloadItems(at: [IndexPath(row: project.LayerSelected, section: 0)])
        }
    }
    
    @objc func openSettings() {
        delegate.openFrameControl()
    }
    
    init(proj: ProjectWork, frameDelegate: FrameActionDelegate & LayerActionDelegate & AnimationDelegate & ToolsActionDelegate) {
        project = proj
        delegate = frameDelegate

        super.init(frame: .zero)
        
        backgroundColor = getAppColor(color: .background)
        translatesAutoresizingMaskIntoConstraints = false
        setCorners(corners: 12, needMask: false, curveType: .continuous,activeCorners: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
        
        setupView()
    }
    
    override func layoutSubviews() {
        setShadow(color: getAppColor(color: .shadow), radius: 12, opasity: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProjectControlView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == frames ? project.frameCount : project.layerCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == frames {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "frame", for: indexPath) as! LayerCellNew
            
            cell.setBackground(clr: project.backgroundColor)
            cell.setVisible(visible: true)
            cell.setSelect(isSelect: project.FrameSelected == indexPath.item, animate: false)
            cell.setImage(img: UIImage())

            DispatchQueue.global(qos: .userInteractive).async {
                let img = (indexPath.item == self.project.FrameSelected) ? self.project.getFrameFromLayers(frame : indexPath.item,size: CGSize(width: 36, height: 36)).flip(xFlip: self.project.isFlipX, yFlip: self.project.isFlipY) : self.project.getFrame(frame: indexPath.item, size: CGSize(width: 36, height: 36)).flip(xFlip: self.project.isFlipX, yFlip: self.project.isFlipY)

                DispatchQueue.main.async {
                        cell.setImage(img: img)
                }
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "layer", for: indexPath) as! LayerCellNew
            
            cell.setBackground(clr: project.backgroundColor)
            cell.setSelect(isSelect: project.LayerSelected == indexPath.item, animate: false)
            cell.setVisible(visible: project.layerVisible(layer: indexPath.item))
            cell.setImage(img: UIImage())
            
            DispatchQueue.global(qos: .userInteractive).async {
                let img = self.project.getSmallLayer(frame : self.project.FrameSelected,layer: indexPath.item,size : CGSize(width: 36, height: 36)).flip(xFlip: self.project.isFlipX, yFlip: self.project.isFlipY)
                DispatchQueue.main.async {
                    cell.setImage(img: img)
                }
            }
            
            return cell
        }
    }
}

extension ProjectControlView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == frames {
            delegate.updateFrameSelect(lastFrame: project.FrameSelected, newFrame: indexPath.item)
            reloadLayers()
        } else {
            delegate.updateLayerSelect(lastFrame: project.LayerSelected, newFrame: indexPath.item)
        }
    }
}

class LayerCellNew: UICollectionViewCell {
    private var select = false
    
    lazy private var preview : UIImageView = {
        let img = UIImageView()
        img.layer.magnificationFilter = .nearest
        img.contentMode = .scaleAspectFit
        
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        img.addSubviewFullSize(view: visibleView)
        return img
    }()
    
    lazy private var visibleView : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "unvisible_icon")
        img.tintColor = .white
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return img
    }()
    
    func setVisible(visible : Bool){
        visibleView.isHidden = visible
    }
    
    lazy private var previewBg : UIImageView = {
        let img = UIImageView()
        img.layer.magnificationFilter = .nearest
        img.contentMode = .scaleAspectFit
        img.image = #imageLiteral(resourceName: "background")
        
        img.translatesAutoresizingMaskIntoConstraints = false
        img.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        img.addSubviewFullSize(view: preview)
        
        img.setCorners(corners: 8, needMask: true, curveType: .continuous)
        return img
    }()
    
    lazy private var selectBg : UIView = {
       let view = UIView()
        view.setCorners(corners: 11)
        view.backgroundColor = getAppColor(color: .select)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 42).isActive = true
        view.heightAnchor.constraint(equalToConstant: 42).isActive = true
        return view
    }()
    
    func setSelect(isSelect : Bool, animate : Bool){
        select = isSelect
        if animate {
        UIView.animate(withDuration: 0.2, animations: {
            self.selectBg.transform = CGAffineTransform(scaleX: isSelect ? 1 : 0.75, y: isSelect ? 1 : 0.75)
        })
        } else {
            UIView.performWithoutAnimation {
                self.selectBg.transform = CGAffineTransform(scaleX: isSelect ? 1 : 0.75, y: isSelect ? 1 : 0.75)
            }
        }
    }
    
    func setImage(img : UIImage?){
        preview.image = img
    }
    
    func setBackground(clr : UIColor) {
        preview.backgroundColor = clr
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectBg)
        selectBg.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        selectBg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(previewBg)
        previewBg.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        previewBg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.setShadow(color: getAppColor(color: .shadow), radius: 3, opasity: 1)
        contentView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 3, y: 3, width: 36, height: 36), cornerRadius: 8).cgPath
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

