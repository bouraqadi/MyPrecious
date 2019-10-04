Class {
	#name : #MpUnconnectedTransportMiddlewareForTest,
	#superclass : #MpMiddlewareForTest,
	#category : #'MyPreciousTests-Unconnected'
}

{ #category : #initialization }
MpUnconnectedTransportMiddlewareForTest >> transporterClass [
	^MpUnconnectedTransporterForTest 
]
