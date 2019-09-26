Class {
	#name : #MpRemoteMessage,
	#superclass : #Object,
	#instVars : [
		'selector',
		'arguments',
		'receiver'
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
MpRemoteMessage >> deliverBy: transporter [
	self subclassResponsibility
]

{ #category : #marshalling }
MpRemoteMessage >> marshalWith: aMarshaller [
	^aMarshaller marshalRemoteMessage: self
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

{ #category : #marshalling }
MpRemoteMessage >> unmarshalWith: aMarshaller [
	^aMarshaller unmarshalRemoteMessage: self
]
