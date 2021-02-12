//
//  Game.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 18/01/21.
//

import Foundation
import SpriteKit
import GameplayKit

class Game: NSObject {

    private(set) var player: Entity
    var playerDirection: PlayerDirection {
        get {
            if let component = player.component(ofType: PlayerControlComponent.self) {
                return component.direction
            } else {
                return .none
            }
        }
        set {
            if let component = player.component(ofType: PlayerControlComponent.self) {
                component.attemptedDirection = newValue
            }
        }
    }

    private var enemies: [Entity] = []

    private(set) var level: Level
    private var _scene: GameScene?

    private var intelligenceSystem: GKComponentSystem<IntelligenceComponent>

    var powerupTimeRemaining: CFTimeInterval = 0 {
        didSet {
            if powerupTimeRemaining < 0 {
                hasPowerup = false
            }
        }
    }

    var hasPowerup = false {
        willSet {
            let powerUpDuration: TimeInterval = 10

            if newValue != hasPowerup {
                let nextState = self.hasPowerup ? EnemyChaseState.self : EnemyFleeState.self
                for component in intelligenceSystem.components {
                    component.stateMachine.enter(nextState)
                }
                powerupTimeRemaining = powerUpDuration
            }
        }
    }

    var random: GKRandomSource? // Random source shared by various game mechanics.

    private var prevUpdateTime: TimeInterval = 0.0

    override init() {

        self.random = GKRandomSource()

        self.level = Level()

        self.player = Entity()
        self.player.gridPosition = level.startPosition?.gridPosition
        self.player.addComponent(SpriteComponent(defaultColor: SKColor.cyan))
        self.player.addComponent(PlayerControlComponent(level: level))

        // Create enemy entities with display and AI components.
        let colors: [SKColor] = [.red, .green, .yellow, .magenta]

        self.intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)

        super.init()

        var enemies: [Entity] = []
        for (index, node) in level.enemyStartPositions.enumerated() {
            let enemy = Entity()
            enemy.gridPosition = node.gridPosition
            enemy.addComponent(SpriteComponent(defaultColor: colors[index]))
            enemy.addComponent(IntelligenceComponent(game: self, enemy: enemy, startingPosition: node))
            intelligenceSystem.addComponent(foundIn: enemy)
            enemies.append(enemy)
        }
        self.enemies = enemies

    }

    var scene: SKScene {
        guard let gameScene = _scene else {
            self._scene = GameScene(
                size:
                    CGSize(
                        width: self.level.width * cellWidth,
                        height: self.level.height * cellWidth
                    )
            )

            self._scene!.sceneDelegate = self
            self._scene!.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            self._scene!.physicsWorld.contactDelegate = self

            return self._scene!
        }

        return gameScene
    }

}

extension Game: GameSceneDelegate {

    func scene(_ scene: GameScene?, didMoveTo view: SKView?) {
        scene?.backgroundColor = SKColor.black

        let cellSize = CGSize(width: cellWidth, height: cellWidth)

        generateMaze(scene: scene!, cellSize: cellSize)
        addPlayerEntityToScene(scene: scene!, size: cellSize)
        addEnemyEntitiesToScene(scene: scene!, size: cellSize)
    }

    func generateMaze(scene: GameScene, cellSize: CGSize) {
        let maze = SKNode()
        let graph = level.pathfindingGraph
        for widthCoordinate in 0..<level.width {
            for heightCoordinate in 0..<level.height {
                let vector = SIMD2<Int32>(Int32(widthCoordinate), Int32(heightCoordinate))
                if graph?.node(atGridPosition: vector) != nil {
                    // Make nodes for traversable areas; leave walls as background color.
                    let node = SKSpriteNode(color: SKColor.gray, size: cellSize)
                    node.position = CGPoint(
                        x: widthCoordinate * cellWidth + cellWidth / 2,
                        y: heightCoordinate * cellWidth + cellWidth / 2
                    )
                    maze.addChild(node)
                }
            }
        }
        scene.addChild(maze)
    }

    func addPlayerEntityToScene(scene: GameScene, size: CGSize) {
        guard let playerComponent: SpriteComponent = player.component(ofType: SpriteComponent.self),
              let playerGridPosition = self.player.gridPosition else { return }

        let sprite: SpriteNode = SpriteNode(color: SKColor.cyan, size: size)
        sprite.owner = playerComponent
        sprite.position = scene.point(forGridPosition: playerGridPosition)
        sprite.zRotation = CGFloat.pi
        sprite.xScale = CGFloat(0.5).squareRoot()
        sprite.yScale = CGFloat(0.5).squareRoot()

        let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(cellWidth/2))
        physicsBody.categoryBitMask = ContactCategory.player.rawValue
        physicsBody.contactTestBitMask = ContactCategory.enemy.rawValue
        physicsBody.collisionBitMask = 0
        sprite.physicsBody = physicsBody

        playerComponent.sprite = sprite

        scene.addChild(playerComponent.sprite!)
    }

    func addEnemyEntitiesToScene(scene: GameScene, size: CGSize) {
        for enemy in self.enemies {

            guard let enemyComponent = enemy.component(ofType: SpriteComponent.self),
                  let enemyGridPosition = enemy.gridPosition else {
                continue
            }

            let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(cellWidth/2))
            physicsBody.categoryBitMask = ContactCategory.enemy.rawValue
            physicsBody.contactTestBitMask = ContactCategory.player.rawValue
            physicsBody.collisionBitMask = 0

            let sprite = SpriteNode(color: enemyComponent.defaultColor, size: size)
            sprite.owner = enemyComponent
            sprite.position = scene.point(forGridPosition: enemyGridPosition)
            sprite.physicsBody = physicsBody

            enemyComponent.sprite = sprite

            scene.addChild(enemyComponent.sprite!)
        }
    }

    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        //Track remaining time delta since last update.
        if self.prevUpdateTime < 0 {
            self.prevUpdateTime = currentTime
        }

        let delta = currentTime - self.prevUpdateTime
        self.prevUpdateTime = currentTime

        //Track remaining time on powerup.
        self.powerupTimeRemaining -= delta

        //Update components with the new time delta.
        self.intelligenceSystem.update(deltaTime: delta)
        self.player.update(deltaTime: delta)
    }

}

extension Game: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {

        guard let bodyASpriteNode = contact.bodyA.node! as? SpriteNode,
              let bodyBSpriteNode = contact.bodyB.node! as? SpriteNode else { return }

        let enemyIsBodyA: Bool = contact.bodyA.categoryBitMask == ContactCategory.enemy.rawValue
        let enemyIsBodyB: Bool = contact.bodyB.categoryBitMask == ContactCategory.enemy.rawValue

        var enemyNode: SpriteNode!
        if enemyIsBodyA {
            enemyNode = bodyASpriteNode
        } else if enemyIsBodyB {
            enemyNode = bodyBSpriteNode
        }

        guard let entity: Entity = enemyNode.owner?.entity as? Entity,
              let aiComponent = entity.component(ofType: IntelligenceComponent.self) else { return }
        if aiComponent.stateMachine.currentState is EnemyChaseState {
            self.playerAttacked()
        } else {
            aiComponent.stateMachine.enter(EnemyDefeatedState.self)
        }
    }

    func playerAttacked() {
        // Warp player back to starting point.
        guard let spriteComponent = player.component(ofType: SpriteComponent.self),
              let controlComponent = player.component(ofType: PlayerControlComponent.self),
              let levelStartPointGridPosition = level.startPosition?.gridPosition else {
            return
        }

        spriteComponent.warp(toGridPosition: levelStartPointGridPosition)

        // Reset the player's direction controls upon warping.
        controlComponent.direction = PlayerDirection.none
        controlComponent.attemptedDirection = PlayerDirection.none
    }

}
