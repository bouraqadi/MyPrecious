Class {
	#name : #MpRemoteReference,
	#superclass : #Object,
	#traits : 'TEquality',
	#classTraits : 'TEquality classTrait',
	#instVars : [
		'objectId',
		'address'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteReference >> address [
	^address
]

{ #category : #accessing }
MpRemoteReference >> address: anAddress [
	^address := anAddress
]

{ #category : #accessing }
MpRemoteReference >> objectId [
	^ objectId
]

{ #category : #accessing }
MpRemoteReference >> objectId: anObject [
	objectId := anObject
]

{ #category : #printing }
MpRemoteReference >> printOn: aStream [
	aStream 
		<< 'ID: '
		<< self objectId
]

{ #category : #marshalling }
MpRemoteReference >> unmarshalWith: marshaller [
	^marshaller unmarshalRemoteReference: self
]
