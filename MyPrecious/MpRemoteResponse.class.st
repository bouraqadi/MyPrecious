Class {
	#name : #MpRemoteResponse,
	#superclass : #Object,
	#instVars : [
		'id'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteResponse >> contents [
	self subclassResponsibility
]

{ #category : #communicating }
MpRemoteResponse >> deliverByTransporter: transporter [
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
