Class {
	#name : #MpConnectedMiddlewareTest,
	#superclass : #MpMiddlewareTest,
	#category : #'MyPreciousTests-Connected'
}

{ #category : #tests }
MpConnectedMiddlewareTest >> middlewareClass [ 
	^MpConnectedMiddlewareForTest
]

{ #category : #tests }
MpConnectedMiddlewareTest >> testRemoteMessageBasicSend [
	| valueHolderA remoteReferenceA message connection |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	message := MpSynchronousRemoteMessage new
		selector: #contents:;
		arguments: #(2);
		receiver: remoteReferenceA;
		senderAddress: middlewareB address;
		responseId: #anyID.
	connection := middlewareB transporter connectTo: remoteReferenceA.
	connection sendObject: message.
	self waitUntil: [valueHolderA contents = 2] onTimeout: 300 milliSeconds do: [ self fail: 'Assertion failed' ]
	
]
