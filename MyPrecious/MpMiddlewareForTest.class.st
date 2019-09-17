Class {
	#name : #MpMiddlewareForTest,
	#superclass : #MpMiddleware,
	#classVars : [
		'Registry'
	],
	#category : #'MyPrecious-Tests'
}

{ #category : #initialization }
MpMiddlewareForTest >> transporterClass [
	^MpTransporterForTest 
]
