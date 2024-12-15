import Foundation

struct IdentifiableErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

class VideoToTextViewModel: ObservableObject {
    private let model = VideoToTextModel()
    @Published var transcription: String = ""
    @Published var isProcessing: Bool = false
    @Published var errorMessage: IdentifiableErrorMessage?

    func processVideo(from videoURL: URL) {
        isProcessing = true
        model.extractAudio(from: videoURL) { [weak self] audioURL in
            guard let audioURL = audioURL else {
                DispatchQueue.main.async {
                    self?.errorMessage = IdentifiableErrorMessage(message: "Failed to extract audio.")
                    self?.isProcessing = false
                }
                return
            }

            self?.model.convertAudioToText(audioURL: audioURL) { transcription in
                DispatchQueue.main.async {
                    if let transcription = transcription {
                        self?.transcription = transcription
                    } else {
                        self?.errorMessage = IdentifiableErrorMessage(message: "Failed to transcribe audio.")
                    }
                    self?.isProcessing = false
                }
            }
        }
    }
}
