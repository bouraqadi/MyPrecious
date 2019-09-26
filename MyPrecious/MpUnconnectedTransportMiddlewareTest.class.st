Class {
	#name : #MpUnconnectedTransportMiddlewareTest,
	#superclass : #MpMiddlewareTest,
	#category : #'MyPrecious-Tests'
}

{ #category : #tests }
MpUnconnectedTransportMiddlewareTest >> middlewareClass [
	^ MpUnconnectedTransportMiddlewareForTest
]

{ #category : #tests }
MpUnconnectedTransportMiddlewareTest >> testRemoteMessageBasicReceive [
	| valueHolderA remoteReferenceA message bytes |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	message := MpSynchronousRemoteMessage new
		selector: #contents:;
		arguments: #(2);
		receiver: remoteReferenceA;
		senderAddress: middlewareB address;
		responseId: #anyID.
	bytes := middlewareB transporter marshalAndSerialize: message.
	middlewareA transporter receiveBytes: bytes.
	self waitUntil: [valueHolderA contents = 2] onTimeout: 300 milliSeconds do: [ self fail: 'Message reception failed' ]
	
]

{ #category : #tests }
MpUnconnectedTransportMiddlewareTest >> testRemoteMessageBasicSend [
	| valueHolderA remoteReferenceA message proxyB |
	valueHolderA := self newValueHolder.
	remoteReferenceA := middlewareA export: valueHolderA.
	proxyB := middlewareB objectAt: remoteReferenceA.
	message := MpSynchronousRemoteMessage new
		selector: #contents:;
		arguments: #(2);
		receiver: remoteReferenceA;
		senderAddress: middlewareB address;
		responseId: #anyID.
	middlewareB transporter sendObject: message toAddress: remoteReferenceA address.
	self waitUntil: [valueHolderA contents = 2] onTimeout: 300 milliSeconds do: [ self fail: 'Assertion failed' ]
	
]
