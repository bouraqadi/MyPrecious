Class {
	#name : #MpReferenceConverterForTest,
	#superclass : #MpReferenceConverter,
	#category : #'MyPrecious-Tests'
}

{ #category : #exporting }
MpReferenceConverterForTest >> export: anObject id: id [
	| reference |
	reference := super export: anObject id: id.
	self registry at: reference put: self middleware.
	^reference
]

{ #category : #accessing }
MpReferenceConverterForTest >> registry [
	^self middleware registry
]
