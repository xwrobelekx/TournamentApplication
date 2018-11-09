//
//  PlayerController.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/8/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation


class PlayerController {
    
    static let shared = PlayerController()
    private init() {}
    
    
    func convertToPairs<T>(array: [T]) -> [[T]]{
        var index = 0
        var masterarray = [[T]]()
        var pair = [T]()
        if array.count % 2 == 0 {
            var counter = 1
            while index <= (array.count - 1) {
                if counter <= 2 {
                    counter += 1
                    pair.append(array[index])
                    index += 1
                } else {
                    masterarray.append(pair)
                    counter = 1
                    pair = []
                }
            }
            masterarray.append(pair)
        } else {
            var counter = 2
            while index <= (array.count - 1) {
                if counter <= 2 {
                    counter += 1
                    pair.append(array[index])
                    index += 1
                } else {
                    masterarray.append(pair)
                    counter = 1
                    pair = []
                }
            }
            masterarray.append(pair)
        }
        return masterarray
    }
    
    
    func convertToSingleArray<T>(doubleArray: [[T]]) -> [T] {
        var tempArray = [T]()
        
        for singleArray in doubleArray {
            for item in singleArray {
                tempArray.append(item)
            }
        }
        return tempArray
    }
    
    
    func insert(player: Player, to array: [[Player]], at index: Int) -> [[Player]]{
        var tempSingleArray = convertToSingleArray(doubleArray: array)
        tempSingleArray.insert(player, at: index)
        return convertToPairs(array: tempSingleArray)
    }
    
    
    func shufflePlayers(at: [[Player]]) -> [[Player]]{
        var tempSingleArray = convertToSingleArray(doubleArray: at)
        tempSingleArray.shuffle()
        return convertToPairs(array: tempSingleArray)
    }
    
    
    
    
}
