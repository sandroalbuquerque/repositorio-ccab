#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://spoap03:85/ws/PEDIDO.apw?WSDL    http://spoap03:85/ws/PEDIDO.apw?WSDL
Gerado em        06/17/10 11:38:53
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.090116
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _PPKOSFG ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSPEDIDO
------------------------------------------------------------------------------- */

WSCLIENT WSPEDIDO

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD INCLUSAO

	WSDATA   _URL                      AS String
	WSDATA   oWSPEDIDO                 AS PEDIDO_PEDIDO_VENDA
	WSDATA   cINCLUSAORESULT           AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSPEDIDO_VENDA           AS PEDIDO_PEDIDO_VENDA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSPEDIDO
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.090818P-20100524] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSPEDIDO
	::oWSPEDIDO          := PEDIDO_PEDIDO_VENDA():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSPEDIDO_VENDA    := ::oWSPEDIDO
Return

WSMETHOD RESET WSCLIENT WSPEDIDO
	::oWSPEDIDO          := NIL 
	::cINCLUSAORESULT    := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSPEDIDO_VENDA    := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSPEDIDO
Local oClone := WSPEDIDO():New()
	oClone:_URL          := ::_URL 
	oClone:oWSPEDIDO     :=  IIF(::oWSPEDIDO = NIL , NIL ,::oWSPEDIDO:Clone() )
	oClone:cINCLUSAORESULT := ::cINCLUSAORESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSPEDIDO_VENDA := oClone:oWSPEDIDO
Return oClone

// WSDL Method INCLUSAO of Service WSPEDIDO    cSoap += '<INCLUSAO xmlns="http://sposi01:85/">'          "http://sposi01:85/INCLUSAO",; 	"DOCUMENT","http://sposi01:85/",,"1.031217",;    	"http://sposi01:85/ws/PEDIDO.apw")

WSMETHOD INCLUSAO WSSEND oWSPEDIDO WSRECEIVE cINCLUSAORESULT WSCLIENT WSPEDIDO
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<INCLUSAO xmlns="http://spoap03:85/">'
cSoap += WSSoapValue("PEDIDO", ::oWSPEDIDO, oWSPEDIDO , "PEDIDO_VENDA", .T. , .F., 0 , NIL, .F.) 
cSoap += "</INCLUSAO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://spoap03:85/INCLUSAO",; 
	"DOCUMENT","http://spoap03:85/",,"1.031217",; 
	"http://spoap03:85/ws/PEDIDO.apw")

::Init()
::cINCLUSAORESULT    :=  WSAdvValue( oXmlRet,"_INCLUSAORESPONSE:_INCLUSAORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure PEDIDO_VENDA

WSSTRUCT PEDIDO_PEDIDO_VENDA
	WSDATA   oWSAITEMPV                AS PEDIDO_ARRAYOFITEM_PV
	WSDATA   oWSCABECPV                AS PEDIDO_CABEC_PV
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PEDIDO_PEDIDO_VENDA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PEDIDO_PEDIDO_VENDA
Return

WSMETHOD CLONE WSCLIENT PEDIDO_PEDIDO_VENDA
	Local oClone := PEDIDO_PEDIDO_VENDA():NEW()
	oClone:oWSAITEMPV           := IIF(::oWSAITEMPV = NIL , NIL , ::oWSAITEMPV:Clone() )
	oClone:oWSCABECPV           := IIF(::oWSCABECPV = NIL , NIL , ::oWSCABECPV:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT PEDIDO_PEDIDO_VENDA
	Local cSoap := ""
	cSoap += WSSoapValue("AITEMPV", ::oWSAITEMPV, ::oWSAITEMPV , "ARRAYOFITEM_PV", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("CABECPV", ::oWSCABECPV, ::oWSCABECPV , "CABEC_PV", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ARRAYOFITEM_PV

WSSTRUCT PEDIDO_ARRAYOFITEM_PV
	WSDATA   oWSITEM_PV                AS PEDIDO_ITEM_PV OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PEDIDO_ARRAYOFITEM_PV
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PEDIDO_ARRAYOFITEM_PV
	::oWSITEM_PV           := {} // Array Of  PEDIDO_ITEM_PV():New()
Return

WSMETHOD CLONE WSCLIENT PEDIDO_ARRAYOFITEM_PV
	Local oClone := PEDIDO_ARRAYOFITEM_PV():NEW()
	oClone:oWSITEM_PV := NIL
	If ::oWSITEM_PV <> NIL 
		oClone:oWSITEM_PV := {}
		aEval( ::oWSITEM_PV , { |x| aadd( oClone:oWSITEM_PV , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT PEDIDO_ARRAYOFITEM_PV
	Local cSoap := ""
	aEval( ::oWSITEM_PV , {|x| cSoap := cSoap  +  WSSoapValue("ITEM_PV", x , x , "ITEM_PV", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

// WSDL Data Structure CABEC_PV

WSSTRUCT PEDIDO_CABEC_PV
	WSDATA   cCONDPAG                  AS string
	WSDATA   cDATA1                    AS string OPTIONAL
	WSDATA   cDATA2                    AS string OPTIONAL
	WSDATA   cDATA3                    AS string OPTIONAL
	WSDATA   cDATA4                    AS string OPTIONAL
	WSDATA   cDATA5                    AS string OPTIONAL
	WSDATA   cDATA6                    AS string OPTIONAL
	WSDATA   cEMISSAO                  AS string
	WSDATA   cESPECI1                  AS string
	WSDATA   nMOEDA                    AS float
	WSDATA   cNUMSFA                   AS string
	WSDATA   nPARC1                    AS float OPTIONAL
	WSDATA   nPARC2                    AS float OPTIONAL
	WSDATA   nPARC3                    AS float OPTIONAL
	WSDATA   nPARC4                    AS float OPTIONAL
	WSDATA   nPARC5                    AS float OPTIONAL
	WSDATA   nPARC6                    AS float OPTIONAL
	WSDATA   cTABELA                   AS string
	WSDATA   cVEND1                    AS string OPTIONAL
	WSDATA   cVEND2                    AS string OPTIONAL
	WSDATA   cVEND3                    AS string OPTIONAL
	WSDATA   cVEND4                    AS string OPTIONAL
	WSDATA   cVEND5                    AS string OPTIONAL
	WSDATA   nVOLUME1                  AS float
	WSDATA   cXCLIENT                  AS string
	WSDATA   cXCLIFAT                  AS string
	WSDATA   nXDESPER                  AS float OPTIONAL
	WSDATA   cXHISTCO                  AS string
	WSDATA   cXLOJAENT                 AS string
	WSDATA   cXLOJAFAT                 AS string
	WSDATA   cXOBSERV                  AS string
	WSDATA   cXTPPED                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PEDIDO_CABEC_PV
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PEDIDO_CABEC_PV
Return

WSMETHOD CLONE WSCLIENT PEDIDO_CABEC_PV
	Local oClone := PEDIDO_CABEC_PV():NEW()
	oClone:cCONDPAG             := ::cCONDPAG
	oClone:cDATA1               := ::cDATA1
	oClone:cDATA2               := ::cDATA2
	oClone:cDATA3               := ::cDATA3
	oClone:cDATA4               := ::cDATA4
	oClone:cDATA5               := ::cDATA5
	oClone:cDATA6               := ::cDATA6
	oClone:cEMISSAO             := ::cEMISSAO
	oClone:cESPECI1             := ::cESPECI1
	oClone:nMOEDA               := ::nMOEDA
	oClone:cNUMSFA              := ::cNUMSFA
	oClone:nPARC1               := ::nPARC1
	oClone:nPARC2               := ::nPARC2
	oClone:nPARC3               := ::nPARC3
	oClone:nPARC4               := ::nPARC4
	oClone:nPARC5               := ::nPARC5
	oClone:nPARC6               := ::nPARC6
	oClone:cTABELA              := ::cTABELA
	oClone:cVEND1               := ::cVEND1
	oClone:cVEND2               := ::cVEND2
	oClone:cVEND3               := ::cVEND3
	oClone:cVEND4               := ::cVEND4
	oClone:cVEND5               := ::cVEND5
	oClone:nVOLUME1             := ::nVOLUME1
	oClone:cXCLIENT             := ::cXCLIENT
	oClone:cXCLIFAT             := ::cXCLIFAT
	oClone:nXDESPER             := ::nXDESPER
	oClone:cXHISTCO             := ::cXHISTCO
	oClone:cXLOJAENT            := ::cXLOJAENT
	oClone:cXLOJAFAT            := ::cXLOJAFAT
	oClone:cXOBSERV             := ::cXOBSERV
	oClone:cXTPPED              := ::cXTPPED
Return oClone

WSMETHOD SOAPSEND WSCLIENT PEDIDO_CABEC_PV
	Local cSoap := ""
	cSoap += WSSoapValue("CONDPAG", ::cCONDPAG, ::cCONDPAG , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("DATA1", ::cDATA1, ::cDATA1 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("DATA2", ::cDATA2, ::cDATA2 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("DATA3", ::cDATA3, ::cDATA3 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("DATA4", ::cDATA4, ::cDATA4 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("DATA5", ::cDATA5, ::cDATA5 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("DATA6", ::cDATA6, ::cDATA6 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("EMISSAO", ::cEMISSAO, ::cEMISSAO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ESPECI1", ::cESPECI1, ::cESPECI1 , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("MOEDA", ::nMOEDA, ::nMOEDA , "float", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("NUMSFA", ::cNUMSFA, ::cNUMSFA , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PARC1", ::nPARC1, ::nPARC1 , "float", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PARC2", ::nPARC2, ::nPARC2 , "float", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PARC3", ::nPARC3, ::nPARC3 , "float", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PARC4", ::nPARC4, ::nPARC4 , "float", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PARC5", ::nPARC5, ::nPARC5 , "float", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PARC6", ::nPARC6, ::nPARC6 , "float", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("TABELA", ::cTABELA, ::cTABELA , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("VEND1", ::cVEND1, ::cVEND1 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("VEND2", ::cVEND2, ::cVEND2 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("VEND3", ::cVEND3, ::cVEND3 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("VEND4", ::cVEND4, ::cVEND4 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("VEND5", ::cVEND5, ::cVEND5 , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("VOLUME1", ::nVOLUME1, ::nVOLUME1 , "float", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("XCLIENT", ::cXCLIENT, ::cXCLIENT , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("XCLIFAT", ::cXCLIFAT, ::cXCLIFAT , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("XDESPER", ::nXDESPER, ::nXDESPER , "float", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("XHISTCO", ::cXHISTCO, ::cXHISTCO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("XLOJAENT", ::cXLOJAENT, ::cXLOJAENT , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("XLOJAFAT", ::cXLOJAFAT, ::cXLOJAFAT , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("XOBSERV", ::cXOBSERV, ::cXOBSERV , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("XTPPED", ::cXTPPED, ::cXTPPED , "string", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ITEM_PV

WSSTRUCT PEDIDO_ITEM_PV
	WSDATA   cENTREG                   AS string
	WSDATA   nITEMSFA                  AS float
	WSDATA   cNUMSFA                   AS string
	WSDATA   nPRCVEN                   AS float
	WSDATA   cPRODUTO                  AS string
	WSDATA   nQTDVEN                   AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PEDIDO_ITEM_PV
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PEDIDO_ITEM_PV
Return

WSMETHOD CLONE WSCLIENT PEDIDO_ITEM_PV
	Local oClone := PEDIDO_ITEM_PV():NEW()
	oClone:cENTREG              := ::cENTREG
	oClone:nITEMSFA             := ::nITEMSFA
	oClone:cNUMSFA              := ::cNUMSFA
	oClone:nPRCVEN              := ::nPRCVEN
	oClone:cPRODUTO             := ::cPRODUTO
	oClone:nQTDVEN              := ::nQTDVEN
Return oClone

WSMETHOD SOAPSEND WSCLIENT PEDIDO_ITEM_PV
	Local cSoap := ""
	cSoap += WSSoapValue("ENTREG", ::cENTREG, ::cENTREG , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("ITEMSFA", ::nITEMSFA, ::nITEMSFA , "float", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("NUMSFA", ::cNUMSFA, ::cNUMSFA , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PRCVEN", ::nPRCVEN, ::nPRCVEN , "float", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PRODUTO", ::cPRODUTO, ::cPRODUTO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("QTDVEN", ::nQTDVEN, ::nQTDVEN , "float", .T. , .F., 0 , NIL, .F.) 
Return cSoap