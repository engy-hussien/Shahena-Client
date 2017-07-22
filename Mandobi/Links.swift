

class Links {
    
    var BASE_URL : String {
        get {
               return "http://35.167.101.93/api/"
//            return "http://192.168.1.40/mandobi/api/"
            // return "http://35.167.101.93/beta/uploads/"
        }
    }
    
    var AUTH_PARAMETERS : String {
        get {
            let APP_KEY = "3e990ab542678f436a24304c5d5367d6"
            return  "?app_key=\(APP_KEY)&lang=\(LanguageHelper.getCurrentLanguage())"
        }
    }

    static let SOCKET_URL = "http://35.167.101.93:30010"
//    static let SOCKET_URL = "http://192.168.1.40:30010"

    
}
