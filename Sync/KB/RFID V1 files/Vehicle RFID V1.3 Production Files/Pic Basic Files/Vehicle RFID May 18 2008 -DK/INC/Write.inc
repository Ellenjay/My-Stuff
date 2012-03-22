
'===============Write Employee and Tag to Table============================
WriteTag:			  For Index = 0 to 2
					  B1 = CE[Index]
					  EWRITE NUA + Index, [B1]
					  Next 'Index
					  
					  For Index = 0 to 4					
					  B1 = CT[Index]
					  EWRITE NUA + TagOffset + Index, [B1]
					  Next 'Index
					  B1 = "C"

					  NUA = NUA + 8
					  EWRITE 255, [NUA]
					  Return

WriteMaster:	 	 
					  For Index = 0 to 4
					  EWRITE Index, [CT[Index]]
					  Next
					  Return

'..............End of Write Tag and Employee..............................





