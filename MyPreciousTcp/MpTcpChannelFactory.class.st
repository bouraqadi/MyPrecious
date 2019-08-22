Class {
	#name : #MpTcpChannelFactory,
	#superclass : #MpChannelFactory,
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpChannelFactory >> inboundChannelClass [
	^MpTcpInboundChannel 
]

{ #category : #communicating }
MpTcpChannelFactory >> outboundChannelClass [
	^MpTcpOutboundChannel
]
