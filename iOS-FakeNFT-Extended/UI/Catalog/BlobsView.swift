//
//  BlobsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 28.01.2026.
//

import SwiftUI

struct BlobsView: View {
    
    var body: some View {
        TimelineView(.animation) { timeline in
            PhaseAnimator([0, 1]) { phase in
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .blue.opacity(0.5),
                                    .cyan.opacity(0.5),
                                    .purple.opacity(0.5),
                                    .red.opacity(0.5)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .rotationEffect(.degrees(phase == 1 ? 360 : 0))
                    Text("Loading...")
                        .font(.title)
                        .foregroundStyle(Color.white)
                        .opacity(phase == 0 ? 1 : 0)
                }
            } animation: { _ in
                    .easeInOut(duration: 1.5)
            }
            .mask {
                Canvas { context, size in
                    
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    
                    context.addFilter(.alphaThreshold(min: 0.5))
                    context.addFilter(.blur(radius: 30))
                    
                    context.drawLayer { layer in
                        for i in 0..<3 {
                            let position = blobPosition(
                                index: i,
                                time: time,
                                size: size
                            )
                            
                            let radius: CGFloat = 45
                            
                            layer.fill(
                                Path(ellipseIn: CGRect(
                                    x: position.x - radius,
                                    y: position.y - radius,
                                    width: radius * 2,
                                    height: radius * 2
                                )),
                                with: .color(.white)
                            )
                        }
                    }
                }
            }
        }
        .blur(radius: 2)
        .shadow(radius: 5)
    }
    
    private func blobPosition(index: Int, time: TimeInterval, size: CGSize) -> CGPoint {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let angle = time * 0.8 + Double(index) * .pi * 2 / 3
        let radius: CGFloat = 50
        
        return CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle * 1.3) * radius
        )
    }
}

#Preview {
    BlobsView()
}
