//
//  GameScene.swift
//  FlappyBird
//
//  Created by Eduardo de la Cruz on 1/11/17.
//  Copyright © 2017 Eduardo de la Cruz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
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
    var categoriaPajaro : UInt32 = 1 << 0
    var categoriaSuelo  : UInt32 = 1 << 1
    var categoriaTubos  : UInt32 = 1 << 2
    var categoriaAvance : UInt32 = 1 << 3
    let movimiento = SKNode()
    var reset = false
    let adminTubos = SKNode()
    var puntuacion = Int()
    let puntuacionLabel = SKLabelNode()
    let gravity : CGFloat = -5.0
    let velocidadDeAleteo : CGFloat = 0.25
    let posicionXPajaro : CGFloat = 2.75
    var actualizacionCielo : CGFloat = 0.05
    var actualizacionSuelo : CGFloat = 0.015
    var actualizacionConjuntoTubos : CGFloat = 0.01
    let fontSize : CGFloat = 100
    let fontAlpha : CGFloat = 0.5
    let impulsoPajaro : CGFloat = 6.0
    
    // MARK: - GameScene Load
    
    override func didMove(to view: SKView)
    {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: self.gravity)
        self.physicsWorld.contactDelegate = self
        
        // MARK: - Sky Creation
        
        let texturaCielo = SKTexture(imageNamed: "cielo")
        texturaCielo.filteringMode = SKTextureFilteringMode.nearest
        
        // MARK: - Sky Animation
        
        let movimientoCielo = SKAction.moveBy(x: -texturaCielo.size().width, y: 0.0, duration: TimeInterval(self.actualizacionCielo * texturaCielo.size().width))
        
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
            
            self.movimiento.addChild(fraccionCielo)
        }
        
        colorCielo = SKColor(red: 125.0/255.0, green: 195.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        self.backgroundColor = colorCielo
        
        // MARK: - Ground Creation
        
        let texturaSuelo = SKTexture(imageNamed: "suelo")
        texturaSuelo.filteringMode = SKTextureFilteringMode.nearest
        
        // MARK: - Ground Animation
        
        let movimientoSuelo = SKAction.moveBy(x: -texturaSuelo.size().width, y: 0.0, duration: TimeInterval(self.actualizacionSuelo * texturaSuelo.size().width))
        
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
            
            self.movimiento.addChild(fraccionSuelo)
        }
        
        let topeSuelo = SKNode()
        topeSuelo.position = CGPoint(x: 0.0, y: texturaSuelo.size().height / 2.0)
        topeSuelo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: texturaSuelo.size().height))
        topeSuelo.physicsBody?.isDynamic = false
        
        topeSuelo.physicsBody?.categoryBitMask = self.categoriaSuelo
        topeSuelo.physicsBody?.contactTestBitMask = self.categoriaPajaro
        
        self.addChild(topeSuelo)
        
        // MARK: - Bird Creation
        
        let texturaPajaro1 = SKTexture(imageNamed: "pajaro1")
        texturaPajaro1.filteringMode = SKTextureFilteringMode.nearest
        
        let texturaPajaro2 = SKTexture(imageNamed: "pajaro2")
        texturaPajaro2.filteringMode = SKTextureFilteringMode.nearest
        
        // MARK: - Bird Animation
        
        let aleteo = SKAction.animate(with: [texturaPajaro1, texturaPajaro2], timePerFrame: TimeInterval(self.velocidadDeAleteo))
        
        let vuelo = SKAction.repeatForever(aleteo)
        
        // MARK: - Bird Placement
        
        self.pajaro = SKSpriteNode(texture: texturaPajaro1)
        self.pajaro.position = CGPoint(x: self.frame.size.width / self.posicionXPajaro,
                                       y: self.frame.midY)
        
        self.pajaro.zPosition = 0
        
        pajaro.physicsBody = SKPhysicsBody(circleOfRadius: pajaro.size.height / 2.0)
        self.pajaro.physicsBody?.isDynamic = true
        self.pajaro.physicsBody?.allowsRotation = false
        
        self.pajaro.physicsBody?.categoryBitMask = self.categoriaPajaro
        self.pajaro.physicsBody?.collisionBitMask = self.categoriaSuelo | self.categoriaTubos
        self.pajaro.physicsBody?.contactTestBitMask = self.categoriaSuelo | self.categoriaTubos
        
        self.pajaro.run(vuelo)
        
        self.addChild(self.pajaro)
        
        self.texturaTubo1 = SKTexture(imageNamed: "tubo1")
        self.texturaTubo1.filteringMode = SKTextureFilteringMode.nearest
        self.texturaTubo2 = SKTexture(imageNamed: "tubo2")
        self.texturaTubo2.filteringMode = SKTextureFilteringMode.nearest
        
        
        
        let distanciaMovimiento = CGFloat(self.frame.width + 2.0 * texturaTubo1.size().width)
        let movimientoTubo = SKAction.moveBy(x: -distanciaMovimiento, y: 0.0, duration: TimeInterval(self.actualizacionConjuntoTubos * distanciaMovimiento))
        let eliminarTubo = SKAction.removeFromParent()
        self.controlTubos = SKAction.sequence([movimientoTubo, eliminarTubo])
        
        let crearTubo = SKAction.run({ () in self.gestionTubos()})
        let retardo = SKAction.wait(forDuration: TimeInterval(2.5))
        let crearSiguienteTubo = SKAction.sequence([crearTubo, retardo])
        let crearTuboTrasTubo = SKAction.repeatForever(crearSiguienteTubo)
        
        self.run(crearTuboTrasTubo)
        
        self.movimiento.addChild(self.adminTubos)
        
        self.addChild(self.movimiento)
        
        self.puntuacion = 0
        self.puntuacionLabel.fontName = "Arial"
        self.puntuacionLabel.fontSize = self.fontSize
        self.puntuacionLabel.alpha = self.fontAlpha
        self.puntuacionLabel.position = CGPoint(x: self.frame.midX, y: (self.frame.size.height - 150))
        self.puntuacionLabel.zPosition = 0
        self.puntuacionLabel.text = "\(self.puntuacion)"
        
        self.addChild(self.puntuacionLabel)
    }
    
    //MARK: - Contact Detector
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if (contact.bodyA.categoryBitMask == self.categoriaAvance) || (contact.bodyB.categoryBitMask == self.categoriaAvance)
        {
            self.puntuacion += 1
            self.puntuacionLabel.text = "\(self.puntuacion)"
        }
        else
        {
            if (self.movimiento.speed > 0)
            {
                let resetJuego = SKAction.run({ () in self.resetGame() })
                self.movimiento.speed = 0
                
                let cieloRojo = SKAction.run({ () in self.ponerCieloRojo() })
                
                let conjuntoGameOver = SKAction.group([cieloRojo, resetJuego])
                
                self.run(conjuntoGameOver)
            }
        }
    }
    
    // MARK: - Touches (bird motion) detector
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if (self.movimiento.speed > 0)
        {
            self.pajaro.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            self.pajaro.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: self.impulsoPajaro))
        }
        else if (self.reset)
        {
            self.reiniciarEscena()
        }
    }
    
    // MARK: - Bird inclination update on flight
    
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
    
    // MARK: - Pipes gorup creation
    
    func gestionTubos()
    {
        let conjuntoTubo = SKNode()
        conjuntoTubo.position = CGPoint(x: (self.frame.size.width + texturaTubo1.size().width), y: 0.0)
        conjuntoTubo.zPosition = -90
        
        let y : UInt32 = arc4random_uniform(397)
        var valorFinal : UInt32 = 0
        
        if (self.frame.size.height - 1104.5) > 0
        {
            if y < UInt32(self.frame.size.height - 1104)
            {
                if y > 397 - UInt32(self.frame.size.height - 1104)
                {
                    valorFinal = (398 - UInt32(self.frame.size.height - 1104)) + y
                }
                else
                {
                    valorFinal = UInt32(self.frame.size.height - 1104) + y
                }
            }
            else
            {
                valorFinal = y
            }
        }
        else
        {
            valorFinal = y
        }
        
        
        let tubo1 = SKSpriteNode(texture: texturaTubo1)
        tubo1.position = CGPoint(x: 0.0, y: CGFloat(valorFinal))
        tubo1.physicsBody = SKPhysicsBody(rectangleOf: tubo1.size)
        tubo1.physicsBody?.isDynamic = false
        
        tubo1.physicsBody?.categoryBitMask = self.categoriaTubos
        tubo1.physicsBody?.contactTestBitMask = self.categoriaPajaro
        
        conjuntoTubo.addChild(tubo1)
        
        let tubo2 = SKSpriteNode(texture: texturaTubo2)
        tubo2.position = CGPoint(x: 0.0, y: CGFloat(valorFinal) + tubo1.size.height + CGFloat(separacionTubos))
        tubo2.physicsBody = SKPhysicsBody(rectangleOf: tubo2.size)
        tubo2.physicsBody?.isDynamic = false
        
        tubo2.physicsBody?.categoryBitMask = self.categoriaTubos
        tubo2.physicsBody?.contactTestBitMask = self.categoriaPajaro
        
        conjuntoTubo.addChild(tubo2)
        
        let avanceNodo = SKNode()
        avanceNodo.position = CGPoint(x: (tubo1.size.width + (self.pajaro.size.width / 2)), y: self.frame.midY)
        avanceNodo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tubo1.size.width, height: self.frame.size.height))
        avanceNodo.physicsBody?.isDynamic = false
        avanceNodo.physicsBody?.categoryBitMask = self.categoriaAvance
        avanceNodo.physicsBody?.contactTestBitMask = self.categoriaPajaro
        
        conjuntoTubo.addChild(avanceNodo)
        
        conjuntoTubo.run(self.controlTubos)
        
        self.adminTubos.addChild(conjuntoTubo)
    }
    
    // MARK: - Game Over State of Game
    
    func ponerCieloRojo()
    {
        self.backgroundColor = .red
    }
    
    // MARK: - Game Reset
    
    func resetGame()
    {
        self.reset = true
    }
    
    // MARK: - Scene Reset
    
    func reiniciarEscena()
    {
        self.backgroundColor = self.colorCielo
        self.pajaro.position = CGPoint(x: self.frame.size.width / self.posicionXPajaro,
                                       y: self.frame.midY)
        self.pajaro.speed = 0
        self.pajaro.zRotation = 0
        self.puntuacion = 0
        self.puntuacionLabel.text = "\(self.puntuacion)"
        self.adminTubos.removeAllChildren()
        self.movimiento.speed = 1
        self.actualizacionCielo = 0.05
        self.actualizacionSuelo = 0.015
        self.actualizacionConjuntoTubos = 0.01
    }
}
