Class {
	#name : #MpResponse,
	#superclass : #Object,
	#instVars : [
		'id'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpResponse >> id [
	^ id
]

{ #category : #accessing }
MpResponse >> id: anObject [
	id := anObject
]

{ #category : #acting }
MpResponse >> trigger: aPromise [
	self subclassResponsibility
]
