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
    var currentScale: CGFloat

    init(frame: CGRect) {
        self.frame = frame
        self.cameraNode = SKCameraNode()
        self.currentScale = GC.CAMERA.MIN_CAMERA_SCALE
    }
    
    func updateCameraPosition(catEntity: CatEntity) {
        let catPosition = catEntity.spriteComponent.node.position
        currentScale = adjustScale(progress: catEntity.calculateProgress())
        
        let lerpFactor: CGFloat = 0.2
        let smoothedPosition = CGPoint(
            x: cameraNode.position.x + (catPosition.x - cameraNode.position.x) * lerpFactor,
            y: cameraNode.position.y + ((catPosition.y + frame.height * 0.1) - cameraNode.position.y) * lerpFactor
        )
        
        cameraNode.position = smoothedPosition
    }
    
    func zoomOut() {
        let zoomOutAction = SKAction.scale(to: 1.5, duration: 0.5)
        zoomOutAction.timingMode = .easeInEaseOut
        cameraNode.run(zoomOutAction)
    }
    
    func adjustScale(progress: CGFloat) -> CGFloat {
        let scale = GC.CAMERA.MIN_CAMERA_SCALE + progress * (GC.CAMERA.MAX_CAMERA_SCALE - GC.CAMERA.MIN_CAMERA_SCALE)
        cameraNode.setScale(scale)
        
        return scale
    }
    
    func resetZoom() {
        let resetZoomAction = SKAction.scale(to: currentScale, duration: 0.5)
        resetZoomAction.timingMode = .easeInEaseOut
        cameraNode.run(resetZoomAction)
    }
}
