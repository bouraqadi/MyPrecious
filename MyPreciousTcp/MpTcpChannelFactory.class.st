Class {
	#name : #MpTcpChannelFactory,
	#superclass : #MpChannelFactory,
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpChannelFactory >> communicateVia: socketStream [
	| channel |
	channel := self newInboundChannel.
	channel communicateVia: socketStream
]

{ #category : #communicating }
MpTcpChannelFactory >> outboundChannelTo: remoteReference [ 
	| socketStream remoteAddress |
	remoteAddress := remoteReference address.
	socketStream := ZdcSocketStream openConnectionToHost: remoteAddress ip port: remoteAddress port.
	^self newOutboundChannel
		socketStream: socketStream;
		yourself
]
