#  ShimmerView ![Platform iOS11+](https://img.shields.io/badge/platform-ios11%2B-red) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

ShimmerView is a subclass of `UIView` to construct Skelton View + Shimmering Effect type loading indicator. This framework is inspired by Facebook's [Shimmer](https://github.com/facebook/Shimmer).

![ShimmerViewExample0](images/shimmer_view_example_0.gif)

## Installation

### Carthage

```
github "mercari/ShimmerView"
```

## Usage
Shimmer Effect has four related APIs as blow:
- `ShimmerView`
- `ShimmerSyncTarget`
- `ShimmerReplicatorView`
- `ShimmerReplicatorViewCell`

### `ShimmerView`
`ShimmerView` is a subclass of `UIView` that has `CAGradientLayer` as a sublayer and encapsulates the logic for the shimmering effect animation.
```swift
let shimmerView = ShimmerView()
view.addSubview(shimmerView)
shimmerView.startAnimating()
```

The style of `ShimmerView` can be customized with `ShimmerViewStyle`.
```swift
let style = ShimmerViewStyle(
    baseColor: UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0),
    highlightColor: UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0),
    duration: 1.2,
    interval: 0.4,
    effectSpan: .points(120),
    effectAngle: 0 * CGFloat.pi)
shimmerView.apply(style: style)
```

### `ShimmerSyncTarget`
`ShimmerView` can be used as it is, but the shimmering effect would be effectively displayed when all the subviews’s effect in the screen is synced and animated together.

To make the best effect, create a view or view controller that contains multiple ShimmerViews and specify the container as `ShimmerSyncTarget`. ShimmerView will calculate its relative origin against the target and adjust the effect automatically.

### `ShimmerReplicatorView` & `ShimmerReplicatorViewCell`
`ShimmerReplicatorView` will let you create a list type loading screen with a few lines of code.

```swift
let replicatorView = ShimmerReplicatorView(
    itemSize: .fixedSize(CGSize(width: 80, height: 80)),
    interitemSpacing: 16,
    lineSpacing: 0,
    horizontalEdgeMode: .within,
    cellProvider: { () -> ShimmerReplicatorViewCell in
        let cell = ShimmerView()
        cell.layer.cornerRadius = 8.0
        cell.layer.masksToBounds = true
        return cell
})
replicatorView.startAnimating()
```

## Contribution

Please read the CLA carefully before submitting your contribution to Mercari.
Under any circumstances, by submitting your contribution, you are deemed to accept and agree to be bound by the terms and conditions of the CLA.

[https://www.mercari.com/cla/](https://www.mercari.com/cla/)


## License

Copyright 2020 Mercari, Inc.

Licensed under the MIT License.
