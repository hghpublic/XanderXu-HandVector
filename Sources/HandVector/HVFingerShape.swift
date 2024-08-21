//
//  HVFingerShape.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/20.
//

import ARKit

public struct HVFingerShape: Sendable, Equatable {
    public struct FingerShapeConfiguration {
        public var maximumBaseCurlDegrees: Float
        public var maximumFullCurlDegrees1: Float
        public var maximumFullCurlDegrees2: Float
        public var maximumFullCurlDegrees3: Float
        public var maximumPinchDistance: Float
        public var maximumSpreadDegrees: Float
        public var maximumTipCurlDegrees1: Float
        public var maximumTipCurlDegrees2: Float
        
        public var minimumBaseCurlDegrees: Float
        public var minimumFullCurlDegrees1: Float
        public var minimumFullCurlDegrees2: Float
        public var minimumFullCurlDegrees3: Float
        public var minimumPinchDistance: Float
        public var minimumSpreadDegrees: Float
        public var minimumTipCurlDegrees1: Float
        public var minimumTipCurlDegrees2: Float
        
        public static var detault: FingerShapeConfiguration {
            return FingerShapeConfiguration(maximumBaseCurlDegrees: 90, maximumFullCurlDegrees1: 90, maximumFullCurlDegrees2: 90, maximumFullCurlDegrees3: 80, maximumPinchDistance: 0.05, maximumSpreadDegrees: 45, maximumTipCurlDegrees1: 90, maximumTipCurlDegrees2: 90, minimumBaseCurlDegrees: 0, minimumFullCurlDegrees1: 0, minimumFullCurlDegrees2: 0, minimumFullCurlDegrees3: 0, minimumPinchDistance: 0.015, minimumSpreadDegrees: 0, minimumTipCurlDegrees1: 0, minimumTipCurlDegrees2: 0)
        }
    }
    public enum FingerShapeType: Int {
        case baseCurl = 1
        case tipCurl = 2
        case fullCurl = 4
        case pinch = 8
        case spread = 16
    }
    
    
    let finger: HVJointGroupOptions
    let fingerShapeTypes: Set<HVFingerShape.FingerShapeType>
    
    let fullCurl: Float
    let baseCurl: Float
    let tipCurl: Float
    let pinch: Float?
    let spread: Float?
    
//    init(finger: HVJointGroupOptions, fingerShapeTypes: Set<HVFingerShape.FingerShapeType>, fullCurl: Float, baseCurl: Float, tipCurl: Float, pinch: Float?, spread: Float?) {
//        self.finger = finger
//        self.fingerShapeTypes = fingerShapeTypes
//        self.fullCurl = fullCurl
//        self.baseCurl = baseCurl
//        self.tipCurl = tipCurl
//        self.pinch = pinch
//        self.spread = spread
//    }
    init(finger: HVJointGroupOptions, fingerShapeTypes: Set<HVFingerShape.FingerShapeType>, joints: [HandSkeleton.JointName: HVJointInfo], configuration: HVFingerShape.FingerShapeConfiguration = .detault) {
        self.finger = finger
        self.fingerShapeTypes = fingerShapeTypes
        
        func linearInterpolate(min: Float, max: Float, t: Float) -> Float {
            let x = t < min ? min : (t > max ? max : t)
            return (x - min) / (max - min)
        }
        
        
        if fingerShapeTypes.contains(.baseCurl), HVJointGroupOptions.all.contains(finger) {
            let joint = joints[finger.jointGroupNames.first!]!
            let xAxis = joint.transformToParent.columns.0
            let angle = atan2(xAxis.x, xAxis.y)
            self.baseCurl = linearInterpolate(min: configuration.minimumBaseCurlDegrees, max: configuration.maximumBaseCurlDegrees, t: angle / .pi * 180)
            print(angle,baseCurl)
        } else {
            self.baseCurl = 0
        }
        tipCurl = 0
        fullCurl = 0
        pinch = 0
        spread = 0
    }
}

public extension Set<HVFingerShape.FingerShapeType> {
    public static let all: Set<HVFingerShape.FingerShapeType> = [.baseCurl, .tipCurl, .fullCurl, .pinch, .spread]
}
