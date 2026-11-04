unit uTaxiService;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  uOrderModel,
  uOrderRepository;

type
  TTaxiBusinessService = class
  private
    FRepo: TOrderRepository;
    procedure LogError(const AMsg: string);
  public
    constructor Create(ARepo: TOrderRepository);
    function CalculateTotalRevenue: Currency;
  end;

implementation

constructor TTaxiBusinessService.Create(ARepo: TOrderRepository);
begin
  inherited Create;
  FRepo := ARepo;
end;

procedure TTaxiBusinessService.LogError(const AMsg: string);
begin
  Writeln('[ERROR LOG] ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' : ' + AMsg);
end;

function TTaxiBusinessService.CalculateTotalRevenue: Currency;
var
  Orders: TObjectList<TTaxiOrder>;
  Order: TTaxiOrder;
begin
  Result := 0;
  try
    Orders := FRepo.GetActiveOrders;
    try
      for Order in Orders do
        Result := Result + Order.Price;
    finally
      Orders.Free; // Уничтожает список И все TTaxiOrder внутри него автоматически!
    end;
  except
    on E: Exception do
    begin
      LogError('Ошибка при расчете выручки: ' + E.Message);
      raise;
    end;
  end;
end;

end.

