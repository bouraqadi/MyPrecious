Class {
	#name : #MpConnectedTransportMiddlewareTest,
	#superclass : #MpMiddlewareTest,
	#category : #'MyPrecious-Tests'
}

{ #category : #tests }
MpConnectedTransportMiddlewareTest >> middlewareClass [ 
	^MpConnectedTransportMiddlewareForTest
]

{ #category : #tests }
MpConnectedTransportMiddlewareTest >> testRemoteMessageBasicSend [
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
