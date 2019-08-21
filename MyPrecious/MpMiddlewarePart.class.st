Class {
	#name : #MpMiddlewarePart,
	#superclass : #Object,
	#instVars : [
		'middleware'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpMiddlewarePart class >> middleware: aMiddleware [
	^self new
		middleware: aMiddleware;
		yourself
]

{ #category : #accessing }
MpMiddlewarePart >> middleware [
	^ middleware
]

{ #category : #accessing }
MpMiddlewarePart >> middleware: anObject [
	middleware := anObject
]
