Class {
	#name : #MpNormalResponse,
	#superclass : #MpResponse,
	#instVars : [
		'result'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpNormalResponse class >> id: id result: result [
	^self new
		id: id;
		result: result;
		yourself
]

{ #category : #marshalling }
MpNormalResponse >> marshalWith: marshaller [
	^marshaller marshalNormalResponse: self
]

{ #category : #accessing }
MpNormalResponse >> result [
	^ result
]

{ #category : #accessing }
MpNormalResponse >> result: anObject [
	result := anObject
]

{ #category : #acting }
MpNormalResponse >> trigger: aPromise [
	aPromise fulfillWith: self result
]

{ #category : #marshalling }
MpNormalResponse >> unmarshalWith: marshaller [
	^marshaller unmarshalNormalResponse: self
]
