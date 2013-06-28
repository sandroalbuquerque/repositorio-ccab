#Include "PROTHEUS.CH"
User Function DANFE_P1()
Local oBitmap1
Static oDlg
MSGSTOP("Favor Selecionar a DANFE em formato RETRATO, conforme orientação na Proxima Tela.")
  DEFINE MSDIALOG oDlg TITLE "New Dialog" FROM 000, 000  TO 600, 500 COLORS 0, 16777215 PIXEL
    @ 001, 014 BITMAP oBitmap1 SIZE 217, 295 OF oDlg FILENAME "D:\protheus10\system\danfe.jpg" NOBORDER PIXEL
  ACTIVATE MSDIALOG oDlg CENTERED
Return