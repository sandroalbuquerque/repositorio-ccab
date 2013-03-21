#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CABR800     � Autor � Sandra Ribeiro    � Data �  03/05/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Relat�rio de notas fiscais de fretes x notas fiscais de sa�da 
���          � Controle de saldo de empenho de MP usada                   ���
���          � em Ordem de Produ��o;                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente CCAB                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CCABR800()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "NF x Documento de Frete"
Local cPict          := ""
Local titulo       := "NF x Documento de Frete"
Local nLin         := 80

Local Cabec1       := "Fil Doc     Ser Esp Emissao    Est      Peso B.     Valor    TES  Tipo Nt Frete  Serie   Valor  Transp Descri��o                  Pedido Cliente   Descri��o                Hist�rico"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "G"
Private nomeprog         := "CCABR800" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CBR800"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CCABR800" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SF2"

dbSelectArea("SF2")
dbSetOrder(1)

pergunte(cPerg,.F.)    


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  26/10/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQuery	:= ""
Local nRecno

If mv_par09 = 1          // sele��o com CTR
	cQuery := "SELECT DISTINCT SF2.F2_FILIAL FIL,SF2.F2_DOC DOCTO,SF2.F2_SERIE SER, SF2.F2_ESPECIE ESP, SF2.F2_TPFRETE TF, "
	cQuery += "(SUBSTRING(SF2.F2_EMISSAO,7,2)+'/'+SUBSTRING(SF2.F2_EMISSAO,5,2)+'/'+ SUBSTRING(SF2.F2_EMISSAO,1,4)) EMISSAO, SF2.F2_EST EST,  SF2.F2_PBRUTO AS PBRUTO, "
	cQuery += "SF2.F2_VALBRUT MERCAD, SD2.D2_TES TES, SF2.F2_XDOC CTR, SF2.F2_XSERIE SERIE, SF1.F1_VALMERC FRETE, SF2.F2_TRANSP TRANSP, "
	cQuery += "SA4.A4_NOME DESCRICAO, SD2.D2_PEDIDO PEDIDO, SF2.F2_CLIENTE CLIENTE, SF2.F2_LOJA LOJA, SA1.A1_NOME DESCRIC, SC5.C5_MENNOTA HISTORICO"   // , SF2.F2_ESPECIE acrescentado por Valdemir Jose 05/03/2013
	
	cQuery +="FROM "+RetSqlName("SF2") + " SF2 " 
	cQuery += "LEFT JOIN "+RetSqlName("SF1") + " SF1 "  
	cQuery += "ON SF1.D_E_L_E_T_ = '  ' 	AND SF1.F1_DOC = SF2.F2_XDOC AND SF1.F1_FILIAL = SF2.F2_FILIAL AND SF1.F1_SERIE = SF2.F2_XSERIE " 
	cQuery += "LEFT JOIN "+RetSqlName("SC5") + " SC5 "  
	cQuery += "ON SC5.D_E_L_E_T_ = '  ' 	AND SC5.C5_NOTA = SF2.F2_DOC AND SC5.C5_CLIENTE = SF2.F2_CLIENTE "
	cQuery += "LEFT JOIN "+RetSqlName("SA1") + " SA1 "
	cQuery += "ON SA1.D_E_L_E_T_ = '  '  AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA "
	cQuery += "LEFT JOIN  "+RetSqlName("SA4") + " SA4 "
	cQuery += "ON SA4.D_E_L_E_T_ = '  '  AND SA4.A4_COD = SF2.F2_TRANSP "
	cQuery += "LEFT JOIN "+RetSqlName("SC6") + " SC6 "
	cQuery += "ON SC6.D_E_L_E_T_ = '  ' AND SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NOTA = SF2.F2_DOC "  
	cQuery += " LEFT JOIN "+RetSqlName("SD2") + " SD2 "
	cQuery += " ON SD2.D_E_L_E_T_ = '  ' AND SD2.D2_FILIAL = SF2.F2_FILIAL "
	cQuery += " AND SD2.D2_PEDIDO = SC5.C5_NUM AND SD2.D2_DOC = SF2.F2_DOC "
				
	cQuery +=" WHERE SF2.F2_FILIAL BETWEEN  '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery +=" AND SC5.C5_FILIAL = SF2.F2_FILIAL" 
	cQuery +=" AND SF2.F2_EMISSAO BETWEEN  '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "                                                                            
	cQuery +=" AND SF2.F2_CLIENTE BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery +=" AND SF2.F2_TRANSP BETWEEN  '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	cQuery +=" AND SF1.F1_ESPECIE LIKE ('CT%')  "
	cQuery +=" AND SF2.D_E_L_E_T_ = '  ' "
	
	cQuery +=	" ORDER BY F2_FILIAL, F2_DOC " 

ElseIf mv_par09 = 2        //sele��o sem CTR
	cQuery := "SELECT DISTINCT SF2.F2_FILIAL FIL,SF2.F2_DOC DOCTO,SF2.F2_SERIE SER, SF2.F2_ESPECIE ESP, SF2.F2_TPFRETE TF,"
	cQuery += "(SUBSTRING(SF2.F2_EMISSAO,7,2)+'/'+SUBSTRING(SF2.F2_EMISSAO,5,2)+'/'+ SUBSTRING(SF2.F2_EMISSAO,1,4)) EMISSAO, SF2.F2_EST EST, SF2.F2_PBRUTO AS PBRUTO, "
	cQuery += "SF2.F2_VALBRUT MERCAD, SD2.D2_TES TES, SF2.F2_XDOC CTR, SF2.F2_XSERIE SERIE, SF2.F2_TRANSP TRANSP, "
	cQuery += "SA4.A4_NOME DESCRICAO, SD2.D2_PEDIDO PEDIDO, SF2.F2_CLIENTE CLIENTE, SF2.F2_LOJA LOJA, SA1.A1_NOME DESCRIC, SC5.C5_MENNOTA HISTORICO"   // , SF2.F2_ESPECIE acrescentado por Valdemir Jose 05/03/2013
	
	cQuery +="FROM "+RetSqlName("SF2") + " SF2 " 	
	cQuery += "LEFT JOIN "+RetSqlName("SC5") + " SC5 "  
	cQuery += "ON SC5.D_E_L_E_T_ = '  ' 	AND SC5.C5_NOTA = SF2.F2_DOC AND SC5.C5_CLIENTE = SF2.F2_CLIENTE "
	cQuery += "LEFT JOIN "+RetSqlName("SA1") + " SA1 "
	cQuery += "ON SA1.D_E_L_E_T_ = '  '  AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA "
	cQuery += "LEFT JOIN  "+RetSqlName("SA4") + " SA4 "
	cQuery += "ON SA4.D_E_L_E_T_ = '  '  AND SA4.A4_COD = SF2.F2_TRANSP "
	cQuery += "LEFT JOIN "+RetSqlName("SC6") + " SC6 "
	cQuery += "ON SC6.D_E_L_E_T_ = '  ' AND SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NOTA = SF2.F2_DOC "  
	cQuery += " LEFT JOIN "+RetSqlName("SD2") + " SD2 "
	cQuery += " ON SD2.D_E_L_E_T_ = '  ' AND SD2.D2_FILIAL = SF2.F2_FILIAL "
	cQuery += " AND SD2.D2_DOC = SF2.F2_DOC "
	
	cQuery +=" WHERE SF2.F2_FILIAL BETWEEN  '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery +=" AND SF2.F2_EMISSAO BETWEEN  '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
	cQuery +=" AND SF2.F2_CLIENTE BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery +=" AND SF2.F2_TRANSP BETWEEN  '"+MV_PAR07+"' AND '"+MV_PAR08+"' " 
	cQuery +=" AND SF2.F2_XDOC = '  ' "
	cQuery +=" AND SF2.D_E_L_E_T_ = '  ' "
	
	cQuery +=	" ORDER BY F2_FILIAL, F2_DOC "    
	
Else 
	cQuery := "SELECT DISTINCT SF2.F2_FILIAL FIL,SF2.F2_DOC DOCTO,SF2.F2_SERIE SER, SF2.F2_ESPECIE ESP, SF2.F2_TPFRETE TF, "
	cQuery += "(SUBSTRING(SF2.F2_EMISSAO,7,2)+'/'+SUBSTRING(SF2.F2_EMISSAO,5,2)+'/'+ SUBSTRING(SF2.F2_EMISSAO,1,4)) EMISSAO, SF2.F2_EST EST,  SF2.F2_PBRUTO AS PBRUTO,"
	cQuery += "SF2.F2_VALBRUT MERCAD, SD2.D2_TES TES, SF2.F2_XDOC CTR, SF2.F2_XSERIE SERIE, SF1.F1_VALMERC FRETE, SF2.F2_TRANSP TRANSP, "
	cQuery += "SA4.A4_NOME DESCRICAO, SD2.D2_PEDIDO PEDIDO, SF2.F2_CLIENTE CLIENTE, SF2.F2_LOJA LOJA, SA1.A1_NOME DESCRIC, SC5.C5_MENNOTA HISTORICO"   // , SF2.F2_ESPECIE acrescentado por Valdemir Jose 05/03/2013		
	
	cQuery +="FROM "+RetSqlName("SF2") + " SF2 " 	                                                                            
	cQuery += "LEFT JOIN "+RetSqlName("SF1") + " SF1 "  
	cQuery += "ON SF1.D_E_L_E_T_ = '  ' 	AND SF1.F1_DOC = SF2.F2_XDOC AND SF1.F1_FILIAL = SF2.F2_FILIAL AND SF1.F1_SERIE = SF2.F2_XSERIE " 
	cQuery += "LEFT JOIN "+RetSqlName("SC5") + " SC5 "  
	cQuery += "ON SC5.D_E_L_E_T_ = '  ' 	AND SC5.C5_NOTA = SF2.F2_DOC AND SC5.C5_CLIENTE = SF2.F2_CLIENTE "
	cQuery += "LEFT JOIN "+RetSqlName("SA1") + " SA1 "
	cQuery += "ON SA1.D_E_L_E_T_ = '  '  AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA "
	cQuery += "LEFT JOIN  "+RetSqlName("SA4") + " SA4 "
	cQuery += "ON SA4.D_E_L_E_T_ = '  '  AND SA4.A4_COD = SF2.F2_TRANSP "
	cQuery += "LEFT JOIN "+RetSqlName("SC6") + " SC6 "
	cQuery += "ON SC6.D_E_L_E_T_ = '  ' AND SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NOTA = SF2.F2_DOC "  
	cQuery += " LEFT JOIN "+RetSqlName("SD2") + " SD2 "
	cQuery += " ON SD2.D_E_L_E_T_ = '  ' AND SD2.D2_FILIAL = SF2.F2_FILIAL "
	cQuery += " AND SD2.D2_DOC = SF2.F2_DOC "
	
	cQuery +=" WHERE SF2.F2_FILIAL BETWEEN  '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery +=" AND SF2.F2_EMISSAO BETWEEN  '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
	cQuery +=" AND SF2.F2_CLIENTE BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery +=" AND SF2.F2_TRANSP BETWEEN  '"+MV_PAR07+"' AND '"+MV_PAR08+"' " 
	cQuery +=" AND SF2.D_E_L_E_T_ = '  ' "
	
	cQuery +=	" ORDER BY F2_FILIAL, F2_DOC "    
	
EndIf

cQuery := ChangeQuery(cQuery)      
dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "QUERY", .F., .T. )
TcSetField("QUERY","MERCAD"  ,"N",14,2)
TcSetField("QUERY","PBRUTO"  ,"N",14,4)
TcSetField("QUERY","FRETE"   ,"N",9,2)
Count to nRecno
SetRegua(nRecno)

dbSelectArea("QUERY")       

If  nRecno == 0
            MsgAlert("Arquivo vazio")  
            QUERY->(dbCloseArea())
            Return()
EndIf 

dbGoTop()
While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 8
   Endif 
//                                10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170
//                       123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//Local Cabec1       := "Fil Doc      Ser  Emissao  Est    Peso B.        Valor TES  Nt Frete  Ser     Valor     Transp   Descri��o                 Pedido   Cliente  Descri��o               Hist�rico    "

	@nLin,00  PSAY QUERY->FIL picture "@!"         
 	@nLin,03  PSAY QUERY->DOCTO picture "@!"                
   	@nLin,14  PSAY ALLTRIM(QUERY->SER) picture "@!"  
   	@nLin,16  PSAY ALLTRIM(QUERY->ESP) picture "@!"  
	@nLin,20  PSAY QUERY->EMISSAO picture "99/99/9999"         
   	@nLin,31  PSAY QUERY->EST picture "@!"
    @nLin,33  PSAY QUERY->PBRUTO picture "@R 999,999,999.99"
   	@nLin,46  PSAY QUERY->MERCAD picture "@R 999,999,999.99"                            
  	@nLin,61  PSAY QUERY->TES picture "@!" 
  	@nLin,65  PSAY POSICIONE("SC5",1,xFilial("SC5")+PEDIDO,"C5_TPFRETE") picture "@!" 
   	@nLin,69  PSAY QUERY->CTR picture "@!"
   	@nLin,80  PSAY QUERY->SERIE picture "@!"   	
	If mv_par09 = 2      //sem CTR
		@nLin, 85 PSAY "  "  			
	Else
		@nLin, 85 PSAY QUERY->FRETE picture "@R 99,999.99"
	EndIf
   	@nLin,95  PSAY ALLTRIM(QUERY->TRANSP) picture "@!"
   	@nLin,102  PSAY SubStr(QUERY->DESCRICAO,1,25) picture "@!" 
  	@nLin,129 PSAY ALLTRIM(QUERY->PEDIDO) picture "@!"	  	   			
   	@nLin,138 PSAY ALLTRIM(QUERY->CLIENTE) picture "@!"         
   	@nLin,146 PSAY SubStr(Alltrim(QUERY->DESCRIC),1,24) picture "@!"                                                                                                   
	@nLin,170 PSAY SubStr(Alltrim(QUERY->HISTORICO),1,55) picture "@!"  

 	nLin := nLin + 1 // Avanca a linha de impressao   
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo
	roda(cbcont,cbtxt,tamanho)
//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������


If mv_par10= 1
   		cFile := cGetFile("",	"",0,"",.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_RETDIRECTORY+GETF_NETWORKDRIVE,.F.)
   		_cArqTmp := 'cabr800.xls' 

	If Empty(cFile) 
		cFile := 'C:\'
	EndIF 
	Set Decimals to 4	         
	Copy To &(_cArqTmp) // DELIMITED
	CpyS2T( GetPvProfString( GetEnvServer(), "StartPath", "", GetADV97() )+_cArqTmp , cFile, .T. )
	MsgInfo('Arquivo criado em: '+AllTrim(cFile)+_cArqTmp,'Planilha Excel')  
   //+------------------------
   //| Abrir planilha MS-Excel - Valdemir Jose 05/03/2013
   //+------------------------
	If ! ApOleClient("MsExcel") 
		MsgAlert("MsExcel n�o instalado")
		Return
	Endif    
	cArqExcel := AllTrim(cFile)+_cArqTmp
	CursorArrow()
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cArqExcel )  
	oExcelApp:SetVisible(.T.)	  
	oExcelApp:Destroy()
	
	FErase(_cArqTmp)
        
EndIf
                             
QUERY->(dbCloseArea())


SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return 


