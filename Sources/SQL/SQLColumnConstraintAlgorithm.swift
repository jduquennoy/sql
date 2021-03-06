public protocol SQLColumnConstraintAlgorithm: SQLSerializable {
    associatedtype Expression: SQLExpression
    associatedtype Collation: SQLCollation
    associatedtype PrimaryKeyDefault: SQLPrimaryKeyDefault
    associatedtype ForeignKey: SQLForeignKey
    static func primaryKey(_ `default`: PrimaryKeyDefault?) -> Self
    static var notNull: Self { get }
    static var unique: Self { get }
    static func check(_ expression: Expression) -> Self
    static func collate(_ collation: Collation) -> Self
    static func `default`(_ expression: Expression) -> Self
    static func foreignKey(_ foreignKey: ForeignKey) -> Self
}

// MARK: Generic

public enum GenericSQLColumnConstraintAlgorithm<Expression, Collation, PrimaryKeyDefault, ForeignKey>: SQLColumnConstraintAlgorithm
    where Expression: SQLExpression, Collation: SQLCollation, PrimaryKeyDefault: SQLPrimaryKeyDefault, ForeignKey: SQLForeignKey
{
    public typealias `Self` = GenericSQLColumnConstraintAlgorithm<Expression, Collation, PrimaryKeyDefault, ForeignKey>
    
    /// See `SQLColumnConstraintAlgorithm`.
    public static func primaryKey(_ `default`: PrimaryKeyDefault?) -> Self {
        return ._primaryKey(`default`)
    }
    
    /// See `SQLColumnConstraintAlgorithm`.
    public static var notNull: Self {
        return ._notNull
    }
    
    /// See `SQLColumnConstraintAlgorithm`.
    public static var unique: Self {
        return ._unique
    }
    
    /// See `SQLColumnConstraintAlgorithm`.
    public static func check(_ expression: Expression) -> Self {
        return ._check(expression)
    }
    
    /// See `SQLColumnConstraintAlgorithm`.
    public static func collate(_ collation: Collation) -> Self {
        return ._collate(collation)
    }
    
    /// See `SQLColumnConstraintAlgorithm`.
    public static func `default`(_ expression: Expression) -> Self {
        return ._default(expression)
    }
    
    /// See `SQLColumnConstraintAlgorithm`.
    public static func foreignKey(_ foreignKey: ForeignKey) -> Self {
        return ._foreignKey(foreignKey)
    }
    
    case _primaryKey(PrimaryKeyDefault?)
    case _notNull
    case _unique
    case _check(Expression)
    case _collate(Collation)
    case _default(Expression)
    case _foreignKey(ForeignKey)
    
    /// See `SQLSerializable`.
    public func serialize(_ binds: inout [Encodable]) -> String {
        switch self {
        case ._primaryKey(let `default`):
            if let d = `default` {
                return "PRIMARY KEY " + d.serialize(&binds)
            } else {
                return "PRIMARY KEY"
            }
        case ._notNull: return "NOT NULL"
        case ._unique: return "UNIQUE"
        case ._check(let expression):
            return "CHECK (" + expression.serialize(&binds) + ")"
        case ._collate(let collation):
            return "COLLATE " + collation.serialize(&binds)
        case ._default(let expression):
            return "DEFAULT " + expression.serialize(&binds)
        case ._foreignKey(let foreignKey): return "REFERENCES " + foreignKey.serialize(&binds)
        }
    }
}
