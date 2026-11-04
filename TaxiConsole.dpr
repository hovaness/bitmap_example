program TaxiApp;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  uOrderModel in 'uOrderModel.pas',
  uOrderRepository in 'uOrderRepository.pas',
  uTaxiService in 'uTaxiService.pas';

var
  Repo: TOrderRepository;
  Service: TTaxiBusinessService;
  TotalRevenue: Currency;
begin
  // Инициализируем переменные в nil, чтобы в блоке finally случайно не вызвать Free у мусора
  Repo := nil;
  Service := nil;
  try
    try
      Repo := TOrderRepository.Create;
      Service := TTaxiBusinessService.Create(Repo);

      Writeln('--- Вычисление финансовых показателей ---');
      TotalRevenue := Service.CalculateTotalRevenue;
      Writeln(Format('Общая выручка компании: %f руб.', [TotalRevenue]));
    except
      on E: Exception do
        Writeln('Критический сбой приложения: ', E.Message);
    end;
  finally
    // Освобождаем память строго в обратном порядке создания
    Service.Free;
    Repo.Free;
  end;

  Readln;
end.

