public final class SQLCreateTableBuilder<Connection>: SQLQueryBuilder, SQLColumnBuilder
    where Connection: DatabaseQueryable, Connection.Query: SQLQuery
{
    /// See `SQLColumnBuilder`.
    public typealias ColumnDefinition = Connection.Query.CreateTable.ColumnDefinition
    
    /// `CreateTable` query being built.
    public var createTable: Connection.Query.CreateTable
    
    /// See `SQLQueryBuilder`.
    public var connection: Connection
    
    /// See `SQLQueryBuilder`.
    public var query: Connection.Query {
        return .createTable(createTable)
    }
    
    /// See `SQLColumnBuilder`.
    public var columns: [Connection.Query.CreateTable.ColumnDefinition] {
        get { return createTable.columns }
        set { createTable.columns = newValue }
    }
    
    /// Creates a new `SQLCreateTableBuilder`.
    public init(_ createTable: Connection.Query.CreateTable, on connection: Connection) {
        self.createTable = createTable
        self.connection = connection
    }
    
    
    /// If the "TEMP" or "TEMPORARY" keyword occurs between the "CREATE" and "TABLE" then the new table is created in the temp database.
    public func temporary() -> Self {
        createTable.temporary = true
        return self
    }
    
    /// It is usually an error to attempt to create a new table in a database that already contains a table, index or view of the
    /// same name. However, if the "IF NOT EXISTS" clause is specified as part of the CREATE TABLE statement and a table or view
    /// of the same name already exists, the CREATE TABLE command simply has no effect (and no error message is returned). An
    /// error is still returned if the table cannot be created because of an existing index, even if the "IF NOT EXISTS" clause is
    /// specified.
    public func ifNotExists() -> Self {
        createTable.ifNotExists = true
        return self
    }
}

// MARK: Connection

extension DatabaseQueryable where Query: SQLQuery {
    /// Creates a new `SQLCreateTableBuilder`.
    ///
    ///     conn.create(table: Planet.self)...
    ///
    /// - parameters:
    ///     - table: Table to create.
    /// - returns: `CreateTableBuilder`.
    public func create<Table>(table: Table.Type) -> SQLCreateTableBuilder<Self>
        where Table: SQLTable
    {
        return .init(.createTable(.table(Table.self)), on: self)
    }
}
