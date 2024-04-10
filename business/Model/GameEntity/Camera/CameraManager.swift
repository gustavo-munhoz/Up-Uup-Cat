//
//  CameraManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 27/03/24.
//

import SpriteKit

class CameraManager {
    var cameraNode: SKCameraNode
    var frame: CGRect
    var minimumHeight: CGFloat
    var currentScale: CGFloat
    var isZoomedOut = false

    init(frame: CGRect, minimumHeight: CGFloat) {
        self.frame = frame
        self.cameraNode = SKCameraNode()
        self.currentScale = GC.CAMERA.MIN_CAMERA_SCALE
        self.minimumHeight = minimumHeight
    }
    
    func updateCameraPosition(catEntity: CatEntity) {
        let catPosition = catEntity.spriteComponent.node.position
        adjustScale(progress: catEntity.calculateProgress())
        
        let lerpFactor: CGFloat = 0.2
        let smoothedPosition = CGPoint(
            x: cameraNode.position.x + (catPosition.x - cameraNode.position.x) * lerpFactor,
            y: cameraNode.position.y + ((catPosition.y + frame.height * 0.1) - cameraNode.position.y) * lerpFactor
        )
        
        let maxX = frame.width * 0.85
        let minX = -frame.width * 0.85
        
        let clampedXPosition = max(minX, min(smoothedPosition.x, maxX))
        
        cameraNode.position = CGPoint(
            x: clampedXPosition,
            y: max(smoothedPosition.y, minimumHeight)
        )
    }
    
    func zoomOut() {
        isZoomedOut = true
        let zoomOutAction = SKAction.scale(to: max(GC.CAMERA.MAX_CAMERA_SCALE,  1.5), duration: 0.5)
        zoomOutAction.timingMode = .easeInEaseOut
        cameraNode.run(zoomOutAction)
    }
    
    func adjustScale(progress: CGFloat) {
        currentScale = GC.CAMERA.MIN_CAMERA_SCALE + progress * (GC.CAMERA.MAX_CAMERA_SCALE - GC.CAMERA.MIN_CAMERA_SCALE)
        
        if !isZoomedOut {
            cameraNode.setScale(currentScale)
        }
    }
    
    func resetZoom() {
        isZoomedOut = false
        let resetZoomAction = SKAction.scale(to: currentScale, duration: 0.5)
        resetZoomAction.timingMode = .easeInEaseOut
        cameraNode.run(resetZoomAction)
    }
}
