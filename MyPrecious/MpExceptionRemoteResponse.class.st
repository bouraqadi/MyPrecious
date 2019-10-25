Class {
	#name : #MpExceptionRemoteResponse,
	#superclass : #MpRemoteResponse,
	#instVars : [
		'exception'
	],
	#category : #'MyPrecious-Messages'
}

{ #category : #'instance creation' }
MpExceptionRemoteResponse class >> id: id exception: exception [
	^self new
		id: id;
		exception: exception;
		yourself
]

{ #category : #accessing }
MpExceptionRemoteResponse >> contents [
	self exception signal
]

{ #category : #accessing }
MpExceptionRemoteResponse >> exception [
	^ exception
]

{ #category : #accessing }
MpExceptionRemoteResponse >> exception: anObject [
	exception := anObject
]

{ #category : #marshalling }
MpExceptionRemoteResponse >> marshalWith: marshaller [
	^marshaller marshallExceptionResponse: self
]

{ #category : #acting }
MpExceptionRemoteResponse >> trigger: aPromise [	
	[aPromise rejectWith: self] on: CcPromiseAlreadySettledError do: [nil]
]
