Class {
	#name : 'MpConnectedMiddlewareForTest',
	#superclass : 'MpMiddlewareForTest',
	#category : 'MyPreciousTests-Connected',
	#package : 'MyPreciousTests',
	#tag : 'Connected'
}

{ #category : 'initialization' }
MpConnectedMiddlewareForTest >> transporterClass [
	^MpConnectedTransporterForTest 
]
