' Play 5 tunes depending on which key is pressed
		
		Include "PROTON_4.INC"
        
		Symbol  R	=	0
		Symbol	C	=	82
		Symbol  Db0	=	85
		Symbol	D	=	87
		Symbol  Eb	=	89
		Symbol  E	=	92
		Symbol  F	=	94
		Symbol  Gb	=	95
		Symbol  G	=	97
		Symbol	Ab1	=	99
		Symbol  A1	=	73
		Symbol  Bb1	=	76
		Symbol  BE1	=	79
		Symbol	C1	=	82
		Symbol  Db1	=	85
		Symbol	D1	=	87
		Symbol  Eb1	=	89
		Symbol  E1	=	92
		Symbol  F1	=	94
		Symbol  Gb1	=	95
		Symbol  G1	=	97
		Symbol	Ab2	=	99
		Symbol	A2	=	101
		Symbol	Bb2	=	102
		Symbol	BE2	=	104
		Symbol	C2	=	105
		Symbol	Db2	=	106
		Symbol	D2	=	108
		Symbol	E2	=	110
		Symbol	F2	=	111
		Symbol	Gb2	=	112
		Symbol	G2	=	113
		Symbol	Bb3	=	115
		Symbol	Bm3	=	116
		Symbol	C3	=	117
		Symbol	D3	=	118
		Symbol PIN = PORTA.0

	
START:	
		If INKEY = 0 Then Song1		'Starwars
		If INKEY = 1 Then Song2		'Death march 
		If INKEY = 2 Then Song3		'Shave and a Haircut 
		If INKEY = 3 Then Song4		'Charge!
		If INKEY = 4 Then Song5		'Heart and Soul
        Goto Start
        
Song1:	Sound PIN,[G,80,D2,80,C2,20,BE2,20,A2,20,G2,80,D2,80,C2,20,BE2,20,A2,20,G2,80,D2,80,C2,20,BE2,20,C2,20,A2,80]
		Goto START
Song2:	Sound PIN,[F,80,R,2,F,70,R,2,F,10,R,2,F,80,Ab1,60,R,2,G,10,R,2,G,60,R,5,F,10,R,2,F,50,R,2,E,20,R,1,F,40]
		Goto START
Song3:	Sound PIN,[F2,40,R,2,C2,20,R,2,C2,20,R,5,D2,50,R,3,C2,30,R,40,E2,40,F2,50]
		Goto START
Song4:	Sound PIN,[Db2,20,Gb2,20,Bb3,15,C3,30,R,5,Bb3,20,C3,75]
		Goto START
Song5:	Sound PIN,[C2,30,R,10,C2,30,R,10,C2,80,R,3,C2,20,BE2,30,A2,20,BE2,30,C2,20,D2,30,R,5,C2,10,E2,30,R,15,E2,30,R,15,E2,80]
		Goto START

