//
//  ShatteredView.swift
//  Shattered
//
//  Created by bear on 12/12/21.
//

import ScreenSaver

class ShatteredView: ScreenSaverView {
    private let generator: Generator
    private var full: [Generator.Piece]
    private var count = 0

    // MARK: - Initialization
    override init? (frame: NSRect, isPreview: Bool) {
        generator = Generator(h: frame.height, w: frame.width)
        full = generator.run();
        super.init(frame: frame, isPreview: isPreview)
    }

    @available(*, unavailable)
    required init? (coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func draw (_ rect: NSRect) {
        // Draw a single frame in this function
        let set = full
        for p in set {
            let pt = p.points
            let draw = NSBezierPath()
            draw.move(to: pt[0])
            draw.line(to: pt[1])
            draw.line(to: pt[2])
            draw.line(to: pt[3])
            draw.close()
            p.color.setFill()
            p.color.setStroke()
            
            NSColor.white.setStroke()
            draw.fill()
            draw.stroke()
        }
        
    }

    override func animateOneFrame () {
        super.animateOneFrame()

        // Update the "state" of the screensaver in this function
        count += 1
        if count >= 100 {
            full = generator.run()
            count = 0
            setNeedsDisplay(bounds)
        }
    }
    
}
