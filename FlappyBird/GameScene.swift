//
//  GameScene.swift
//  FlappyBird
//
//  Created by Eduardo de la Cruz on 1/11/17.
//  Copyright © 2017 Eduardo de la Cruz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    // MARK: - Global Variables
    
    var pajaro = SKSpriteNode()
    var fraccionCielo = SKSpriteNode()
    var fraccionSuelo = SKSpriteNode()
    var colorCielo = SKColor()
    var texturaTubo1 = SKTexture()
    var texturaTubo2 = SKTexture()
    var separacionTubos = 200
    var controlTubos = SKAction()
    
    // MARK: - GameScene Load
    
    override func didMove(to view: SKView)
    {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        // MARK: - Sky Creation
        
        let texturaCielo = SKTexture(imageNamed: "cielo")
        texturaCielo.filteringMode = SKTextureFilteringMode.nearest
        
        // MARK: - Sky Animation
        
        let movimientoCielo = SKAction.moveBy(x: -texturaCielo.size().width, y: 0.0, duration: TimeInterval(0.05 * texturaCielo.size().width))
        
        let resetCielo = SKAction.moveBy(x: texturaCielo.size().width, y: 0.0, duration: 0.0)
        
        let movimientoCieloCntinuo = SKAction.repeatForever(SKAction.sequence([movimientoCielo, resetCielo]))
        
        // MARK: - Sky Placement
        
        for i in stride(from: 0, through: (2 + (self.frame.size.width / texturaCielo.size().width)), by: 1)
        {
            self.fraccionCielo = SKSpriteNode(texture: texturaCielo)
            self.fraccionCielo.zPosition = -99
            self.fraccionCielo.position = CGPoint(x: (i * fraccionCielo.size.width),
                                                  y: ((fraccionCielo.size.height / 2.0) + 96))
            
            self.fraccionCielo.run(movimientoCieloCntinuo)
            
            self.addChild(fraccionCielo)
        }
        
        colorCielo = SKColor(red: 125.0/255.0, green: 195.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        self.backgroundColor = colorCielo
        
        // MARK: - Ground Creation
        
        let texturaSuelo = SKTexture(imageNamed: "suelo")
        texturaSuelo.filteringMode = SKTextureFilteringMode.nearest
        
        // MARK: - Ground Animation
        
        let movimientoSuelo = SKAction.moveBy(x: -texturaSuelo.size().width, y: 0.0, duration: TimeInterval(0.015 * texturaSuelo.size().width))
        
        let resetSuelo = SKAction.moveBy(x: texturaSuelo.size().width, y: 0.0, duration: 0.0)
        
        let movimientoSueloCntinuo = SKAction.repeatForever(SKAction.sequence([movimientoSuelo, resetSuelo]))
        
        // MARK: - Ground Placement
        
        for i in stride(from: 0, through: (2 + (self.frame.size.width / texturaSuelo.size().width)), by: 1)
        {
            self.fraccionSuelo = SKSpriteNode(texture: texturaSuelo)
            self.fraccionSuelo.zPosition = -80
            self.fraccionSuelo.position = CGPoint(x: (i * fraccionSuelo.size.width),
                                                  y: (fraccionSuelo.size.height / 2.0))
            
            self.fraccionSuelo.run(movimientoSueloCntinuo)
            
            self.addChild(fraccionSuelo)
        }
        
        // MARK: - Bird Creation
        
        let texturaPajaro1 = SKTexture(imageNamed: "pajaro1")
        texturaPajaro1.filteringMode = SKTextureFilteringMode.nearest
        
        let texturaPajaro2 = SKTexture(imageNamed: "pajaro2")
        texturaPajaro2.filteringMode = SKTextureFilteringMode.nearest
        
        // MARK: - Bird Animation
        
        let aleteo = SKAction.animate(with: [texturaPajaro1, texturaPajaro2], timePerFrame: TimeInterval(0.25))
        
        let vuelo = SKAction.repeatForever(aleteo)
        
        // MARK: - Bird Placement
        
        self.pajaro = SKSpriteNode(texture: texturaPajaro1)
        self.pajaro.position = CGPoint(x: self.frame.size.width / 2.75,
                                       y: self.frame.midY)
        
        self.pajaro.zPosition = 0
        
        pajaro.physicsBody = SKPhysicsBody(circleOfRadius: pajaro.size.height / 2.0)
        self.pajaro.physicsBody?.isDynamic = true
        self.pajaro.physicsBody?.allowsRotation = false
        
        self.pajaro.run(vuelo)
        
        self.addChild(self.pajaro)
        
        let topeSuelo = SKNode()
        topeSuelo.position = CGPoint(x: 0.0, y: texturaSuelo.size().height / 2.0)
        topeSuelo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: texturaSuelo.size().height))
        topeSuelo.physicsBody?.isDynamic = false
        
        self.addChild(topeSuelo)
        
        self.texturaTubo1 = SKTexture(imageNamed: "tubo1")
        self.texturaTubo1.filteringMode = SKTextureFilteringMode.nearest
        self.texturaTubo2 = SKTexture(imageNamed: "tubo2")
        self.texturaTubo2.filteringMode = SKTextureFilteringMode.nearest
        
        
        
        let distanciaMovimiento = CGFloat(self.frame.width + 2.0 * texturaTubo1.size().width)
        let movimientoTubo = SKAction.moveBy(x: -distanciaMovimiento, y: 0.0, duration: TimeInterval(0.01 * distanciaMovimiento))
        let eliminarTubo = SKAction.removeFromParent()
        self.controlTubos = SKAction.sequence([movimientoTubo, eliminarTubo])
        
        print(self.frame.size.height)
        
        
        
        let crearTubo = SKAction.run({ () in self.gestionTubos()})
        let retardo = SKAction.wait(forDuration: TimeInterval(2.5))
        let crearSiguienteTubo = SKAction.sequence([crearTubo, retardo])
        let crearTuboTrasTubo = SKAction.repeatForever(crearSiguienteTubo)
        
        self.run(crearTuboTrasTubo)
    }
    
    
    func touchDown(atPoint pos : CGPoint)
    {
        
    }
    
    func touchMoved(toPoint pos : CGPoint)
    {
        
    }
    
    func touchUp(atPoint pos : CGPoint)
    {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        pajaro.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        self.pajaro.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 6.0))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if (pajaro.physicsBody?.velocity.dy)! < CGFloat(0.0)
        {
            pajaro.zRotation = self.rotation(min: -1.0, max: 0.5, valorActual: ((pajaro.physicsBody?.velocity.dy)! * 0.003))
        }
        else
        {
            pajaro.zRotation = self.rotation(min: -1.0, max: 0.5, valorActual: ((pajaro.physicsBody?.velocity.dy)! * 0.001))
        }
    }
    
    func rotation(min: CGFloat, max: CGFloat, valorActual: CGFloat) -> CGFloat
    {
        if valorActual > max
        {
            return max
        }
        else if valorActual < min
        {
            return min
        }
        else
        {
            return valorActual
        }
    }
    
    func gestionTubos()
    {
        let conjuntoTubo = SKNode()
        conjuntoTubo.position = CGPoint(x: (self.frame.size.width + texturaTubo1.size().width), y: 0.0)
        conjuntoTubo.zPosition = -90
        
        let alturaTubo = UInt(self.frame.size.height / 3)
        
        let y = arc4random_uniform(397)
        var valorFinal : UInt32 = 0
        
        if y < 230
        {
            valorFinal = 168 + y
        }
        else
        {
            valorFinal = y
        }
        
        let tubo1 = SKSpriteNode(texture: texturaTubo1)
        tubo1.position = CGPoint(x: 0.0, y: CGFloat(valorFinal))
        tubo1.physicsBody = SKPhysicsBody(rectangleOf: tubo1.size)
        tubo1.physicsBody?.isDynamic = false
        conjuntoTubo.addChild(tubo1)
        
        let tubo2 = SKSpriteNode(texture: texturaTubo2)
        tubo2.position = CGPoint(x: 0.0, y: CGFloat(valorFinal) + tubo1.size.height + CGFloat(separacionTubos))
        tubo2.physicsBody = SKPhysicsBody(rectangleOf: tubo2.size)
        tubo2.physicsBody?.isDynamic = false
        conjuntoTubo.addChild(tubo2)
        
        conjuntoTubo.run(self.controlTubos)
        
        self.addChild(conjuntoTubo)
    }
}
