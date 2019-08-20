Class {
	#name : #MpRemoteReference,
	#superclass : #Object,
	#traits : 'TEquality',
	#classTraits : 'TEquality classTrait',
	#instVars : [
		'objectId'
	],
	#category : #'MyPrecious-Kernel'
}

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
