Class {
	#name : #MpChannelFactoryOLD,
	#superclass : #MpMiddlewarePart,
	#instVars : [
		'inboundChannels',
		'outboundChannelsDict'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpChannelFactoryOLD >> channelClass [
	^self middleware channelClass

]

{ #category : #communicating }
MpChannelFactoryOLD >> inboundChannelWith: anObject [
	^self newStartedInboundChannelWith: anObject
]

{ #category : #accessing }
MpChannelFactoryOLD >> inboundChannels [
	^inboundChannels
]

{ #category : #initialization }
MpChannelFactoryOLD >> initialize [
	super initialize.
	inboundChannels := Set new.
	outboundChannelsDict := Dictionary new.
]

{ #category : #communicating }
MpChannelFactoryOLD >> newChannel [
	^self channelClass middleware: self middleware
]

{ #category : #communicating }
MpChannelFactoryOLD >> newInboundChannelWith: anObject [
	| newChannel |
	newChannel := self newChannel.
	inboundChannels add: newChannel.
self inform: 'New Inbound Channel. No GC!!!'.
	^newChannel
]

{ #category : #communicating }
MpChannelFactoryOLD >> newOutboundChannelTo: remoteReference [
	| newChannel |
	newChannel := self newChannel.
	outboundChannelsDict at: remoteReference put: newChannel.
self inform: 'New Outbound Channel. No GC!!!'.
	^newChannel
]

{ #category : #communicating }
MpChannelFactoryOLD >> newStartedInboundChannelWith: anObject [
	^(self newInboundChannelWith: anObject)
		start;
		yourself
]

{ #category : #communicating }
MpChannelFactoryOLD >> newStartedOutboundChannelTo: remoteReference [
	^(self newOutboundChannelTo: remoteReference)
		start;
		yourself
]

{ #category : #communicating }
MpChannelFactoryOLD >> outboundChannelTo: remoteReference [
	outboundChannelsDict at: remoteReference ifPresent: [: channel | ^channel ].
	^self newStartedOutboundChannelTo: remoteReference
]

{ #category : #accessing }
MpChannelFactoryOLD >> outboundChannelsDict [
	^outboundChannelsDict
]
