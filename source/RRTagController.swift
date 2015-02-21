//
//  RRTagController.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

struct Tag {
    var isSelected: Bool
    var isLocked: Bool
    var textContent: String
}

let colorUnselectedTag = UIColor.whiteColor()
let colorSelectedTag = UIColor(red:0.22, green:0.7, blue:0.99, alpha:1)

let colorTextUnSelectedTag = UIColor(red:0.33, green:0.33, blue:0.35, alpha:1)
let colorTextSelectedTag = UIColor.whiteColor()

class RRTagController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var tags: Array<Tag>!
    private var navigationBarItem: UINavigationItem!
    private var leftButton: UIBarButtonItem!
    private var rigthButton: UIBarButtonItem!
    private var _totalTagsSelected = 0
    private let addTagView = RRAddTagView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64))
    private var heightKeyboard: CGFloat = 0
    
    var blockFinih: ((selectedTags: Array<Tag>, unSelectedTags: Array<Tag>) -> ())!
    var blockCancel: (() -> ())!

    var totalTagsSelected: Int {
        get {
            return self._totalTagsSelected
        }
        set {
            if newValue == 0 {
                self._totalTagsSelected = 0
                return
            }
            self._totalTagsSelected += newValue
            self._totalTagsSelected = (self._totalTagsSelected < 0) ? 0 : self._totalTagsSelected
            self.navigationBarItem = UINavigationItem(title: "Tags")
            self.navigationBarItem.leftBarButtonItem = self.leftButton
            if (self._totalTagsSelected == 0) {
                self.navigationBarItem.rightBarButtonItem = nil
            }
            else {
                self.navigationBarItem.rightBarButtonItem = self.rigthButton
            }
            self.navigationBar.pushNavigationItem(self.navigationBarItem, animated: false)
        }
    }
    
    lazy var collectionTag: UICollectionView = {
        let layoutCollectionView = UICollectionViewFlowLayout()
        layoutCollectionView.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layoutCollectionView.itemSize = CGSizeMake(90, 20)
        layoutCollectionView.minimumLineSpacing = 10
        layoutCollectionView.minimumInteritemSpacing = 5
        let collectionTag = UICollectionView(frame: self.view.frame, collectionViewLayout: layoutCollectionView)
        collectionTag.contentInset = UIEdgeInsets(top: 84, left: 0, bottom: 20, right: 0)
        collectionTag.delegate = self
        collectionTag.dataSource = self
        collectionTag.backgroundColor = UIColor.whiteColor()
        collectionTag.registerClass(RRTagCollectionViewCell.self, forCellWithReuseIdentifier: RRTagCollectionViewCellIdentifier)
        return collectionTag
    }()
    
    lazy var addNewTagCell: RRTagCollectionViewCell = {
        let addNewTagCell = RRTagCollectionViewCell()
        addNewTagCell.contentView.addSubview(addNewTagCell.textContent)
        addNewTagCell.textContent.text = "+"
        addNewTagCell.frame.size = CGSizeMake(40, 40)
        addNewTagCell.backgroundColor = UIColor.grayColor()
        return addNewTagCell
    }()
    
    lazy var controlPanelEdition: UIView = {
        let controlPanel = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height + 50, UIScreen.mainScreen().bounds.size.width, 50))
        controlPanel.backgroundColor = UIColor.whiteColor()
        
        let buttonCancel = UIButton(frame: CGRectMake(10, 10, 100, 30))
        buttonCancel.layer.borderColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1).CGColor
        buttonCancel.layer.borderWidth = 2
        buttonCancel.backgroundColor = UIColor.whiteColor()
        buttonCancel.setTitle("Cancel", forState: UIControlState.Normal)
        buttonCancel.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonCancel.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        buttonCancel.layer.cornerRadius = 15
        buttonCancel.addTarget(self, action: "cancelEditTag", forControlEvents: UIControlEvents.TouchUpInside)

        let buttonAccept = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width - 110, 10, 100, 30))
        buttonAccept.layer.borderColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1).CGColor
        buttonAccept.layer.borderWidth = 2
        buttonAccept.backgroundColor = UIColor.whiteColor()
        buttonAccept.setTitle("Create", forState: UIControlState.Normal)
        buttonAccept.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonAccept.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        buttonAccept.layer.cornerRadius = 15
        buttonAccept.addTarget(self, action: "createNewTag", forControlEvents: UIControlEvents.TouchUpInside)
        
        controlPanel.addSubview(buttonCancel)
        controlPanel.addSubview(buttonAccept)
        return controlPanel
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64))
        
        self.navigationBarItem = UINavigationItem(title: "Tags")
        self.navigationBarItem.leftBarButtonItem = self.leftButton
        
        navigationBar.pushNavigationItem(self.navigationBarItem, animated: true)
        navigationBar.tintColor = colorSelectedTag
        return navigationBar
    }()
    
    func cancelTagController() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.blockCancel()
        })
    }
    
    func finishTagController() {
        var selected: Array<Tag> = Array()
        var unSelected: Array<Tag> = Array()
        
        for currentTag in tags {
            if currentTag.isSelected {
                selected.append(currentTag)
            }
            else {
                unSelected.append(currentTag)
            }
        }
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.blockFinih(selectedTags: selected, unSelectedTags: unSelected)
        })
    }
    
    func cancelEditTag() {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.4, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
            self.addTagView.frame.origin.y = 0
            self.controlPanelEdition.frame.origin.y = UIScreen.mainScreen().bounds.size.height
            self.collectionTag.alpha = 1
            }) { (anim:Bool) -> Void in
            
        }
    }
    
    func createNewTag() {
        let spaceSet = NSCharacterSet.whitespaceCharacterSet()
        let contentTag = addTagView.textEdit.text.stringByTrimmingCharactersInSet(spaceSet)
        if strlen(contentTag) > 0 {
            let newTag = Tag(isSelected: false, isLocked: false, textContent: contentTag)
            tags.insert(newTag, atIndex: tags.count)
            collectionTag.reloadData()            
        }
        cancelEditTag()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            if indexPath.row < tags.count {
                return RRTagCollectionViewCell.contentHeight(tags[indexPath.row].textContent)
            }
            return CGSizeMake(40, 40)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell: RRTagCollectionViewCell? = collectionView.cellForItemAtIndexPath(indexPath) as? RRTagCollectionViewCell
        
        if indexPath.row < tags.count {
            var currentTag = tags[indexPath.row]
            
            if tags[indexPath.row].isSelected == false {
                tags[indexPath.row].isSelected = true
                selectedCell?.animateSelection(tags[indexPath.row].isSelected)
                totalTagsSelected = 1
            }
            else {
                tags[indexPath.row].isSelected = false
                selectedCell?.animateSelection(tags[indexPath.row].isSelected)
                totalTagsSelected = -1
            }
        }
        else {
            addTagView.textEdit.text = nil
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4,
                options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                self.collectionTag.alpha = 0.3
                self.addTagView.frame.origin.y = 64
                }, completion: { (anim: Bool) -> Void in
                    self.addTagView.textEdit.becomeFirstResponder()
                    println("")
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: RRTagCollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier(RRTagCollectionViewCellIdentifier, forIndexPath: indexPath) as? RRTagCollectionViewCell
        
        if indexPath.row < tags.count {
            let currentTag = tags[indexPath.row]
            cell?.initContent(currentTag)
        }
        else {
            cell?.initAddButtonContent()
        }
        return cell!
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // TODO: change value
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                heightKeyboard = keyboardSize.height
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4,
                    options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                    self.controlPanelEdition.frame.origin.y = self.view.frame.size.height - self.heightKeyboard - 50
                }, completion: nil)
            }
        }
        else {
            heightKeyboard = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        heightKeyboard = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        leftButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancelTagController")
        rigthButton = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.Done, target: self, action: "finishTagController")
        
        totalTagsSelected = 0
        self.view.addSubview(collectionTag)
        self.view.addSubview(addTagView)
        self.view.addSubview(controlPanelEdition)
        self.view.addSubview(navigationBar)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    class func displayTagController(#parentController: UIViewController, tagsString: [String]?,
        blockFinish: (selectedTags: Array<Tag>, unSelectedTags: Array<Tag>)->(), blockCancel: ()->()) {
        let tagController = RRTagController()
            tagController.tags = Array()
            if tagsString != nil {
                for currentTag in tagsString! {
                    tagController.tags.append(Tag(isSelected: false, isLocked: false, textContent: currentTag))
                }
            }
            tagController.blockCancel = blockCancel
            tagController.blockFinih = blockFinish
            parentController.presentViewController(tagController, animated: true, completion: nil)
    }

    class func displayTagController(#parentController: UIViewController, tags: [Tag]?,
        blockFinish: (selectedTags: Array<Tag>, unSelectedTags: Array<Tag>)->(), blockCancel: ()->()) {
            let tagController = RRTagController()
            tagController.tags = tags
            tagController.blockCancel = blockCancel
            tagController.blockFinih = blockFinish
            parentController.presentViewController(tagController, animated: true, completion: nil)
    }
    
}
