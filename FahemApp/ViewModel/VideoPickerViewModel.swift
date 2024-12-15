import Foundation
import PhotosUI

class VideoPickerViewModel: ObservableObject {
    @Published var pickedVideoURL: URL?

    func pickVideo(from result: PHPickerResult) {
        let provider = result.itemProvider

        if provider.hasItemConformingToTypeIdentifier("public.movie") {
            provider.loadInPlaceFileRepresentation(forTypeIdentifier: "public.movie") { url, inPlace, error in
                DispatchQueue.main.async {
                    if let url = url {
                        // Copy the video to a temporary directory
                        let tempURL = FileManager.default.temporaryDirectory
                            .appendingPathComponent(UUID().uuidString + ".mp4")
                        do {
                            if inPlace {
                                // Copy the file if it's in place
                                try FileManager.default.copyItem(at: url, to: tempURL)
                            } else {
                                // If the file is already accessible, use the URL directly
                                print("Video loaded directly: \(url)")
                            }
                            print("File copied to: \(tempURL)")
                            self.pickedVideoURL = tempURL
                        } catch {
                            print("Error copying file: \(error.localizedDescription)")
                        }
                    } else {
                        print("Error loading file representation: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    }

}
