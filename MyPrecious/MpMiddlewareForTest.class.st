Class {
	#name : #MpMiddlewareForTest,
	#superclass : #MpMiddleware,
	#classVars : [
		'Registry'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #accessing }
MpMiddlewareForTest >> address: anAndress [
	super address: anAndress.
	self registry at: anAndress put: self
]

{ #category : #initialization }
MpMiddlewareForTest >> initialize [
	super initialize.
	self address: UUID new
]

{ #category : #accessing }
MpMiddlewareForTest >> registry [
	^ Registry ifNil: [Registry := WeakValueDictionary new ]
]

{ #category : #initialization }
MpMiddlewareForTest >> transporterClass [
	^MpTransporterForTest 
]
