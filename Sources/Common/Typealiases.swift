#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

#if os(iOS) || os(tvOS)
public typealias BaseColor = UIColor
public typealias BaseView = UIView
public typealias BaseViewController = UIViewController
public typealias BaseStackView = UIStackView
public typealias Responder = UIResponder
public typealias BaseEdgeInsets = UIEdgeInsets
#else
public typealias BaseColor = NSColor
public typealias BaseView = NSView
public typealias BaseViewController = NSViewController
public typealias BaseStackView = NSStackView
public typealias Responder = NSResponder
public typealias BaseEdgeInsets = NSEdgeInsets
#endif
