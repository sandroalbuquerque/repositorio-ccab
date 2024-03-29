#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410ALOK �Autor  �Edgar Serrano       � Data �  14/02/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para validacao do pedido de venda 		  ���
���          �criado automaticamente via entrega futura					  ���
���          �				                                              ���
�������������������������������������������������������������������������͹��
���Uso       �Exclusivo para o cliente CCAB                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M410ALOK

Local _aAreaSC5		:= SC5->(GetArea())
Local _aAreaSC6		:= SC6->(GetArea())
Local _cPedOri	 	:= ""
Local _cTpPedido 	:= ""
                    

If l410Auto   
	Return .T.
EndIf

If !Empty(SC5->C5_XDOCORI) .And. !Empty(SC5->C5_XSERORI)
	
	_cPedOri 	:= Posicione("SD2", 3, xFilial("SD2") + SC5->C5_XDOCORI + SC5->C5_XSERORI + SC5->C5_CLIENTE + SC5->C5_LOJACLI , "D2_PEDIDO" )
	_cTpPedido	:= Posicione("SC5", 1, xFilial("SC5") + _cPedOri, "C5_XTPPED")

  //	If _cTpPedido == "1"
	//	MsgInfo("Informe a data de entrega.")
//	EndIf
EndIf

RestArea(_aAreaSC5)
RestArea(_aAreaSC6)

Return .T.