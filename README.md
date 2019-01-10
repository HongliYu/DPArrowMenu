# DPArrowMenu
Click the button in any position, show a list of menu

[![Cocoapods](https://img.shields.io/cocoapods/v/DPArrowMenuKit.svg)](http://cocoapods.org/?q=DPArrowMenuKit)
[![Pod License](http://img.shields.io/cocoapods/l/DPArrowMenuKit.svg)](https://github.com/HongliYu/DPSlideMenuKit-Swift/blob/master/LICENSE)
[![Swift-4.0](https://img.shields.io/badge/Swift-4.2-blue.svg)]()
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

<img src="https://github.com/HongliYu/DPArrowMenu/blob/master/DPArrowMenu.png?raw=true" alt="alt text"  height="400">

## Usage

```  swift
  // 1. Create view model, including title and image name.
    let arrowMenuViewModel0 = DPArrowMenuViewModel(title: "Find Teachers",
                                                   imageName: "iconProfessionalTeacherSemiBlack")
    let arrowMenuViewModel1 = DPArrowMenuViewModel(title: "Find Language Partners",
                                                   imageName: "iconUserFriendsSemiBlack24")
    viewModels.append(arrowMenuViewModel0)
    viewModels.append(arrowMenuViewModel1)

  // 2. Bind action, when user selects one of them
    DPArrowMenu.show(view, viewModels: viewModels, done: { index in
      print(index)
    }) {
      print("cancel")
    }

```
