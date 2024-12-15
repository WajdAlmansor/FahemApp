import SwiftUI

struct ContentView: View {
    @StateObject private var videoPickerViewModel = VideoPickerViewModel()
    @StateObject private var videoToTextViewModel = VideoToTextViewModel()
    @State private var showPicker = false

    var body: some View {
        VStack {
            if let url = videoPickerViewModel.pickedVideoURL {
                Text("Selected video URL:")
                    .font(.headline)
                Text(url.absoluteString)
                    .font(.subheadline)
                    .padding()
            } else {
                Text("No video selected")
                    .padding()
            }

            Button("Pick a Video") {
                showPicker = true
            }
            .padding()
            .sheet(isPresented: $showPicker) {
                VideoPicker(viewModel: videoPickerViewModel)
            }

            if !videoToTextViewModel.transcription.isEmpty {
                Text("Transcription:")
                    .font(.headline)
                    .padding(.top)
                ScrollView {
                    Text(videoToTextViewModel.transcription)
                        .padding()
                        .multilineTextAlignment(.leading)

                }
            } else if videoToTextViewModel.isProcessing {
                ProgressView("Processing video...")
                    .padding()
            } else {
                Text("No transcription available")
                    .padding()
            }

            if videoPickerViewModel.pickedVideoURL != nil {
                Button("Translate Audio to Text") {
                    if let videoURL = videoPickerViewModel.pickedVideoURL {
                        videoToTextViewModel.processVideo(from: videoURL)
                    }
                }
                .padding()
            }
        }
        .alert(item: $videoToTextViewModel.errorMessage) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Video to Text")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
