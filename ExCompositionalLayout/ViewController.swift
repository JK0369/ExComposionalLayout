//
//  ViewController.swift
//  ExCompositionalLayout
//
//  Created by Jake.K on 2022/04/19.
//

import UIKit

final class ViewController: UIViewController {
  private lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: Self.getLayout())
    view.isScrollEnabled = true
    view.showsHorizontalScrollIndicator = false
    view.showsVerticalScrollIndicator = true
    view.scrollIndicatorInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 4)
    view.contentInset = .zero
    view.backgroundColor = .clear
    view.clipsToBounds = true
    view.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private let dataSource: [MySection] = [
    .first((1...30).map(String.init).map(MySection.FirstItem.init(value:))),
    .second((31...60).map(String.init).map(MySection.SecondItem.init(value:))),
  ]
  
  static func getLayout() -> UICollectionViewCompositionalLayout {
    UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
      switch section {
      case 0:
        let itemFractionalWidthFraction = 1.0 / 3.0 // horizontal 3개의 셀
        let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
        let itemInset: CGFloat = 2.5
        
        // Item
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(itemFractionalWidthFraction),
          heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(groupFractionalHeightFraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        return section
      default:
        let itemFractionalWidthFraction = 1.0 / 5.0 // horizontal 5개의 셀
        let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
        let itemInset: CGFloat = 2.5
        
        // Item
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(itemFractionalWidthFraction),
          heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(groupFractionalHeightFraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        return section
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.collectionView)
    NSLayoutConstraint.activate([
      self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
    ])
    self.collectionView.dataSource = self
  }
}

extension ViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    self.dataSource.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch self.dataSource[section] {
    case let .first(items):
      return items.count
    case let .second(items):
      return items.count
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
    switch self.dataSource[indexPath.section] {
    case let .first(items):
      cell.prepare(text: items[indexPath.item].value)
    case let .second(items):
      cell.prepare(text: items[indexPath.item].value)
    }
    return cell
  }
}

final class MyCell: UICollectionViewCell {
  let label: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.backgroundColor = UIColor(
      red: CGFloat(drand48()),
      green: CGFloat(drand48()),
      blue: CGFloat(drand48()),
      alpha: 1.0
    )
    self.contentView.addSubview(self.label)
    NSLayoutConstraint.activate([
      self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      self.label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
    ])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.prepare(text: "")
  }
  
  func prepare(text: String) {
    self.label.text = text
  }
}

enum MySection {
  case first([FirstItem])
  case second([SecondItem])
  
  struct FirstItem {
    let value: String
  }
  struct SecondItem {
    let value: String
  }
}
