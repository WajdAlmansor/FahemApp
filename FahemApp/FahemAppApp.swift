import UIKit
import Speech

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestSpeechRecognitionPermission()
        return true
    }
    
    private func requestSpeechRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Speech recognition authorized.")
            case .denied:
                print("Speech recognition denied.")
            case .restricted:
                print("Speech recognition restricted.")
            case .notDetermined:
                print("Speech recognition not determined.")
            @unknown default:
                print("Unknown authorization status.")
            }
        }
    }
}
