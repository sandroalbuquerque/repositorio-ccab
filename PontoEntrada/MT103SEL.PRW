/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103SEL  �Autor  �Valdemir Jose       � Data �  10/04/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para selecionar o Pedido de Compra        ���
���          � Utilizado para carregar a taxa e moeda do pedido Compra    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT103SEL()
	Local nRecno := PARAMIXB[1]
	Local aArea  := GetArea()
	Local nRet   := 0  
	Local _nMoeda:= 0
	
	dbSelectArea('SC7')
	dbGoto(nRecno)			//Validacoes do usuario

	nMoedaCor := SC7->C7_MOEDA
	nTAXA     := SC7->C7_TXMOEDA 
	
	_nMoeda   := SC7->C7_MOEDA
	nMoedaCor := _nMoeda 
		
	RestArea(aArea)  
	nRet   := 1
Return(nRet)