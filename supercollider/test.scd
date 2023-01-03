
 ~n1 = NetAddr.new("127.0.0.1", 12000);


(
w = Window("button", Rect(0,0,200,200)).front;
b = Button(w,Rect(0,0,100,100));
b.action_({arg me;
	var vel,pc,dur,midin;
	vel = rrand(0,255); // random velocity
	midin=rrand(60,71); //random midi number in the 4th octave
	pc = midin%12; // respective pitch class
	dur = rrand(10,100); // random duration
	midin.postln;
	(\midinote:midin).play; // note feedback but with default vel and dur
	~n1.sendMsg('/test', vel.asFloat, pc, dur.asFloat); //to processing
});
)







