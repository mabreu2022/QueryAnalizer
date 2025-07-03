unit uProjetoItem;

interface

uses
  System.Generics.Collections, uSQLItem;

type
  TProjetoItem = class
  public
    NomeProjeto: string;
    SQLs: TObjectList<TSQLItem>;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TProjetoItem.Create;
begin
  SQLs := TObjectList<TSQLItem>.Create(True);
end;

destructor TProjetoItem.Destroy;
begin
  SQLs.Free;
  inherited;
end;

end.
