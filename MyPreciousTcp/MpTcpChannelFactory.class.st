Class {
	#name : #MpTcpChannelFactory,
	#superclass : #MpChannelFactoryOLD,
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpChannelFactory >> newInboundChannelWith: socketStream [
	^(super newInboundChannelWith: socketStream)
		socketStream: socketStream;
		yourself
]

{ #category : #communicating }
MpTcpChannelFactory >> newOutboundChannelTo: remoteReference [ 
	| socketStream remoteAddress |
	remoteAddress := remoteReference address.
	socketStream := ZdcSocketStream openConnectionToHost: remoteAddress ip port: remoteAddress port.
	^(super newOutboundChannelTo: remoteReference)
		socketStream: socketStream;
		yourself
]
