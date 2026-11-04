unit uOrderRepository;

interface
uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  FireDAC.Phys.PG,
  uOrderModel;

type
  TOrderRepository = class
    private FConnection: TFDConnection;
    public
      constructor Create;
      destructor Destroy; override;
      function GetActiveOrders: TObjectList<TTaxiOrder>;
  end;

implementation
//constructor
constructor TOrderRepository.Create;
begin
    inherited Create;
    FConnection:= TFDConnection.Create(nil);
    FConnection.DriverName := 'PG';
    FConnection.Params.Values['Server'] := 'localhost';
    FConnection.Params.Values['Database'] := 'bit_master';
    FConnection.Params.Values['User_Name'] := 'postgres';
    FConnection.Params.Values['Password'] := 'root';
end;

//destructor
destructor TOrderRepository.Destroy;
begin
  FConnection.Free;
  inherited Destroy;
end;

function TOrderRepository.GetActiveOrders: TObjectList<TTaxiOrder>;
var
  Query: TFDQuery;
  Order: TTaxiOrder;
begin
  Result := TObjectList<TTaxiOrder>.Create(True);

  If not FConnection.Connected then Exit; //подключение не активно
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := FConnection;
    Query.SQL.Text := ' WITH HighValueOrders AS ( ' +
    ' SELECT id, driver_name, destination, price, created_at ' +
    ' FROM orders WHERE price > 100) ' +
    'SELECT * FROM HighValueOrders ORDER BY created_at DESC';
    Query.Open;

    while not Query.Eof do
    begin
      Order := TTaxiOrder.Create;
      Order.Id := Query.FieldByName('id').AsInteger;
      Order.DriverName := Query.FieldByName('driver_name').AsString;
      Order.Destination := Query.FieldByName('destination').AsString;
      Order.Price := Query.FieldByName('price').AsCurrency;
      Order.CreatedAt := Query.FieldByName('created_at').AsDateTime;
      Result.Add(Order);
      Query.Next
    end;
  finally
    Query.Free;
  end;
end;

end.
