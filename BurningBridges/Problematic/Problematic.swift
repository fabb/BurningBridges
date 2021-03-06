import Foundation
import UIKit
import Photos


enum SwiftEnum {
	case Case1
}


/**
	This class demonstrates a few problems that happen with the Swift 3 migrator and bridge in Xcode 8
	Tested with Xcode 8 beta 1
*/
class Problematic {

	// ObjC method should be bridged to `problematic(launchedDueToDeepLink: Bool)`, but gets bridged to `problematicWithLaunchedDue(toDeepLink: Bool)`
	func problematic1() {
		ProblematicBridgedObjCClass.problematicWithLaunchedDueToDeepLink(true)
	}
	
	// @noescape and @autoclosure are not moved to parameter type
	// FIXED in beta 6
	func problematic2(@noescape block1: () -> Void, @autoclosure block2: () -> Void) {
		
	}
	
	// compile error, uppercase enum gets bridged to uppercase, but converter converts to lowercase
	// FIXED
	func problematic3() {
		let _: ObjCEnum = .UPPERCASE // this was fixed in beta 3
		let _: UIUserInterfaceIdiom = .TV // this was fixed in beta 2
	}
	
	// compile error, uppercase enum gets bridged to uppercase, but converter converts to lowercase
	// FIXED
	func problematic4() {
		let _: SecondObjcEnum = .CaseNotIncludingEnumNameAsPrefix // this was fixed in beta 3
	}
	
	// compile error, Default is not a real case but a static var, in Swift 3 it currently only can be referenced it the way `PHImageContentMode.Default`
	func problematic5() {
		let _: PHImageContentMode = .Default
	}
	
	// compile error, lastObject now returns concrete type instead of AnyObject?
	func problematic6() {
		let fetchResult: PHFetchResult? = nil
		let _: PHAsset? = fetchResult?.lastObject as? PHAsset
	}
	
	// compile error, only codepaths for Release build config get migrated
	func problematic7() {
		#if DEBUG
			// does not get migrated
			let _: SwiftEnum = .Case1
		#else
			let _: SwiftEnum = .Case1
		#endif
	}
	
	// compile error, ObjC categories on foundation classes that have been renamed in Swift cannot be found anymore when calling class method
	// FIXED in GM
	func problematic8() {
		NSNotification.problematicClassMethod()
	}
	
	// compile error, ObjC categories on foundation classes that have been renamed in Swift cannot be found anymore when calling instance method that has a parameter
	// FIXED in GM
	func problematic9(notification: NSNotification) {
		notification.problematicInstanceMethodWithProblematicParameter(0)
	}
	
	// compile error, block parameter nullability is not migrated
	func problematic10() {
		ProblematicBridgedObjCClass.problematicWithBlock({ (error: NSError!) -> Void in
			let _: NSError = error
		})
	}
	
	// compile error, URLComponents is not mutable anymore
	func problematic11(url: NSURL, query: String) {
		guard let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) else {
			return
		}
		
		if query.characters.count > 0 {
			urlComponents.query = query
		}
		else {
			urlComponents.query = nil
		}
	}
	
	// compile error, stringByRemovingPercentEncoding is not migrated to removingPercentEncoding
	func problematic12(string: String) {
		let _ = string.stringByRemovingPercentEncoding
	}

	// compile error, migration of showResultsWithUrl misses parameter name
	// FIXED
	func problematic13() {
		ProblematicBridgedObjCClass.showResultsWithUrl(nil) // FIXED in beta 4
	}

}
