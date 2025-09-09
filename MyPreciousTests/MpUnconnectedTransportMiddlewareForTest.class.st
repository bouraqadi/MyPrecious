Class {
	#name : 'MpUnconnectedTransportMiddlewareForTest',
	#superclass : 'MpMiddlewareForTest',
	#category : 'MyPreciousTests-Unconnected',
	#package : 'MyPreciousTests',
	#tag : 'Unconnected'
}

{ #category : 'initialization' }
MpUnconnectedTransportMiddlewareForTest >> responseHeadersForKey: key [
	^ ZnHeaders defaultResponseHeaders
			at: 'Upgrade' put: 'websocket';
			at: 'Connection' put: 'Upgrade';
			at: 'Sec-WebSocket-Accept' put: key;
			yourself
]

{ #category : 'initialization' }
MpUnconnectedTransportMiddlewareForTest >> transporterClass [
	^MpUnconnectedTransporterForTest 
]
