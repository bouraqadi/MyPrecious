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

{ #category : #'instance creation' }
MpRemoteReference class >> address: address objectId: id [

	^ super new
		  address: address;
		  objectId: id;
		  yourself
]

{ #category : #'instance creation' }
MpRemoteReference class >> new [
	self error: 'Use address:objectId: to create remote reference instances'
]

{ #category : #accessing }
MpRemoteReference >> address [
	^address
]

{ #category : #accessing }
MpRemoteReference >> address: anAddress [
	^address := anAddress
]

{ #category : #marshalling }
MpRemoteReference >> marshalWith: marshaller [
	^marshaller marshalRemoteReference: self
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
