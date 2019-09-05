Class {
	#name : #MpRemoteMessage,
	#superclass : #Object,
	#instVars : [
		'selector',
		'arguments',
		'receiver',
		'responseId'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpRemoteMessage class >> selector: selector arguments: args receiver: receiver responseId: responseId [
	^self new
		selector: selector; 
		arguments: args; 
		receiver: receiver;
		responseId: responseId; 
		yourself

]

{ #category : #accessing }
MpRemoteMessage >> arguments [
	^ arguments
]

{ #category : #accessing }
MpRemoteMessage >> arguments: anObject [
	arguments := anObject
]

{ #category : #marshalling }
MpRemoteMessage >> marshalWith: aMarshaller [
	^aMarshaller marshalMessage: self
]

{ #category : #communicating }
MpRemoteMessage >> receivedByChannel: channel [
	^channel receiveMessage: self
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

{ #category : #marshalling }
MpRemoteMessage >> unmarshalWith: aMarshaller [
	^aMarshaller unmarshalMessage: self
]
