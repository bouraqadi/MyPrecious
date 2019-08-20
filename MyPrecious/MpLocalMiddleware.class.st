Class {
	#name : #MpLocalMiddleware,
	#superclass : #MpMiddleware,
	#classVars : [
		'Registry'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #accessing }
MpLocalMiddleware class >> registry [
	^ Registry ifNil: [Registry := WeakValueDictionary new ]
]

{ #category : #exporting }
MpLocalMiddleware >> export: anObject id: id [
	| reference |
	reference := super export: anObject id: id.
	self registry at: reference put: self.
	^reference
]

{ #category : #communicating }
MpLocalMiddleware >> newInboundChannel [
	^MpLocalInboundChannel middleware: self.
]

{ #category : #communicating }
MpLocalMiddleware >> outboundChannelClass [
	^MpLocalOutboundChannel 
]

{ #category : #communicating }
MpLocalMiddleware >> outboundChannelTo: remoteReference [
	| otherMiddleware inboundChannel |
	otherMiddleware := self registry at: remoteReference.
	inboundChannel := otherMiddleware newInboundChannel.
	^(super outboundChannelTo: remoteReference)
		targetChannel: inboundChannel;
		yourself.
	
]

{ #category : #accessing }
MpLocalMiddleware >> registry [
	^self class registry
]
