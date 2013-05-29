#Include 'Protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PNEU002   �Autor  �Denison Soares      � Data �  15/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E Executado apos a escolha da NF Original.			      ���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       �No Ok apos o F7 da tela de Documento de Entrada.            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PNEU002()  

If	xFilial("SD1") == SD2->D2_FILIAL .And.;
	aCols[n][GdFieldPos("D1_NFORI")] == SD2->D2_DOC .And.;
	aCols[n][GdFieldPos("D1_SERIORI")] == SD2->D2_SERIE .And.;
	cA100For == SD2->D2_CLIENTE .And.;
	cLoja == SD2->D2_LOJA .And.;  
	aCols[n][GdFieldPos("D1_COD")] ==  SD2->D2_COD .And.;
	aCols[n][GdFieldPos("D1_ITEMORI")] == SD2->D2_ITEM	   
	//�����������������������������������������������Ŀ
	//�Nao importa o desconto da nota fiscal original.�
	//�������������������������������������������������	
	MaFisRef("IT_DESCONTO","MT100",0)	
	MaFisRef("IT_PRCUNI","MT100",SD2->D2_PRCVEN)					
	MaFisRef("IT_QUANT","MT100",aCols[n][GdFieldPos("D1_QUANT")])
	MaFisRef("IT_VALMERC","MT100",aCols[n][GdFieldPos("D1_QUANT")]*aCols[n][GdFieldPos("D1_VUNIT")])			
EndIf

Return