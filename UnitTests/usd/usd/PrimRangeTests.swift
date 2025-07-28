//
//  UsdPrimRangeTests.swift
//  UsdInteropTests
//
//  Created by Maddy Adams on 8/8/23.
//

import XCTest
import OpenUSD

final class UsdPrimRangeTests: XCTestCase {
    func testTraverse() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)
        
        let expected = ["/Hello", "/Hello/World", "/Goodbye"]
        var i = 0
        for prim in stage.Traverse() {
            XCTAssertEqual(expected[i], String(prim.GetPath().GetAsString()))
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }
    
    func testTraverseWithIterator() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/Hello", false), ("/Hello/World", false), ("/Goodbye", false)]
        var i = 0
        for (iter, prim) in stage.Traverse().withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }
    
    func testTraverseWithPruning() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/Hello", false), ("/Goodbye", false)]
        var i = 0
        for (iter, prim) in stage.Traverse().withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
            if String(prim.GetPath().GetAsString()) == "/Hello" {
                iter.PruneChildren()
            }
        }
        XCTAssertEqual(i, expected.count)
    }

    func testPreAndPostVisit() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = ["/", "/Hello", "/Hello/World", "/Hello/World", "/Hello",
                        "/Goodbye", "/Goodbye", "/"]
        var i = 0
        for prim in pxr.UsdPrimRange.PreAndPostVisit(stage.GetPseudoRoot()) {
            XCTAssertEqual(expected[i], String(prim.GetPath().GetAsString()))
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }
    
    func testPreAndPostVisitWithIterator() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/", false), ("/Hello", false), ("/Hello/World", false), ("/Hello/World", true), ("/Hello", true),
                        ("/Goodbye", false), ("/Goodbye", true), ("/", true)]
        var i = 0
        for (iter, prim) in pxr.UsdPrimRange.PreAndPostVisit(stage.GetPseudoRoot()).withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }

    func testPreAndPostVisitWithPruning() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/", false), ("/Hello", false), ("/Hello", true),
                        ("/Goodbye", false), ("/Goodbye", true), ("/", true)]
        var i = 0
        for (iter, prim) in pxr.UsdPrimRange.PreAndPostVisit(stage.GetPseudoRoot()).withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
            if String(prim.GetPath().GetAsString()) == "/Hello" {
                iter.PruneChildren()
            }
        }
        XCTAssertEqual(i, expected.count)
    }

    func testAllPrims() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)
        
        let expected = ["/", "/Hello", "/Hello/World", "/Goodbye", "/Goodbye/Earth"]
        var i = 0
        for prim in pxr.UsdPrimRange.AllPrims(stage.GetPseudoRoot()) {
            XCTAssertEqual(expected[i], String(prim.GetPath().GetAsString()))
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }
    
    func testAllPrimsWithIterator() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/", false), ("/Hello", false), ("/Hello/World", false), ("/Goodbye", false), ("/Goodbye/Earth", false)]
        var i = 0
        for (iter, prim) in pxr.UsdPrimRange.AllPrims(stage.GetPseudoRoot()).withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }

    func testAllPrimsWithPruning() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/", false), ("/Hello", false), ("/Goodbye", false), ("/Goodbye/Earth", false)]
        var i = 0
        for (iter, prim) in pxr.UsdPrimRange.AllPrims(stage.GetPseudoRoot()).withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
            if String(prim.GetPath().GetAsString()) == "/Hello" {
                iter.PruneChildren()
            }
        }
        XCTAssertEqual(i, expected.count)
    }
    
    func testAllPrimsPreAndPostVisit() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = ["/", "/Hello", "/Hello/World", "/Hello/World", "/Hello",
                        "/Goodbye", "/Goodbye/Earth", "/Goodbye/Earth", "/Goodbye", "/"]
        var i = 0
        for prim in pxr.UsdPrimRange.AllPrimsPreAndPostVisit(stage.GetPseudoRoot()) {
            XCTAssertEqual(expected[i], String(prim.GetPath().GetAsString()))
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }
    
    func testAllPrimsPreAndPostVisitWithIterator() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/", false), ("/Hello", false), ("/Hello/World", false), ("/Hello/World", true), ("/Hello", true),
                        ("/Goodbye", false), ("/Goodbye/Earth", false), ("/Goodbye/Earth", true), ("/Goodbye", true), ("/", true)]
        var i = 0
        for (iter, prim) in pxr.UsdPrimRange.AllPrimsPreAndPostVisit(stage.GetPseudoRoot()).withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }

    func testAllPrimsPreAndPostVisitWithPruning() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/", false), ("/Hello", false), ("/Hello", true),
                        ("/Goodbye", false), ("/Goodbye/Earth", false), ("/Goodbye/Earth", true), ("/Goodbye", true), ("/", true)]
        var i = 0
        for (iter, prim) in pxr.UsdPrimRange.AllPrimsPreAndPostVisit(stage.GetPseudoRoot()).withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
            if String(prim.GetPath().GetAsString()) == "/Hello" {
                iter.PruneChildren()
            }
        }
        XCTAssertEqual(i, expected.count)
    }
    
    func testStage() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = ["/Hello", "/Hello/World", "/Goodbye"]
        var i = 0
        for prim in pxr.UsdPrimRange.Stage(Overlay.TfWeakPtr(stage), Overlay.UsdPrimDefaultPredicate) {
            XCTAssertEqual(expected[i], String(prim.GetPath().GetAsString()))
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }
    
    func testStageWithIterator() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/Hello", false), ("/Hello/World", false), ("/Goodbye", false)]
        var i = 0
        for (iter, prim) in pxr.UsdPrimRange.Stage(Overlay.TfWeakPtr(stage), Overlay.UsdPrimDefaultPredicate).withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
        }
        XCTAssertEqual(i, expected.count)
    }
    
    func testStageWithPruning() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/Hello", "Scope")
        stage.DefinePrim("/Hello/World", "Scope")
        stage.DefinePrim("/Goodbye", "Scope")
        stage.DefinePrim("/Goodbye/Earth", "Scope")
        stage.DefinePrim("/Goodbye/Earth/AndMoon", "Scope")
        stage.GetPrimAtPath("/Goodbye/Earth").SetActive(false)

        let expected = [("/Hello", false), ("/Goodbye", false)]
        var i = 0
        for (iter, prim) in pxr.UsdPrimRange.Stage(Overlay.TfWeakPtr(stage), Overlay.UsdPrimDefaultPredicate).withIterator() {
            XCTAssertEqual(expected[i].0, String(prim.GetPath().GetAsString()))
            XCTAssertEqual(expected[i].1, iter.IsPostVisit())
            i += 1
            if String(prim.GetPath().GetAsString()) == "/Hello" {
                iter.PruneChildren()
            }

        }
        XCTAssertEqual(i, expected.count)
    }
}
