Class {
	#name : #MpRemoteResponse,
	#superclass : #Object,
	#instVars : [
		'id'
	],
	#category : #'MyPrecious-Messages'
}

{ #category : #accessing }
MpRemoteResponse >> contents [
	self subclassResponsibility
]

{ #category : #communicating }
MpRemoteResponse >> deliverBy: transporter [
	^transporter deliverResponse: self 
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
