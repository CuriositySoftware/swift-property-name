import Implementation
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

private let testMacros: [String: Macro.Type] = [
    "PropertyNameAccessible": PropertyNameMacro.self,
]

final class PropertyNameTests: XCTestCase {
    func testBasic() throws {
        assertMacroExpansion(
            """
            @PropertyNameAccessible
            struct Foo {
                var name: String
            }
            """
            ,
            expandedSource: """
            struct Foo {
                var name: String
            }

            extension Foo {
                static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
                    switch keyPath {
                    case \\.name:
                        return "name"
                    default:
                        fatalError()
                    }
                }
            }
            """, macros: testMacros
        )
    }

    func testAccessPublic() throws {
        assertMacroExpansion(
            """
            @PropertyNameAccessible
            public struct Foo {
                var name: String
            }
            """
            ,
            expandedSource: """
            public struct Foo {
                var name: String
            }

            public extension Foo {
                static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
                    switch keyPath {
                    case \\.name:
                        return "name"
                    default:
                        fatalError()
                    }
                }
            }
            """, macros: testMacros
        )
    }

    func testAccessPrivate() throws {
        assertMacroExpansion(
            """
            @PropertyNameAccessible
            private struct Foo {
                var name: String
            }
            """
            ,
            expandedSource: """
            private struct Foo {
                var name: String
            }

            private extension Foo {
                static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
                    switch keyPath {
                    case \\.name:
                        return "name"
                    default:
                        fatalError()
                    }
                }
            }
            """, macros: testMacros
        )
    }

    func testAccessPrivatePublic() throws {
        assertMacroExpansion(
            """
            @PropertyNameAccessible
            private public struct Foo {
                var name: String
            }
            """
            ,
            expandedSource: """
            private public struct Foo {
                var name: String
            }

            private public extension Foo {
                static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
                    switch keyPath {
                    case \\.name:
                        return "name"
                    default:
                        fatalError()
                    }
                }
            }
            """, macros: testMacros
        )
    }

    func testBindingsListSyntax() throws {
        assertMacroExpansion(
            """
            @PropertyNameAccessible
            struct Foo {
                var name: String, age: Int
            }
            """
            ,
            expandedSource: """
            struct Foo {
                var name: String, age: Int
            }

            extension Foo {
                static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
                    switch keyPath {
                    case \\.name:
                        return "name"
                    case \\.age:
                        return "age"
                    default:
                        fatalError()
                    }
                }
            }
            """, macros: testMacros
        )
    }

    func testClosure() throws {
        assertMacroExpansion(
            """
            @PropertyNameAccessible
            struct Foo {
                var name: () -> String
                func age() -> Int
            }
            """
            ,
            expandedSource: """
            struct Foo {
                var name: () -> String
                func age() -> Int
            }

            extension Foo {
                static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
                    switch keyPath {
                    case \\.name:
                        return "name"
                    default:
                        fatalError()
                    }
                }
            }
            """, macros: testMacros
        )
    }

    func testClassBasic() throws {
        assertMacroExpansion(
            """
            @PropertyNameAccessible
            class Foo {
                var name: String
            }
            """
            ,
            expandedSource: """
            class Foo {
                var name: String
            }

            extension Foo {
                static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
                    switch keyPath {
                    case \\.name:
                        return "name"
                    default:
                        fatalError()
                    }
                }
            }
            """, macros: testMacros
        )
    }

    func testActorBasic() throws {
        assertMacroExpansion(
            """
            @PropertyNameAccessible
            actor Foo {
                var name: String
            }
            """
            ,
            expandedSource: """
            actor Foo {
                var name: String
            }

            extension Foo {
                static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
                    switch keyPath {
                    case \\.name:
                        return "name"
                    default:
                        fatalError()
                    }
                }
            }
            """, macros: testMacros
        )
    }
}
