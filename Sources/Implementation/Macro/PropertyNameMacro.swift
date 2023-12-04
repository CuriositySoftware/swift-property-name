import SwiftSyntax
import SwiftSyntaxMacros
import Foundation

public enum PropertyNameMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard
            declaration.is(StructDeclSyntax.self) ||
            declaration.is(ClassDeclSyntax.self) ||
            declaration.is(ActorDeclSyntax.self)
        else {
            throw Diagnostics.appliedTypeFail
        }

        let variableDeclarations = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }

        guard !variableDeclarations.isEmpty else {
            return []
        }

        return [
            ExtensionDeclSyntax(
                modifiers: declaration.modifiers,
                extendedType: type,
                memberBlock: try MemberBlockSyntax {
                    try FunctionDeclSyntax(
                    """
                    static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
                        switch keyPath {
                        \(raw:  variables(with: variableDeclarations))
                        default:
                            fatalError()
                        }
                    }
                    """
                    )
                }
            )
        ]
    }
}

private extension PropertyNameMacro {
    static func makeExtensionSyntax(
        extendedType: TypeSyntaxProtocol,
        modifiers: DeclModifierListSyntax,
        functionDeclSyntax: FunctionDeclSyntax
    ) -> ExtensionDeclSyntax {
        .init(
            modifiers: modifiers,
            extendedType: extendedType,
            memberBlock: MemberBlockSyntax {
                functionDeclSyntax
            }
        )
    }

    static func variables(
        with variableDeclarations: [VariableDeclSyntax]
    ) -> String {
        variableDeclarations
            .flatMap { $0.bindings }
            .compactMap { $0.pattern.as(IdentifierPatternSyntax.self) }
            .map { $0.identifier.text }
            .reduce("") { result, text in
                result + """
                case \\.\(text): return "\(text)"
                """
            }
    }
}
