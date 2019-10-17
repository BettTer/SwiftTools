//
//  MusicConverter.swift
//  SoundsFilter
//
//  Created by X Young. on 2018/10/12.
//  Copyright © 2018 X Young. All rights reserved.
//

import UIKit
import AVFoundation
import AudioKit

// MARK: - 频率相关
class MusicConverter: NSObject {
    /// 通过一个音高字符串("C4")获取该音高的频率的数组index
    private static func getFrequencyArrayIndexFrom(pitchName: String) -> Int {
        var pitchScale = 0
        
        for index in 0 ..< NoteNamesWithSharps.count {
            let scale = NoteNamesWithSharps[index]
            
            if (pitchName.range(of: scale) != nil) {
                pitchScale = index
            }
        }
        
        return pitchScale
    }
    
    /// 通过一个音高字符串("C4")获取该音高的频率
    static func getFrequencyFrom(pitchName: String) -> Double {
        let pitchScale = self.getFrequencyArrayIndexFrom(pitchName: pitchName)
        
                let octaveCountString = pitchName.cutWithPlaces(startPlace: pitchName.count - 1, endPlace: pitchName.count)
        
        let needExponentialCoefficient = pow(2, Double(octaveCountString)!)
        
        return NoteFrequencies[pitchScale] * needExponentialCoefficient
        
    }
    
    /// 通过一个音高Number获取该音高的频率
    static func getFrequencyFrom(noteNumber: UInt8) -> Float {
        return Float(440.0 * pow(2.0, (Double(noteNumber) - 69.0)/12.0))
    }
    
}

// MARK: - 音符相关
extension MusicConverter {
    /// 给定一个音阶与八度信息 返回音高midi音符数字
    static private func getMidiNote(_ scaleName: String, octaveCount: Int, isRising: Bool?) -> UInt8 {
        var tmpScale: UInt8 = 0
        let tmpOctaveCount = UInt8(octaveCount)
        
        
        switch scaleName {
        case "A":
            tmpScale = 9
            
        case "B":
            tmpScale = 11
            
        case "C":
            tmpScale = 0
            
        case "D":
            tmpScale = 2
            
        case "E":
            tmpScale = 4
            
        case "F":
            tmpScale = 5
            
        case "G":
            tmpScale = 7
            
        default:
            return 0
        }
        
        if isRising != true {
            return tmpScale + (tmpOctaveCount + 2) * 12
            
        }else {
            return tmpScale + (tmpOctaveCount + 2) * 12 + 1
            
        }
        
    }// funcEnd
    
    /// 通过一个音符字符串("C4")获取音高
    static func getMidiNoteFromString(_ noteString: String) -> UInt8 {
        let scale = noteString.cutWithPlaces(startPlace: 0, endPlace: 1)
        
        let octaveCountString = noteString.cutWithPlaces(startPlace: noteString.count - 1, endPlace: noteString.count)
        
        let isRising: Bool = {
            if noteString.range(of: "#") == nil {
                return false
                
            }
            
            return true
            
        }()
        
        return self.getMidiNote(scale, octaveCount: Int(octaveCountString)!, isRising: isRising)
        
    }
    
    /// 通过一个音高数字("38")获取音高字符串
    static func getMidiNoteStringFromNum(_ noteNum: UInt8) -> String {
        let noteNumInt = Int(noteNum)
        
        let pitchNameIndex = noteNumInt % 12
        
        let octaveCount = (noteNumInt - pitchNameIndex) / 12 - 2
        
        
        return NoteNamesWithSharps[pitchNameIndex] + String(octaveCount)

    }
    
    /// 获取两个Pitch间的Pitches
    static func getPitchesFrom(pitchA: String, pitchB: String) -> [String] {
        let noteNumA = self.getMidiNoteFromString(pitchA)
        let noteNumB = self.getMidiNoteFromString(pitchB)
        
        let range: ClosedRange<UInt8> = {
            if noteNumA >= noteNumB {
                return noteNumB ... noteNumA
                
            }else {
                return noteNumA ... noteNumB
                
            }
            
        }()
        
        var pitches: [String] = []
        
        for noteNum in range {
            pitches.append(self.getMidiNoteStringFromNum(noteNum))
            
        }
        
        return pitches
        
    }
    
}

extension MusicConverter {
    static func beatDuration(tempoBPM: Double, beatCount: Int) -> Double {
        return 240 / tempoBPM / Double(beatCount)
        
    }
    
}

extension MusicConverter {
    /// 拼接音频文件
    static func mergeAudioFiles(audioFileUrls: [URL],
                                savePathDirectory: FileManager.SearchPathDirectory = FileManager.SearchPathDirectory.documentDirectory,
                                finalFileName: String,
                                callBack: @escaping (Bool, URL?) -> Void) {
        let composition = AVMutableComposition()
        let documentDirectoryURL = FileManager.default.urls(for: savePathDirectory, in: .userDomainMask).first!
        let finalURL = documentDirectoryURL.appendingPathComponent(finalFileName + ".m4a")
        
        audioFileUrls.forEach { (fileURL) in
            
            let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
            let asset = AVURLAsset(url: fileURL)
            
            let track = asset.tracks(withMediaType: AVMediaType.audio)[0]
            let timeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 600), duration: track.timeRange.duration)
            try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
        
        }
        
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileType.m4a
        assetExport?.outputURL = finalURL
        assetExport?.exportAsynchronously(completionHandler: {
            
            switch assetExport!.status {
            case .completed:
                callBack(true, finalURL)
                
            default:
                print("导出中...")
                
            }
        })

    }
    
    /// 重叠音频文件
    static func overlapAudioFiles(audioFileURLs: [URL],
                                  savePathDirectory: FileManager.SearchPathDirectory = FileManager.SearchPathDirectory.documentDirectory,
                                  finalFileName: String,
                                  mediaType: String = "m4a",
                                  callBack: @escaping (Bool, String) -> Void) -> Void {
        
        let documentDirectoryURL = FileManager.default.urls(for: savePathDirectory, in: .userDomainMask).first!
        
        var ownAudioFileURLs: [URL] = []
        
        for fileURL in audioFileURLs {
            
            if fileURL.path.contains("AboutAK") == true {
                let currentURL = documentDirectoryURL.appendingPathComponent(fileURL.lastPathComponent)
                ownAudioFileURLs.append(currentURL)
                
            }else {
                ownAudioFileURLs.append(fileURL)
                
            }

        }
        
        
        let resultURL = documentDirectoryURL.appendingPathComponent(finalFileName + ".m4a")
        
        let composition = AVMutableComposition()
        var parametersArray: [AVAudioMixInputParameters] = []
        
        let finalAction = {
            if parametersArray.count == ownAudioFileURLs.count {
                
                let audioMix = AVMutableAudioMix.init()
                audioMix.inputParameters = parametersArray
                
                let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
                assetExport.audioMix = audioMix
                assetExport.outputFileType = .m4a
                assetExport.outputURL = resultURL
                
                assetExport.exportAsynchronously {
                    
                    switch assetExport.status {
                    case .failed:
                        callBack(false, "导出失败")
                        
                    case .completed:
                        print("完成")
                        
                        if mediaType != "m4a" {
                            var options = AKConverter.Options()
                            options.format = mediaType
                            options.sampleRate = 44100
                            options.bitDepth = 16
                            
                            let finalURL = documentDirectoryURL.appendingPathComponent(finalFileName + "." + mediaType)
                            
                            let converter = AKConverter(inputURL: resultURL, outputURL: finalURL, options: options)
                            
                            converter.start(completionHandler: { (error) in
                                if error == nil {
                                    callBack(true, finalURL.path)
                                    
                                }else {
                                    callBack(false, "")
                                    
                                }
                            })
                            
                        }else {
                            callBack(true, resultURL.path)
                            
                        }
                        
                    default:
                        print("导出中...")
                        
                    }
                }
                
            }
        }
        
        ownAudioFileURLs.forEach { (fileURL) in
            
            let songAsset = AVURLAsset.init(url: fileURL)
            let mutableTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
            
            songAsset.loadValuesAsynchronously(
                forKeys: ["tracks"],
                completionHandler: {
                    var error: NSError?
                    let status = songAsset.statusOfValue(forKey: "tracks", error: &error)
                    
                    if status == .loaded {
                        let sourceAudioTrack = songAsset.tracks(withMediaType: AVMediaType.audio)[0]
                        
                        let startTime = CMTimeMakeWithSeconds(0, preferredTimescale: 1)
                        let trackDuration = songAsset.duration
                        let tRange = CMTimeRange.init(start: startTime, duration: trackDuration)
                        
                        let trackMixParameters = AVMutableAudioMixInputParameters.init(track: mutableTrack)
                        trackMixParameters.setVolume(1, at: startTime)
                        
                        if NetRequest.shared.getUploadFileType(filePath: fileURL.path) == .Drum {
                            try! mutableTrack.insertTimeRange(tRange, of: sourceAudioTrack, at: CMTimeMakeWithSeconds(Float64(0.02), preferredTimescale: Int32(44100)))
                            
                        }else {
                            try! mutableTrack.insertTimeRange(tRange, of: sourceAudioTrack, at: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(44100)))
                            
                            
                        }
                        
                        parametersArray.append(trackMixParameters)
                        
                        finalAction()
                        
                    }
            })
            
        }
    }
    

    
}

extension MusicConverter {
    /// 声音频率表(对应)
    static let NoteFrequencies: [Double] = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    
    /// 音阶表
    static let NoteNamesWithSharps: [String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    
}
