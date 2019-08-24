Class {
	#name : #MpTcpChannelFactory,
	#superclass : #MpChannelFactory,
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpChannelFactory >> channelTo: remoteReference [ 
	| socketStream remoteAddress |
	remoteAddress := remoteReference address.
	socketStream := ZdcSocketStream openConnectionToHost: remoteAddress ip port: remoteAddress port.
	^self newChannel
		socketStream: socketStream;
		yourself
]
