Class {
	#name : #MpRemoteResponse,
	#superclass : #Object,
	#instVars : [
		'id'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpRemoteResponse >> deliverByTransporter: aChannel [
	^aChannel deliverResponse: self 
]

{ #category : #accessing }
MpRemoteResponse >> id [
	^ id
]

{ #category : #accessing }
MpRemoteResponse >> id: anObject [
	id := anObject
]

{ #category : #acting }
MpRemoteResponse >> trigger: aPromise [
	self subclassResponsibility
]
