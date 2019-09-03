Class {
	#name : #MpChannelFactory,
	#superclass : #MpMiddlewarePart,
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpChannelFactory >> channelClass [
	^self middleware channelClass

]

{ #category : #communicating }
MpChannelFactory >> newChannel [
	^self channelClass middleware: self middleware
]

{ #category : #communicating }
MpChannelFactory >> newInboundChannel [
	^self newChannel
]

{ #category : #communicating }
MpChannelFactory >> newOutboundChannel [
	^self newChannel
]

{ #category : #communicating }
MpChannelFactory >> outboundChannelTo: remoteReference [
	^self subclassResponsibility
]
