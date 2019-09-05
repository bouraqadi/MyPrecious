Class {
	#name : #MpChannelFactory,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'inboundChannels'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpChannelFactory >> channelClass [
	^self middleware channelClass

]

{ #category : #communicating }
MpChannelFactory >> inboundChannelWith: anObject [
	^self newStartedInboundChannelWith: anObject
]

{ #category : #accessing }
MpChannelFactory >> inboundChannels [
	^inboundChannels
]

{ #category : #initialization }
MpChannelFactory >> initialize [
	super initialize.
	inboundChannels := Set new
]

{ #category : #communicating }
MpChannelFactory >> newChannel [
	^self channelClass middleware: self middleware
]

{ #category : #communicating }
MpChannelFactory >> newInboundChannelWith: anObject [
	| newChannel |
	newChannel := self newChannel.
	inboundChannels add: newChannel.
self inform: 'New Inbound Channel. No GC!!!'.
	^newChannel
]

{ #category : #communicating }
MpChannelFactory >> newOutboundChannelTo: remoteReference [
	^self newChannel
]

{ #category : #communicating }
MpChannelFactory >> newStartedInboundChannelWith: anObject [
	^(self newInboundChannelWith: anObject)
		start;
		yourself
]

{ #category : #communicating }
MpChannelFactory >> newStartedOutboundChannelTo: remoteReference [
	^(self newOutboundChannelTo: remoteReference)
		start;
		yourself
]

{ #category : #communicating }
MpChannelFactory >> outboundChannelTo: remoteReference [
	^self newStartedOutboundChannelTo: remoteReference
]
