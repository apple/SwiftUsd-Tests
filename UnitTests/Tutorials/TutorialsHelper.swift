//
//  TutorialsHelper.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/6/23.
//

import Foundation

class TutorialsHelper: TemporaryDirectoryHelper {    
    class var name: String { "" }
    func expected(_ n: Int) throws -> String {
        try contentsOfResource(subPath: "Tutorials/\(Self.name)/\(n).txt")
    }
}
