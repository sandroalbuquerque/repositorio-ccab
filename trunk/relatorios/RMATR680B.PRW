#INCLUDE "MATR680.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATB680  ³ Autor ³ Marco Bianchi         ³ Data ³ 04/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT - R4                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RMATB680()

Local oReport
Private cPerg	:= "MTB680"
Private nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	RMATB680R3()
EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³ 04/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oPedNEnt
Local oProduto
Local oCliente
Local oData
Local oVendedor

Local nSaldo	:= 0
Local nValor	:= 0
Local nTotVen	:= 0
Local nTotEnt	:= 0
Local nTamData	:= Len(DTOC(MsDate()))
Local cWhere	:= ""
Local cQueryAdd := ""
Local cAliasQry := GetNextAlias()

LOCAL nOrdem    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("MATB680","Relacao de Pedidos nao entregues",cPerg, {|oReport| ReportPrint(oReport,cAliasQry,oPedNEnt,oProduto,oCliente,oData,oVendedor)},"Este programa ira emitir a relacao dos Pedidos Pendentes," + " " + "imprimindo o numero do Pedido, Cliente, Data da Entrega, " + " " + "Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso.")
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Pedido                                                         	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPedNEnt := TRSection():New(oReport,"Por Pedido",{/*"TRB","SC6",*/"SA1","SA3","SF4","SB1","SC5","SZ2","SX5"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// ###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oPedNEnt:SetTotalInLine(.F.)
TRCell():New(oPedNEnt,"FILIAL"		,"TRB",RetTitle("C6_FILIAL"		),PesqPict("SC6","C6_FILIAL"	),TamSx3("C6_FILIAL"	)[1],/*lPixel*/,{|| TRB->FILIAL						})
TRCell():New(oPedNEnt,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM						})
TRCell():New(oPedNEnt,"NUMSFA"		,"TRB",RetTitle("Z2_NUMSFA"		),PesqPict("SZ2","Z2_NUMSFA"	),TamSx3("Z2_NUMSFA"	)[1],/*lPixel*/,{|| TRB->NUMSFA   					})
TRCell():New(oPedNEnt,"XTPPED"		,"TRB",RetTitle("C5_XTPPED"		),PesqPict("SC5","C5_XTPPED"	),TamSx3("C5_XTPPED"	)[1],/*lPixel*/,{|| IIF(AllTrim(TRB->XTPPED) == "1","1-Entrega Futura",IIF(AllTrim(TRB->XTPPED) == "2","2-Conta e Ordem",IIF(AllTrim(TRB->XTPPED) == "3","3-Normal",""))) 	})	// Tipo de Pre-Pedido 
TRCell():New(oPedNEnt,"EMISSAO"		,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO					})
TRCell():New(oPedNEnt,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE					})
TRCell():New(oPedNEnt,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 						})
TRCell():New(oPedNEnt,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI					})
TRCell():New(oPedNEnt,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 						})
TRCell():New(oPedNEnt,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oPedNEnt,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO					})
TRCell():New(oPedNEnt,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO					})

// Quando nome da celular nao e do SX3 e o campo for do tipo Data, o tamanho deve ser preenchido com
// Len(DTOC(MsDate())), para que nao haja problema na utilizacao de ano com 4 digitos.
TRCell():New(oPedNEnt,"DATENTR"	,"TRB"  ,RetTitle("C6_ENTREG")	,PesqPict("SC6","C6_ENTREG"	),nTamData				    ,/*lPixel*/ ,{|| TRB->DATENTR			})	// Data de Entrega
TRCell():New(oPedNEnt,"NTOTVEN"	,       ,RetTitle("C6_QTDVEN")	,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oPedNEnt,"NTOTENT"	,   	,RetTitle("C6_QTDENT")	,PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oPedNEnt,"NSALDO"	,	 	,"Quant.Pendente"		,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oPedNEnt,"NVALOR"	,	  	,"Valor Total Pendente"	,PesqPict("SC6","C6_VALOR"	),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor	})	// "Valor Total Pendente"
TRCell():New(oPedNEnt,"NPRCVEN"	,"TRB"	,"Vlr Unit"	,"@E 9999999.9999",TamSx3("C6_PRCVEN"		)[1],/*lPixel*/,{|| TRB->NPRCVEN 	})	// "Vlr Unitario
TRCell():New(oPedNEnt,"PARC1"	,"TRB"	,"Parc.1"	,"@E 999.99",TamSx3("C5_PARC1"		)[1],/*lPixel*/,{|| TRB->PARC1 	})	// "Parc.1  VALDEMIR JOSE 27/05/2013
TRCell():New(oPedNEnt,"DATA1"	,"TRB"  ,RetTitle("C5_DATA1")	,PesqPict("SC5","C5_DATA1"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA1	})	// Data de VENC.1 - VALDEMIR JOSE 27/05/2013
TRCell():New(oPedNEnt,"PARC2"	,"TRB"	,"Parc.2"	,"@E 999.99",TamSx3("C5_PARC2"		)[1],/*lPixel*/,{|| TRB->PARC2 	})	// "Parc.2    VALDEMIR JOSE 27/05/2013
TRCell():New(oPedNEnt,"DATA2"	,"TRB"  ,RetTitle("C5_DATA2")	,PesqPict("SC5","C5_DATA2"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA2	})	// Data de VENC.2 - VALDEMIR JOSE 27/05/2013
TRCell():New(oPedNEnt,"XLIBERA"		,"TRB",RetTitle("C6_XLIBERA"),PesqPict("SC6","C6_XLIBERA"	),TamSx3("C6_XLIBERA"	)[1],/*lPixel*/,{|| TRB->XLIBERA					})	// Status Libera
TRCell():New(oPedNEnt,"TABELA"		,"TRB",RetTitle("C5_TABELA"	),PesqPict("SC5","C5_TABELA"	),TamSx3("C5_TABELA"	)[1],/*lPixel*/,{|| TRB->TABELA					})	// Tabela de Pre-Pedido
TRCell():New(oPedNEnt,"TABDES"		,"TRB",RetTitle("C5_XTABDES"	),PesqPict("SC5","C5_XTABDES"	),TamSx3("C5_XTABDES"	)[1],/*lPixel*/,{|| TRB->TABDES				})	// 
TRCell():New(oPedNEnt,"VEND2"		,"TRB","Cooperativa"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->VEND2 })	// 
TRCell():New(oPedNEnt,"TPFIN"		,"TRB",RetTitle("C5_XTPFIN"	),PesqPict("SC5","C5_XTPFIN"	),TamSx3("C5_XTPFIN"	)[1],/*lPixel*/,{|| TRB->TPFIN				})	// 
TRCell():New(oPedNEnt,"DESCTP"		,"TRB",RetTitle("C5_DESCTP"	),PesqPict("SC5","C5_DESCTP"	),TamSx3("C5_DESCTP"	)[1],/*lPixel*/,{|| TRB->DESCTP				})	// 
TRCell():New(oPedNEnt,"VEND3"		,"TRB",RetTitle("C5_VEND3"	),PesqPict("SC5","C5_VEND3"	),TamSx3("C5_VEND3"	)[1],/*lPixel*/,{|| TRB->VEND3				})	// 
TRCell():New(oPedNEnt,"NOMEV3"		,"TRB","Nome Vend 3"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->NOMEV3 })	// 
TRCell():New(oPedNEnt,"XGESTOR"		,"TRB",RetTitle("A1_XGESTOR"	),PesqPict("SA1","A1_XGESTOR"	),TamSx3("A1_XGESTOR"	)[1],/*lPixel*/,{|| TRB->XGESTOR				})	// 
TRCell():New(oPedNEnt,"XNOMEG"		,"TRB",RetTitle("X5_DESCRI"	),PesqPict("SX5","X5_DESCRI"	),TamSx3("X5_DESCRI"	)[1],/*lPixel*/,{|| TRB->XNOMEG				})	// 
 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Produto                                                       	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProduto := TRSection():New(oReport,"Por Produto",{/*"TRB","SC6",*/"SA1","SA3","SF4","SB1","SC5","SZ2","SX5"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// ###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oProduto:SetTotalInLine(.F.)

TRCell():New(oProduto,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oProduto,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oProduto,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oProduto,"FILIAL"		,"TRB",RetTitle("C6_FILIAL"		),PesqPict("SC6","C6_FILIAL"	),TamSx3("C6_FILIAL"	)[1],/*lPixel*/,{|| TRB->FILIAL						})
TRCell():New(oProduto,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oProduto,"NUMSFA"		,"TRB",RetTitle("Z2_NUMSFA"		),PesqPict("SZ2","Z2_NUMSFA"	),TamSx3("Z2_NUMSFA"	)[1],/*lPixel*/,{|| TRB->NUMSFA																			})
TRCell():New(oProduto,"XTPPED"		,"TRB",RetTitle("C5_XTPPED"		),PesqPict("SC5","C5_XTPPED"	),TamSx3("C5_XTPPED"	)[1],/*lPixel*/,{|| IIF(AllTrim(TRB->XTPPED) == "1","1-Entrega Futura",IIF(AllTrim(TRB->XTPPED) == "2","2-Conta e Ordem",IIF(AllTrim(TRB->XTPPED) == "3","3-Normal",""))) 	})	// Tipo de Pre-Pedido 
TRCell():New(oProduto,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oProduto,"EMISSAO"		,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO 																			})
TRCell():New(oProduto,"DATENTR"		,"TRB",RetTitle("C6_ENTREG"		),PesqPict("SC6","C6_ENTREG"	),TamSx3("C6_ENTREG"	)[1],/*lPixel*/,{|| TRB->DATENTR																			})
TRCell():New(oProduto,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE 																			})
TRCell():New(oProduto,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oProduto,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI 																			})
TRCell():New(oProduto,"NTOTVEN"		,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oProduto,"NTOTENT"		,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oProduto,"NSALDO"		,  ,"Quant.Pendente"			 ,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oProduto,"NVALOR"		,  ,"Valor Total Pendente"	 ,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor																						})	// "Valor Total Pendente"
TRCell():New(oProduto,"NPRCVEN"	    , "TRB"	,"Vlr Unit"	,"@E 9999999.9999",TamSx3("C6_PRCVEN"		)[1],/*lPixel*/,{|| TRB->NPRCVEN 	})	// "Vlr Unitario
TRCell():New(oProduto,"PARC1"	,"TRB"	,"Parc.1"	,"@E 999.99",TamSx3("C5_PARC1"		)[1],/*lPixel*/,{|| TRB->PARC1 	})	// "Parc.1 - VALDEMIR JOSE 27/05/2013
TRCell():New(oProduto,"DATA1"	,"TRB"  ,RetTitle("C5_DATA1")	,PesqPict("SC5","C5_DATA1"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA1	})	// Data de VENC.1 - VALDEMIR JOSE 27/05/2013
TRCell():New(oProduto,"PARC2"	,"TRB"	,"Parc.2"	,"@E 999.99",TamSx3("C5_PARC2"		)[1],/*lPixel*/,{|| TRB->PARC2 	})	// "Parc.2 - VALDEMIR JOSE 27/05/2013
TRCell():New(oProduto,"DATA2"	,"TRB"  ,RetTitle("C5_DATA2")	,PesqPict("SC5","C5_DATA2"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA2	})	// Data de VENC.2 - VALDEMIR JOSE 27/05/2013
TRCell():New(oProduto,"XLIBERA"		,"TRB",RetTitle("C6_XLIBERA"	),PesqPict("SC6","C6_XLIBERA"	),TamSx3("C6_XLIBERA"	)[1],/*lPixel*/,{|| TRB->XLIBERA					})	// Status Libera
TRCell():New(oProduto,"TABELA"		,"TRB",RetTitle("C5_TABELA"	),PesqPict("SC5","C5_TABELA"	),TamSx3("C5_TABELA"	)[1],/*lPixel*/,{|| TRB->TABELA					})	// Tabela de Pre-Pedido
TRCell():New(oProduto,"TABDES"		,"TRB",RetTitle("C5_XTABDES"	),PesqPict("SC5","C5_XTABDES"	),TamSx3("C5_XTABDES"	)[1],/*lPixel*/,{|| TRB->TABDES				})	// 
TRCell():New(oProduto,"VEND2"		,"TRB","Cooperativa"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->VEND2 })	// 
TRCell():New(oProduto,"TPFIN"		,"TRB",RetTitle("C5_XTPFIN"	),PesqPict("SC5","C5_XTPFIN"	),TamSx3("C5_XTPFIN"	)[1],/*lPixel*/,{|| TRB->TPFIN				})	// 
TRCell():New(oProduto,"DESCTP"		,"TRB",RetTitle("C5_DESCTP"	),PesqPict("SC5","C5_DESCTP"	),TamSx3("C5_DESCTP"	)[1],/*lPixel*/,{|| TRB->DESCTP				})	// 
TRCell():New(oProduto,"VEND3"		,"TRB",RetTitle("C5_VEND3"	),PesqPict("SC5","C5_VEND3"	),TamSx3("C5_VEND3"	)[1],/*lPixel*/,{|| TRB->VEND3				})	// 
TRCell():New(oProduto,"NOMEV3"		,"TRB","Nome Vend 3"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->NOMEV3 })	// 
TRCell():New(oProduto,"XGESTOR"		,"TRB",RetTitle("A1_XGESTOR"	),PesqPict("SA1","A1_XGESTOR"	),TamSx3("A1_XGESTOR"	)[1],/*lPixel*/,{|| TRB->XGESTOR				})	// 
TRCell():New(oProduto,"XNOMEG"		,"TRB",RetTitle("X5_DESCRI"	),PesqPict("SX5","X5_DESCRI"	),TamSx3("X5_DESCRI"	)[1],/*lPixel*/,{|| TRB->XNOMEG				})	// 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Cliente                                                       	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oCliente := TRSection():New(oReport,"Por Cliente",{/*"TRB","SC6",*/"SA1","SA3","SF4","SB1","SC5","SZ2","SX5"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// ###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oCliente:SetTotalInLine(.F.)

TRCell():New(oCliente,"CLIENTE"		,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE 																			})
TRCell():New(oCliente,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oCliente,"NOMECLI"		,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI 																			})
TRCell():New(oCliente,"FILIAL"		,"TRB",RetTitle("C6_FILIAL"		),PesqPict("SC6","C6_FILIAL"	),TamSx3("C6_FILIAL"	)[1],/*lPixel*/,{|| TRB->FILIAL						})
TRCell():New(oCliente,"NUM"			,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oCliente,"NUMSFA"		,"TRB",RetTitle("Z2_NUMSFA"		),PesqPict("SZ2","Z2_NUMSFA"	),TamSx3("Z2_NUMSFA"	)[1],/*lPixel*/,{|| TRB->NUMSFA																			})
TRCell():New(oCliente,"XTPPED"		,"TRB",RetTitle("C5_XTPPED"		),PesqPict("SC5","C5_XTPPED"	),TamSx3("C5_XTPPED"	)[1],/*lPixel*/,{|| IIF(AllTrim(TRB->XTPPED) == "1","1-Entrega Futura",IIF(AllTrim(TRB->XTPPED) == "2","2-Conta e Ordem",IIF(AllTrim(TRB->XTPPED) == "3","3-Normal",""))) 	})	// Tipo de Pre-Pedido 
TRCell():New(oCliente,"ITEM"	  	,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																			})
TRCell():New(oCliente,"EMISSAO"		,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO 																			})
TRCell():New(oCliente,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oCliente,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oCliente,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oCliente,"DATENTR"		,"TRB",RetTitle("C6_ENTREG"		),PesqPict("SC6","C6_ENTREG"	),TamSx3("C6_ENTREG"	)[1],/*lPixel*/,{|| TRB->DATENTR																			})
TRCell():New(oCliente,"NTOTVEN"		,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oCliente,"NTOTENT"		,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oCliente,"NSALDO"		,	  ,"Quant.Pendente"			 ,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oCliente,"NVALOR"		,	  ,"Valor Total Pendente"	 ,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor																						})	// "Valor Total Pendente"
TRCell():New(oCliente,"NPRCVEN"	,"TRB"	,"Vlr Unit"	,"@E 9999999.9999",TamSx3("C6_PRCVEN"		)[1],/*lPixel*/,{|| TRB->NPRCVEN 	})	// "Vlr Unitario
TRCell():New(oCliente,"PARC1"	,"TRB"	,"Parc.1"	,"@E 999.99",TamSx3("C5_PARC1"		)[1],/*lPixel*/,{|| TRB->PARC1 	})	// "Parc.1 - VALDEMIR JOSE 27/05/2013
TRCell():New(oCliente,"DATA1"	,"TRB"  ,RetTitle("C5_DATA1")	,PesqPict("SC5","C5_DATA1"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA1	})	// Data de VENC.1 - VALDEMIR JOSE 27/05/2013
TRCell():New(oCliente,"PARC2"	,"TRB"	,"Parc.2"	,"@E 999.99",TamSx3("C5_PARC2"		)[1],/*lPixel*/,{|| TRB->PARC2 	})	// "Parc.2 - VALDEMIR JOSE 27/05/2013
TRCell():New(oCliente,"DATA2"	,"TRB"  ,RetTitle("C5_DATA2")	,PesqPict("SC5","C5_DATA2"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA2	})	// Data de VENC.2 - VALDEMIR JOSE 27/05/2013
TRCell():New(oCliente,"XLIBERA"		,"TRB",RetTitle("C6_XLIBERA"	),PesqPict("SC6","C6_XLIBERA"	),TamSx3("C6_XLIBERA"	)[1],/*lPixel*/,{|| TRB->XLIBERA					})	// Status Libera
TRCell():New(oCliente,"TABELA"		,"TRB",RetTitle("C5_TABELA"	),PesqPict("SC5","C5_TABELA"	),TamSx3("C5_TABELA"	)[1],/*lPixel*/,{|| TRB->TABELA					})	// Tabela de Pre-Pedido
TRCell():New(oCliente,"TABDES"		,"TRB",RetTitle("C5_XTABDES"	),PesqPict("SC5","C5_XTABDES"	),TamSx3("C5_XTABDES"	)[1],/*lPixel*/,{|| TRB->TABDES				})	// 
TRCell():New(oCliente,"VEND2"		,"TRB","Cooperativa"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->VEND2 })	// 
TRCell():New(oCliente,"TPFIN"		,"TRB",RetTitle("C5_XTPFIN"	),PesqPict("SC5","C5_XTPFIN"	),TamSx3("C5_XTPFIN"	)[1],/*lPixel*/,{|| TRB->TPFIN				})	// 
TRCell():New(oCliente,"DESCTP"		,"TRB",RetTitle("C5_DESCTP"	),PesqPict("SC5","C5_DESCTP"	),TamSx3("C5_DESCTP"	)[1],/*lPixel*/,{|| TRB->DESCTP				})	// 
TRCell():New(oCliente,"VEND3"		,"TRB",RetTitle("C5_VEND3"	),PesqPict("SC5","C5_VEND3"	),TamSx3("C5_VEND3"	)[1],/*lPixel*/,{|| TRB->VEND3				})	// 
TRCell():New(oCliente,"NOMEV3"		,"TRB","Nome Vend 3"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->NOMEV3 })	// 
TRCell():New(oCliente,"XGESTOR"		,"TRB",RetTitle("A1_XGESTOR"	),PesqPict("SA1","A1_XGESTOR"	),TamSx3("A1_XGESTOR"	)[1],/*lPixel*/,{|| TRB->XGESTOR				})	// 
TRCell():New(oCliente,"XNOMEG"		,"TRB",RetTitle("X5_DESCRI"	),PesqPict("SX5","X5_DESCRI"	),TamSx3("X5_DESCRI"	)[1],/*lPixel*/,{|| TRB->XNOMEG				})	// 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Data de Entrega                                                	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oData := TRSection():New(oReport,"Por Dt. Entrega",{/*"TRB","SC6",*/"SA1","SA3","SF4","SB1","SC5","SZ2","SX5"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// ###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oData:SetTotalInLine(.F.)

TRCell():New(oData,"DATENTR"	,"TRB",RetTitle("C6_ENTREG"		),PesqPict("SC6","C6_ENTREG"	),TamSx3("C6_ENTREG"	)[1],/*lPixel*/,{|| TRB->DATENTR																			})
TRCell():New(oData,"FILIAL"		,"TRB",RetTitle("C6_FILIAL"		),PesqPict("SC6","C6_FILIAL"	),TamSx3("C6_FILIAL"	)[1],/*lPixel*/,{|| TRB->FILIAL						})
TRCell():New(oData,"NUM"		,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oData,"NUMSFA"		,"TRB",RetTitle("Z2_NUMSFA"		),PesqPict("SZ2","Z2_NUMSFA"	),TamSx3("Z2_NUMSFA"	)[1],/*lPixel*/,{|| TRB->NUMSFA																			})
TRCell():New(oData,"XTPPED"		,"TRB",RetTitle("C5_XTPPED"		),PesqPict("SC5","C5_XTPPED"	),TamSx3("C5_XTPPED"	)[1],/*lPixel*/,{|| IIF(AllTrim(TRB->XTPPED) == "1","1-Entrega Futura",IIF(AllTrim(TRB->XTPPED) == "2","2-Conta e Ordem",IIF(AllTrim(TRB->XTPPED) == "3","3-Normal",""))) 	})	// Tipo de Pre-Pedido 
TRCell():New(oData,"EMISSAO"	,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO 																			})
TRCell():New(oData,"CLIENTE"	,"TRB",RetTitle("C6_CLI"		),PesqPict("SC6","C6_CLI"		),TamSx3("C6_CLI"		)[1],/*lPixel*/,{|| TRB->CLIENTE 																			})
TRCell():New(oData,"LOJA"		,"TRB",RetTitle("C6_LOJA"		),PesqPict("SC6","C6_LOJA"		),TamSx3("C6_LOJA"		)[1],/*lPixel*/,{|| TRB->LOJA 																				})
TRCell():New(oData,"NOMECLI"	,"TRB",RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| TRB->NOMECLI 																			})
TRCell():New(oData,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oData,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(odata,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oData,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oData,"NTOTVEN"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(odata,"NTOTENT"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oData,"NSALDO"		,	  ,"Quant.Pendente"			 ,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oData,"NVALOR"		,	  ,"Valor Total Pendente"	 ,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor																						})	// "Valor Total Pendente"
TRCell():New(oData,"NPRCVEN"	,"TRB"	,"Vlr Unit"	,"@E 9999999.9999",TamSx3("C6_PRCVEN"		)[1],/*lPixel*/,{|| TRB->NPRCVEN 	})	// "Vlr Unitario
TRCell():New(oData,"PARC1"	,"TRB"	,"Parc.1"	,"@E 999.99",TamSx3("C5_PARC1"		)[1],/*lPixel*/,{|| TRB->PARC1 	})	// "Parc.1 VALDEMIR JOSE 27/05/2013
TRCell():New(oData,"DATA1"	,"TRB"  ,RetTitle("C5_DATA1")	,PesqPict("SC5","C5_DATA1"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA1	})	// Data de VENC.1 VALDEMIR JOSE 27/05/2013
TRCell():New(oData,"PARC2"	,"TRB"	,"Parc.2"	,"@E 999.99",TamSx3("C5_PARC2"		)[1],/*lPixel*/,{|| TRB->PARC2 	})	// "Parc.2 VALDEMIR JOSE 27/05/2013
TRCell():New(oData,"DATA2"	,"TRB"  ,RetTitle("C5_DATA2")	,PesqPict("SC5","C5_DATA2"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA2	})	// Data de VENC.2 VALDEMIR JOSE 27/05/2013
TRCell():New(oData,"XLIBERA"		,"TRB",RetTitle("C6_XLIBERA"	),PesqPict("SC6","C6_XLIBERA"	),TamSx3("C6_XLIBERA"	)[1],/*lPixel*/,{|| TRB->XLIBERA					})	// Status Libera
TRCell():New(oData,"TABELA"		,"TRB",RetTitle("C5_TABELA"	),PesqPict("SC5","C5_TABELA"	),TamSx3("C5_TABELA"	)[1],/*lPixel*/,{|| TRB->TABELA					})	// Tabela de Pre-Pedido
TRCell():New(oData,"TABDES"		,"TRB",RetTitle("C5_XTABDES"	),PesqPict("SC5","C5_XTABDES"	),TamSx3("C5_XTABDES"	)[1],/*lPixel*/,{|| TRB->TABDES				})	// 
TRCell():New(oData,"VEND2"		,"TRB","Cooperativa"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->VEND2 })	// 
TRCell():New(oData,"TPFIN"		,"TRB",RetTitle("C5_XTPFIN"	),PesqPict("SC5","C5_XTPFIN"	),TamSx3("C5_XTPFIN"	)[1],/*lPixel*/,{|| TRB->TPFIN				})	// 
TRCell():New(oData,"DESCTP"		,"TRB",RetTitle("C5_DESCTP"	),PesqPict("SC5","C5_DESCTP"	),TamSx3("C5_DESCTP"	)[1],/*lPixel*/,{|| TRB->DESCTP				})	// 
TRCell():New(oData,"VEND3"		,"TRB",RetTitle("C5_VEND3"	),PesqPict("SC5","C5_VEND3"	),TamSx3("C5_VEND3"	)[1],/*lPixel*/,{|| TRB->VEND3				})	// 
TRCell():New(oData,"NOMEV3"		,"TRB","Nome Vend 3"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->NOMEV3 })	// 
TRCell():New(oData,"XGESTOR"		,"TRB",RetTitle("A1_XGESTOR"	),PesqPict("SA1","A1_XGESTOR"	),TamSx3("A1_XGESTOR"	)[1],/*lPixel*/,{|| TRB->XGESTOR				})	// 
TRCell():New(oData,"XNOMEG"		,"TRB",RetTitle("X5_DESCRI"	),PesqPict("SX5","X5_DESCRI"	),TamSx3("X5_DESCRI"	)[1],/*lPixel*/,{|| TRB->XNOMEG				})	// 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Vendedor                                                       	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oVendedor := TRSection():New(oReport,"Por Vendedor",{/*"TRB","SC6",*/"SA1","SA3","SF4","SB1","SC5","SZ2","SX5"},{STR0031,STR0032,STR0033,STR0034,STR0035},/*Campos do SX3*/,/*Campos do SIX*/)	// ###"Por Pedido"###"Por Produto"###"Por Cliente"###"Por Dt.Entrega"###"Por Vendedor"
oVendedor:SetTotalInLine(.F.)

TRCell():New(oVendedor,"VENDEDOR"	,"TRB",RetTitle("C5_VEND1"		),PesqPict("SC5","C5_VEND1"	),TamSx3("C5_VEND1"	)[1],/*lPixel*/,{|| TRB->VENDEDOR																					})
TRCell():New(oVendedor,"NOMEVEN"	,"TRB",RetTitle("A3_NREDUZ"		),PesqPict("SA3","A3_NREDUZ"	),TamSx3("A3_NREDUZ"	)[1],/*lPixel*/,{|| TRB->NOMEVEN																					})
TRCell():New(oVendedor,"FILIAL"		,"TRB",RetTitle("C6_FILIAL"		),PesqPict("SC6","C6_FILIAL"	),TamSx3("C6_FILIAL"	)[1],/*lPixel*/,{|| TRB->FILIAL						})
TRCell():New(oVendedor,"NUM"		,"TRB",RetTitle("C6_NUM"		),PesqPict("SC6","C6_NUM"		),TamSx3("C6_NUM"		)[1],/*lPixel*/,{|| TRB->NUM 																				})
TRCell():New(oVendedor,"NUMSFA"		,"TRB",RetTitle("Z2_NUMSFA"		),PesqPict("SZ2","Z2_NUMSFA"	),TamSx3("Z2_NUMSFA"	)[1],/*lPixel*/,{|| TRB->NUMSFA																			})
TRCell():New(oVendedor,"XTPPED"		,"TRB",RetTitle("C5_XTPPED"		),PesqPict("SC5","C5_XTPPED"	),TamSx3("C5_XTPPED"	)[1],/*lPixel*/,{|| IIF(AllTrim(TRB->XTPPED) == "1","1-Entrega Futura",IIF(AllTrim(TRB->XTPPED) == "2","2-Conta e Ordem",IIF(AllTrim(TRB->XTPPED) == "3","3-Normal",""))) 	})	// Tipo de Pre-Pedido 
TRCell():New(oVendedor,"ITEM"		,"TRB",RetTitle("C6_ITEM"		),PesqPict("SC6","C6_ITEM"		),TamSx3("C6_ITEM"		)[1],/*lPixel*/,{|| TRB->ITEM 																				})
TRCell():New(oVendedor,"EMISSAO"	,"TRB",RetTitle("C5_EMISSAO"	),PesqPict("SC5","C5_EMISSAO"	),TamSx3("C5_EMISSAO"	)[1],/*lPixel*/,{|| TRB->EMISSAO 																			})
TRCell():New(oVendedor,"PRODUTO1"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| Substr(TRB->PRODUTO,1,nTamref)	})
TRCell():New(oVendedor,"PRODUTO2"	,"TRB",RetTitle("C6_PRODUTO"	),PesqPict("SC6","C6_PRODUTO"	),TamSx3("C6_PRODUTO"	)[1],/*lPixel*/,{|| TRB->PRODUTO	})
TRCell():New(oVendedor,"DESCRICAO"	,"TRB",RetTitle("C6_DESCRI"		),PesqPict("SC6","C6_DESCRI"	),TamSx3("C6_DESCRI"	)[1],/*lPixel*/,{|| TRB->DESCRICAO																			})
TRCell():New(oVendedor,"DATENTR"	,"TRB",RetTitle("C6_ENTREG"		),PesqPict("SC6","C6_ENTREG"	),TamSx3("C6_ENTREG"	)[1],/*lPixel*/,{|| TRB->DATENTR																			})
TRCell():New(oVendedor,"NTOTVEN"	,"TRB",RetTitle("C6_QTDVEN"		),PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDVEN"	)[1],/*lPixel*/,{|| nTotVen							})
TRCell():New(oVendedor,"NTOTENT"	,"TRB",RetTitle("C6_QTDENT"		),PesqPict("SC6","C6_QTDENT"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nTotEnt							})
TRCell():New(oVendedor,"NSALDO"		,	  ,"Quant.Pendente"			 ,PesqPict("SC6","C6_QTDVEN"	),TamSx3("C6_QTDENT"	)[1],/*lPixel*/,{|| nSaldo																						})	// "Quant.Pendente"
TRCell():New(oVendedor,"NVALOR"		,	  ,"Valor Total Pendente"	 ,PesqPict("SC6","C6_VALOR"		),TamSx3("C6_VALOR"		)[1],/*lPixel*/,{|| nValor																						})	// "Valor Total Pendente"
TRCell():New(oVendedor,"NPRCVEN"	,"TRB"	,"Vlr Unit"	,"@E 9999999.9999",TamSx3("C6_PRCVEN"		)[1],/*lPixel*/,{|| TRB->NPRCVEN 	})	// "Vlr Unitario
TRCell():New(oVendedor,"PARC1"	,"TRB"	,"Parc.1"	,"@E 999.99",TamSx3("C5_PARC1"		)[1],/*lPixel*/,{|| TRB->PARC1 	})	// "Parc.1 VALDEMIR JOSE 27/05/2013
TRCell():New(oVendedor,"DATA1"	,"TRB"  ,RetTitle("C5_DATA1")	,PesqPict("SC5","C5_DATA1"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA1	})	// Data de VENC.1 VALDEMIR JOSE 27/05/2013
TRCell():New(oVendedor,"PARC2"	,"TRB"	,"Parc.2"	,"@E 999.99",TamSx3("C5_PARC2"		)[1],/*lPixel*/,{|| TRB->PARC2 	})	// "Parc.2 VALDEMIR JOSE 27/05/2013
TRCell():New(oVendedor,"DATA2"	,"TRB"  ,RetTitle("C5_DATA2")	,PesqPict("SC5","C5_DATA2"	),TamSx3("C6_ENTREG"	)[1] ,/*lPixel*/ ,{|| TRB->DATA2	})	// Data de VENC.2 VALDEMIR JOSE 27/05/2013
TRCell():New(oVendedor,"XLIBERA"	,"TRB",RetTitle("C6_XLIBERA"	),PesqPict("SC6","C6_XLIBERA"	),TamSx3("C6_XLIBERA"	)[1],/*lPixel*/,{|| TRB->XLIBERA					})	// Status Libera
TRCell():New(oVendedor,"TABELA"		,"TRB",RetTitle("C5_TABELA"	),PesqPict("SC5","C5_TABELA"	),TamSx3("C5_TABELA"	)[1],/*lPixel*/,{|| TRB->TABELA					})	// Tabela de Pre-Pedido
TRCell():New(oVendedor,"TABDES"		,"TRB",RetTitle("C5_XTABDES"),PesqPict("SC5","C5_XTABDES"	),TamSx3("C5_XTABDES"	)[1],/*lPixel*/,{|| TRB->TABDES				})	// 
TRCell():New(oVendedor,"VEND2"		,"TRB","Cooperativa"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->VEND2 })	// 
TRCell():New(oVendedor,"TPFIN"		,"TRB",RetTitle("C5_XTPFIN"	),PesqPict("SC5","C5_XTPFIN"	),TamSx3("C5_XTPFIN"	)[1],/*lPixel*/,{|| TRB->TPFIN				})	// 
TRCell():New(oVendedor,"DESCTP"		,"TRB",RetTitle("C5_DESCTP"	),PesqPict("SC5","C5_DESCTP"	),TamSx3("C5_DESCTP"	)[1],/*lPixel*/,{|| TRB->DESCTP				})	// 
TRCell():New(oVendedor,"VEND3"		,"TRB",RetTitle("C5_VEND3"	),PesqPict("SC5","C5_VEND3"	),TamSx3("C5_VEND3"	)[1],/*lPixel*/,{|| TRB->VEND3				})	// 
TRCell():New(oVendedor,"NOMEV3"		,"TRB","Nome Vend 3"		  ,PesqPict("SA3","A3_NREDUZ"	)    ,TamSx3("A3_NREDUZ"	    )[1],/*lPixel*/,{|| TRB->NOMEV3 })	// 
TRCell():New(oVendedor,"XGESTOR"	,"TRB",RetTitle("A1_XGESTOR"	),PesqPict("SA1","A1_XGESTOR"	),TamSx3("A1_XGESTOR"	)[1],/*lPixel*/,{|| TRB->XGESTOR				})	// 
TRCell():New(oVendedor,"XNOMEG"		,"TRB",RetTitle("X5_DESCRI"	),PesqPict("SX5","X5_DESCRI"	),TamSx3("X5_DESCRI"	)[1],/*lPixel*/,{|| TRB->XNOMEG				})	// 

oReport:Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(2):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(3):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
//oReport:Section(4):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
//oReport:Section(5):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 				    	               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fCriaSX1(cperg)
Pergunte(oReport:uParam,.F.)

oReport:Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(2):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
oReport:Section(3):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
//oReport:Section(4):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
//oReport:Section(5):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Marco Bianchi         ³ Data ³ 04/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportPrint(oReport,cAliasQry,oPedNEnt,oProduto,oCliente,oData,oVendedor)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis   										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local dData     := CtoD("  /  /  ")
Local cNumPed   := ""
Local cNumCli   := ""
Local nTotVen   := 0
Local nTotEnt   := 0
Local nFirst    := 0
Local nSaldo    := 0
Local nValor    := 0
Local cQuebra	:= ""
Local nSection  := oReport:Section(1):GetOrder()
Local oSecao    := oReport:Section(nSection)

Private nMoeda    := IIF(cPaisLoc == "BRA",mv_par22,1)
Private cNum		:= ""
Private cProduto	:= ""
Private cCli		:= ""
Private dEntreg 	:= CtoD("  /  /  ")
Private cVde    	:= ""

Private cFilSA1     := ""
Private cFilSA3     := ""
Private cFilSB1     := ""
Private cFilSF4     := ""
Private cFilSC5     := ""
Private cFilSZ2     := ""
Private cFilSX5     := ""

oSecao:Cell("NSALDO" ):SetBlock({|| nSaldo})
oSecao:Cell("NVALOR" ):SetBlock({|| nValor})
oSecao:Cell("NTOTVEN" ):SetBlock({|| nTotVen})
oSecao:Cell("NTOTENT" ):SetBlock({|| nTotEnt})
nSaldo  := 0
nValor  := 0
nTotVen := 0
nTotEnt := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Por Pedido                                                         	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nSection == 1			// Por Pedido
	cQuebra := "NUM = cNum"
	TRFunction():New(oPedNEnt:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oPedNEnt:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oPedNEnt:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oPedNEnt:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Por Produto                                                       	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf nSection == 2		// Por Produto
	cQuebra := "PRODUTO = cProduto"
	TRFunction():New(oProduto:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oProduto:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oProduto:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oProduto:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Por Cliente                                                       	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf nSection == 3		// Por Cliente
	cQuebra := "CLIENTE+LOJA = cCli"
	TRFunction():New(oCliente:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oCliente:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oCliente:Cell("NSALDO"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oCliente:Cell("NVALOR"		),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Por Data de Entrega                                                	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf nSection == 4		// Por Data de Entrega
	cQuebra := "DATENTR = dEntreg"
	TRFunction():New(oData:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oData:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oData:Cell("NSALDO"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oData:Cell("NVALOR"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Por Vendedor                                                       	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Else
	cQuebra := "VENDEDOR = cVde"
	TRFunction():New(oVendedor:Cell("NTOTVEN"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oVendedor:Cell("NTOTENT"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oVendedor:Cell("NSALDO"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oVendedor:Cell("NVALOR"	),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Altera o Titulo do Relatorio de acordo com parametros	 	           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title() + " - " + IIF(nSection == 1,STR0031,	;		// "Relacao de Pedidos nao entregues"###"Por Pedido"
IIF(nSection==2,STR0032,;				// "Por Produto"
IIF(nSection==3,STR0033,;				// "Por Cliente"
IIF(nSection==4,STR0034,STR0035))));	// "Por Dt.Entrega"###"Por Vendedor"
+ " - " + GetMv("MV_MOEDA"+STR(nMoeda,1)))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho no top da pagina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSecao:SetHeaderPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma parametros Range em expressao SQL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oSecao,"SA1",1,{|| xFilial("SA1")+TRB->CLIENTE+TRB->LOJA })
TRPosition():New(oSecao,"SA3",1,{|| xFilial("SA3")+TRB->VENDEDOR })
TRPosition():New(oSecao,"SF4",1,{|| xFilial("SF4")+TRB->TES })
TRPosition():New(oSecao,"SB1",1,{|| xFilial("SB1")+TRB->PRODUTO })
TRPosition():New(oSecao,"SC5",1,{|| TRB->FILIAL+TRB->NUM })
TRPosition():New(oSecao,"SZ2",1,{|| Space(02)  +TRB->NUM })
TRPosition():New(oSecao,"SX5",1,{|| xFilial("SX5")+"ZC"+TRB->XNOMEG })

//TRPosition():New(oSecao,"SC6",1,{|| xFilial("SC6")+TRB->NUM+TRB->ITEM+TRB->PRODUTO })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Tabela Temporaria para impressao                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| TR680Trab(oReport,cAliasQry,nSection,oSecao)},STR0038)			// "Gerando Tabela de Trabalho. Aguarde..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGoTop()
oReport:SetMeter(RecCount())		// Total de elementos da regua

nFirst := 0
oSecao:Init()
While !oReport:Cancel() .And. !Eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica campo para quebra									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFil    := TRB->FILIAL
	cNum	:= NUM
	cProduto:= PRODUTO
	cCli	:= CLIENTE+LOJA
	dEntreg := DATENTR
	cVde    := VENDEDOR
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis Totalizadoras     		    					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldo  := QUANTIDADE-ENTREGUE
	nTotVen := QUANTIDADE
	nTotEnt := ENTREGUE
	nValor  := xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrutina os produtos da grade conforme o parametro mv_par16  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF TRB->GRADE == "S" .And. mv_par16 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		If nSection = 2
			cAgrutina := "cProdRef == Substr(PRODUTO,1,nTamRef)"
		Else
			cAgrutina := cQuebra
		Endif
		
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
		nValor  := 0
		nReg    := 0
		
		While !Eof() .And. cFil == TRB->FILIAL .And. cProdRef == Substr(PRODUTO,1,nTamRef);
			.And. TRB->GRADE == "S" .And. &cAgrutina .And. cNum == NUM
			
			nReg	:= Recno()
			nTotVen += QUANTIDADE
			nTotEnt += ENTREGUE
			nSaldo  += QUANTIDADE-ENTREGUE
			nValor  += xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
			
			dbSelectArea("TRB")
			dbSkip()
			oReport:IncMeter()
			
		End
		
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	
	If (nFirst = 0 .And. nSection != 4) .Or. nSection == 4
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleicona celulas do cabecalho da linha                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case nSection = 1    				// Por Pedido
				oSecao:Cell("FILIAL"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
			Case nSection = 2					// Pro Produto
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("FILIAL"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
			Case nSection = 3					// Por Cliente
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
				oSecao:Cell("FILIAL"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
			Case nSection = 4					// Por Data de Entrega
				If cNumPed+cNumCli+DtoS(dData) == NUM+CLIENTE+DtoS(DATENTR)
					oSecao:Cell("DATENTR"	):Hide()
					oSecao:Cell("FILIAL"	):Hide()
					oSecao:Cell("NUM"		):Hide()
					oSecao:Cell("EMISSAO"	):Hide()
					oSecao:Cell("CLIENTE"	):Hide()
					oSecao:Cell("LOJA"		):Hide()
					oSecao:Cell("NOMECLI"	):Hide()
				Else
					oSecao:Cell("DATENTR"	):Show()
					oSecao:Cell("FILIAL"	):Show()
					oSecao:Cell("NUM"		):Show()
					oSecao:Cell("EMISSAO"	):Show()
					oSecao:Cell("CLIENTE"	):Show()
					oSecao:Cell("LOJA"		):Show()
					oSecao:Cell("NOMECLI"	):Show()
				EndIf
				cNumPed := NUM
				cNumCli := CLIENTE
				dData   := DATENTR
				
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
			OtherWise	  											// Por Vendedor
				oSecao:Cell("VENDEDOR"	):Show()
				oSecao:Cell("NOMEVEN"	):Show()
				oSecao:Cell("FILIAL"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
		EndCase
		
		IF nFirst = 0 .And. nSection != 4
			nFirst := 1
		Endif
		
	Else
		
		Do Case
			Case nSection = 1    				// Por Pedido
				oSecao:Cell("FILIAL"	):Hide()
				oSecao:Cell("NUM"		):Hide()
				oSecao:Cell("EMISSAO"	):Hide()
				oSecao:Cell("CLIENTE"	):Hide()
				oSecao:Cell("LOJA"		):Hide()
				oSecao:Cell("NOMECLI"	):Hide()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				IF mv_par27 == 1    // // VALDEMIR JOSE 27/05/2013
					oSecao:Cell("PARC1"	):Show()
					oSecao:Cell("DATA1"	):Show()    
					oSecao:Cell("PARC2"	):Show()
					oSecao:Cell("DATA2"	):Show()
				ELSE
					oSecao:Cell("PARC1"	):Hide()
					oSecao:Cell("DATA1"	):Hide()
					oSecao:Cell("PARC2"	):Hide()
					oSecao:Cell("DATA2"	):Hide()
				ENDIF
			Case nSection = 2					// Pro Produto
				oSecao:Cell("PRODUTO1"	):Hide()
				oSecao:Cell("PRODUTO2"	):Hide()
				oSecao:Cell("DESCRICAO"	):Hide()
				oSecao:Cell("FILIAL"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				oSecao:Cell("CLIENTE"	):Show()
				oSecao:Cell("LOJA"		):Show()
				oSecao:Cell("NOMECLI"	):Show()
				IF mv_par27 == 1   // VALDEMIR JOSE 27/05/2013
					oSecao:Cell("PARC1"	):Show()
					oSecao:Cell("DATA1"	):Show()
					oSecao:Cell("PARC2"	):Show()
					oSecao:Cell("DATA2"	):Show()
				ELSE
					oSecao:Cell("PARC1"	):Hide()
					oSecao:Cell("DATA1"	):Hide()
					oSecao:Cell("PARC2"	):Hide()
					oSecao:Cell("DATA2"	):Hide()
				ENDIF
			Case nSection = 3					// Por Cliente
				oSecao:Cell("CLIENTE"	):Hide()
				oSecao:Cell("LOJA"		):Hide()
				oSecao:Cell("NOMECLI"	):Hide()
				oSecao:Cell("FILIAL"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				IF mv_par27 == 1     // VALDEMIR JOSE 27/05/2013
					oSecao:Cell("PARC1"	):Show()
					oSecao:Cell("DATA1"	):Show()
					oSecao:Cell("PARC2"	):Show()
					oSecao:Cell("DATA2"	):Show()
				ELSE
					oSecao:Cell("PARC1"	):Hide()
					oSecao:Cell("DATA1"	):Hide()
					oSecao:Cell("PARC2"	):Hide()
					oSecao:Cell("DATA2"	):Hide()
				ENDIF
			Case nSection = 4					// Por Data de Entrega
				If cNumPed+cNumCli+DtoS(dData) == NUM+CLIENTE+DtoS(DATENTR)
					oSecao:Cell("DATENTR"	):Hide()
					oSecao:Cell("FILIAL"	):Hide()
					oSecao:Cell("NUM"		):Hide()
					oSecao:Cell("EMISSAO"	):Hide()
					oSecao:Cell("CLIENTE"	):Hide()
					oSecao:Cell("LOJA"		):Hide()
					oSecao:Cell("NOMECLI"	):Hide()
				Else
					oSecao:Cell("DATENTR"	):Show()
					oSecao:Cell("FILIAL"	):Show()
					oSecao:Cell("NUM"		):Show()
					oSecao:Cell("EMISSAO"	):Show()
					oSecao:Cell("CLIENTE"	):Show()
					oSecao:Cell("LOJA"		):Show()
					oSecao:Cell("NOMECLI"	):Show()
				EndIf
				cNumPed := NUM
				cNumCli := CLIENTE
				dData   := DATENTR
				
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				IF mv_par27 == 1   				// VALDEMIR JOSE 27/05/2013
					oSecao:Cell("PARC1"	):Show()
					oSecao:Cell("DATA1"	):Show()
					oSecao:Cell("PARC2"	):Show()
					oSecao:Cell("DATA2"	):Show()
				ELSE
					oSecao:Cell("PARC1"	):Hide()
					oSecao:Cell("DATA1"	):Hide()
					oSecao:Cell("PARC2"	):Hide()
					oSecao:Cell("DATA2"	):Hide()
				ENDIF
			OtherWise												// Por Vendedor
				oSecao:Cell("VENDEDOR"	):Hide()
				oSecao:Cell("NOMEVEN"	):Hide()
				oSecao:Cell("FILIAL"	):Show()
				oSecao:Cell("NUM"		):Show()
				oSecao:Cell("ITEM"		):Show()
				oSecao:Cell("EMISSAO"	):Show()
				oSecao:Cell("PRODUTO1"	):Show()
				oSecao:Cell("PRODUTO2"	):Show()
				oSecao:Cell("DESCRICAO"	):Show()
				oSecao:Cell("DATENTR"	):Show()
				IF mv_par27 == 1 	// VALDEMIR JOSE 27/05/2013
					oSecao:Cell("PARC1"	):Show()
					oSecao:Cell("DATA1"	):Show()
					oSecao:Cell("PARC2"	):Show()
					oSecao:Cell("DATA2"	):Show()
				ELSE
					oSecao:Cell("PARC1"	):Hide()
					oSecao:Cell("DATA1"	):Hide()
					oSecao:Cell("PARC2"	):Hide()
					oSecao:Cell("DATA2"	):Hide()
				ENDIF
		EndCase
		
	EndIf
	
	If TRB->GRADE=="S" .And. mv_par16 == 1
		oSecao:Cell("PRODUTO2"):Disable()
		oSecao:Cell("PRODUTO1"):Enable()
	Else
		oSecao:Cell("PRODUTO1"):Disable()
		oSecao:Cell("PRODUTO2"):Enable()
	EndIf
	
	oSecao:PrintLine()
	
	dbSelectArea("TRB")
	dbSkip()
	oReport:IncMeter()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total do Pedido                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If NUM <> cNum
		If   nSection = 3 .Or.	nSection = 4 .Or.	nSection = 1
			oSecao:SetTotalText(STR0031 + " " + cNum)
			oSecao:Finish()
			oSecao:Init()
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total ou linha divisora conforme a quebra		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cQuebra
		
		nTotVen := 0
		nTotEnt := 0
		nFirst  := 0
		
		oSecao:SetTotalText(IIF(nSection == 1,STR0031 + " " + cNum			,;					// "Total do Pedido"
		IIF(nSection == 2,STR0032 + " " + cProduto		,;					// "Total do Produto"
		IIF(nSection == 3,STR0033 + " " + cCli			,;					// "Total do Cliente"
		IIF(nSection == 4,STR0034 + " " + DTOC(dEntreg),STR0035  + " " + cVde)))))		// "Total da Dt.Entrega"###"Total do Vendedor"
		
		// Finaliza Secao
		If nSection <> 3 .And. nSection <> 4 .And. nSection <> 1
			oSecao:Finish()
			oSecao:Init()
		EndIf
		
		If mv_par19 == 1 .And. !Eof()
			// Forca salto de pagina no fim da secao
			oReport:nrow := 5000
			oReport:skipLine()
		EndIf
		
		
	Endif
	
	dbSelectArea("TRB")
	
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Relatorio                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSecao:SetPageBreak()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha tabela de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Tabelas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³TR680Trab ³ Autor ³ Marco Bianchi         ³ Data ³ 05/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria Arquivo de Trabalho                             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATB680													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function TR680Trab(oReport,cAliasQry,nSection,oSecao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCampos   := {}
Local aTam      := ""
Local cVend     := ""
Local cVendedor := ""
Local nTipVal   := IIF(cPaisLoc == "BRA",mv_par23,mv_par24)
Local nSaldo    := 0
Local nX        := 0
Local nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
Local nValor	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("Z2_NUMSFA")
AADD(aCampos,{ "NUMSFA"   ,"C",aTam[1],aTam[2] } )   
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NREDUZ")
AADD(aCampos,{ "NOMEVEN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEMGRD")
AADD(aCampos,{ "ITEMGRD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLQ")
AADD(aCampos,{ "BLQ"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLOQUEI")
AADD(aCampos,{ "BLOQUEI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRCVEN")
AADD(aCampos,{ "NPRCVEN"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_PARC1")
AADD(aCampos,{ "PARC1"   ,"N",aTam[1],aTam[2] } )
//  VALDEMIR JOSE 27/05/2013
aTam:=TamSX3("C5_DATA1")					
AADD(aCampos,{ "DATA1"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_PARC2")
AADD(aCampos,{ "PARC2"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_DATA2")
AADD(aCampos,{ "DATA2"   ,"D",aTam[1],aTam[2] } )
//-------------------------------------
aTam:=TamSX3("C6_XLIBERA")
AADD(aCampos,{ "XLIBERA"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_XTPPED")
AADD(aCampos,{ "XTPPED"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_XTPFIN")
AADD(aCampos,{ "TPFIN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_DESCTP")
AADD(aCampos,{ "DESCTP"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_TABELA")
AADD(aCampos,{ "TABELA"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_XTABDES")
AADD(aCampos,{ "TABDES"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NREDUZ")
AADD(aCampos,{ "VEND2" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND3")
AADD(aCampos,{ "VEND3"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NREDUZ")
AADD(aCampos,{ "NOMEV3" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_XGESTOR")
AADD(aCampos,{ "XGESTOR"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("X5_DESCRI")
AADD(aCampos,{ "XNOMEG","C",aTam[1],aTam[2] } )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

dbSelectArea("TRB")
Do Case
	Case nSection = 1
		IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRODUTO",,,STR0040)       //"Selecionando Registros..."
	Case nSection = 2
		IndRegua("TRB",cArqTrab,"FILIAL+PRODUTO+NUM+ITEM",,,STR0040)       //"Selecionando Registros..."
	Case nSection = 3
		IndRegua("TRB",cArqTrab,"FILIAL+CLIENTE+LOJA+NUM+ITEM",,,STR0040)  //"Selecionando Registros..."
	Case nSection = 4
		IndRegua("TRB",cArqTrab,"FILIAL+DTOS(DATENTR)+NUM+ITEM",,,STR0040) //"Selecionando Registros..."
	Case nSection = 5
		IndRegua("TRB",cArqTrab,"FILIAL+VENDEDOR+NUM+ITEM",,,STR0040)      //"Selecionando Registros..."
EndCase

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)

aStruSC6  := SC6->(dbStruct())
cWhere := "%"
If mv_par17 == 3
	cWhere += " AND C6_BLQ = 'R '"
Endif
cWhere += "%"

cWhere := "%"
If Mv_par30 <> 4
	cWhere += " AND C5_XTPPED = " + Alltrim(Str(MV_PAR30))
Endif
cWhere += "%"

oSecao:BeginQuery()
BeginSql Alias cAliasQry                                                                                                 // ADICIONADO PARC E DATA    VALDEMIR JOSE 27/05/2013
	SELECT SC6.*,SC5.C5_XTPPED, SC5.C5_XTPFIN, SC5.C5_DESCTP, SC5.C5_VEND3, SC5.C5_TABELA, SC5.C5_XTABDES, SC5.C5_MOEDA, SC5.C5_PARC1, SC5.C5_DATA1, SC5.C5_PARC2, SC5.C5_DATA2,
	ISNULL((SELECT A3_NREDUZ FROM %table:SA3% SA3 WHERE SA3.A3_FILIAL = %xFilial:SA3% AND SA3.A3_COD = SC5.C5_VEND2 AND SA3.%NotDel%),' ')A3_NREDUZ
	FROM %Table:SC6% SC6,%Table:SC5% SC5
	WHERE SC6.%notdel%
	AND C6_FILIAL >= %Exp:mv_par01% AND C6_FILIAL <= %Exp:mv_par02%
	AND C6_NUM >= %Exp:mv_par03% AND C6_NUM <= %Exp:mv_par04%
	AND C6_PRODUTO >= %Exp:mv_par07% AND C6_PRODUTO <= %Exp:mv_par08%
	AND C6_CLI >= %Exp:mv_par09% AND C6_CLI <= %Exp:mv_par10%
	AND C6_ENTREG >= %Exp:DtoS(mv_par11)% AND C6_ENTREG <= %Exp:DtoS(mv_par12)%
	AND SC6.%notdel%
	AND C6_NUM = C5_NUM
	AND C6_FILIAL = C5_FILIAL
	%Exp:cWhere%
	ORDER BY C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO
EndSql
oSecao:EndQuery()
oSecao:SetParentQuery()

If len(oSecao:GetAdvplExp("SA1")) > 0
	cFilSA1 := oSecao:GetAdvplExp("SA1")
EndIf
If len(oSecao:GetAdvplExp("SA3")) > 0
	cFilSA3 := oSecao:GetAdvplExp("SA3")
EndIf
If len(oSecao:GetAdvplExp("SB1")) > 0
	cFilSB1 := oSecao:GetAdvplExp("SB1")
EndIf
If len(oSecao:GetAdvplExp("SF4")) > 0
	cFilSF4 := oSecao:GetAdvplExp("SF4")
EndIf
If len(oSecao:GetAdvplExp("SC5")) > 0
	cFilSC5 := oSecao:GetAdvplExp("SC5")
EndIf
If len(oSecao:GetAdvplExp("SZ2")) > 0
	cFilSZ2 := oSecao:GetAdvplExp("SZ2")
EndIf

If len(oSecao:GetAdvplExp("SX5")) > 0
	cFilSX5 := oSecao:GetAdvplExp("SX5")
EndIf

dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter(RecCount())     // Total de Elementos da Regua
While !oReport:Cancel() .And. !Eof()
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial("SA1")+ (cAliasQry)->C6_CLI + (cAliasQry)->C6_LOJA )
	
	// Verifica filtro do usuario
	If !Empty(cFilSA1) .And. !(&cFilSA1)
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf
	
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+ (cAliasQry)->C6_PRODUTO )
	
	// Verifica filtro do usuario
	If !Empty(cFilSB1) .And. !(&cFilSB1)
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf
	
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek( xFilial(("SF4"))+(cAliasQry)->C6_TES )
	
	// Verifica filtro do usuario
	If !Empty(cFilSF4) .And. !(&cFilSF4)
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek( (cAliasQry)->C6_FILIAL + (cAliasQry)->C6_NUM )
	//dbSeek( xFilial(("SC5"))+(cAliasQry)->C6_NUM )
	
	// Verifica filtro do usuario
	If !Empty(cFilSC5) .And. !(&cFilSC5)
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf


	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5")+"ZC"+SA1->A1_XGESTOR)
	
	// Verifica filtro do usuario
	If !Empty(cFilSX5) .And. !(&cFilSX5)
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf

	dbSelectArea(cAliasQry)
	If cPaisLoc <> "BRA"
		If ( SF4->F4_ESTOQUE == "S" .And. mv_par22 == 2 ) .Or. ( SF4->F4_ESTOQUE!= "S" .And. mv_par22 == 1 )
			dbSkip()
			Loop
		Endif
		If mv_par23 <> 4 .And. SC5->(FIELDPOS("C5_DOCGER")) > 0
			If (mv_par23 == 1 .And. SC5->C5_DOCGER <> '1' ) .Or.;		// Gera nota
				(mv_par23 == 2 .And. SC5->C5_DOCGER <> '2' ) .Or.;		// Gera REMITO
				(mv_par23 == 3 .And. SC5->C5_DOCGER <> '3' ) 			// Entrega futura
				dbSkip()
				Loop
			Endif
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se esta dentro dos parametros						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet:=ValidMasc((cAliasQry)->C6_PRODUTO,mv_par15)
	If Alltrim((cAliasQry)->C6_BLQ) == "R" .and. mv_par17 == 2 // Se Foi Eliminado Residuos
		nSaldo  := 0
	Else
		nSaldo  := C6_QTDVEN-C6_QTDENT
	Endif
	
	If ((C6_QTDENT < C6_QTDVEN .And. mv_par13 == 1) .Or. (mv_par13 == 2)).And.;
		((nSaldo == 0 .And. mv_par18 == 1.And.Alltrim((cAliasQry)->C6_BLQ)<>"R").Or. nSaldo <> 0).And.;
		((SF4->F4_DUPLIC == "S" .And. mv_par14 == 1) .Or. (SF4->F4_DUPLIC == "N";
		.And. mv_par14 == 2).Or.(mv_par14 == 3));
		.And. At(SC5->C5_TIPO,"DB") = 0 .And.lRet
		
		If nSection = 5		// Por Vendedor
			
			cVend := "1"
			For nX := 1 to nQtdVend
				cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
				If !EMPTY(cVendedor) .And. (cVendedor >= mv_par20 .And. cVendedor <= mv_par21 )
					
					dbSelectArea("SA3")
					dbSetOrder(1)
					dbSeek( xFilial("SA3")+cVendedor)
					
					// Verifica filtro do usuario
					If (Empty(cFilSA3)) .Or. (!Empty(cFilSA3) .And. (&cFilSA3))
						
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
						
						Replace VENDEDOR   With cVendedor
						Replace NOMEVEN    With SA3->A3_NREDUZ
						Replace FILIAL     With (cAliasQry)->C6_FILIAL
						Replace NUM        With (cAliasQry)->C6_NUM						
						Replace EMISSAO    With SC5->C5_EMISSAO
						Replace CLIENTE    With (cAliasQry)->C6_CLI
						Replace NOMECLI    With SA1->A1_NOME
						Replace LOJA       With (cAliasQry)->C6_LOJA
						Replace DATENTR    With (cAliasQry)->C6_ENTREG
						Replace ITEM       With (cAliasQry)->C6_ITEM
						Replace PRODUTO    With (cAliasQry)->C6_PRODUTO
						Replace DESCRICAO  With (cAliasQry)->C6_DESCRI
						Replace QUANTIDADE With (cAliasQry)->C6_QTDVEN
						Replace NPRCVEN	   With xMoeda((cAliasQry)->C6_PRCVEN,(cAliasQry)->C5_MOEDA,nMoeda,EMISSAO,6)
						Replace ENTREGUE   With (cAliasQry)->C6_QTDENT
						Replace GRADE      With (cAliasQry)->C6_GRADE
						Replace ITEMGRD    With (cAliasQry)->C6_ITEMGRD
						Replace TES        With (cAliasQry)->C6_TES
						Replace BLQ        With (cAliasQry)->C6_BLQ
						Replace BLOQUEI    With (cAliasQry)->C6_BLOQUEI
						Replace PARC1      With (cAliasQry)->C5_PARC1
						// VALDEMIR JOSE 27/05/2013
						Replace DATA1      With (cAliasQry)->C5_DATA1
						Replace PARC2      With (cAliasQry)->C5_PARC2
						Replace DATA2      With (cAliasQry)->C5_DATA2
						//-------------------------------
						Replace XLIBERA    With (cAliasQry)->C6_XLIBERA
						Replace XTPPED     With (cAliasQry)->C5_XTPPED
						Replace TABELA     With (cAliasQry)->C5_TABELA           
						Replace TABDES 	   With (cAliasQry)->C5_XTABDES           
						Replace VEND2 	   With (cAliasQry)->A3_NREDUZ
						Replace TPFIN	   With (cAliasQry)->C5_XTPFIN           
						Replace DESCTP     With (cAliasQry)->C5_DESCTP
						Replace VEND3	   With (cAliasQry)->C5_VEND3           
						Replace NOMEV3	   With Posicione("SA3",1,xFilial("SA3")+(cAliasQry)->C5_VEND3,"A3_NREDUZ")         						
						Replace XGESTOR    With SA1->A1_XGESTOR
						Replace XNOMEG	   With Posicione("SX5",1,xFilial("SX5")+"ZC"+SA1->A1_XGESTOR,"X5_DESCRI")
						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAliasQry)->C6_VALOR
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAliasQry)->C6_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasQry)->C6_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf
						Replace VALOR      With nValor
						Replace MOEDA      With SC5->C5_MOEDA
						
						MsUnLock()
						
					EndIf
					
				Endif
				
				cVend := Soma1(cVend,1)
				dbSelectArea("SC5")
				dbSetOrder(1)
			Next nX
			
		Else
			
			lVend := .F.
			cVend := "1"
			For nX := 1 to nQtdVend
				cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
				
				dbSelectArea("SA3")
				dbSetOrder(1)
				dbSeek( xFilial("SA3")+cVendedor)
				
				// Verifica filtro do usuario
				If (Empty(cFilSA3)) .Or. (!Empty(cFilSA3) .And. (&cFilSA3))
					If (cVendedor >= mv_par20 .And. cVendedor <= mv_par21 )
						lVend :=.T.
						Exit
					Endif
				Endif
				cVend := Soma1(cVend,1)
			Next nX
			
			
			If lVend
				
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				
				Replace FILIAL     With (cAliasQry)->C6_FILIAL
				Replace NUM        With (cAliasQry)->C6_NUM
				Replace EMISSAO    With SC5->C5_EMISSAO
				Replace CLIENTE    With (cAliasQry)->C6_CLI
				Replace NOMECLI    With SA1->A1_NOME
				Replace LOJA       With (cAliasQry)->C6_LOJA
				Replace DATENTR    With (cAliasQry)->C6_ENTREG
				Replace ITEM       With (cAliasQry)->C6_ITEM
				Replace PRODUTO    With (cAliasQry)->C6_PRODUTO
				Replace DESCRICAO  With (cAliasQry)->C6_DESCRI
				Replace QUANTIDADE With (cAliasQry)->C6_QTDVEN
				Replace NPRCVEN	   With xMoeda((cAliasQry)->C6_PRCVEN,(cAliasQry)->C5_MOEDA,nMoeda,EMISSAO,6)
				Replace ENTREGUE   With (cAliasQry)->C6_QTDENT
				Replace GRADE      With (cAliasQry)->C6_GRADE
				Replace ITEMGRD    With (cAliasQry)->C6_ITEMGRD
				Replace TES        With (cAliasQry)->C6_TES
				Replace BLQ        With (cAliasQry)->C6_BLQ
				Replace BLOQUEI    With (cAliasQry)->C6_BLOQUEI
				// VALDEMIR JOSE 27/05/2013
				Replace PARC1      With (cAliasQry)->C5_PARC1
				Replace DATA1      With (cAliasQry)->C5_DATA1
				Replace PARC2      With (cAliasQry)->C5_PARC2
				Replace DATA2      With (cAliasQry)->C5_DATA2
				//-----------------------------
				Replace XLIBERA    With (cAliasQry)->C6_XLIBERA
				Replace XTPPED     With (cAliasQry)->C5_XTPPED
				Replace TABELA     With (cAliasQry)->C5_TABELA           
				Replace TABDES 	   With (cAliasQry)->C5_XTABDES 
				Replace VEND2 	   With (cAliasQry)->A3_NREDUZ
				Replace TPFIN	   With (cAliasQry)->C5_XTPFIN           
				Replace DESCTP     With (cAliasQry)->C5_DESCTP
				Replace VEND3	   With (cAliasQry)->C5_VEND3           
				Replace NOMEV3	   With Posicione("SA3",1,xFilial("SA3")+(cAliasQry)->C5_VEND3,"A3_NREDUZ")          						
				Replace XGESTOR    With SA1->A1_XGESTOR 
				Replace XNOMEG	   With Posicione("SX5",1,xFilial("SX5")+"ZC"+SA1->A1_XGESTOR,"X5_DESCRI")
				If nTipVal == 1 //--  Imprime Valor Total do Item
					nValor:=(cAliasQry)->C6_VALOR
				Else
					//--  Imprime Saldo
					If TRB->QUANTIDADE==0
						nValor:=(cAliasQry)->C6_VALOR
					Else
						nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasQry)->C6_PRCVEN
						nValor := If(nValor<0,0,nValor)
					EndIf
				EndIf
				Replace VALOR      With nValor
				Replace MOEDA      With SC5->C5_MOEDA
				
				lVend := .F.
				MsUnLock()
			Endif
		Endif
	Endif
	
	dbSelectArea(cAliasQry)
	dbSkip()
	oReport:IncMeter()
	
EndDo

dbSelectArea(cAliasQry)
dbClosearea()

//----------------------------------------------------------------------------------------------------------------------------
//INICIA ESTRUTURA PRE-PEDIDO
//----------------------------------------------------------------------------------------------------------------------------

cAliasQry := GetNextAlias()
nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
nSaldo    := 0
nValor    := 0
nX        := 0

dbSelectArea("SZ3")
dbSetOrder(1)

aStruSZ3  := SZ3->(dbStruct())
cWhere := "%"
If mv_par17 == 3
	cWhere += "AND Z3_BLQ IN ('R', 'C')"
ElseIf mv_par17 == 2
	cWhere += "AND Z3_BLQ NOT IN ('R', 'C')"
Endif
cWhere += "%"

oSecao:BeginQuery()
BeginSql Alias cAliasQry                                                                                                                           // ADICIONADO PARC E DATA -  VALDEMIR JOSE 27/05/2013
	SELECT SZ3.*, SZ2.Z2_NUMSFA,SZ2.Z2_XTPPED, SZ2.Z2_XTPFIN,SZ2.Z2_DESCTP, SZ2.Z2_VEND3, SZ2.Z2_TABELA,SZ2.Z2_DESCTAB, SZ2.Z2_VEND2,SZ2.Z2_MOEDA, SZ2.Z2_PARC1, SZ2.Z2_DATA1, SZ2.Z2_PARC2, SZ2.Z2_DATA2,
	ISNULL((SELECT A3_NREDUZ FROM %table:SA3% SA3 WHERE SA3.A3_FILIAL = %xFilial:SA3% AND SA3.A3_COD = SZ2.Z2_VEND2 AND SA3.%NotDel%),' ')A3_NREDUZ
	FROM %Table:SZ3% SZ3 , %Table:SZ2% SZ2
	WHERE SZ3.%notdel%
	AND Z3_FILIAL  >= %Exp:mv_par01%       AND Z3_FILIAL  <= %Exp:mv_par02%
	AND Z3_NUM     >= %Exp:mv_par05%       AND Z3_NUM     <= %Exp:mv_par06%
	AND Z3_PRODUTO >= %Exp:mv_par07%       AND Z3_PRODUTO <= %Exp:mv_par08%
	AND Z3_CLI     >= %Exp:mv_par09%       AND Z3_CLI     <= %Exp:mv_par10%
	AND Z3_ENTREG  >= %Exp:DtoS(mv_par11)% AND Z3_ENTREG  <= %Exp:DtoS(mv_par12)%
	AND SZ3.%notdel%
	AND SZ2.%notdel%
	AND SZ2.Z2_NUM = SZ3.Z3_NUM
	AND SZ2.Z2_FILIAL = SZ3.Z3_FILIAL
	%Exp:cWhere%
	ORDER BY Z3_FILIAL,Z3_NUM,Z3_ITEM,Z3_PRODUTO
EndSql
oSecao:EndQuery()
oSecao:SetParentQuery()

If len(oSecao:GetAdvplExp("SA1")) > 0
	cFilSA1 := oSecao:GetAdvplExp("SA1")
EndIf
If len(oSecao:GetAdvplExp("SA3")) > 0
	cFilSA3 := oSecao:GetAdvplExp("SA3")
EndIf
If len(oSecao:GetAdvplExp("SB1")) > 0
	cFilSB1 := oSecao:GetAdvplExp("SB1")
EndIf
If len(oSecao:GetAdvplExp("SF4")) > 0
	cFilSF4 := oSecao:GetAdvplExp("SF4")
EndIf
If len(oSecao:GetAdvplExp("SC5")) > 0
	cFilSC5 := oSecao:GetAdvplExp("SC5")
EndIf
If len(oSecao:GetAdvplExp("SZ2")) > 0
	cFilSZ2 := oSecao:GetAdvplExp("SZ2")
EndIf
If len(oSecao:GetAdvplExp("SX5")) > 0
	cFilSX5 := oSecao:GetAdvplExp("SX5")
EndIf

dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter(RecCount())     // Total de Elementos da Regua
While !oReport:Cancel() .And. !Eof()
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	dbSeek( (cAliasQry)->Z3_FILIAL + (cAliasQry)->Z3_NUM )
	// Verifica filtro do usuario
	If !Empty(cFilSZ2) .And. !(&cFilSZ2)
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial("SA1")+ SZ2->Z2_CLIENTE + SZ2->Z2_LOJACLI )
	
	// Verifica filtro do usuario
	If !Empty(cFilSA1) .And. !(&cFilSA1)
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1") + (cAliasQry)->Z3_PRODUTO )
	
	// Verifica filtro do usuario
	If !Empty(cFilSB1) .And. !(&cFilSB1)
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf


	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5")+"ZC"+SA1->A1_XGESTOR)
	
	// Verifica filtro do usuario
	If !Empty(cFilSX5) .And. !(&cFilSX5)
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea(cAliasQry)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se esta dentro dos parametros						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet:=ValidMasc((cAliasQry)->Z3_PRODUTO,mv_par15)
	
	If Alltrim((cAliasQry)->Z3_BLQ) $ "R/C" .and. mv_par17 == 2 // Se Foi Eliminado Residuos
		nSaldo  := 0
	Else
		nSaldo  := Z3_QTDVEN-Z3_QTDLIB
	Endif
	
	If ((Z3_QTDLIB < Z3_QTDVEN .And. mv_par13 == 1) .Or. (mv_par13 == 2)).And.;
		((nSaldo == 0 .And. mv_par18 == 1.And. !Alltrim((cAliasQry)->Z3_BLQ) $ "R/C") .Or. nSaldo <> 0).And.;
		At(SZ2->Z2_TIPO,"DB") = 0 .And.lRet
		
		
		If nSection = 5		// Por Vendedor
			
			cVend := "1"
			For nX := 1 to nQtdVend
				cVendedor := SZ2->(FieldGet(FieldPos("Z2_VEND"+cVend)))
				If !EMPTY(cVendedor) .And. (cVendedor >= mv_par20 .And. cVendedor <= mv_par21 )
					
					dbSelectArea("SA3")
					dbSetOrder(1)
					dbSeek( xFilial("SA3")+cVendedor)
					
					// Verifica filtro do usuario
					If (Empty(cFilSA3)) .Or. (!Empty(cFilSA3) .And. (&cFilSA3))
						
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
						
						Replace VENDEDOR   With cVendedor
						Replace NOMEVEN    With SA3->A3_NREDUZ
						Replace FILIAL     With "PRE"
						Replace NUM        With (cAliasQry)->Z3_NUM   
						Replace NUMSFA     With (cAliasQry)->Z2_NUMSFA
						Replace EMISSAO    With SZ2->Z2_EMISSAO
						Replace CLIENTE    With SZ2->Z2_CLIENTE
						Replace LOJA       With SZ2->Z2_LOJACLI
						Replace NOMECLI    With SA1->A1_NOME
						Replace DATENTR    With (cAliasQry)->Z3_ENTREG
						Replace ITEM       With (cAliasQry)->Z3_ITEM
						Replace PRODUTO    With (cAliasQry)->Z3_PRODUTO
						Replace DESCRICAO  With (cAliasQry)->Z3_DESCRI
						Replace QUANTIDADE With (cAliasQry)->Z3_QTDVEN 
						Replace NPRCVEN	   With xMoeda((cAliasQry)->Z3_PRCVEN,(cAliasQry)->Z2_MOEDA,nMoeda,EMISSAO,6)
						Replace ENTREGUE   With (cAliasQry)->Z3_QTDLIB
						Replace BLQ        With (cAliasQry)->Z3_BLQ  
						// VALDEMIR JOSE 27/05/2013
						Replace PARC1      With (cAliasQry)->Z2_PARC1
						Replace DATA1      With (cAliasQry)->Z2_DATA1
						Replace PARC2      With (cAliasQry)->Z2_PARC2
						Replace DATA2      With (cAliasQry)->Z2_DATA2
						//--------------------------------
						Replace XLIBERA    With (cAliasQry)->Z3_XLIBERA
						Replace XTPPED     With (cAliasQry)->Z2_XTPPED						
						Replace TABELA     With (cAliasQry)->Z2_TABELA           
						Replace TABDES 	   With (cAliasQry)->Z2_DESCTAB           
						Replace VEND2 	   With (cAliasQry)->A3_NREDUZ
						Replace TPFIN	   With (cAliasQry)->Z2_XTPFIN           
						Replace DESCTP     With (cAliasQry)->Z2_DESCTP  						
						Replace VEND3	   With (cAliasQry)->Z2_VEND3           
						Replace NOMEV3	   With Posicione("SA3",1,xFilial("SA3")+(cAliasQry)->Z2_VEND3,"A3_NREDUZ")           						
						Replace XGESTOR    With SA1->A1_XGESTOR  						
						Replace XNOMEG	   With Posicione("SX5",1,xFilial("SX5")+"ZC"+SA1->A1_XGESTOR,"X5_DESCRI")
						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAliasQry)->Z3_VALOR
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAliasQry)->Z3_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasQry)->Z3_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf
						Replace VALOR      With nValor
						Replace MOEDA      With SZ2->Z2_MOEDA
						
						MsUnLock()
						
					EndIf
					
				Endif
				
				cVend := Soma1(cVend,1)
				dbSelectArea("SZ2")
				dbSetOrder(1)
			Next nX
			
		Else
			
			lVend := .F.
			cVend := "1"
			For nX := 1 to nQtdVend
				cVendedor := SZ2->(FieldGet(FieldPos("Z2_VEND"+cVend)))
				
				dbSelectArea("SA3")
				dbSetOrder(1)
				dbSeek( xFilial("SA3")+cVendedor)
				
				// Verifica filtro do usuario
				If (Empty(cFilSA3)) .Or. (!Empty(cFilSA3) .And. (&cFilSA3))
					If (cVendedor >= mv_par20 .And. cVendedor <= mv_par21 )
						lVend :=.T.
						Exit
					Endif
				Endif
				cVend := Soma1(cVend,1)
			Next nX
			
			
			If lVend
				
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				
				Replace FILIAL     With "PRE"
				Replace NUM        With (cAliasQry)->Z3_NUM 
				Replace NUMSFA     With (cAliasQry)->Z2_NUMSFA
				Replace EMISSAO    With SZ2->Z2_EMISSAO
				Replace CLIENTE    With SZ2->Z2_CLIENTE
				Replace LOJA       With SZ2->Z2_LOJACLI
				Replace NOMECLI    With SA1->A1_NOME
				Replace DATENTR    With (cAliasQry)->Z3_ENTREG
				Replace ITEM       With (cAliasQry)->Z3_ITEM
				Replace PRODUTO    With (cAliasQry)->Z3_PRODUTO
				Replace DESCRICAO  With (cAliasQry)->Z3_DESCRI
				Replace QUANTIDADE With (cAliasQry)->Z3_QTDVEN
				Replace NPRCVEN	   With xMoeda((cAliasQry)->Z3_PRCVEN,(cAliasQry)->Z2_MOEDA,nMoeda,EMISSAO,6)
				Replace ENTREGUE   With (cAliasQry)->Z3_QTDLIB
				Replace BLQ        With (cAliasQry)->Z3_BLQ
				// VALDEMIR JOSE 27/05/2013
				Replace PARC1      With (cAliasQry)->Z2_PARC1
				Replace DATA1      With (cAliasQry)->Z2_DATA1
				Replace PARC2      With (cAliasQry)->Z2_PARC2
				Replace DATA2      With (cAliasQry)->Z2_DATA2
				//---------------------------------
				Replace XLIBERA    With (cAliasQry)->Z3_XLIBERA
				Replace XTPPED     With (cAliasQry)->Z2_XTPPED				
				Replace TABELA     With (cAliasQry)->Z2_TABELA           
				Replace TABDES 	   With (cAliasQry)->Z2_DESCTAB 
				Replace VEND2 	   With (cAliasQry)->A3_NREDUZ
				Replace TPFIN	   With (cAliasQry)->Z2_XTPFIN           
				Replace DESCTP     With (cAliasQry)->Z2_DESCTP
				Replace VEND3	   With (cAliasQry)->Z2_VEND3           
				Replace NOMEV3	   With Posicione("SA3",1,xFilial("SA3")+(cAliasQry)->Z2_VEND3,"A3_NREDUZ")           						
				Replace XGESTOR    With SA1->A1_XGESTOR  						
				Replace XNOMEG	   With Posicione("SX5",1,xFilial("SX5")+"ZC"+SA1->A1_XGESTOR,"X5_DESCRI")
				If nTipVal == 1 //--  Imprime Valor Total do Item
					nValor:=(cAliasQry)->Z3_VALOR	
				Else
					//--  Imprime Saldo
					If TRB->QUANTIDADE==0
						nValor:=(cAliasQry)->Z3_VALOR
					Else
						nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasQry)->Z3_PRCVEN
						nValor := If(nValor<0,0,nValor)
					EndIf
				EndIf
				Replace VALOR      With nValor
				Replace MOEDA      With SZ2->Z2_MOEDA
				
				lVend := .F.
				MsUnLock()
			Endif
		Endif
	Endif
	
	dbSelectArea(cAliasQry)
	dbSkip()
	oReport:IncMeter()
	
EndDo

dbSelectArea(cAliasQry)
dbClosearea()
//----------------------------------------------------------------------------------------------------------------------------
//FINALIZA ESTRUTURA PRE-PEDIDO
//----------------------------------------------------------------------------------------------------------------------------

dbSelectArea("SC6")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RMATB680 ³ Autor ³ Felipe Aurélio de Melo³ Data ³ 04/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos e Pré-pedidos não entregues             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RMATB680R3()

LOCAL titulo    := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
LOCAL cDesc1    := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao dos Pedidos Pendentes,"
LOCAL cDesc2    := OemToAnsi(STR0003)	//"imprimindo o numero do Pedido, Cliente, Data da Entrega, "
LOCAL cDesc3    := OemToAnsi(STR0004)	//"Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
LOCAL cString   := "SC6"
LOCAL tamanho   := "G"
LOCAL wnrel     := "MATB680"     

PRIVATE aReturn := { STR0005, 1,STR0006, 1, 2, 1, "", 1 }      //"Zebrado"###"Administracao"
PRIVATE nomeprog:= "MATB680"
PRIVATE cArqTrab:= ""
PRIVATE cFilTrab:= ""
PRIVATE nLastKey:= 0
PRIVATE aExcel  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 				    	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fCriaSX1(cPerg)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aOrd = Ordems Por Pedido/Produto/Cliente/Dt.Entrega/Vendedor ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aOrd :={STR0007,STR0008,STR0009,STR0010,STR0022,"Por Descricao"}
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C680Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ C680IMP	³ Autor ³ Alexandre Incaio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATB680													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C680Imp(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis   										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL titulo    := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
LOCAL dData     := CtoD("  /  /  ")
LOCAL cTotPed   := "AllTrim(NUM+PRENUM) = cNum"
LOCAL CbTxt     := ""
LOCAL cabec1    := ""
LOCAL cabec2    := ""
LOCAL tamanho   := "G"
LOCAL cNumPed   := ""
LOCAL cNumCli   := ""
LOCAL limite    := 220
LOCAL CbCont    := 0
//LOCAL nOrdem    := 0
LOCAL nTotVen   := 0
LOCAL nTotEnt   := 0
LOCAL _nValor   := 0
LOCAL _nVlrEnt:= 0
LOCAL _nVlrPed:= 0
LOCAL nTotSal   := 0
LOCAL nTotItem  := 0
LOCAL nTItEntr  := 0
LOCAL nTItPedi  := 0
LOCAL nFirst    := 0
LOCAL nSaldo    := 0
LOCAL nValor    := 0
LOCAL nVlrEnt   := 0
LOCAL nVlrPed   := 0
LOCAL nCont     := 0
//LOCAL lImpTot   := .F.
LOCAL lContinua := .T.
LOCAL nTVGeral  := 0
LOCAL nTEGeral  := 0
LOCAL nTSGeral  := 0
LOCAL nTPedGeral  := 0
LOCAL nTEntGeral  := 0
LOCAL nTPenGeral  := 0  
Local cTpPed := ""    
Private nMoeda    := mv_par22


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li 	    := 80

nTipo   := IIF(aReturn[4]==1,15,18)
nOrdem  := aReturn[8]

IF nOrdem <> 2 .AND. nOrdem <> 6
	mv_par24 := 1
ENDIF

Processa({|lEnd| C680Trb(@lEnd,wnRel,"TRB")},Titulo)

//                   999999 99/99/9999 999999xxxxxxxxxxxxxx/XXXXXXXX XX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 99/99/9999 999999999999 999999999999 999999999999
//                             1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18
//                   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
dbSelectArea("TRB")

Do Case
	Case nOrdem = 1
		cQuebra := "AllTrim(NUM+PRENUM) = cNum"
		titulo  := titulo +" - "+ STR0007 //"Por Pedido"
		Aadd(aExcel, {" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+titulo+" - "+GetMv("MV_MOEDA"+STR(nMoeda,1))+";"+" "})
		cabec1  := "FIL/PRE/PED  CODIGO DO         DESCRICAO DO                                                 DATA DE      QUANTIDADE      VALOR TOTAL       QUANTIDADE        VALOR TOTAL     QUANTIDADE     VALOR TOTAL     DATA DE     FLG"
		cabec2  := "IT           PRODUTO           MATERIAL                                                     ENTREGA          PEDIDA           PEDIDA         ENTREGUE           ENTREGUE       PENDENTE        PENDENTE     VENCIMENTO  LIB"	 
		Aadd(aExcel, {"Filial;Pre e Pedido;Ped. Portal;Tp Ped Espec;Data de Emissao;Codigo Loja / Nome Cliente;UF;IT;Codigo do Produto;Descriçao do Material;Data de entrega;Quantidade Pedida; Valor Total Pedida; Quantidade Entregue;Valor Total Entregue; Quantidade Pendente;Valor Total Pendente;Vlr Unit; Parc.1; DT Venc.1; Parc.2; DT. Venc.2; Flag Libera;Tabela de Preço;Descrição da Tabela;Cooperativa;Tipo Financiamento; Descrição do Tp. Financ; Vendedor 3; Nome Vend 3; Gestor; Nome Gestor"})
	Case nOrdem = 2
		cQuebra := "PRODUTO = cProduto"
		titulo  := titulo + " - "+STR0008 //"Por Produto"
		Aadd(aExcel, {" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+titulo+" - "+GetMv("MV_MOEDA"+STR(nMoeda,1))+";"+" "})
		IF mv_par24 <> 2
			//cabec1  := "CODIGO DO       DESCRICAO DO                  FILIAL      IT DATA DE                    DATA DE      QUANTIDADE      VALOR TOTAL       QUANTIDADE        VALOR TOTAL     QUANTIDADE     VALOR TOTAL     DATA DE     FLG"
			//cabec2  := "PRODUTO         MATERIAL                      PRE E PED      EMISSAO                    ENTREGA          PEDIDA           PEDIDA         ENTREGUE           ENTREGUE       PENDENTE        PENDENTE     VENCIMENTO  LIB"	 
			cabec1  := "CODIGO DO       DESCRICAO DO MATERIAL                                                  UF   DATA DE      QUANTIDADE      VALOR TOTAL       QUANTIDADE        VALOR TOTAL     QUANTIDADE     VALOR TOTAL     DATA DE     FLG"
	  		cabec2  := "PRODUTO                          IT  EMISSAO   CODIGO-LOJA/NOME DO CLIENTE                  ENTREGA          PEDIDA           PEDIDA         ENTREGUE           ENTREGUE       PENDENTE        PENDENTE     VENCIMENTO  LIB"	 
			Aadd(aExcel, {"Codigo do Produto;Descriçao do Material;Filial;Pre e Pedido;Ped. Portal;Tp Ped Espec;IT;Data de Emissao;Data de entrega;Codigo Loja / Nome Cliente;UF; Quantidade Pedida; Valor Total Pedida; Quantidade Entregue;Valor Total Entregue; Quantidade Pendente;Valor Total Pendente; Vlr Unit; Parc.1; DT Venc.1; Parc.2; DT. Venc.2; Flag Libera;Tabela de Preço;Descrição da Tabela;Cooperativa;Tipo Financiamento; Descrição do Tp. Financ; Vendedor 3; Nome Vend 3; Gestor; Nome Gestor"})
		else
			cabec1  := "CODIGO DO       DESCRICAO DO                                                                                                     QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL "
			cabec2  := "PRODUTO         MATERIAL                                                                                                             PEDIDA         PEDIDA    ENTREGUE       ENTREGUE    PENDENTE       PENDENTE "
			Aadd(aExcel, {"Codigo do Produto;Descriçao do Material;Quantidade Pedida; Valor Total Pedida; Quantidade Entregue;Valor Total Entregue; Quantidade Pendente;Valor Total Pendente"})
		endif
	Case nOrdem = 3
		cQuebra := "CLIENTE+LOJA = cCli"
		titulo  := titulo + " - "+STR0009 //"Por Cliente"
		Aadd(aExcel, {" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+titulo+" - "+GetMv("MV_MOEDA"+STR(nMoeda,1))+";"+" "})
		cabec1  := "CODIGO-LOJA/NOME DO CLIENTE                    UF         DESCRICAO DO                      DATA DE      QUANTIDADE      VALOR TOTAL       QUANTIDADE        VALOR TOTAL     QUANTIDADE     VALOR TOTAL     DATA DE     FLG"
		cabec2  := "FIL/PRE/PED   P.PORTAL  IT  EMISSAO     PRODUTO           MATERIAL                          ENTREGA          PEDIDA           PEDIDA         ENTREGUE           ENTREGUE       PENDENTE        PENDENTE     VENCIMENTO  LIB"
		Aadd(aExcel, {"Codigo Loja / Nome Cliente;UF;Filial;Pre e Pedido;Ped. Portal;Tp Ped Espec;IT;Data de Emissao;Codigo do Produto;Descriçao do Material;Data de entrega; Quantidade Pedida; Valor Total Pedida; Quantidade Entregue;Valor Total Entregue; Quantidade Pendente;Valor Total Pendente; Vlr Unit; Parc.1; DT Venc.1;Parc.2; DT Venc.2; Flag Libera;Tabela de Preço;Descrição da Tabela;Cooperativa;Tipo Financiamento; Descrição do Tp. Financ; Vendedor 3; Nome Vend 3; Gestor; Nome Gestor"})
	Case nOrdem = 4
		cQuebra := "DATENTR = dEntreg"
		titulo  := titulo + STR0018 //" - Por Data de Entrega"
		Aadd(aExcel, {" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+titulo+" - "+GetMv("MV_MOEDA"+STR(nMoeda,1))+";"+" "})
	  //cabec1  := " DATA DE  FILIAL        DATA DE   CODIGO LOJA /NOME DO CLIENTE                   UF  IT CODIGO DO       DESCRICAO DO             QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL DT VENC. FLG"
	  //cabec2  := " ENTREGA  PRE E PED     EMISSAO                                                         PRODUTO         MATERIAL                     PEDIDA         PEDIDA    ENTREGUE       ENTREGUE    PENDENTE       PENDENTE          LIB"
	  	cabec1  := "DT ENTREGA           DESCRICAO                                                                           QUANTIDADE      VALOR TOTAL       QUANTIDADE        VALOR TOTAL     QUANTIDADE     VALOR TOTAL     DATA DE     FLG"
		cabec2  := "IT  PRODUTO          DO MATERIAL                                                                             PEDIDA           PEDIDA         ENTREGUE           ENTREGUE       PENDENTE        PENDENTE     VENCIMENTO  LIB"	 
		Aadd(aExcel, {"Data de entrega;Filial;Pre e Pedido;Ped. Portal;Tp Ped Espec;Data de Emissao;Codigo Loja / Nome Cliente;UF;IT;Codigo do Produto;Descriçao do Material; Quantidade Pedida;Valor Total Pedida; Quantidade Entregue;Valor Total Entregue; Quantidade Pendente;Valor Total Pendente;Vlr Unit; Parc.1; DT Venc.1; Parc.2; DT. Venc.2; Flag Libera;Tabela de Preço;Descrição da Tabela;Cooperativa;Tipo Financiamento; Descrição do Tp. Financ; Vendedor 3; Nome Vend 3; Gestor; Nome Gestor"})
	Case nOrdem = 5
		cQuebra := "VENDEDOR = cVde"
		titulo  := titulo+ " - " + STR0022 //"Por Vendedor"
		Aadd(aExcel, {" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+titulo+" - "+GetMv("MV_MOEDA"+STR(nMoeda,1))+";"+" "})
		//cabec1  := "CODIGO VENDEDOR                                 FILIAL      IT DATA DE  CODIGO DO       DESCRICAO DO                   DATA DE   QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL DT VENC. FLG"
		//cabec2  := "                                                PRE E PED      EMISSAO  PRODUTO         MATERIAL                       ENTREGA       PEDIDA         PEDIDA    ENTREGUE       ENTREGUE    PENDENTE       PENDENTE          LIB"
		  cabec1  := "CODIGO VENDEDOR                         CODIGO DO         DESCRICAO DO                      DATA DE      QUANTIDADE      VALOR TOTAL       QUANTIDADE        VALOR TOTAL     QUANTIDADE     VALOR TOTAL     DATA DE     FLG"
		  cabec2  := "FIL/PRE/PED   P.PORTAL  IT  EMISSAO     PRODUTO           MATERIAL                          ENTREGA          PEDIDA           PEDIDA         ENTREGUE           ENTREGUE       PENDENTE        PENDENTE     VENCIMENTO  LIB"
		Aadd(aExcel, {"Codigo Vendedor;Filial;Pre e Pedido;Ped. Portal;Tp Ped Espec;IT;Data de Emissao;Codigo do Produto;Descriçao do Material;Data de entrega; Quantidade Pedida; Valor Total Pedida; Quantidade Entregue;Valor Total Entregue; Quantidade Pendente;Valor Total Pendente;Vlr Unit; Parc.1; DT Venc.1; Parc.2; DT. Venc.2; Flag Libera;Tabela de Preço;Descrição da Tabela;Cooperativa;Tipo Financiamento; Descrição do Tp. Financ; Vendedor 3; Nome Vend 3; Gestor; Nome Gestor"})
	Case nOrdem = 6
		cQuebra := "DESCRICAO = _cDesc"
		titulo  := titulo + " - "+STR0008+" (Descricao) " //"Por Produto"
		Aadd(aExcel, {" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+titulo+" - "+GetMv("MV_MOEDA"+STR(nMoeda,1))+";"+" "})
		IF mv_par24 <> 2
		   //cabec1  := "CODIGO DO       DESCRICAO DO                   FILIAL         IT DATA DE  DATA DE  CODIGO LOJA /NOME DO CLIENTE               UF QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL DT VENC. FLG"
			//cabec2  := "PRODUTO         MATERIAL                       PRE E PED         EMISSAO  ENTREGA                                                    PEDIDA         PEDIDA    ENTREGUE       ENTREGUE    PENDENTE       PENDENTE          LIB"
			cabec1  := "CODIGO DO       DESCRICAO DO MATERIAL                                                  UF   DATA DE      QUANTIDADE      VALOR TOTAL       QUANTIDADE        VALOR TOTAL     QUANTIDADE     VALOR TOTAL     DATA DE     FLG"
	  		cabec2  := "PRODUTO                          IT  EMISSAO   CODIGO-LOJA/NOME DO CLIENTE                  ENTREGA          PEDIDA           PEDIDA         ENTREGUE           ENTREGUE       PENDENTE        PENDENTE     VENCIMENTO  LIB"	 
			Aadd(aExcel, {"Codigo do Produto;Descriçao do Material;Filial;Pre e Pedido;Ped. Portal;Tp Ped Espec;IT;Data de Emissao;Data de entrega;Codigo Loja / Nome Cliente;UF; Quantidade Pedida; Valor Total Pedida; Quantidade Entregue;Valor Total Entregue; Quantidade Pendente;Valor Total Pendente; Vlr Unit; Parc.1; DT Venc.1; Parc.2; DT. Venc.2; Flag Libera;Tabela de Preço;Descrição da Tabela;Cooperativa;Tipo Financiamento; Descrição do Tp. Financ; Vendedor 3; Nome Vend 3; Gestor; Nome Gestor"})
		else
			cabec1  := "CODIGO DO       DESCRICAO DO                                                                                                     QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL  QUANTIDADE    VALOR TOTAL "//DT VENC. FLG"
			cabec2  := "PRODUTO         MATERIAL                                                                                                             PEDIDA         PEDIDA    ENTREGUE       ENTREGUE    PENDENTE       PENDENTE "//         LIB"
			Aadd(aExcel, {"Codigo do Produto;Descriçao do Material;Quantidade Pedida; Valor Total Pedida; Quantidade Entregue;Valor Total Entregue; Quantidade Pendente;Valor Total Pendente"}) //; DT Venc.; Flag Libera"})
		endif
		
EndCase

titulo += " - " + GetMv("MV_MOEDA"+STR(nMoeda,1))		//" MOEDA "

dbSelectArea("TRB")
dbGoTop()
SetRegua(RecCount())                    	// TOTAL DE ELEMENTOS DA REGUA

nFirst := 0
cVarExcelCab := ""
cVarExcelItm := ""

While !Eof() .And. lContinua
	If Empty(VENCDATA1) == .F.
		If !(Dtos(VENCDATA1)>= Dtos(mv_par25) .And. Dtos(VENCDATA1)<=Dtos(mv_par26))
			dbSkip()
			Loop
		Endif
	EndIf
	IF lEnd
		@PROW()+1,001 Psay STR0021        //    "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF li > 58 .Or.( mv_par19 = 1 .And.!&cQuebra)
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica campo para quebra									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFil    := TRB->FILIAL
	cNum	:= AllTrim(NUM+PRENUM)
	cProduto:= PRODUTO
	cCli	:= CLIENTE+LOJA
	dEntreg := DATENTR
	cVde    := VENDEDOR
	_cDesc  := DESCRICAO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis Totalizadoras     		    					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldo  := QUANTIDADE-ENTREGUE
	nTotSal += nSaldo
	nTotVen += QUANTIDADE
	nTotEnt += ENTREGUE           
	
    cTipoC5 := Posicione("SC5",1,TRB->FILIAL+TRB->NUM,"C5_TIPO" )
    IF cTipoC5 $ "C//I//P"
   	    nValor  := 1*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
	    nVlrEnt := 1*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
	    nVlrPed := 1*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
    Else
	    nValor  := (QUANTIDADE-ENTREGUE)*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
	    nVlrEnt := ENTREGUE*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
	    nVlrPed := QUANTIDADE*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
    EndIf
	
	
	_nVlrEnt += nVlrEnt
	_nVlrPed += nVlrPed
	_nValor  += nValor
	
	If !(TRB->GRADE == "S" .And. mv_par16 == 1)
		nTItPedi+= nVlrPed
		nTItEntr+= nVlrEnt
		nTotItem+= nValor
		
		nTPedGeral+= nVlrPed
		nTEntGeral+= nVlrEnt
		nTPenGeral+= nValor
		
	EndIf
	
	If !((nOrdem = 2  .OR.  nOrdem = 6) .And. mv_par24 == 2)
		Aadd(aExcel, {""})
	EndIf
	cVarExcelItm := ""
	IF (nFirst = 0 .And. nOrdem != 4) .Or. nOrdem == 4
		IF nOrdem <> 2 .AND. nOrdem <> 6 .AND. MV_PAR24 == 1	
   			li++
		EndIf		  
		cTpPed := ""
		If AllTrim(TRB->XTPPED) == '1'
			cTpPed := "1-Entrega Futura"
		ElseIf AllTrim(TRB->XTPPED) == '2'    
			cTpPed := "2-Conta e Ordem"
		ElseIf AllTrim(TRB->XTPPED) == '3'    
			cTpPed := "3-Normal"
		EndIf		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o cabecalho da linha		    					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case nOrdem = 1			
				@li,  0 Psay IIf(Empty(TRB->NUM),"PRE-"+TRB->PRENUM," "+TRB->FILIAL+"-"+TRB->NUM)
				@li, 14 Psay IIf(!Empty(TRB->NUMSFA),"PED. PORTAL: "+TRB->NUMSFA," ")
				@li, 36 Psay "EMISSÃO: "+DToC(TRB->EMISSAO)
				@li, 55 Psay "CLIENTE: "+TRB->(Left(CLIENTE+"-"+LOJA+"/"+Alltrim(NOMECLI), 30))
				@li, 97 Psay "UF: "+Alltrim(TRB->UF)			
				cVarExcelCab := IIf(Empty(TRB->NUM),"PRE;"+TRB->PRENUM," "+Chr(160)+TRB->FILIAL+";"+TRB->NUM)+";"+TRB->NUMSFA+";"+cTpPed+";"+Dtoc(TRB->EMISSAO)+";"+Left(CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI, 50)+";"+UF			
			Case nOrdem = 2
				@li,  0 Psay IIF(GRADE=="S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
				@li, 16 Psay Alltrim(TRB->DESCRICAO)
				cVarExcelCab :=  IIF(GRADE=="S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)+";"+Left(TRB->DESCRICAO, 30)
			Case nOrdem = 3
				@li,  0 Psay TRB->(Left(CLIENTE+"-"+LOJA+"/"+Alltrim(NOMECLI), 45))
				@li, 47 Psay Alltrim(TRB->UF) 				
				cVarExcelCab := Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 50)+";"+UF
			Case nOrdem = 4
				If cNumPed+cNumCli+DtoS(dData) != IIf(Empty(TRB->NUM),TRB->PRENUM,TRB->NUM)+CLIENTE+DtoS(DATENTR)
					@li, 000 Psay DATENTR
					@li, 010 Psay IIf(Empty(TRB->NUM),"PRE-"+TRB->PRENUM," "+TRB->FILIAL+"-"+TRB->NUM)
					@li, 024 Psay IIf(!Empty(TRB->NUMSFA),"PED. PORTAL: "+TRB->NUMSFA," ")
					@li, 046 Psay "DT EMISSÃO: "+DToC(TRB->EMISSAO)
					@li, 068 Psay "CLIENTE: "+TRB->(Left(CLIENTE+"-"+LOJA+"/"+Alltrim(NOMECLI), 45))
					@li, 124 Psay "UF: "+Alltrim(TRB->UF)
					cVarExcelCab := Dtoc(DATENTR)+";"+IIf(Empty(TRB->NUM),"PRE;"+TRB->PRENUM," "+Chr(160)+TRB->FILIAL+";"+TRB->NUM)+";"+TRB->NUMSFA+";"+cTpPed+";"+Dtoc(EMISSAO)+";"+Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 50)+";"+UF
					cNumPed := IIf(Empty(TRB->NUM),TRB->PRENUM,TRB->NUM)
					cNumCli := CLIENTE
					li += 2
				Else
					li--
				EndIf
				dData := DATENTR
			Case nOrdem = 5
				@li,  000 Psay TRB->VENDEDOR+" "+NOMEVEN
				cVarExcelCab :=  Left(TRB->VENDEDOR+" "+NOMEVEN, 47)
			Case nOrdem = 6
				@li,  0 Psay IIF(GRADE=="S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
				@li, 16 Psay Left(TRB->DESCRICAO, 30)
				cVarExcelCab := IIF(GRADE=="S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)+";"+Left(TRB->DESCRICAO, 30)
		EndCase
		
		IF nFirst = 0 .And. nOrdem != 4
			nFirst := 1
		Endif
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrutina os produtos da grade conforme o parametro mv_par16  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF TRB->GRADE == "S" .And. mv_par16 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		If nOrdem = 2
			cAgrutina := "cProdRef == Substr(PRODUTO,1,nTamRef)"
		Else
			cAgrutina := cQuebra
		Endif
		
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
		_nValor := 0
		_nVlrEnt:= 0
		_nVlrPed:= 0
		
		nTotSal := 0
		nValor  := 0
		nVlrEnt := 0
		nVlrPed := 0
		nReg    := 0
		
		While !Eof() .And. cFil == TRB->FILIAL .And. cProdRef == Substr(PRODUTO,1,nTamRef);
			.And. TRB->GRADE == "S" .And. &cAgrutina .And. cNum == IIf(Empty(TRB->NUM),TRB->PRENUM,TRB->NUM)
			
			nReg	 := Recno()
			
			nTotVen  += QUANTIDADE
			nTotEnt  += ENTREGUE
			nSaldo   += QUANTIDADE-ENTREGUE
			//nValor += xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
		    cTipoC5 := Posicione("SC5",1,TRB->FILIAL+TRB->NUM,"C5_TIPO" )
		    IF cTipoC5 $ "C//I//P"
		   	    nValor  := 1*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
			    nVlrEnt := 1*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
			    nVlrPed := 1*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
		    Else
			    nValor  := (QUANTIDADE-ENTREGUE)*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
			    nVlrEnt := ENTREGUE*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
			    nVlrPed := QUANTIDADE*xMoeda(PRCVENDA,MOEDA,nMoeda,EMISSAO,6)
		    EndIf
			_nVlrEnt += nVlrEnt
			_nVlrPed += nVlrPed
			_nValor  += nValor
			
			dbSelectArea("TRB")
			IncRegua()
			dbSkip()
			
		End
		
		nTotSal += nSaldo
		
		nTItPedi+= nVlrPed
		nTItEntr+= nVlrEnt
		nTotItem+= nValor
		
		nTPedGeral+= nVlrPed
		nTEntGeral+= nVlrEnt
		nTPenGeral+= nValor
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime a linha Conforme a ordem selecionada na setprint	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
   	IF nFirst == 1 .And. nOrdem != 4  .And. ((nOrdem <> 2 .Or. nOrdem <> 6) .AND. MV_PAR24 == 1)
		li+=2
	 	nFirst := 2
	Endif
	
	Do Case
		Case nOrdem = 1				
			@li, 000 Psay IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)			
			@li, 013 Psay IIF(GRADE == "S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 031 Psay TRB->(Left(DESCRICAO,45))
			@li, 092 Psay DATENTR
			cVarExcelItm := cVarExcelCab+";"+IIf(Empty(ITEM),PREITEM,ITEM)+";"+IIF(GRADE=="S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)+";"+Left(TRB->DESCRICAO, 30)+";"+Dtoc(DATENTR)		
		Case nOrdem = 2
			if mv_par24 <> 2
				@li, 000 Psay IIf(Empty(TRB->NUM),"PRE-"+TRB->PRENUM," "+TRB->FILIAL+"-"+TRB->NUM)
				@li, 014 Psay IIf(!Empty(TRB->NUMSFA),"P.PORTAL-"+TRB->PRENUM," ")
  				@li, 033 Psay IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)
				@li, 037 Psay TRB->EMISSAO
	  			@li, 047 Psay TRB->(Left(CLIENTE+"-"+LOJA+"/"+Alltrim(NOMECLI),35))
				@li, 087 Psay Alltrim(TRB->UF)
				@li, 092 Psay DATENTR				
				cVarExcelItm := cVarExcelCab+";"+IIf(Empty(TRB->NUM),"PRE;"+TRB->PRENUM," "+Chr(160)+TRB->FILIAL+";"+TRB->NUM)+";"+TRB->NUMSFA+";"+cTpPed+";"+IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)+";"+Dtoc(EMISSAO)+";"+Dtoc(DATENTR)+";"+Left(TRB->CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI,40)+";"+UF
			endif
		Case nOrdem = 3   		
			@li, 000 Psay Left(IIf(Empty(TRB->NUM),"PRE-"+TRB->PRENUM," "+TRB->FILIAL+"-"+TRB->NUM),12)
		   	@li, 014 Psay TRB->NUMSFA
			@li, 024 Psay IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)
			@li, 028 Psay TRB->EMISSAO
			@li, 040 Psay IIF(GRADE == "S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 058 Psay TRB->DESCRICAO
			@li, 092 Psay DATENTR
			cVarExcelItm := cVarExcelCab+";"+IIf(Empty(TRB->NUM),"PRE;"+TRB->PRENUM," "+Chr(160)+TRB->FILIAL+";"+TRB->NUM)+";"+TRB->NUMSFA+";"+cTpPed+";"+IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)+";"+Dtoc(EMISSAO)+";"+IIF(GRADE == "S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)+";"+Left(TRB->DESCRICAO,30)+";"+Dtoc(DATENTR)
		Case nOrdem = 4
			@li, 000 Psay IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)
			@li, 004 Psay IIF(GRADE == "S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamRef),PRODUTO)
			@li, 021 Psay Left(TRB->DESCRICAO, 25)
			cVarExcelItm := cVarExcelCab+";"+IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)+";"+IIF(GRADE == "S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamRef),PRODUTO)+";"+Left(TRB->DESCRICAO, 25)//+";"+IIF (!Empty(Dtoc(VENCDATA1)),Dtoc(VENCDATA1), Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI"))
		Case nOrdem = 6
			if mv_par24 <> 2
			@li, 000 Psay IIf(Empty(TRB->NUM),"PRE-"+TRB->PRENUM," "+TRB->FILIAL+"-"+TRB->NUM)
				@li, 014 Psay IIf(!Empty(TRB->NUMSFA),"P.PORTAL-"+TRB->PRENUM," ")
  				@li, 033 Psay IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)
				@li, 037 Psay TRB->EMISSAO
	  			@li, 047 Psay TRB->(Left(CLIENTE+"-"+LOJA+"/"+Alltrim(NOMECLI),35))
				@li, 087 Psay Alltrim(TRB->UF)
				@li, 092 Psay DATENTR							
				cVarExcelItm := cVarExcelCab+";"+ IIf(Empty(TRB->NUM),"PRE;"+TRB->PRENUM," "+Chr(160)+TRB->FILIAL+";"+TRB->NUM)+";"+TRB->NUMSFA+";"+cTpPed+";"+IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)+";"+Dtoc(EMISSAO)+";"+Dtoc(DATENTR)+";"+ Left(TRB->CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI,40)+";"+UF
			endif
		OtherWise		
			@li, 000 Psay Left(IIf(Empty(TRB->NUM),"PRE-"+TRB->PRENUM," "+TRB->FILIAL+"-"+TRB->NUM),12)
		   	@li, 014 Psay TRB->NUMSFA
			@li, 024 Psay IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)
			@li, 028 Psay TRB->EMISSAO
			@li, 040 Psay IIF(GRADE == "S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 058 Psay Left(TRB->DESCRICAO,30)
			@li, 092 Psay DATENTR
			cVarExcelItm := cVarExcelCab+";"+IIf(Empty(TRB->NUM),"PRE;"+TRB->PRENUM," "+Chr(160)+TRB->FILIAL+";"+TRB->NUM)+";"+TRB->NUMSFA+";"+cTpPed+";"+IIf(Empty(TRB->ITEM),TRB->PREITEM,TRB->ITEM)+";"+Dtoc(EMISSAO)+";"+IIF(GRADE == "S" .And. mv_par16 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)+";"+ Left(TRB->DESCRICAO,30)+";"+Dtoc(DATENTR)//+";"+IIF (!Empty(Dtoc(VENCDATA1)),Dtoc(VENCDATA1), Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI"))
	EndCase
	
	IF mv_par24 <> 2
		@li,100+IIF(nOrdem == 3,1,0) Psay IIF(GRADE=="S" .And. mv_par16 == 1,nTotVen,QUANTIDADE) PICTURE Avsx3("C6_QTDVEN",6)
		@li,120+IIF(nOrdem == 3,1,0) Psay nVlrPed                                                PICTURE PesqPict("SC6","C6_VALOR",12)
		@li,135+IIF(nOrdem == 3,1,0) Psay IIF(GRADE=="S" .And. mv_par16 == 1,nTotEnt,ENTREGUE)   PICTURE Avsx3("C6_QTDENT",6)
		@li,156+IIF(nOrdem == 3,1,0) Psay nVlrEnt                                                PICTURE PesqPict("SC6","C6_VALOR",12)
		@li,168+IIF(nOrdem == 3,1,0) Psay nSaldo	                                                PICTURE Avsx3("C6_QTDVEN",6)
		@li,187+IIF(nOrdem == 3,1,0) Psay nValor	                                                PICTURE PesqPict("SC6","C6_VALOR",12)
		@li,204+IIF(nOrdem == 3,1,0) Psay IIF (!Empty(VENCDATA1),VENCDATA1, PadR(Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI"),8)) //Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI")
		@li,217+IIF(nOrdem == 3,1,0) Psay XLIBERA                                                PICTURE PesqPict("SC6","C6_XLIBERA",12)
		
		cVarExcelItm += ";"+IIF(GRADE=="S" .And. mv_par16 == 1,Transform(nTotVen, "@E 999999999.99"),Transform(QUANTIDADE, "@E 999999999.99"))+";"+Transform(nVlrPed, "@E 999999999.99")+";"+IIF(GRADE=="S" .And. mv_par16 == 1,Transform(nTotEnt, "@E 999999999.99"),Transform(ENTREGUE, "@E 999999999.99"))+";"+Transform(nVlrEnt, "@E 999999999.99")+";"+Transform(nSaldo, "@E 999999999.99")+";"+Transform(nValor, "@E 999999999.99")+";"+Transform(TRB->NPRCVEN,"@E 999999999.9999")+";"+Transform(TRB->PARC1,"@E 999.99")+";"+IIF (!Empty(DtoS(VENCDATA1)),Dtoc(VENCDATA1), Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI"))+";"+Transform(TRB->PARC2,"@E 999.99")+";"+IIF (!Empty(DtoS(VENCDATA2)),Dtoc(VENCDATA2), '')+";"+XLIBERA+";"+TRB->TABELA+";"+TRB->TABDES+";"+TRB->VEND2+";"+TRB->TPFIN+";"+TRB->DESCTP+";"+TRB->VEND3+";"+TRB->NOMEV3+";"+TRB->XGESTOR+";"+TRB->XNOMEG
		nCont++
		li++
	ENDIF
	
	@li,220 Psay BLQ
	
	If !Empty(cVarExcelItm)
		aExcel[Len(aExcel)][1] := cVarExcelItm
	EndIf
	
	dbSelectArea("TRB")
	IncRegua()
	dbSkip()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total do Pedido                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cTotPed
		If nOrdem = 1 .Or. nOrdem = 3 .Or.  nOrdem = 4 .Or. (nOrdem == 5 .And. !&cQuebra)
			li++
			@li,000 Psay STR0025
			@li,117 Psay nTItPedi PICTURE PesqPict("SC6","C6_VALOR",15)
			@li,153 Psay nTItEntr PICTURE PesqPict("SC6","C6_VALOR",15)
			@li,184 Psay nTotItem PICTURE PesqPict("SC6","C6_VALOR",15)
			If mv_par29 == 2
				Aadd(aExcel, {STR0025+IIf(nOrdem!=5,";"+" ","")+";"+" "+";"+" "+";"+" "+";"+" "+";"+" "+";"+" " +";"+" " +";"+" " +";"+" " +";"+" " +";"+" " +";"+Transform(nTItPedi, "@E 999999999.99")+";"+" "+";"+Transform(nTItEntr, "@E 999999999.99")+";"+" "+";"+Transform(nTotItem, "@E 999999999.99")   })
			EndIf
			If nOrdem = 3
				li+=2
			Else
				li++
			ENdif
			nTotitem:= 0
			nTItEntr:= 0
			nTItPedi:= 0
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total ou linha divisora conforme a quebra		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cQuebra
		
		If (mv_par19 = 1 .And. nOrdem = 2) .Or. mv_par19 = 2
			
			
			If nOrdem = 2  .OR.  nOrdem = 6 
				li++
				IF mv_par24 <> 2
					@li,000 Psay STR0025
				ENDIF           
				
				@li,105 Psay Transform(nTotVen,"@E 9999999.99") //PICTURE Avsx3("C6_QTDVEN",6)				
				@li,117 Psay _nVlrPed PICTURE PesqPict("SC6","C6_VALOR",15)
				
				@li,139 Psay Transform(nTotEnt,"@E 9999999.99") //PICTURE Avsx3("C6_QTDENT",6)				
				@li,153 Psay _nVlrEnt PICTURE PesqPict("SC6","C6_VALOR",15)                  
				
				@li,173 Psay Transform(nTotSal,"@E 9999999.99") //PICTURE Avsx3("C6_QTDVEN",6)				
				@li,184 Psay _nValor PICTURE PesqPict("SC6","C6_VALOR",15)			  
				
				If mv_par24 == 2
					Aadd(aExcel, {""})
					cVarExcelItm := cVarExcelCab+";"+Transform(nTotVen,"@E 9999999.99")+";"+Transform(_nVlrPed,"@E 999,999,999,999.99")+";"+Transform(nTotEnt,"@E 9999999.99")+";"+Transform(_nVlrEnt,"@E 999,999,999,999.99")+";"+Transform(nTotSal,"@E 9999999.99")+";"+Transform(_nValor,"@E 999,999,999,999.99")
					aExcel[Len(aExcel)][1] := cVarExcelItm
				EndIf
				
				If mv_par24 == 1 .And. mv_par29 == 2
					Aadd(aExcel, {"TOTAL ----->"+";"+" "+";"+" "+";"+" "+";"+" " +";"+" " +";"+" " +";"+" " +";"+" " +";"+STR(nTotVen)+";"+Transform(_nVlrPed, "@E 999999999.99")+";"+STR(nTotEnt)+";"+Transform(_nVlrEnt, "@E 999999999.99")+";"+STR(nTotSal)+";"+Transform(_nValor, "@E 999999999.99")   })

				EndIf
				
				IF mv_par24 <> 2
					li++
				endif
			Endif
			
			If nTotVen > 0 .And. nOrdem != 1 .AND. mv_par24 <> 2
				@li,  0 Psay __PrtThinLine()
				li++
			Endif
			
		Endif
		
		nTVGeral += nTotVen
		nTEGeral += nTotEnt
		nTSGeral += nTotSal
		
		nTotVen := 0
		nTotEnt := 0
		_nVlrEnt:= 0
		_nVlrPed:= 0
		_nValor := 0
		
		nTotSal := 0
		nCont   := 0
		nFirst  := 0
		
	Endif
	
	
	
	
End
nTVGeral += nTotVen
nTEGeral += nTotEnt
nTSGeral += nTotSal
nTotVen := 0
nTotEnt := 0
nTotSal := 0
If nTPenGeral > 0
	
	If li >= 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	li++
	@li,000 Psay STR0026
	
	@li,104 Psay Transform(nTVGeral,"@E 99999999.99")   //PICTURE PesqPict("SC6","C6_QTDVEN",12)
	@li,117 Psay nTPedGeral PICTURE PesqPict("SC6","C6_VALOR",15)
	
	@li,139 Psay Transform(nTEGeral,"@E 9999999.99")   //PICTURE PesqPict("SC6","C6_QTDENT",12)
	@li,153 Psay nTEntGeral PICTURE PesqPict("SC6","C6_VALOR",15)
	
	@li,172 Psay Transform(nTSGeral,"@E 99999999.99")   //PICTURE PesqPict("SC6","C6_QTDVEN",12)
	@li,186 Psay nTPenGeral PICTURE PesqPict("SC6","C6_VALOR",13)
	If mv_par24 == 1 .And. mv_par29 == 2
		Aadd(aExcel, {"TOTAL GERAL ---->"+IIf(nOrdem!=5,";"+" ","")+";"+" "+";"+" "+";"+" " +";"+" " +";"+" " +";"+" " +";"+" " +";"+Transform(nTVGeral, "@E 999999999.99")+";"+Transform(nTPedGeral, "@E 999999999.99")+";"+Transform(nTEGeral, "@E 999999999.99")+";"+Transform(nTEntGeral, "@E 999999999.99")+";"+Transform(nTSGeral, "@E 999999999.99")+";"+Transform(nTPenGeral, "@E 999999999.99")   })
	EndIf
	If mv_par24 == 2 .And. mv_par29 == 2
		Aadd(aExcel, {"TOTAL GERAL ---->"+";"+" "+";"+Transform(nTVGeral, "@E 999999999.99")+";"+Transform(nTPedGeral, "@E 999999999.99")+";"+Transform(nTEGeral, "@E 999999999.99")+";"+Transform(nTEntGeral, "@E 999999999.99")+";"+Transform(nTSGeral, "@E 999999999.99")+";"+Transform(nTPenGeral, "@E 999999999.99")   })
	EndIf
EndIf

If li != 80
	Roda(cbcont,cbtxt)
Endif

dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

If mv_par27==1
	cDirXls := Alltrim(cGetFile("Arquivo Excel  (*.CSV)        | *.CSV | ","Selecione a pasta destino do arquivo Excel",0,"\",.T.,GETF_RETDIRECTORY + GETF_LOCALHARD))
	GeraExcel(aExcel,cDirXls)
	
	If !ApOleClient( 'MsExcel' )
		MsgStop( 'Microsoft Excel não instalado!' )
		Return
	EndIf
	
	shellExecute( "Open",  cDirXls+ALLTRIM(mv_par28)+".CSV", " /k dir", cDirXls, 1 )
	
	/*
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cDirXls+ALLTRIM(mv_par28)+".CSV") // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	*/
	
	
	
Endif
IF 	SELECT("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
End

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ C680TRB	³ Autor ³ Alexandre Inacio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria Arquivo de Trabalho                             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATB680													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C680TRB(nOrdem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aCampos   := {}
LOCAL aTam      := ""
LOCAL cKey      := ""
LOCAL cCondicao := ""
LOCAL cVend     := ""
LOCAL cVendedor := ""
LOCAL cAliasSC6 := "SC6"
LOCAL cFilIni   := mv_par01
LOCAL cFilFim   := mv_par02
LOCAL cPedIni   := mv_par03
LOCAL cPedFim   := mv_par04
LOCAL cPreIni   := mv_par05
LOCAL cPreFim   := mv_par06
LOCAL cProIni   := mv_par07
LOCAL cProFim   := mv_par08
LOCAL cCliIni   := mv_par09
LOCAL cCliFim   := mv_par10
LOCAL cDatIni   := mv_par11
LOCAL cDatFim   := mv_par12
LOCAL nTipVal   := mv_par23
LOCAL nSaldo    := 0
LOCAL nX        := 0
LOCAL nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
LOCAL nValor	:= 0
LOCAL cQueryAdd := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("Z3_NUM")
AADD(aCampos,{ "PRENUM"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("Z2_NUMSFA")
AADD(aCampos,{ "NUMSFA"   ,"C",aTam[1],aTam[2] } )                                                  
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_XESTCLI")
AADD(aCampos,{ "UF"        ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NREDUZ")
AADD(aCampos,{ "NOMEVEN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("Z3_ITEM")
AADD(aCampos,{ "PREITEM"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEMGRD")
AADD(aCampos,{ "ITEMGRD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLQ")
AADD(aCampos,{ "BLQ"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLOQUEI")
AADD(aCampos,{ "BLOQUEI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRCVEN")
AADD(aCampos,{ "NPRCVEN"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRCVEN")
AADD(aCampos,{ "PRCVENDA"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_CONDPAG")
AADD(aCampos,{ "CONDPAG"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_PARC1")                                    // Valdemir Jose 27/05/2013
AADD(aCampos,{ "PARC1"   ,"N",aTam[1],aTam[2] } )			// Valdemir Jose 27/05/2013
aTam:=TamSX3("C5_DATA1")
AADD(aCampos,{ "VENCDATA1"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_PARC2")                                    // Valdemir Jose 27/05/2013
AADD(aCampos,{ "PARC2"   ,"N",aTam[1],aTam[2] } )			// Valdemir Jose 27/05/2013
aTam:=TamSX3("C5_DATA2")								    // Valdemir Jose 27/05/2013
AADD(aCampos,{ "VENCDATA2"   ,"D",aTam[1],aTam[2] } )		// Valdemir Jose 27/05/2013
aTam:=TamSX3("C6_XLIBERA")
AADD(aCampos,{ "XLIBERA"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_XTPPED")
AADD(aCampos,{ "XTPPED"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_XTPFIN")
AADD(aCampos,{ "TPFIN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_DESCTP")
AADD(aCampos,{ "DESCTP"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_TABELA")
AADD(aCampos,{ "TABELA"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_XTABDES")
AADD(aCampos,{ "TABDES"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NREDUZ")
AADD(aCampos,{ "VEND2"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND3")
AADD(aCampos,{ "VEND3"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NREDUZ")
AADD(aCampos,{ "NOMEV3" ,"C",aTam[1],aTam[2] } )   
aTam:=TamSX3("A1_XGESTOR")
AADD(aCampos,{ "XGESTOR"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("X5_DESCRI")
AADD(aCampos,{ "XNOMEG","C",aTam[1],aTam[2] } )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

nOrdem  := aReturn[8]

dbSelectArea("TRB")
Do Case
	Case nOrdem = 1
		IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRENUM+PREITEM+PRODUTO",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 2
		IndRegua("TRB",cArqTrab,"PRODUTO+FILIAL+NUM+ITEM+PRENUM+PREITEM",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 3
		IndRegua("TRB",cArqTrab,"CLIENTE+LOJA+FILIAL+NUM+ITEM+PRENUM+PREITEM",,,STR0015)  //"Selecionando Registros..."
	Case nOrdem = 4
		IndRegua("TRB",cArqTrab,"DTOS(DATENTR)+FILIAL+NUM+ITEM+PRENUM+PREITEM",,,STR0015) //"Selecionando Registros..."
	Case nOrdem = 5
		IndRegua("TRB",cArqTrab,"VENDEDOR+FILIAL+NUM+ITEM+PRENUM+PREITEM",,,STR0015)      //"Selecionando Registros..."
	Case nOrdem = 6
		IndRegua("TRB",cArqTrab,"DESCRICAO+FILIAL+NUM+ITEM+PRENUM+PREITEM",,,STR0015)      //"Selecionando Registros..."
EndCase

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)

cAliasSC6 := "MR680Trab"
aStruSC6  := SC6->(dbStruct())

cQuery := " SELECT * FROM ( "
cQuery += " SELECT SC6.*,SC5.C5_XTPPED, (SELECT B1_DESC FROM "+RetSqlName('SB1')+" AS SB1 WHERE B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ') AS DESCRICAO, "
cQuery += " SC5.C5_TABELA, SC5.C5_XTABDES, SC5.C5_XTPFIN, SC5.C5_DESCTP, SC5.C5_VEND3, SC5.C5_MOEDA, "
cQuery += " ISNULL((SELECT A3_NREDUZ FROM "+RetSqlName("SA3")+" SA3 WHERE SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.A3_COD = SC5.C5_VEND2 AND SA3.D_E_L_E_T_ = ''),' ')A3_NREDUZ
cQuery += " FROM "+RetSqlName("SC6")+" SC6, " +RetSqlName("SC5")+" SC5"
cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' '"
cQuery += "   AND C6_FILIAL  >= '"+cFilIni+"' "
cQuery += "   AND C6_FILIAL  <= '"+cFilFim+"' "
cQuery += "   AND C6_NUM     >= '"+cPedIni+"' "
cQuery += "   AND C6_NUM     <= '"+cPedFim+"' "
cQuery += "   AND C6_PRODUTO >= '"+cProIni+"' "
cQuery += "   AND C6_PRODUTO <= '"+cProFim+"' "
cQuery += "   AND C6_CLI     >= '"+cCliIni+"' "
cQuery += "   AND C6_CLI     <= '"+cCliFim+"' "
cQuery += "   AND C6_ENTREG  >= '"+Dtos(cDatIni)+"' "
cQuery += "   AND C6_ENTREG  <= '"+Dtos(cDatFim)+"' "
cQuery += "   AND C6_FILIAL  = C5_FILIAL"
cQuery += "   AND C6_NUM     = C5_NUM"
If MV_PAR30 <> 4
	cQuery += "   AND C5_XTPPED  = '"+Alltrim(Str(MV_PAR30))+"' "
Endif
If mv_par17 == 3
	cQuery += "  AND C6_BLQ = 'R ' "
Endif

cQuery += " ) TRB "
cQuery += "ORDER BY "+IF(nOrdem<>6,SqlOrder(IndexKey()),'C6_FILIAL,DESCRICAO')

cQuery := ChangeQuery(cQuery)


dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)

For nX := 1 To Len(aStruSC6)
	If ( aStruSC6[nX][2] <> "C" )
		TcSetField(cAliasSC6,aStruSC6[nX][1],aStruSC6[nX][2],aStruSC6[nX][3],aStruSC6[nX][4])
	EndIf
Next nX

dbSelectArea(cAliasSC6)

// Total de Elementos da Regua
ProcRegua(RecCount())

DbGoTop()
While (cAliasSC6)->(!Eof())
	IncProc()
	If ( Empty(aReturn[7]) .Or. &(aReturn[7]) )
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial("SA1") + (cAliasSC6)->C6_CLI + (cAliasSC6)->C6_LOJA )
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek( xFilial("SF4") + (cAliasSC6)->C6_TES )
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek( (cAliasSC6)->C6_FILIAL + (cAliasSC6)->C6_NUM )
		//dbSeek( xFilial("SC5") + (cAliasSC6)->C6_NUM )
		
		dbSelectArea(cAliasSC6)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta dentro dos parametros						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet:=ValidMasc((cAliasSC6)->C6_PRODUTO,mv_par15)
		
		If Alltrim((cAliasSC6)->C6_BLQ) == "R" .and. mv_par17 == 2 // Se Foi Eliminado Residuos
			nSaldo  := 0
		Else
			nSaldo  := C6_QTDVEN-C6_QTDENT
		Endif
		
		If ((C6_QTDENT < C6_QTDVEN .And. mv_par13 == 1) .Or. (mv_par13 == 2)).And.;
			((nSaldo == 0 .And. mv_par18 == 1.And.Alltrim((cAliasSC6)->C6_BLQ)<>"R").Or. nSaldo <> 0).And.;
			((SF4->F4_DUPLIC == "S" .And. mv_par14 == 1) .Or. (SF4->F4_DUPLIC == "N";
			.And. mv_par14 == 2).Or.(mv_par14 == 3));
			.And. At(SC5->C5_TIPO,"DB") = 0 .And.lRet
			
			If nOrdem = 5
				
				cVend := "1"
				
				For nX := 1 to nQtdVend
					
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					
					If !EMPTY(cVendedor) .And. (cVendedor >= mv_par20 .And. cVendedor <= mv_par21 )
						
						dbSelectArea("SA3")
						dbSetOrder(1)
						dbSeek( xFilial("SA3")+cVendedor)
						
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
						
						REPLACE VENDEDOR   WITH cVendedor
						REPLACE NOMEVEN    WITH SA3->A3_NREDUZ
						REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
						REPLACE NUM        WITH (cAliasSC6)->C6_NUM
						REPLACE EMISSAO    WITH SC5->C5_EMISSAO
						REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
						REPLACE NOMECLI    WITH SA1->A1_NOME
						REPLACE UF         WITH SC5->C5_XESTCLI
						REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
						REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
						REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
						REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
						REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
						REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
						REPLACE NPRCVEN    WITH xMoeda((cAliasSC6)->C6_PRCVEN,(cAliasSC6)->C5_MOEDA,nMoeda,EMISSAO,6)
						REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
						REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
						REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
						REPLACE TES        WITH (cAliasSC6)->C6_TES
						REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
						REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI
						Replace XLIBERA    With (cAliasSC6)->C6_XLIBERA
						Replace XTPPED     With (cAliasSC6)->C5_XTPPED						
						Replace TABELA     With (cAliasSC6)->C5_TABELA           
						Replace TABDES 	   With (cAliasSC6)->C5_XTABDES           
						Replace VEND2 	   With (cAliasSC6)->A3_NREDUZ
						Replace TPFIN	   With (cAliasSC6)->C5_XTPFIN           
						Replace DESCTP     With (cAliasSC6)->C5_DESCTP 
						Replace VEND3	   With (cAliasSC6)->C5_VEND3           
						Replace NOMEV3	   With Posicione("SA3",1,xFilial("SA3")+(cAliasSC6)->C5_VEND3,"A3_NREDUZ")           						
						Replace XGESTOR    With SA1->A1_XGESTOR
						Replace XNOMEG	   With Posicione("SX5",1,xFilial("SX5")+"ZC"+SA1->A1_XGESTOR,"X5_DESCRI")
						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAliasSC6)->C6_VALOR
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAliasSC6)->C6_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf
						REPLACE VALOR      WITH nValor
						REPLACE PRCVENDA   WITH (cAliasSC6)->C6_PRCVEN
						REPLACE MOEDA      WITH SC5->C5_MOEDA
						REPLACE CONDPAG    WITH SC5->C5_CONDPAG
						REPLACE PARC1      WITH SC5->C5_PARC1
						REPLACE VENCDATA1  WITH SC5->C5_DATA1
						REPLACE PARC2      WITH SC5->C5_PARC2
						REPLACE VENCDATA2  WITH SC5->C5_DATA2
						MsUnLock()
						
					Endif
					
					cVend := Soma1(cVend,1)
					
					dbSelectArea("SC5")
					dbSetOrder(1)
					
				Next nX
				
			Else
				
				lVend := .F.
				cVend := "1"
				
				For nX := 1 to nQtdVend
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					If (cVendedor >= mv_par20 .And. cVendedor <= mv_par21 )
						lVend :=.T.
						Exit
					Endif
					cVend := Soma1(cVend,1)
				Next nX
				
				If lVend
					
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					
					REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
					REPLACE NUM        WITH (cAliasSC6)->C6_NUM
					REPLACE EMISSAO    WITH SC5->C5_EMISSAO
					REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
					REPLACE NOMECLI    WITH SA1->A1_NOME
					REPLACE UF         WITH SC5->C5_XESTCLI
					REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
					REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
					REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
					REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
					REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
					REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
					REPLACE NPRCVEN    WITH xMoeda((cAliasSC6)->C6_PRCVEN,(cAliasSC6)->C5_MOEDA,nMoeda,EMISSAO,6)
					REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
					REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
					REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
					REPLACE TES        WITH (cAliasSC6)->C6_TES
					REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
					REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI
					Replace XLIBERA    With (cAliasSC6)->C6_XLIBERA
					Replace XTPPED     With (cAliasSC6)->C5_XTPPED    
					Replace TABELA     With (cAliasSC6)->C5_TABELA           
					Replace TABDES 	   With (cAliasSC6)->C5_XTABDES           
					Replace VEND2 	   With (cAliasSC6)->A3_NREDUZ           
					Replace TPFIN	   With (cAliasSC6)->C5_XTPFIN           
					Replace DESCTP     With (cAliasSC6)->C5_DESCTP
					Replace VEND3	   With (cAliasSC6)->C5_VEND3           
					Replace NOMEV3	   With Posicione("SA3",1,xFilial("SA3")+(cAliasSC6)->C5_VEND3,"A3_NREDUZ")          						
					Replace XGESTOR    With SA1->A1_XGESTOR
					Replace XNOMEG	   With Posicione("SX5",1,xFilial("SX5")+"ZC"+SA1->A1_XGESTOR,"X5_DESCRI")
					If nTipVal == 1 //--  Imprime Valor Total do Item
						nValor:=(cAliasSC6)->C6_VALOR
					Else
						//--  Imprime Saldo
						If TRB->QUANTIDADE==0
							nValor:=(cAliasSC6)->C6_VALOR
						Else
							nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
							nValor := If(nValor<0,0,nValor)
						EndIf
					EndIf
					REPLACE VALOR      WITH nValor
					REPLACE PRCVENDA   WITH (cAliasSC6)->C6_PRCVEN
					REPLACE MOEDA      WITH SC5->C5_MOEDA
					REPLACE CONDPAG    WITH SC5->C5_CONDPAG
					REPLACE PARC1      WITH SC5->C5_PARC1
					REPLACE VENCDATA1  WITH SC5->C5_DATA1
					REPLACE PARC2      WITH SC5->C5_PARC2
					REPLACE VENCDATA2  WITH SC5->C5_DATA2
					lVend := .F.
					
					MsUnLock()
				Endif
			Endif
		Endif
	Endif
	
	dbSelectArea(cAliasSC6)
	dbSkip()
End

dbSelectArea(cAliasSC6)
dbClosearea()
dbSelectArea("SC6")

//----------------------------------------------------------------------------------------------------------------------------
//INICIA ESTRUTURA PRE-PEDIDO
//----------------------------------------------------------------------------------------------------------------------------
nSaldo    := 0
nX        := 0
nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
nValor    := 0

cQuery := " SELECT SZ3.*, SZ2.Z2_NUMSFA, SZ2.Z2_CLIENTE, SZ2.Z2_LOJACLI, SB1.B1_DESC AS DESCRICAO, SZ2.Z2_XTPPED, "
cQuery += " SZ2.Z2_XTPFIN,SZ2.Z2_DESCTP, SZ2.Z2_VEND3, SZ2.Z2_TABELA,SZ2.Z2_DESCTAB, SZ2.Z2_MOEDA, "
cQuery += " ISNULL((SELECT A3_NREDUZ FROM "+RetSqlName("SA3")+" SA3 WHERE SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.A3_COD = SZ2.Z2_VEND2 AND SA3.D_E_L_E_T_ = ''),' ')A3_NREDUZ
cQuery += " FROM "+RetSqlName("SZ3")+" SZ3 "
cQuery += " LEFT JOIN "+RetSqlName("SZ2")+" SZ2 ON SZ2.Z2_NUM=SZ3.Z3_NUM     AND SZ2.D_E_L_E_T_ != '*' "
cQuery += " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD=SZ3.Z3_PRODUTO AND SB1.D_E_L_E_T_ != '*' "
cQuery += " WHERE SZ3.D_E_L_E_T_ != '*' "
cQuery += "   AND SZ3.Z3_NUM     >= '"+cPreIni+"' "
cQuery += "   AND SZ3.Z3_NUM     <= '"+cPreFim+"' "
cQuery += "   AND SZ3.Z3_PRODUTO >= '"+cProIni+"' "
cQuery += "   AND SZ3.Z3_PRODUTO <= '"+cProFim+"' "
cQuery += "   AND SZ3.Z3_CLI     >= '"+cCliIni+"' "
cQuery += "   AND SZ3.Z3_CLI     <= '"+cCliFim+"' "
cQuery += "   AND SZ3.Z3_ENTREG  >= '"+Dtos(cDatIni)+"' "
cQuery += "   AND SZ3.Z3_ENTREG  <= '"+Dtos(cDatFim)+"' "
If mv_par17 == 3
	cQuery += " AND SZ3.Z3_BLQ In ('R', 'C') "
ElseIf mv_par17 == 2
	cQuery += " AND Z3_BLQ NOT IN ('R', 'C')"
Endif
cQuery += "   ORDER BY Z3_FILIAL,Z3_NUM,Z3_ITEM,Z3_PRODUTO,DESCRICAO "

cQuery := ChangeQuery(cQuery)

If Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TMP"

TcSetField("TMP","Z3_ENTREG","D",8,0)

// Total de Elementos da Regua
cAliasSC6 := "TMP"
dbSelectArea(cAliasSC6)
ProcRegua(RecCount())

DbGoTop()
While (cAliasSC6)->(!Eof())
	IncProc()
	
	//If ( Empty(aReturn[7]) .Or. &(aReturn[7]) )
	If Empty(StrTran(aReturn[7],"C6","Z3")) .Or. IIf(Type((StrTran(aReturn[7],"C6_","Z3_")))!="U",&(StrTran(aReturn[7],"C6","Z3")),.T.)//
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial("SA1") + (cAliasSC6)->Z2_CLIENTE + (cAliasSC6)->Z2_LOJACLI )
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		dbSeek( xFilial("SZ2") + (cAliasSC6)->Z3_NUM )
		
		dbSelectArea(cAliasSC6)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta dentro dos parametros						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet:=ValidMasc((cAliasSC6)->Z3_PRODUTO,mv_par15)
		
		If Alltrim((cAliasSC6)->Z3_BLQ) $ "R/C" .and. mv_par17 == 2 // Se Foi Eliminado Residuos
			nSaldo  := 0
		Else
			nSaldo  := Z3_QTDVEN-Z3_QTDLIB
		Endif
		
		If ((Z3_QTDLIB < Z3_QTDVEN .And. mv_par13 == 1) .Or. (mv_par13 == 2)).And.;
			((nSaldo == 0 .And. mv_par18 == 1.And. !Alltrim((cAliasSC6)->Z3_BLQ) $ "R/C").Or. nSaldo <> 0).And.;
			At(SZ2->Z2_TIPO,"DB") = 0 .And.lRet
			
			If nOrdem = 5
				
				cVend := "1"
				
				For nX := 1 to nQtdVend
					
					cVendedor := SZ2->(FieldGet(FieldPos("Z2_VEND"+cVend)))
					
					If !EMPTY(cVendedor) .And. (cVendedor >= mv_par20 .And. cVendedor <= mv_par21 )
						
						dbSelectArea("SA3")
						dbSetOrder(1)
						dbSeek( xFilial("SA3")+cVendedor)
						
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
						
						REPLACE VENDEDOR   WITH cVendedor
						REPLACE NOMEVEN    WITH SA3->A3_NREDUZ
						REPLACE FILIAL     WITH (cAliasSC6)->Z3_FILIAL
						REPLACE PRENUM     WITH (cAliasSC6)->Z3_NUM
						REPLACE NUMSFA     WITH (cAliasSC6)->Z2_NUMSFA
						REPLACE EMISSAO    WITH SZ2->Z2_EMISSAO
						REPLACE CLIENTE    WITH (cAliasSC6)->Z2_CLIENTE
						REPLACE NOMECLI    WITH SA1->A1_NOME
						REPLACE UF         WITH SZ2->Z2_XESTCLI
						REPLACE LOJA       WITH (cAliasSC6)->Z2_LOJACLI
						REPLACE DATENTR    WITH (cAliasSC6)->Z3_ENTREG
						REPLACE PREITEM    WITH (cAliasSC6)->Z3_ITEM
						REPLACE PRODUTO    WITH (cAliasSC6)->Z3_PRODUTO
						REPLACE DESCRICAO  WITH (cAliasSC6)->Z3_DESCRI
						REPLACE QUANTIDADE WITH (cAliasSC6)->Z3_QTDVEN
						REPLACE NPRCVEN    WITH xMoeda((cAliasSC6)->Z3_PRCVEN,(cAliasSC6)->Z2_MOEDA,nMoeda,EMISSAO,6)
						REPLACE ENTREGUE   WITH (cAliasSC6)->Z3_QTDLIB
						REPLACE BLQ        WITH (cAliasSC6)->Z3_BLQ
						Replace XLIBERA    With (cAliasSC6)->Z3_XLIBERA	
						Replace XTPPED     With (cAliasSC6)->Z2_XTPPED    				
						Replace TABELA     With (cAliasSC6)->Z2_TABELA           
						Replace TABDES 	   With (cAliasSC6)->Z2_DESCTAB
						Replace VEND2 	   With (cAliasSC6)->A3_NREDUZ
						Replace TPFIN	   With (cAliasSC6)->Z2_XTPFIN           
						Replace DESCTP     With (cAliasSC6)->Z2_DESCTP
						Replace VEND3	   With (cAliasSC6)->Z2_VEND3           
						Replace NOMEV3	   With Posicione("SA3",1,xFilial("SA3")+(cAliasSC6)->Z2_VEND3,"A3_NREDUZ")          						
						Replace XGESTOR    With SA1->A1_XGESTOR
						Replace XNOMEG	   With Posicione("SX5",1,xFilial("SX5")+"ZC"+SA1->A1_XGESTOR,"X5_DESCRI")
						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAliasSC6)->Z3_VALOR
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAliasSC6)->Z3_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->Z3_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf
						REPLACE VALOR      WITH nValor
						REPLACE PRCVENDA   WITH (cAliasSC6)->Z3_PRCVEN
						REPLACE MOEDA      WITH SZ2->Z2_MOEDA
						REPLACE CONDPAG    WITH SZ2->Z2_CONDPAG
						REPLACE PARC1      WITH SZ2->Z2_PARC1
						REPLACE VENCDATA1  WITH SZ2->Z2_DATA1
						REPLACE PARC2      WITH SZ2->Z2_PARC2
						REPLACE VENCDATA2  WITH SZ2->Z2_DATA2
						MsUnLock()
					Endif
					
					cVend := Soma1(cVend,1)
					
					dbSelectArea("SZ2")
					dbSetOrder(1)
					
				Next nX
				
			Else
				
				lVend := .F.
				cVend := "1"
				
				For nX := 1 to nQtdVend
					cVendedor := SZ2->(FieldGet(FieldPos("Z2_VEND"+cVend)))
					If (cVendedor >= mv_par20 .And. cVendedor <= mv_par21 )
						lVend :=.T.
						Exit
					Endif
					cVend := Soma1(cVend,1)
				Next nX
				
				If lVend
					
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					
					REPLACE FILIAL     WITH (cAliasSC6)->Z3_FILIAL
					REPLACE PRENUM     WITH (cAliasSC6)->Z3_NUM
					REPLACE NUMSFA     WITH (cAliasSC6)->Z2_NUMSFA
					REPLACE EMISSAO    WITH SZ2->Z2_EMISSAO
					REPLACE CLIENTE    WITH (cAliasSC6)->Z2_CLIENTE
					REPLACE NOMECLI    WITH SA1->A1_NOME
					REPLACE UF         WITH SZ2->Z2_XESTCLI
					REPLACE LOJA       WITH (cAliasSC6)->Z2_LOJACLI
					REPLACE DATENTR    WITH (cAliasSC6)->Z3_ENTREG
					REPLACE PREITEM    WITH (cAliasSC6)->Z3_ITEM
					REPLACE PRODUTO    WITH (cAliasSC6)->Z3_PRODUTO
					REPLACE DESCRICAO  WITH (cAliasSC6)->Z3_DESCRI
					REPLACE QUANTIDADE WITH (cAliasSC6)->Z3_QTDVEN
					REPLACE NPRCVEN	   WITH xMoeda((cAliasSC6)->Z3_PRCVEN,(cAliasSC6)->Z2_MOEDA,nMoeda,EMISSAO,6)
					REPLACE ENTREGUE   WITH (cAliasSC6)->Z3_QTDLIB
					REPLACE BLQ        WITH (cAliasSC6)->Z3_BLQ
					Replace XLIBERA    With (cAliasSC6)->Z3_XLIBERA
					Replace XTPPED     With (cAliasSC6)->Z2_XTPPED    
					Replace TABELA     With (cAliasSC6)->Z2_TABELA           
					Replace TABDES 	   With (cAliasSC6)->Z2_DESCTAB
					Replace VEND2 	   With (cAliasSC6)->A3_NREDUZ
					Replace TPFIN	   With (cAliasSC6)->Z2_XTPFIN           
					Replace DESCTP     With (cAliasSC6)->Z2_DESCTP
					Replace VEND3	   With (cAliasSC6)->Z2_VEND3           
					Replace NOMEV3	   With Posicione("SA3",1,xFilial("SA3")+(cAliasSC6)->Z2_VEND3,"A3_NREDUZ")
					Replace XGESTOR    With SA1->A1_XGESTOR
					Replace XNOMEG	   With Posicione("SX5",1,xFilial("SX5")+"ZC"+SA1->A1_XGESTOR,"X5_DESCRI")
					If nTipVal == 1 //--  Imprime Valor Total do Item
						nValor:=(cAliasSC6)->Z3_VALOR
					Else
						//--  Imprime Saldo
						If TRB->QUANTIDADE==0
							nValor:=(cAliasSC6)->Z3_VALOR
						Else
							nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->Z3_PRCVEN
							nValor := If(nValor<0,0,nValor)
						EndIf
					EndIf
					REPLACE VALOR      WITH nValor
					REPLACE PRCVENDA   WITH (cAliasSC6)->Z3_PRCVEN
					REPLACE MOEDA      WITH SZ2->Z2_MOEDA
					REPLACE CONDPAG    WITH SZ2->Z2_CONDPAG
					REPLACE PARC1      WITH SZ2->Z2_PARC1
					REPLACE VENCDATA1  WITH SZ2->Z2_DATA1
					REPLACE PARC2      WITH SZ2->Z2_PARC2
					REPLACE VENCDATA2  WITH SZ2->Z2_DATA2
					lVend := .F.
					
					MsUnLock()
				Endif
			Endif
		Endif
	Endif
	
	dbSelectArea(cAliasSC6)
	DbSkip()
End
//----------------------------------------------------------------------------------------------------------------------------
//FINALIZA ESTRUTURA PRE-PEDIDO
//----------------------------------------------------------------------------------------------------------------------------

dbSelectArea(cAliasSC6)
dbClosearea()
dbSelectArea("SC6")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fCriaSX1     ³Autor ³  Paulo Eduardo       ³Data³ 17.03.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCriaSX1(cPerg1)

Local aPergs := {}

Aadd(aPergs,{"Da Filial ?"           ,"Da Filial ?"           ,"Da Filial ?"           ,"mv_ch1","C",  2, 00, 00, "G", "", "mv_par01", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Ate a Filial ?"        ,"Ate a Filial ?"        ,"Ate a Filial ?"        ,"mv_ch2","C",  2, 00, 00, "G", "", "mv_par02", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Do Pedido ?"           ,"Do Pedido ?"           ,"Do Pedido ?"           ,"mv_ch3","C",  6, 00, 00, "G", "", "mv_par03", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Ate o Pedido ?"        ,"Ate o Pedido ?"        ,"Ate o Pedido ?"        ,"mv_ch4","C",  6, 00, 00, "G", "", "mv_par04", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Do Pré-Pedido ?"       ,"Do Pré-Pedido ?"       ,"Do Pré-Pedido ?"       ,"mv_ch5","C",  6, 00, 00, "G", "", "mv_par05", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Ate o Pré-Pedido ?"    ,"Ate o Pré-Pedido ?"    ,"Ate o Pré-Pedido ?"    ,"mv_ch6","C",  6, 00, 00, "G", "", "mv_par06", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Do Produto ?"          ,"Do Produto ?"          ,"Do Produto ?"          ,"mv_ch7","C", 15, 00, 00, "G", "", "mv_par07", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "SB1", ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Ate o Produto ?"       ,"Ate o Produto ?"       ,"Ate o Produto ?"       ,"mv_ch8","C", 15, 00, 00, "G", "", "mv_par08", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "SB1", ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Do Cliente ?"          ,"Do Cliente ?"          ,"Do Cliente ?"          ,"mv_ch9","C",  6, 00, 00, "G", "", "mv_par09", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "CLI", "001","S","","",{},{},{}})
Aadd(aPergs,{"Ate o Cliente ?"       ,"Ate o Cliente ?"       ,"Ate o Cliente ?"       ,"mv_cha","C",  6, 00, 00, "G", "", "mv_par10", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "CLI", "001","S","","",{},{},{}})
Aadd(aPergs,{"Da Data de Entrega ?"  ,"Da Data de Entrega ?"  ,"Da Data de Entrega ?"  ,"mv_chb","D",  8, 00, 00, "G", "", "mv_par11", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Ate a Data Entrega ?"  ,"Ate a Data Entrega ?"  ,"Ate a Data Entrega ?"  ,"mv_chc","D",  8, 00, 00, "G", "", "mv_par12", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Situacao do Pedido ?"  ,"Situacao do Pedido ?"  ,"Situacao do Pedido ?"  ,"mv_chd","N",  1, 00, 00, "C", "", "mv_par13", "Em aberto"    , "Em aberto"    , "Em aberto"    , "", "", "Todos"        , "Todos"        , "Todos"        , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Com Geracao Duplic. ?" ,"Com Geracao Duplic. ?" ,"Com Geracao Duplic. ?" ,"mv_che","N",  1, 00, 00, "C", "", "mv_par14", "Sim"          , "Sim"          , "Sim"          , "", "", "Não"          , "Não"          , "Não"          , "", "", "Ambos"        , "Ambos"        , "Ambos"        , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Mßscara do Produto ?"  ,"Mßscara do Produto ?"  ,"Mßscara do Produto ?"  ,"mv_chf","C", 15, 00, 00, "G", "", "mv_par15", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Aglutina prod.Grade ?" ,"Aglutina prod.Grade ?" ,"Aglutina prod.Grade ?" ,"mv_chg","N",  1, 00, 00, "C", "", "mv_par16", "Sim"          , "Sim"          , "Sim"          , "", "", "Não"          , "Não"          , "Não"          , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Cons.Res.Eliminados ?" ,"Cons.Res.Eliminados ?" ,"Cons.Res.Eliminados ?" ,"mv_chh","N",  1, 00, 00, "C", "", "mv_par17", "Sim"          , "Sim"          , "Sim"          , "", "", "Não"          , "Não"          , "Não"          , "", "", "Somente"      , "Somente"      , "Somente"      , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Lista Tot.Faturados ?" ,"Lista Tot.Faturados ?" ,"Lista Tot.Faturados ?" ,"mv_chi","N",  1, 00, 00, "C", "", "mv_par18", "Sim"          , "Sim"          , "Sim"          , "", "", "Não"          , "Não"          , "Não"          , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Pula pag. na Quebra ?" ,"Pula pag. na Quebra ?" ,"Pula pag. na Quebra ?" ,"mv_chj","N",  1, 00, 00, "C", "", "mv_par19", "Sim"          , "Sim"          , "Sim"          , "", "", "Não"          , "Não"          , "Não"          , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Do Vendedor ?"         ,"Do Vendedor ?"         ,"Do Vendedor ?"         ,"mv_chk","C",  6, 00, 00, "G", "", "mv_par20", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "SA3", ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Ate o Vendedor ?"      ,"Ate o Vendedor ?"      ,"Ate o Vendedor ?"      ,"mv_chl","C",  6, 00, 00, "G", "", "mv_par21", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "SA3", ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Qual moeda ?"          ,"Qual moeda ?"          ,"Qual moeda ?"          ,"mv_chm","N",  1, 00, 00, "C", "", "mv_par22", "Moeda 1"      , "Moeda 1"      , "Moeda 1"      , "", "", "Moeda 2"      , "Moeda 2"      , "Moeda 2"      , "", "", "Moeda 3"      , "Moeda 3"      , "Moeda 3"      , "", "", "Moeda 4"      , "Moeda 4"      , "Moeda 4"      , "", "", "Moeda 5"      , "Moeda 5"      , "Moeda 5"      , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Imprime ?"             ,"Imprime ?"             ,"Imprime ?"             ,"mv_chn","N",  1, 00, 00, "C", "", "mv_par23", "Valor Total"  , "Valor Total"  , "Valor Total"  , "", "", "Saldo"        , "Saldo"        , "Saldo"        , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Tipo Relatorio ?"      ,"Tipo Relatorio ?"      ,"Tipo Relatorio ?"      ,"mv_cho","N",  1, 00, 00, "C", "", "mv_par24", "Analitico"    , "Analitico"    , "Analitico"    , "", "", "Sintetico"    , "Sintetico"    , "Sintetico"    , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Do Vencimento?"        ,"Do Vencimento?"        ,"Do Vencimento?"        ,"mv_chp","D",  8, 00, 00, "G", "", "mv_par25", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Ate Vencimento?"       ,"Ate Vencimento?"       ,"Ate Vencimento?"       ,"mv_chq","D",  8, 00, 00, "G", "", "mv_par26", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Gera Planilha?"        ,"Gera Planilha?"        ,"Gera Planilha?"        ,"mv_chr","N",  1, 00, 00, "C", "", "mv_par27", "Sim"          , "Sim"          , "Sim"          , "", "", "Não"          , "Não"          , "Não"          , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Nome da Planilha?"     ,"Nome da Planilha?"     ,"Nome da Planilha?"     ,"mv_chs","C", 15, 00, 00, "G", "", "mv_par28", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Suprimir  linhas?"     ,"Suprimir  linhas?"     ,"Suprimir  linhas?"     ,"mv_cht","N",  1, 00, 00, "C", "", "mv_par29", "Sim"          , "Sim"          , "Sim"          , "", "", "Não"          , "Não"          , "Não"          , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", ""   , ""   ,"S","","",{},{},{}})
Aadd(aPergs,{"Tipo de Pedido?"       ,"Tipo de Pedido?"       ,"Tipo de Pedido?"       ,"mv_chu","N",  1, 00, 00, "C", "", "mv_par30", "Entreg Futura" , "Entreg Futura" , "Entreg Futura"      , "", "", "Conta e Ordem"      , "Conta e Ordem"      , "Conta e Ordem"      , "", "", "Normal"      , "Normal"      , "Normal"      , "", "", "Todos"      , "Todos"      , "Todos"      , "", "", ""      , ""      , ""      , "", ""   , ""   ,"S","","",{},{},{}})

AjustaSx1(cPerg1,aPergs)

Return


Static Function GeraExcel(aExcel,cDirXls)

Local 	cArq := StrTran(cDirXls+mv_par28," ","")+".CSV"
Local 	nArq := fCreate(cArq,0)
Local    nLinExcel := 0
Local cLinha := ""
Local IW := 0

For IW:= 1 to Len(aExcel)
	cLinha := aExcel[iw][1] + chr(13) + chr(10)
	FWrite(nArq,cLinha,Len(cLinha))
	nLinExcel ++
Next IW

fClose(nArq)

Return