Class {
	#name : #MpRemoteMessage,
	#superclass : #Object,
	#instVars : [
		'selector',
		'arguments',
		'receiver',
		'responseId',
		'targetAddress',
		'senderAddress'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteMessage >> arguments [
	^ arguments
]

{ #category : #accessing }
MpRemoteMessage >> arguments: anObject [
	arguments := anObject
]

{ #category : #communicating }
MpRemoteMessage >> deliverByTransporter: transporter [
	^transporter deliverMessage: self
]

{ #category : #marshalling }
MpRemoteMessage >> marshalWith: aMarshaller [
	^aMarshaller marshalMessage: self
]

{ #category : #printing }
MpRemoteMessage >> printOn: aStream [
	super printOn: aStream.
	self selector ifNil: [ ^self ].
	aStream
		<< ' #';
		<< self selector
]

{ #category : #accessing }
MpRemoteMessage >> receiver [
	^ receiver
]

{ #category : #accessing }
MpRemoteMessage >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
MpRemoteMessage >> responseId [
	^ responseId
]

{ #category : #accessing }
MpRemoteMessage >> responseId: anObject [
	responseId := anObject
]

{ #category : #accessing }
MpRemoteMessage >> selector [
	^ selector
]

{ #category : #accessing }
MpRemoteMessage >> selector: anObject [
	selector := anObject
]

{ #category : #performing }
MpRemoteMessage >> send [
	^self receiver
		perform: selector 
		withArguments: arguments
]

{ #category : #accessing }
MpRemoteMessage >> senderAddress [
	^ senderAddress
]

{ #category : #accessing }
MpRemoteMessage >> senderAddress: anObject [
	senderAddress := anObject
]

{ #category : #accessing }
MpRemoteMessage >> targetAddress [
	^ targetAddress
]

{ #category : #accessing }
MpRemoteMessage >> targetAddress: anObject [
	targetAddress := anObject
]

{ #category : #marshalling }
MpRemoteMessage >> unmarshalWith: aMarshaller [
	^aMarshaller unmarshalMessage: self
]
