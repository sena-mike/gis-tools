#if !os(Linux)
import CoreLocation
#endif
import Foundation
import XCTest

@testable import GISTools

final class PolygonTests: XCTestCase {

    private let polygonJsonNoHole = """
        {
            "type": "Polygon",
            "coordinates": [
                [
                    [100.0, 0.0],
                    [101.0, 0.0],
                    [101.0, 1.0],
                    [100.0, 1.0],
                    [100.0, 0.0]
                ]
            ]
        }
        """

        let polygonJsonWithHoles = """
        {
            "type": "Polygon",
            "coordinates": [
                [
                    [100.0, 0.0],
                    [101.0, 0.0],
                    [101.0, 1.0],
                    [100.0, 1.0],
                    [100.0, 0.0]
                ],
                [
                    [100.8, 0.8],
                    [100.8, 0.2],
                    [100.2, 0.2],
                    [100.2, 0.8],
                    [100.8, 0.8]
                ]
            ]
        }
        """

    func testLoadJson() {
        let polygonNoHole = Polygon(jsonString: polygonJsonNoHole)
        XCTAssertNotNil(polygonNoHole)
        XCTAssertEqual(polygonNoHole?.type, GeoJsonType.polygon)
        XCTAssertEqual(polygonNoHole?.coordinates, [[Coordinate3D(latitude: 0.0, longitude: 100.0), Coordinate3D(latitude: 0.0, longitude: 101.0), Coordinate3D(latitude: 1.0, longitude: 101.0), Coordinate3D(latitude: 1.0, longitude: 100.0), Coordinate3D(latitude: 0.0, longitude: 100.0)]])

        let polygonWithHoles = Polygon(jsonString: polygonJsonWithHoles)
        XCTAssertNotNil(polygonWithHoles)
        XCTAssertEqual(polygonWithHoles?.type, GeoJsonType.polygon)
        XCTAssertEqual(polygonWithHoles?.coordinates, [[Coordinate3D(latitude: 0.0, longitude: 100.0), Coordinate3D(latitude: 0.0, longitude: 101.0), Coordinate3D(latitude: 1.0, longitude: 101.0), Coordinate3D(latitude: 1.0, longitude: 100.0), Coordinate3D(latitude: 0.0, longitude: 100.0)], [Coordinate3D(latitude: 0.8, longitude: 100.8), Coordinate3D(latitude: 0.2, longitude: 100.8), Coordinate3D(latitude: 0.2, longitude: 100.2), Coordinate3D(latitude: 0.8, longitude: 100.2), Coordinate3D(latitude: 0.8, longitude: 100.8)]])
    }

    func testCreateJson() {
        let polygonNoHole = Polygon([[Coordinate3D(latitude: 0.0, longitude: 100.0), Coordinate3D(latitude: 0.0, longitude: 101.0), Coordinate3D(latitude: 1.0, longitude: 101.0), Coordinate3D(latitude: 1.0, longitude: 100.0), Coordinate3D(latitude: 0.0, longitude: 100.0)]])!
        let polygonWithHoles = Polygon([
            [Coordinate3D(latitude: 0.0, longitude: 100.0), Coordinate3D(latitude: 0.0, longitude: 101.0), Coordinate3D(latitude: 1.0, longitude: 101.0), Coordinate3D(latitude: 1.0, longitude: 100.0), Coordinate3D(latitude: 0.0, longitude: 100.0)],
            [Coordinate3D(latitude: 1.0, longitude: 100.8), Coordinate3D(latitude: 0.0, longitude: 100.8), Coordinate3D(latitude: 0.0, longitude: 100.2), Coordinate3D(latitude: 1.0, longitude: 100.2), Coordinate3D(latitude: 1.0, longitude: 100.8)]])!

        let stringNoHole = polygonNoHole.asJsonString()!
        XCTAssert(stringNoHole.contains("\"type\":\"Polygon\""))
        XCTAssert(stringNoHole.contains("\"coordinates\":[[[100,0],[101,0],[101,1],[100,1],[100,0]]]"))

        let stringWithHoles = polygonWithHoles.asJsonString()!
        XCTAssert(stringWithHoles.contains("\"type\":\"Polygon\""))
        XCTAssert(stringWithHoles.contains("\"coordinates\":[[[100,0],[101,0],[101,1],[100,1],[100,0]],[[100.8,1],[100.8,0],[100.2,0],[100.2,1],[100.8,1]]]"))
    }

    static var allTests = [
        ("testLoadJson", testLoadJson),
        ("testCreateJson", testCreateJson),
    ]

}
