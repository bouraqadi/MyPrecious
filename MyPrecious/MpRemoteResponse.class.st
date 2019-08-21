Class {
	#name : #MpRemoteResponse,
	#superclass : #Object,
	#instVars : [
		'id'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteResponse >> id [
	^ id
]

{ #category : #accessing }
MpRemoteResponse >> id: anObject [
	id := anObject
]

{ #category : #communicating }
MpRemoteResponse >> receivedByChannel: aChannel [
	^aChannel receiveResponse: self 
]

{ #category : #acting }
MpRemoteResponse >> trigger: aPromise [
	self subclassResponsibility
]
