Class {
	#name : #MpReferenceConverterForTestOLD,
	#superclass : #MpReferenceConverter,
	#category : #'MyPrecious-Tests'
}

{ #category : #exporting }
MpReferenceConverterForTestOLD >> export: anObject id: id [
	| reference |
	reference := super export: anObject id: id.
	self registry at: reference put: self middleware.
	^reference
]

{ #category : #accessing }
MpReferenceConverterForTestOLD >> registry [
	^self middleware registry
]
