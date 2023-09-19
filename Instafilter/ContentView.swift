//
//  ContentView.swift
//  Instafilter
//
//  Created by Никита Мартьянов on 17.09.23.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI


struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterIntensity2 = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter : CIFilter = CIFilter.sepiaTone()
    @State private var currentFilter2 : CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    @State private var showingFilterSheet2 = false
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                showingImagePicker = true
                }
                HStack {
                    Text("Intensity")
                    Slider(value:$filterIntensity)
                        .onChange(of: filterIntensity) {_ in applyProcessing() }
                }
                .padding(.vertical)
                HStack {
                    Text("Intensity2")
                    Slider(value:$filterIntensity2)
                        .onChange(of: filterIntensity2) {_ in applyProcessing2() }
                }
                HStack {
                    Button("Change Filter1") {
                        showingFilterSheet = true
                    }
                    Spacer()
                        
                        Button("Save",action: save)
                    }
                HStack {
                    Button("Change Filter2") {
                        showingFilterSheet2 = true
                    }
                    Spacer()
                }
                }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) {
                _ in loadImage()}
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(CIFilter.crystallize())}
                Button("Edges") { setFilter(CIFilter.edges())}
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur())}
                Button("Pixellate") { setFilter(CIFilter.pixellate())}
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone())}
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask())}
                Button("Vignette") { setFilter(CIFilter.vignette())}
                Button("Gamma Adjust") { setFilter2(CIFilter.gammaAdjust())}
                Button("Flash Transition") { setFilter2(CIFilter.flashTransition())}
                Button("Cancel",role: .cancel) { }
            }
            .confirmationDialog("Select a filter2", isPresented: $showingFilterSheet2) {
                Button("Crystallize") { setFilter2(CIFilter.crystallize())}
                Button("Edges") { setFilter2(CIFilter.edges())}
                Button("Gaussian Blur") { setFilter2(CIFilter.gaussianBlur())}
                Button("Pixellate") { setFilter2(CIFilter.pixellate())}
                Button("Sepia Tone") { setFilter2(CIFilter.sepiaTone())}
                Button("Unsharp Mask") { setFilter2(CIFilter.unsharpMask())}
                Button("Vignette") { setFilter2(CIFilter.vignette())}
                Button("Gamma Adjust") { setFilter2(CIFilter.gammaAdjust())}
                Button("Flash Transition") { setFilter2(CIFilter.flashTransition())}
                Button("Cancel",role: .cancel) { }
            }
            }
        }
    func loadImage() {
        guard let inputImage = inputImage else {return}
       
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    func loadImage2() {
        guard let inputImage = inputImage else {return}
       
        let beginImage = CIImage(image: inputImage)
        currentFilter2.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing2()
    }
    func save() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        imageSaver.errorHandler = {
            print("Oops!\($0.localizedDescription)")
        }
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) {
            
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) {
            
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image (uiImage: uiImage)
            processedImage = uiImage
        }
    }
    func applyProcessing2() {
        let inputKeys = currentFilter2.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            
            currentFilter2.setValue(filterIntensity2, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) {
            
            currentFilter2.setValue(filterIntensity2 * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) {
            
            currentFilter2.setValue(filterIntensity2 * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter2.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image (uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter:CIFilter) {
        currentFilter = filter
        loadImage()
    }
    func setFilter2(_ filter:CIFilter) {
        currentFilter2 = filter
        loadImage2()
    }
    }
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
