/*
SONIDO DEL CARRO:
- Sonido de los frenos
- Sonido del choque
*/

(

~horn = {
	arg frequency, mul = 0.5, env;
	Mix.ar([LFSaw.ar(frequency, mul: mul),LFSaw.ar(frequency - 70 - 20.rand,  mul: mul)]) * env
};

~hit = {
	arg waitingTime;
	var env = Env.new([],[]);
};

~engine = {
	arg engineTime = 5, doneAction = 0;
	var envelope = Env.new([1,1,0],[engineTime *0.9, engineTime * 0.1]);
	Mix.ar([BrownNoise.ar(0.6 * EnvGen.ar(envelope)) , (BrownNoise.ar(LFPulse.ar(12)) * 0.4 * EnvGen.ar(envelope, doneAction:doneAction)) ])
};

~brake = {
	arg waitingTime = 3, noiseFunc = PinkNoise;
	var env = Env.new([0,0,0.8,0],[waitingTime,0.001,1.42]), noise;
	noise = noiseFunc.ar(EnvGen.ar(env));
	noise = LPF.ar(noise,5500);
	Mix.ar([SinOsc.ar(1130,mul: 0.5 *EnvGen.ar(env)), SinOsc.ar(1912,mul:0.1* EnvGen.ar(env)), SinOsc.ar(3016,mul:0.05 *EnvGen.ar(env)), noise])
};

SynthDef(\carro,{
	arg tmjmp = 0.1, tmshort = 0.54, tmhold = 1.3, wtm = 2;
	var engine, brake, horns, envHorn, output;
	envHorn = Env.new([0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0],
		[wtm,tmjmp,tmhold,tmjmp,tmhold * 0.5,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmhold,tmshort]);
	horns = ~horn.value(500,1,EnvGen.ar(envHorn,doneAction:2));
	engine = ~engine.value(12,2);
	output = Mix.ar([engine, horns]);
	Out.ar(0,Pan2.ar(output));
}).add;

~car = {
	var engine, brake, horns, envHorn, tmjmp = 0.1, tmshort = 0.54, output;
	envHorn = Env.new([0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0],
		[2,tmjmp,2.19,tmjmp,0.9,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,tmshort,tmjmp,2.19,tmshort]);
	horns = ~horn.value(500,1,EnvGen.ar(envHorn,doneAction:2));
	engine = ~engine.value(12,2);
	output = Mix.ar([horns,engine]);
	Pan2.ar(output)
};


)


({~car.value()}.play)

/*
~host = NetAddr("localhost", 4859); // address de PROCESSING


o = OSCFunc({ arg msg, time;
	[time, msg].postln;
	~host.sendMsg("/trigger",42,12.34,"hello processing");
},'/tr', s.addr);

o.free;

*/

({~brake.value}.play)
Synth(\carro, [\tmjmp, 0.1  ,\tmshort, 0.05 , \tmhold, 0.5 ,\wtm, 0.5 ] );


