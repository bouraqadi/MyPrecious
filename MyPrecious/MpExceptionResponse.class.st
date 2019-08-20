Class {
	#name : #MpExceptionResponse,
	#superclass : #MpResponse,
	#instVars : [
		'exception'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpExceptionResponse class >> id: id exception: exception [
	^self new
		id: id;
		exception: exception;
		yourself
]

{ #category : #accessing }
MpExceptionResponse >> exception [
	^ exception
]

{ #category : #accessing }
MpExceptionResponse >> exception: anObject [
	exception := anObject
]

{ #category : #marshalling }
MpExceptionResponse >> marshalWith: marshaller [
	^marshaller marshallExceptionResponse: self
]

{ #category : #acting }
MpExceptionResponse >> trigger: aPromise [
	aPromise rejectWith: self exception
]
