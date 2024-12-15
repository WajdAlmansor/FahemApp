import AVFoundation
import Speech

class VideoToTextModel {
    func extractAudio(from videoURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: videoURL)
        guard let audioTrack = asset.tracks(withMediaType: .audio).first else {
            print("No audio track found in video.")
            completion(nil)
            return
        }

        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("audio.m4a")
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exporter?.outputFileType = .m4a
        exporter?.outputURL = outputURL
        
        exporter?.exportAsynchronously {
            if exporter?.status == .completed {
                print("Audio successfully exported to \(outputURL).")
                completion(outputURL)
            } else if let error = exporter?.error {
                print("Failed to export audio: \(error.localizedDescription)")
                completion(nil)
            } else {
                print("Unknown error during audio export.")
                completion(nil)
            }
        }
    }


    func convertAudioToText(audioURL: URL, completion: @escaping (String?) -> Void) {
        // Arabic locale for speech recognition
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ar-SA")) else {
            print("Speech recognizer not available for the specified locale.")
            completion(nil)
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: audioURL)
        
        recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                print("Transcription: \(result.bestTranscription.formattedString)")
                completion(result.bestTranscription.formattedString)
            } else if let error = error {
                print("Speech recognition error: \(error.localizedDescription)")
                completion(nil)
            } else {
                print("Unknown error during speech recognition.")
                completion(nil)
            }
        }
    }
}
