Class {
	#name : #MpTcpChannelFactory,
	#superclass : #MpChannelFactory,
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpChannelFactory >> channelClass [
	^MpTcpChannel
]
