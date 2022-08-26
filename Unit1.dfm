object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Teste Carga MSSQL com TThread'
  ClientHeight = 433
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 64
    Top = 16
    Width = 32
    Height = 15
    Caption = 'Server'
  end
  object Label2: TLabel
    Left = 64
    Top = 64
    Width = 48
    Height = 15
    Caption = 'DataBase'
  end
  object Label3: TLabel
    Left = 344
    Top = 16
    Width = 128
    Height = 15
    Caption = 'Quantidade de TThreads'
  end
  object bt_start: TButton
    Left = 344
    Top = 84
    Width = 113
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 0
    OnClick = bt_startClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 128
    Width = 622
    Height = 305
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object EDT_SERVER: TEdit
    Left = 64
    Top = 37
    Width = 193
    Height = 23
    TabOrder = 2
  end
  object edt_database: TEdit
    Left = 64
    Top = 85
    Width = 193
    Height = 23
    TabOrder = 3
  end
  object EDT_QTD_TTHREADS: TEdit
    Left = 344
    Top = 37
    Width = 113
    Height = 23
    NumbersOnly = True
    TabOrder = 4
  end
  object bt_stop: TButton
    Left = 463
    Top = 84
    Width = 113
    Height = 25
    Caption = 'Parar'
    TabOrder = 5
  end
end
