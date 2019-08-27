Class {
	#name : #MpTcpChannelFactory,
	#superclass : #MpChannelFactory,
	#instVars : [
		'inboundChannels'
	],
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

{ #category : #communicating }
MpTcpChannelFactory >> communicateVia: socketStream [
	| channel |
	channel := self newChannel.
	inboundChannels add: channel.
	[channel communicateVia: socketStream] fork.

]

{ #category : #accessing }
MpTcpChannelFactory >> inboundChannels [
	^ inboundChannels
]

{ #category : #initialization }
MpTcpChannelFactory >> initialize [
	super initialize.
	inboundChannels := Set new.
]
