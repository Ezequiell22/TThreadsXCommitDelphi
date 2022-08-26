unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Comp.Client;

type
  TForm1 = class(TForm)
    bt_start: TButton;
    Memo1: TMemo;
    EDT_SERVER: TEdit;
    Label1: TLabel;
    edt_database: TEdit;
    Label2: TLabel;
    EDT_QTD_TTHREADS: TEdit;
    Label3: TLabel;
    bt_stop: TButton;
    procedure bt_startClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ExecutaTesteCarga;
  end;

var
  Form1: TForm1;

implementation

uses
  FireDAC.Stan.Option;

{$R *.dfm}
{ TForm1 }

procedure TForm1.bt_startClick(Sender: TObject);
var
  i: integer;
begin

  if EDT_QTD_TTHREADS.Text = '' then
    exit;

  for i := 0 to strtoint(EDT_QTD_TTHREADS.Text) do
  begin

    TThread.CreateAnonymousThread(
      procedure
      begin
        ExecutaTesteCarga;
      end).Start;

  end;

end;

procedure TForm1.ExecutaTesteCarga;
var
  DB: TFdConnection;
  UpdateTransaction: TFDTransaction;
  ReadTransaction: TFDTransaction;
  fdGrava: TFDQuery;
  fdAux: TFDQuery;
  fdDados: TFDQuery;

  procedure DestruiCP;
  begin
    try
      DB.Free;
      fdGrava.Free;
      fdAux.Free;
      fdDados.Free;
    except

    end;
  end;

  procedure msgMEmo(str: string);
  begin
    TThread.Queue(TThread.CurrentThread,
      procedure
      begin
        Memo1.Lines.Add(str);
      end);
  end;

  procedure ajustaConn;
  var
    server, Database: string;
  begin

    // cria conexão
    DB := TFdConnection.Create(nil);

    with DB do
    begin
      Params.Values['DriverID'] := 'FB';
      Params.Values['Server'] := trim(EDT_SERVER.Text);
      Params.Values['Database'] := trim(edt_database.Text);
      Params.Values['User_name'] := 'SYSDBA';
      Params.Values['Password'] := 'money';
      try
        Connected := True;
      except
        on E: exception do
        begin
          msgMEmo(E.Message);
          exit;
        end;
      end;
    end;

    // transactions
    UpdateTransaction.Connection := DB;
    DB.UpdateOptions.LockWait := False;

    UpdateTransaction.Options.ReadOnly := False;
    UpdateTransaction.Options.Isolation := xiReadCommitted;

    ReadTransaction.Connection := DB;
    ReadTransaction.Options.ReadOnly := True;
    ReadTransaction.Options.Isolation := xiReadCommitted;

    // querys
    fdGrava := TFDQuery.Create(nil);
    fdGrava.Transaction := UpdateTransaction;
    fdGrava.Connection := DB;

    fdAux := TFDQuery.Create(nil);
    fdAux.Transaction := ReadTransaction;
    fdAux.Connection := DB;

    fdDados := TFDQuery.Create(nil);
    fdDados.Transaction := ReadTransaction;
    fdDados.Connection := DB;

  end;

  procedure GetSql;
  begin

    with fdDados do
    begin
      close;
      sql.Clear;
      sql.Add(' select top 12 * from estoque');
      open;
    end;

  end;

  procedure update;
  begin

    with fdGrava do
    begin

      close;
      sql.Clear;
      sql.Add('update estoque set quantidade = :qtd + 1');
      paramByname('qtd').AsInteger := fdDados.FieldByName('quantidade')
        .AsInteger;
      paramByname('cod_prod').AsInteger := fdDados.FieldByName('cod_prod')
        .AsInteger;

      try

        DB.StartTransaction;

        execSql;

        DB.Commit;

      except
        on E: exception do
        begin

          DB.Rollback;
          msgMEmo(E.Message);

        end;

      end;

    end;

  end;

begin

  { execução principal }

  GetSql;

  while not fdDados.eof do
  begin

    update;

    next;
  end;

end;

end.
