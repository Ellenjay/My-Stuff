void Routine_2(){
Off(All);

for(int j = 0; j <=5; j++){

for(int i = 0; i <=25; i+=2){
On(ChannelRange(i,1),For (100).Milliseconds,Wait);
} 
Off(All);

for(int i = 1; i <=25; i+=2){
On(ChannelRange(i,1),For (100).Milliseconds,Wait);
}
Off(All);



					}//for(int j

//On(ChannelRange(24,1),For (1).Seconds,Wait);
//On(ChannelRange(3,1),For (1).Seconds,Wait);
//On(ChannelRange(5,1),For (1).Seconds,Wait);
//Random(ChannelRange(1,25),10,For(5).Seconds,Wait);

}