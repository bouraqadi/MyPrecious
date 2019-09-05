Class {
	#name : #MpChannelFactory,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'inboundChannels',
		'outboundChannelsDict'
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
	inboundChannels := Set new.
	outboundChannelsDict := Dictionary new.
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
	| newChannel |
	newChannel := self newChannel.
	outboundChannelsDict at: remoteReference put: newChannel.
self inform: 'New Outbound Channel. No GC!!!'.
	^newChannel
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
	outboundChannelsDict at: remoteReference ifPresent: [: channel | ^channel ].
	^self newStartedOutboundChannelTo: remoteReference
]

{ #category : #accessing }
MpChannelFactory >> outboundChannelsDict [
	^outboundChannelsDict
]
