Class {
	#name : #MpProtocol,
	#superclass : #Object,
	#instVars : [
		'channel'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpProtocol class >> channel: aChannel [
	^self new
		channel: aChannel;
		yourself
]

{ #category : #accessing }
MpProtocol >> channel [
	^ channel
]

{ #category : #accessing }
MpProtocol >> channel: anObject [
	channel := anObject
]

{ #category : #serializing }
MpProtocol >> materializeFrom: bytes [ 
	^FLMaterializer materializeFromByteArray: bytes
]

{ #category : #communicating }
MpProtocol >> receiveBytes: bytes [
	| receivedObject  |
	receivedObject := self materializeFrom: bytes.
	self receiveObject: receivedObject
]

{ #category : #communicating }
MpProtocol >> receiveObject: anObject [
	self channel receiveObject: anObject
]

{ #category : #communicating }
MpProtocol >> sendBytes: bytes [
	self subclassResponsibility

]

{ #category : #communicating }
MpProtocol >> sendObject: anObject [
	| bytes |
	bytes := self serialize: anObject.
	self sendBytes: bytes
]

{ #category : #serializing }
MpProtocol >> serialize: anObject [ 
	^FLSerializer serializeToByteArray: anObject
]
