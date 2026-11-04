unit uOrderModel;

interface
type
  TTaxiOrder = class
    private
      FId: integer;
      FDriverName: string;
      FDestination: string;
      FPrice: Currency;
      FCreatedAt: TDateTime;
    public
      property Id: Integer read FId write FId;
      property DriverName: string read FDriverName write FDriverName;
      property Destination: string read FDestination write FDestination;
      property Price: Currency read FPrice write FPrice;
      property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
  end;
implementation

end.
