Class {
	#name : #MpNormalRemoteResponse,
	#superclass : #MpRemoteResponse,
	#instVars : [
		'result'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpNormalRemoteResponse class >> id: id result: result [
	^self new
		id: id;
		result: result;
		yourself
]

{ #category : #marshalling }
MpNormalRemoteResponse >> marshalWith: marshaller [
	^marshaller marshalNormalResponse: self
]

{ #category : #accessing }
MpNormalRemoteResponse >> result [
	^ result
]

{ #category : #accessing }
MpNormalRemoteResponse >> result: anObject [
	result := anObject
]

{ #category : #acting }
MpNormalRemoteResponse >> trigger: aPromise [
	aPromise fulfillWith: self result
]

{ #category : #marshalling }
MpNormalRemoteResponse >> unmarshalWith: marshaller [
	^marshaller unmarshalNormalResponse: self
]
