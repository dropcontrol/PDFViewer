//
//  ContentView.swift
//  PDFViewer
//
//  Created by hiroshi yamato on 2020/11/03.
//

import SwiftUI
import PDFKit

class PDFInfo: ObservableObject {
    @Published var pageNo: Int = 1
    @Published var pdfView: PDFView = PDFView()
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.pageChanged(_:)), name: Notification.Name.PDFViewPageChanged, object: nil)
    }
    
    @objc func pageChanged(_ notification: Notification) {
        self.pageNo = self.pdfView.currentPage!.pageRef!.pageNumber
        print(self.pageNo)
        print("page is changed")
    }
}

struct ContentView: View {
    @ObservedObject var pdfInfo: PDFInfo = PDFInfo()
    
    var body: some View {
        VStack {
            ShowPDFView(pdfInfo: pdfInfo)
            pdfInfoView(pdfInfo: pdfInfo)
            .padding()
        }.onAppear(){
            pdfInfo.addObserver()
        }
        
    }
}

struct ShowPDFView: View {
    @ObservedObject var pdfInfo: PDFInfo
    
    var body: some View {
        PDFViewer(pdfInfo: pdfInfo)
    }
}

struct pdfInfoView: View {
    @ObservedObject var pdfInfo: PDFInfo
    
    var body: some View {
        Text(String(pdfInfo.pageNo))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PDFViewer: UIViewRepresentable {
    @ObservedObject var pdfInfo: PDFInfo
    
    let url: URL = Bundle.main.url(forResource: "Oz was Wizard - Original Soundtrack", withExtension: "pdf")!
    
    func makeUIView(context: UIViewRepresentableContext<PDFViewer>) -> PDFViewer.UIViewType {
//        pdfView = PDFView()
        pdfInfo.pdfView.document = PDFDocument(url: url)
        // 画面サイズに合わす
        pdfInfo.pdfView.autoScales = true
        // 単一ページのみ表示（これを入れるとページめくりができない）
//        pdfView.displayMode = .singlePage
        //pageViewControllerを利用して表示(displayModeは無視される)
        pdfInfo.pdfView.usePageViewController(true)
        //スクロール方向を水平方向へ
        pdfInfo.pdfView.displayDirection = .horizontal
        //スクロール方向を垂直方向へ
//        pdfInfo.pdfView.displayDirection = .vertical
        //余白を入れる
//        pdfInfo.pdfView.displaysPageBreaks = true
        
        return pdfInfo.pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFViewer>) {
    }
    
}
