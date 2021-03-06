//
//  YXSegmentPageView.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/2.
//

import UIKit

@objc public protocol YXSegmentPageViewDelegate: NSObjectProtocol {
    
    @objc optional func segmentPageView(_ page: YXSegmentPageView, progress: CGFloat)
    @objc optional func segmentPageView(_ page: YXSegmentPageView, at index: Int)
    
}

public class YXSegmentPageView: UIView {

    public weak var delegate: YXSegmentPageViewDelegate?
    private weak var parentViewController: UIViewController?
    private var children: [UIViewController] = []
    private var isScrollToBegin: Bool = false
    private var beginOffsetX: CGFloat = 0
    private var selectIndex: Int = 0
    private var willSelectIndex: Int = 0
    
    public var childrenVC: [UIViewController] {
        
        return self.children
    }

    public var selectedIndex: Int {
        
        return self.selectIndex
    }
    
    public var willSelectedIndex: Int {
        
        return self.willSelectIndex
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }()
    
    public lazy var collectionView: YXSegmentCollectionView = {
        
        let collectionView = YXSegmentCollectionView(frame: self.bounds, collectionViewLayout: self.layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.classForCoder()))
        
        return collectionView
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(self.collectionView)
    }
    
    public convenience init(frame: CGRect = .zero, parent: UIViewController, children: [UIViewController]) {
        
        self.init(frame: frame)
        self.addSubview(self.collectionView)
        self.setupSegmentPageView(parent: parent, children: children)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layout.itemSize = self.bounds.size
        self.collectionView.frame = self.bounds
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension YXSegmentPageView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.children.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.classForCoder()), for: indexPath)
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let child = children[indexPath.item]
        self.parentViewController?.addChild(child)
        child.view.frame = cell.contentView.frame
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.contentView.addSubview(child.view)
        child.didMove(toParent: self.parentViewController)
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.contentView.subviews.forEach { (subView) in
            
            subView.removeFromSuperview()
        }
    }
    
}

//MARK: - UIScrollViewDelegate
extension YXSegmentPageView: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.isScrollToBegin = false
        self.beginOffsetX = scrollView.contentOffset.x
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !self.isScrollToBegin else { return }
        var progress: CGFloat = 0.0
        let offsetX = scrollView.contentOffset.x, width = scrollView.frame.width
        let difference = offsetX.truncatingRemainder(dividingBy: width) / width
        if self.beginOffsetX < offsetX { //Scroll to the right
            self.selectIndex = Int(offsetX / width)
            self.willSelectIndex = self.selectIndex + 1
            if self.willSelectIndex >= children.count {
                self.willSelectIndex = self.selectIndex
            }
            progress = difference
        }
        else if self.beginOffsetX > offsetX { //Scroll to the left
            self.willSelectIndex = Int(offsetX / width)
            self.selectIndex = self.willSelectIndex + 1
            if self.selectIndex >= self.children.count {
                self.selectIndex = self.willSelectIndex
            }
            progress = 1 - difference
        }
        guard self.selectIndex != self.willSelectIndex else { return }
        if delegate?.responds(to: #selector(delegate?.segmentPageView(_:progress:))) ?? false {
            self.delegate?.segmentPageView?(self, progress: progress)
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.selectIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if delegate?.responds(to: #selector(delegate?.segmentPageView(_:at:))) ?? false {
            self.delegate?.segmentPageView?(self, at: self.selectIndex)
        }
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        self.selectIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if delegate?.responds(to: #selector(delegate?.segmentPageView(_:at:))) ?? false {
            self.delegate?.segmentPageView?(self, at: self.selectIndex)
        }
    }
    
}

public extension YXSegmentPageView {
    
    func setupSegmentPageView(parent: UIViewController, children: [UIViewController]) {
        
        self.parentViewController = parent
        self.children = children
    }
    
    func scrollToItem(to index: Int, animated: Bool) {
        
        self.isScrollToBegin = true
        self.willSelectIndex = index
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        if !animated {
            self.selectIndex = index
            self.isScrollToBegin = false
            if delegate?.responds(to: #selector(delegate?.segmentPageView(_:at:))) ?? false {
                self.delegate?.segmentPageView?(self, at: index)
            }
        }
    }
    
    func child<T: UIViewController>(at index: Int, type: T.Type = T.self) -> T {
        
        guard let child = self.children[index] as? T else {
            fatalError("Failed to child index \(index) matching type \(type.self). ")
        }
        return child
    }
    
    func reloadData() {
        
        self.collectionView.reloadData()
    }
    
}
