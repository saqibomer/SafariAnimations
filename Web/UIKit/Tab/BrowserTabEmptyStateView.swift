//
//  BrowserTabEmptyStateView.swift
//  Web
//
//  Created by Saqib Omer on 30/01/2022.
//

import UIKit

class BrowserTabEmptyStateView: UIView {
  let imageView = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Helper methods
private extension BrowserTabEmptyStateView {
  func setupView() {
    backgroundColor = .white
    setupImageView()
  }
  
  func setupImageView() {
    imageView.image = UIImage(named: "SafariEmptyTabBackground")
    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(60)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}
