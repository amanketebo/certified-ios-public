import SwiftUI
import MediaPlayer

struct MusicPlayerView: View {

    @ObservedObject var viewModel: MusicPlayerViewModel
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 12) {
            if let artworkImage = viewModel.artwork {
                Image(uiImage: artworkImage)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(6)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.gray)
                    Text("Certified")
                        .font(.system(size: 5, weight: .bold))
                }
                .frame(width: 30, height: 30)
            }
            VStack(alignment: .leading) {
                Text("Knife Talk")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                Text("Drake")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            Spacer()
            Button {
                viewModel.handleButtonTap()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                    if viewModel.isFetchingSong {
                        ProgressView()
                    } else {
                        viewModel.imageForPlayerState
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
            .disabled(viewModel.isFetchingSong)
        }
        .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
        .background(Colors.Common.tabBarBackgroundColor.swiftUIColor(for: themeManager.currentTheme))
        .alert(viewModel.errorAlert.title, isPresented: $viewModel.isErrorPresented, actions: {
            Button("OK") { viewModel.isErrorPresented = false }
        }, message: {
            Text(viewModel.errorAlert.message)
        })
    }
}

struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerView(viewModel: MusicPlayerViewModel())
    }
}
