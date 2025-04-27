//
//  Generator.swift
//  Shattered
//
//  Created by bear on 12/12/21.
//

import CoreGraphics
import AppKit
import GameplayKit

/// A class that performs all calculation for subdividing pieces of the display area.
class Generator {
    // h & w of display area
    private let h: CGFloat
    private let w: CGFloat
    
    // piece of display area
    struct Piece {
        var points: [CGPoint]
        var color: NSColor
        var area: CGFloat
    }
    
    // array with all pieces of screen
    var pieces: [Piece] = []
    
    /// Initializes a ``Generator`` object with the specified height and width of the display area.
    /// - Parameter h: The height of the display area, as a ``CGFloat``.
    /// - Parameter w: The width of the display area, as a ``CGFloat``.
    /// > Tip: You can easily fetch the parameter from the view frame.
    init (h: CGFloat, w: CGFloat) {
        self.h = h
        self.w = w
    }
    
    /// A function that prepares an array of ``Pieces`` for drawing.
    /// - Returns: An array of ``Piece``s.
    func run () -> [Piece] {
        reset()
        for _ in 0..<50 {
            // remove randomly chosen element
            let p = pieces.remove(at: Int.random(in:0..<pieces.count))
            // slice the element and add its slices back to the array
            pieces.append(contentsOf: slice(p))
        }
        return pieces
    }
    
    /// A function that clears existing pieces and creates the first piece.
    func reset () {
        pieces.removeAll()
        pieces.append(
            Piece(
                points: [CGPoint(x: 0, y: 0),
                         CGPoint(x: w, y: 0),
                         CGPoint(x: w, y: h),
                         CGPoint(x: 0, y: h)],
                color: randomColor(),
                area: w * h
            )
        )
    }
    
    func weightedRandomPiece () {
        
    }
    
    /// A function that calculates the length between two given points.
    /// - Returns: The length, as a ``CGFloat``.
    func getLineLength (s1: CGPoint, s2: CGPoint) -> CGFloat {
        // side lengths
        let x = abs(s2.x - s1.x)
        let y = abs(s2.y - s1.y)
        // pythagorean
        return sqrt(pow(x,2) + pow(y,2))
    }
    
    /// A function that slices the specified ``Piece`` into two.
    /// - Returns: An array of two ``Piece``s.
    private func slice (_ p: Piece) -> [Piece] {
        // randomly pick set of sides to operate on
        let sel1 = Int.random(in:0...3)
        let sel2 = (sel1 + 2) % 4 // pick opposite side
        let slice1 = divideLine(p.points[sel1], p.points[(sel1+1)%4])
        let slice2 = divideLine(p.points[sel2], p.points[(sel2+1)%4])
        var pc1 = p; var pc2 = p
        
        pc1.points[(sel1+1)%4] = slice1
        pc1.points[sel2] = slice2
        
        pc2.points[sel1] = slice1
        pc2.points[(sel2+1)%4] = slice2
            
        pc2.color = randomColor()
        
        return [pc1, pc2]
    }
    
    /// A function that splits the given line segment into two at a random point along it.
    /// - Returns: A ``CGPoint`` of a random value on the given line segment.
    private func divideLine (_ pt1: CGPoint, _ pt2: CGPoint) -> CGPoint {
        // flips points if backwards on x
        let p1 = pt1.x < pt2.x ? pt1 : pt2
        let p2 = pt1.x < pt2.x ? pt2 : pt1
       
        // slope stuff
        let rise = p2.y - p1.y
        let run = p2.x - p1.x
        
        let divPt: CGPoint
        
        // if slope is defined
        if run != 0 {
            // rand number between x values (non-inclusive)
            let randX = gaussianRand(lo: p1.x, hi: p2.x, strength: 0.1)
            // y = m (x - x1) + y1
            let randY = (rise / run) * (randX - p1.x) + p1.y
            divPt = CGPoint(x: randX, y: randY)
        }
        // if slope is undefined
        else {
            // put lower number first because swift is fuckign picky haha
            let lo = (p1.y < p2.y) ? (p1.y) : (p2.y); let hi = (p1.y < p2.y) ? (p2.y) : (p1.y)
            divPt = CGPoint(x: p1.x, y: gaussianRand(lo: lo, hi: hi, strength: 0.5))
        }
        return divPt
    }
    
    /// A function that generates a random color, adjusted to remove dark and desaturated colors.
    /// - Returns: A random ``NSColor``.
    private func randomColor () -> NSColor {
        let hue = CGFloat.random(in: 0...1)
        let sat = CGFloat.random(in: 0.5...1)
        let bri = CGFloat.random(in: 0.5...1)
        let color = NSColor(hue: hue, saturation: sat, brightness: bri, alpha: 1)
        return color
    }
    
    private func gaussianRand (lo: CGFloat, hi: CGFloat, strength: CGFloat) -> CGFloat {
        let rand = GKGaussianDistribution(randomSource: GKRandomSource(), lowestValue: 0, highestValue: 1000000)
        let roll = rand.nextUniform()
        let balRoll = CGFloat.random(in: lo.nextUp ..< hi)
        let calc = CGFloat(roll) * (hi - lo) + lo
        let balStrength = 1 - strength
        let bal = calc * strength + balRoll * balStrength
        print("lo: \(lo), hi: \(hi), roll: \(roll), calc: \(calc)")
        return bal
    }
    
//    private func getNearbyColors (_ p: Piece) -> [NSColor] {
//
//    }
}
