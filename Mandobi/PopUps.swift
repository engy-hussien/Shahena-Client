import UIKit

class PopUps {
    
    private static var instance : PopUps!
    
    static func getInstance() -> PopUps {
        if instance == nil {
            instance = PopUps()
        }
        return instance
    }
    
    func showPopUp(_ viewController: UIViewController,_ Identifier:String) {
        let popoverContent = UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: Identifier)
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 340,height: 350)
        popover?.delegate = viewController as? UIPopoverPresentationControllerDelegate
        popover?.sourceView = viewController.view
        popover?.sourceRect = CGRect(x: viewController.view.bounds.midX - 25, y: viewController.view.bounds.midY, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        viewController.present(popoverContent, animated: true, completion: nil)
    }
}
