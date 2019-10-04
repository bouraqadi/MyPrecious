Class {
	#name : #MpConnectedMiddlewareForTest,
	#superclass : #MpMiddlewareForTest,
	#category : #'MyPreciousTests-Connected'
}

{ #category : #initialization }
MpConnectedMiddlewareForTest >> transporterClass [
	^MpConnectedTransporterForTest 
]
