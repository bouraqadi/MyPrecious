Class {
	#name : #MpValueHolderForTest,
	#superclass : #Object,
	#traits : 'TEquality',
	#classTraits : 'TEquality classTrait',
	#instVars : [
		'contents'
	],
	#category : #'MyPreciousTests-Common'
}

{ #category : #'instance creation' }
MpValueHolderForTest class >> contents: anObject [
	^self new
contents: anObject
;
yourself		
]

{ #category : #accessing }
MpValueHolderForTest >> chainSize [
	self contents ifNil: [ ^1 ].
	^1 + contents chainSize 
]

{ #category : #accessing }
MpValueHolderForTest >> contents [
	^ contents
]

{ #category : #accessing }
MpValueHolderForTest >> contents: anObject [
	contents := anObject
]
