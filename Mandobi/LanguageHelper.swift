import UIKit

class LanguageHelper {
    
    private static var currentLanguage = UserDefaults.standard.value(forKey: "language") as? String == nil ?  NSLocale.current.languageCode! : UserDefaults.standard.value(forKey: "language") as! String
    
    static func setCurrentLanguage(langugaeCode: String) {
        currentLanguage = langugaeCode
        let defaults = UserDefaults.standard
        defaults.setValue(langugaeCode, forKey: "language")
        defaults.synchronize()
    }
    
    static func getCurrentLanguage() -> String {
        return currentLanguage
    }
    
    static func getStringLocalized(key: String) -> String {
        return (currentLanguage == "en" ? EnglishStrings.EnglishStringsDictionary[key] : ArabicStrings.ArabicStringsDictionary[key])!
    }
}
